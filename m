Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211289;
	b=5RrNqhfaVgxQWMgtGKT0WIQ4MWzwSBVwV7KuGEiEx66lWJZpFOnHFpZZsyNFpdLhFQX+
	 p5teEHd8SY6/66hV/rvDEjN3/TbSyN/lC7zf3SvQwoQkHVHWhB3qyxUNTIIxrw74mP8WS
	 4duwF61eBb4OXQVIF/AFhW8KDeEClZzggfkrA5v0XHrzX+pyBDMn9AWO1R13a/NWn5Lw+
	 S3/AW2kE5NBxx3i0QJpQNryWZ4lS/BsZOEIX9wOn8N7NrKy8NsxoEb/5jCtTTyLXN6t5g
	 iJ9IDR3PIffzEW0BMG2+Ky940MIZ1kJNsoWYuroz5OW8PiLbKfAuV2rFFIrEoNGZE0Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211289;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=M8iuBNcmqafoo+mO2XY4GAvdGQX4UoRK5UKf42BN784=;
	b=BuevnBs+s12vPDhigjXf8kyFeof8WqlJ3PqQdOZgkxn7G9Ez0Swoxr6BQkN3tz4UK1S/
	 gPgCVNa/1V6OZSzpcFwh9UVe8o3KiQnlGXYvUyT7T6hEsTH2AGrLh1Hly3GZUrWC11LHe
	 OjQfv+KPrgylxMMZK6j4UGjETyLJH5VAZykfCUj/iT2ewtA23GTALNc4Twz8eYbF/MSi/
	 WXHA2daR0rKFXbreJ2QW9HZ5H/WNdX//p5WtePjPU2ZPb1pp6f2a6Fvg44G68gFa9emuN
	 QoTEdgacbsI+EoWrh9+wneTYh5NXBDXosLKAQM0fEb5PCgxGgMcf6/Lsf3/7N2LwOBw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kYEkvmH7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE47060A5BCD;
	Wed, 28 Oct 2026 18:14:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kYEkvmH7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B7901F01825;
	Wed, 28 Oct 2026 18:14:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211288;
	bh=M8iuBNcmqafoo+mO2XY4GAvdGQX4UoRK5UKf42BN784=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kYEkvmH7idPviMqSRnl1c9eYZHlzIZY57ok9TZBc4YDur2SRtBV/pijKT33a2bxfE
	 kFpOPKZQS3X7NR0lat7rgFZsrstiC5zdJ9QUQTuenh3SoHtG4ujFxBALlulLn/8hwW
	 OgYRKSJ7K9RH2EgOqlEt4DfdGGzIOF6SR40wb5lA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 326/571] USB: serial: clean up core error labels
Date: Wed, 28 Oct 2026 17:57:53 +0100
Message-ID: <20261028170015.740086709@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index ec84825d45aae..7301cd519bd4f 100644
--- a/drivers/usb/serial/usb-serial.c
+++ b/drivers/usb/serial/usb-serial.c
@@ -225,17 +225,17 @@ static int serial_install(struct tty_driver *driver, struct tty_struct *tty)
 
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
 
@@ -247,11 +247,11 @@ static int serial_install(struct tty_driver *driver, struct tty_struct *tty)
 
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
@@ -1388,7 +1388,7 @@ static int __init usb_serial_init(void)
 	result = bus_register(&usb_serial_bus_type);
 	if (result) {
 		pr_err("%s - registering bus driver failed\n", __func__);
-		goto exit_bus;
+		goto err_put_driver;
 	}
 
 	usb_serial_tty_driver->driver_name = "usbserial";
@@ -1406,25 +1406,23 @@ static int __init usb_serial_init(void)
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
 	tty_driver_kref_put(usb_serial_tty_driver);
 	return result;
@@ -1569,13 +1567,13 @@ int usb_serial_register_drivers(struct usb_serial_driver *const serial_drivers[]
 
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
@@ -1583,11 +1581,11 @@ int usb_serial_register_drivers(struct usb_serial_driver *const serial_drivers[]
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



