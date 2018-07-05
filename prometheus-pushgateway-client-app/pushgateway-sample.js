'use strict';

const express = require('express');
const server = express();
const client = require('prom-client');
const Counter = client.Counter;
const register = client.register;

//Non push Alarm metrics 
const c = new Counter({
    name: 'test1_counter',
    help: 'Example of a counter',
    labelNames: ['code']
});


setInterval(() => {
    c.inc({ code: 200 });
}, 5000);

server.get('/metric', (req, res) => {
    res.set('Content-Type', register.contentType);
    res.end(register.metrics());
});




// Setting up the push gateway:
const registry = new client.Registry();
const pushAlarmMetricOne = new Counter({
    name: 'push_alarm_counter_metric_one',
    help: 'Example of a counter',
    labelNames: ['service','pod'],
    registers: [registry]
});

const pushAlarmMetricTwo = new Counter({
    name: 'push_alarm_counter_metric_two',
    help: 'Example of a counter',
    labelNames: ['service', 'pod'],
    registers: [registry]
});

let gateway = new client.Pushgateway('http://mt-coretech-k8s02/pushgateway', {}, registry);

//Exposes the pushgateway registry at '/push/metric'
server.get('/push/metric', (req, res) => {
    res.set('Content-Type', register.contentType);
    res.end(registry.metrics());
});

server.get('/pushadd/:labelOne', (req, res) => {
    gateway.pushAdd({
        jobName: 'push_alarms'}, function (err, resp, body) {
            pushAlarmMetricOne.labels('svcName', req.params.labelOne).inc()
    });
    res.end("Success!!");
});

server.get('/push/:labelOne', (req, res) => {
    gateway.push({ jobName: 'push_alarms' }, function (err, resp, body) {
        pushAlarmMetricOne.labels('svcName', req.params.labelOne).inc()
    });
    res.end("Success!!");
});



console.log('Server listening to 3002, metrics exposed on /metrics endpoint');
server.listen(3002);