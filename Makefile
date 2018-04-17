SRC_DIR=.
MASTERFILES='/var/cfengine/masterfiles'
MASTERCACHE='/var/cfengine/cache'
CFINPUTS='/var/cfengine/inputs'
HOST=$$(shell hostname)

merge: 
	@echo "Installing defaults"
	cp -r ${SRC_DIR}/def.json ${MASTERFILES}/def.json
	@echo "Installing custom promises file"
	cp -r ${SRC_DIR}/promises.cf ${MASTERFILES}/promises.cf
	@echo "Installing all custom bundles and templates"
	cp -r ${SRC_DIR}/services ${MASTERFILES}
	cp -r ${SRC_DIR}/templates ${MASTERFILES}
	@echo "Copying files from ${MASTERFILES} into ${CFINPUTS}"
	cp -r ${MASTERFILES}/* ${CFINPUTS}/
	test -d ${MASTERCACHE} || mkdir ${MASTERCACHE}
	cp -r ${SRC_DIR}/cache/* ${MASTERCACHE}/

clean:
	rm -rf /var/cfengine/inputs/*

check:
	cf-promises --full-check  -f ${CFINPUTS}/update.cf
	cf-promises --full-check  -T ${MASTERFILES}

bootstrap: clean merge check
	@echo "Bootstrapping to $(HOST)"
	cf-agent -KIB ${HOST}
	
test:
	cf-agent -KI 
