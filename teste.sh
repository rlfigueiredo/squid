#!/bin/bash

functeste () {
	date
	ls -ltr /
	date
}

functeste >>teste.log 2>&1
