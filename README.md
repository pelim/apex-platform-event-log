# CCEP Log
## **Data Integration** like botteling on the moving belt <br/> an **event-driven** architekture approach

## Abstarct

To keep trac of events, errors and for debug logging a state of the art logging system musst be implemented. For scalibilty reasons and future proofnes it would make since to implemet this by publish events in a continus log stream.

Since **Winter 18** events can be published in **Apex** by **Salesforce Platform Events** and could be used to implement **Enterprise Messaging Patterns**.

## Implementation

Using platform events doen't mean to apply the whole architecture pattern and creating new dependencies. By using a hybrid approch there will be no impacts on other systems but other systems will be able to consume our events for further features like product recommendations or other ML topics.

## Events
### Apex Subscription

At the beging the events would be published in APEX and consumed by the same System by. This would be done by implementing a Apex Trigger on the correspoding event object.

**Publishing a cart checkout event**

````
List<Ecom__e> evens = new List<Ecom__e>;
Ecom__e       event = new Ecom__e();

event.identifier = 'product.show';
event.data__c = JSON.parse(
    new Map<String> {
        'product.ean'      => '50112135'
        'account.number'   => '1136583',
        'product.quantity' => 1337
    }
);
list.add(event);

event.identifier = 'cart.checkout';
event.data__c = JSON.parse(
    new Map<String> {
        'cart.number'    => '00031508'
        'account.number' => '1136583',
    }
);

list.add(event);

Eventbus.publish(list);
````

**Subscription on checkout events**
````
trigger EcomCheckoutConsumer(after insert) {

    for(Ecom__e event: events) {
        if(event.identifier == 'cart.checkout') {

            EnterpriseSalesOrder salesOrder = EnterpriseSalesOrder.create(event);

            EnterpriseResult result = EnterpriseService->transferSalesOrder(salesOrder);

            EventBus.publish(result.getEvent());

        }
    }
}
````

### CometD Subscription

All published platform events are published on a **http-longpoling** stream by a **cometd** service. Consuming these event data is easily possible by subscribeing on a **channel/ push topic** with the **bayeux protocol**. These is even possible with a javascript client so that the webinterface can make use of real-time notifications.

**Browser Notifications**
````javascript

  const success = 'succes', error = 'error';

  cometd.configure({
    url: 'https://na37.salesforce.com/cometd/40.0',
    requestHeaders: {
      Authorization: 'OAuth {!$Api.Session_ID}'
    }
  });

  cometd.handshake();

  comted.subscribe('/event/notification__e', (m) => {
    if(message.status__c == 'success') {
      App.Context.userNotification(m);
    } else {
      App.Context.errorNotificaton(m);
    }
  });
````
### Handling Exceptions with Event

Beside event logging the message bus could also be used to publish **error** and ***debug logs***. These could be done by handling thrown Exception in a visual force exception page and pubblishing these as platform event.

It is also possible to configure a process to handle those events by sending email notifications or triggering a hip-chat bot.

To analyse problems and counting problems those events could also be pushed to an external log service like senntry or logstash

### Further use cases

Subscribing to this events clould alson be done by a integration services like **mulesoft**, **Logstash**, **apache camel**, or a **heroku kaffka** instance for example. These consumers can act as simple data mappers, enrich data or push other topics to the event bus.

These very scalable architecture could also be used to send tracking data to google analytics or pushing data into a recommendations engine like **prediction.io** - a sparkML based recommendation engine that was accuired by salesforce and used in **einstein**


### Apendix

- [First Impressions with Platform Events and the Salesforce Enterprise Messaging Platform](https://developer.salesforce.com/blogs/developer-relations/2017/05/first-impressions-platform-events-salesforce-enterprise-messaging-platform.html)
-  [Apache Camel - enterprise integreation patterns](http://camel.apache.org/enterprise-integration-patterns.html)
- [Sentry](https://sentry.io/welcome/) - [github repo](https://github.com/getsentry/sentry)
- [Prototype Logger using platform events](https://github.com/pelim/apex-platform-event-log)