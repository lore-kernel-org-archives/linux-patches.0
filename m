Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208946;
	b=dlhXFrnNyglAr4ICagbStqVVZxLNrEM9YsI5I8geGnyF0UDPlxzwuK/AYgfA2FjtdRjz
	 kKm08vOfZT5/7UOufqNlfBl0k1n2O9fC7EsT2VNbRhPswYhKikkLRKoQQbQtzQQVvpEgj
	 7oUG3spuRJqJoF6OUjLB1zU+MUrXEQ27TJFNNwITvKTw8DDIEd7rXP7oKLwOXKWhD+7rt
	 Mkjj7tZeb6zKARF1LX01S3WiSUXtB8bVhAbdtpMF2h85WOLbCELsSI/uRH9ecExxt4jRa
	 4zAB7mYBVBjWM4/ESNsAvP5gWh89NDapwr1jFLl6GNGjLeCTawSSP7iQ9uYwiagg2fA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208946;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JfN1ai2FQH4K8ksVGKn+Oq2LFawicx8XN/7NfYe3yLI=;
	b=Z3GOeOWf5sNJjXUFbxFPV+uqA+O7Sl3UZB/B7HzUL6yaToPsTUL8deHelzFL16Ijek7+
	 /nczlB3oLpouQNS24BQBh7Lo8c5GSmGQT74lMCDvOOhrPXJzELHz7li4bz4wcxKn4o/72
	 HThA1ZgkzaSB13ZCMzravFf7aiyU7SiZrKwpkvnTR0GGj+U+pdy/HRapHq+vtRLSfqvzY
	 VZB1HRvyPE5mAnwxBHkp28C56kCZEpeoQ3p5wYbj3P++2oPuJSHm26bpBoktx9ffWmHm0
	 WQJJoEcTaQERsE62E0FCslJhaKu6Z0TNZdCV1TsbrxvXWhKIcbxVK4ejkL7CT2O6fcw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=C15VWoAb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1747D606A32E;
	Wed, 28 Oct 2026 17:35:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=C15VWoAb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68D7C1F031E2;
	Wed, 28 Oct 2026 17:35:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208946;
	bh=JfN1ai2FQH4K8ksVGKn+Oq2LFawicx8XN/7NfYe3yLI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C15VWoAbMcRVDmemOS+7thhaDd2gJH3UNqAS/IEmc6C3lCgxobj27tNQM9Rsvr4F+
	 24TW5rwQh0fLxtsL0v2lbjbfbmGnZrglSysravcvTRdLuQtjf1dcREGCLmLYyhzcrE
	 y9mQ68a+/HIXb37+daZkRbaC4wPqdoRrm0uWhYqg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 299/516] USB: serial: clean up core error labels
Date: Wed, 28 Oct 2026 17:57:31 +0100
Message-ID: <20261028170010.575050701@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

[ Upstream commit 96a83c95c3da5ba55ea2cf6ce87de10fc03417a9 ]

Clean up the core error labels by consistently naming them after what
they do rather than after from where they are jumped to.

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Stable-dep-of: 646e5b28b4fd ("USB: serial: fix driver deregistration order")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/serial/usb-serial.c | 34 ++++++++++++++++-----------------
 1 file changed, 16 insertions(+), 18 deletions(-)

diff --git a/drivers/usb/serial/usb-serial.c b/drivers/usb/serial/usb-serial.c
index aad5e167d1eab..338fd0d5e65e1 100644
--- a/drivers/usb/serial/usb-serial.c
+++ b/drivers/usb/serial/usb-serial.c
@@ -187,17 +187,17 @@ static int serial_install(struct tty_driver *driver, struct tty_struct *tty)
 
 	serial = port->serial;
 	if (!try_module_get(serial->type->driver.owner))
-		goto error_module_get;
+		goto err_put_serial;
 
 	retval = usb_autopm_get_interface(serial->interface);
 	if (retval)
-		goto error_get_interface;
+		goto err_put_module;
 
 	init_termios = (driver->termios[idx] == NULL);
 
 	retval = tty_standard_install(driver, tty);
 	if (retval)
-		goto error_init_termios;
+		goto err_put_autopm;
 
 	mutex_unlock(&serial->disc_mutex);
 
@@ -209,11 +209,11 @@ static int serial_install(struct tty_driver *driver, struct tty_struct *tty)
 
 	return retval;
 
- error_init_termios:
+err_put_autopm:
 	usb_autopm_put_interface(serial->interface);
- error_get_interface:
+err_put_module:
 	module_put(serial->type->driver.owner);
- error_module_get:
+err_put_serial:
 	usb_serial_put(serial);
 	mutex_unlock(&serial->disc_mutex);
 	return retval;
@@ -1287,7 +1287,7 @@ static int __init usb_serial_init(void)
 	result = bus_register(&usb_serial_bus_type);
 	if (result) {
 		pr_err("%s - registering bus driver failed\n", __func__);
-		goto exit_bus;
+		goto err_put_driver;
 	}
 
 	usb_serial_tty_driver->driver_name = "usbserial";
@@ -1308,25 +1308,23 @@ static int __init usb_serial_init(void)
 	result = tty_register_driver(usb_serial_tty_driver);
 	if (result) {
 		pr_err("%s - tty_register_driver failed\n", __func__);
-		goto exit_reg_driver;
+		goto err_unregister_bus;
 	}
 
 	/* register the generic driver, if we should */
 	result = usb_serial_generic_register();
 	if (result < 0) {
 		pr_err("%s - registering generic driver failed\n", __func__);
-		goto exit_generic;
+		goto err_unregister_driver;
 	}
 
 	return result;
 
-exit_generic:
+err_unregister_driver:
 	tty_unregister_driver(usb_serial_tty_driver);
-
-exit_reg_driver:
+err_unregister_bus:
 	bus_unregister(&usb_serial_bus_type);
-
-exit_bus:
+err_put_driver:
 	pr_err("%s - returning with error %d\n", __func__, result);
 	put_tty_driver(usb_serial_tty_driver);
 	return result;
@@ -1471,13 +1469,13 @@ int usb_serial_register_drivers(struct usb_serial_driver *const serial_drivers[]
 
 	rc = usb_register(udriver);
 	if (rc)
-		goto failed_usb_register;
+		goto err_free_driver;
 
 	for (sd = serial_drivers; *sd; ++sd) {
 		(*sd)->usb_driver = udriver;
 		rc = usb_serial_register(*sd);
 		if (rc)
-			goto failed;
+			goto err_deregister_drivers;
 	}
 
 	/* Now set udriver's id_table and look for matches */
@@ -1485,11 +1483,11 @@ int usb_serial_register_drivers(struct usb_serial_driver *const serial_drivers[]
 	rc = driver_attach(&udriver->drvwrap.driver);
 	return 0;
 
- failed:
+err_deregister_drivers:
 	while (sd-- > serial_drivers)
 		usb_serial_deregister(*sd);
 	usb_deregister(udriver);
-failed_usb_register:
+err_free_driver:
 	kfree(udriver);
 	return rc;
 }
-- 
2.53.0



