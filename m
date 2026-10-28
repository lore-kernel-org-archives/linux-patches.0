Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216651;
	b=UD4lIh1KfpSJSIFRM536rHHtlSxXVpTmH0/olRWxaMkhWxPdwe+SRhsytte4XLTerYW2
	 yCV5erkh+ADiVlpZ0Fe+97MgbOGJI9eLKcWScvRcMwyWeey+/ozsjnsshXqeT0ZOeeeUC
	 n/+Jcfb313RJ91iA5CEpa4PMyd5+GYyrYRnXhAlQ+z25Dj1qrQSj7dkYVS/RTnqHr1YFb
	 u/D+hqkRt64jdxTPnxMRrCFMwOwWh3aubq+0bpYRnMbfQNvAcOzbbK1OqlMKthb2HDIzj
	 WBF2EoLzDmKvkK+hYnNc6CzI1SYJIl5UhKHMldJaqIJM6oodXGHWl6Cltnfy7P2390Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216651;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=Doy7T7q81OJla7HuwTU3vRWLKclOKLSxy+pvbMngQb8=;
	b=qT+zEUrRKpxnycrFE64adVHTtwJrK6wZ9w9J6ieawiYRziBg4gS6doYY4+jLbMCc2BoG
	 x9eHI1I/mGz9qAQThnxEvsAlnvt3Xn05OQJ7f5i2syxf2vYPQSCyQWF5POZ7P7hcbouc3
	 ycZjOBweXFw3jyG+x/Qfy063TTbil7qvhwC186OFT2oIOuTUvxnhEBQbauOZy0f8boz1U
	 Ixq96AUtVCnd9T/dAEMX9QIvMTabu/dhvpTcWXmfoANuEzEuIFdux5wNRStvyx1qIi/EQ
	 n3sRjUOJTMo+AngT4krUGFmqz2XJ/cRYS10Wal9kwpJNnvtTnF62PihBbbMB+eetA0w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X2RH3VEL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69544606A31C;
	Wed, 28 Oct 2026 19:44:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X2RH3VEL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5E031F01825;
	Wed, 28 Oct 2026 19:44:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216651;
	bh=Doy7T7q81OJla7HuwTU3vRWLKclOKLSxy+pvbMngQb8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X2RH3VELbafODCwnQa5wnKPbDz+cX5TPCaLCFw/wEwbQe6DCwUAEeNqG/i8HgVnrM
	 f99tZiuW0XmYqdy4wGbhmdY03WvFmJ0DjKGGZh/g169Swn+u+L979xqil4++PDR0eF
	 31NWqDmH9jg/BH2NBHcReciOGMM/hGG4ee2bS54k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Armin Wolf <W_Armin@gmx.de>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1630/1887] platform/x86: lg-laptop: Fix LED resource handling
Date: Wed, 28 Oct 2026 18:02:06 +0100
Message-ID: <20261028170536.558344633@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Armin Wolf <W_Armin@gmx.de>

[ Upstream commit 3e91964aa74ab261aa15d9d96318eded2fd9d22a ]

The event notification callback might access kbd_backlight even
when it was not successfully registered with the LED subsystem.
The same happens inside acpi_remove(), where the LED devices are
unregistered unconditionally.

Fix this by tracking the availability of the kbd_backlight LED
device and use devm_led_classdev_register() to let devres take
care of unregistering the LED devices during removal. For this
the parent device of the LED devices is changed to the native
platform device.

Fixes: ae26278829a8 ("platform/x86: lg-laptop: Use correct event for keyboard backlight FN-key")
Signed-off-by: Armin Wolf <W_Armin@gmx.de>
Link: https://patch.msgid.link/20260708195553.7762-2-W_Armin@gmx.de
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/lg-laptop.c | 22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

diff --git a/drivers/platform/x86/lg-laptop.c b/drivers/platform/x86/lg-laptop.c
index f6028bc1866c5..cd66db74093ee 100644
--- a/drivers/platform/x86/lg-laptop.c
+++ b/drivers/platform/x86/lg-laptop.c
@@ -71,6 +71,7 @@ static u32 inited;
 #define INIT_SPARSE_KEYMAP      0x80
 
 static int battery_limit_use_wmbb;
+static bool kbd_backlight_available;
 static struct led_classdev kbd_backlight;
 static enum led_brightness get_kbd_backlight_level(struct device *dev);
 
@@ -188,6 +189,7 @@ static void wmi_notify(u32 value, void *context)
 	union acpi_object *obj;
 	acpi_status status;
 	long data = (long)context;
+	unsigned int brightness;
 
 	pr_debug("event guid %li\n", data);
 	status = wmi_get_event_data(value, &response);
@@ -205,8 +207,11 @@ static void wmi_notify(u32 value, void *context)
 		struct key_entry *key;
 
 		if (eventcode == 0x10000000) {
-			led_classdev_notify_brightness_hw_changed(
-				&kbd_backlight, get_kbd_backlight_level(kbd_backlight.dev->parent));
+			if (kbd_backlight_available) {
+				brightness = get_kbd_backlight_level(kbd_backlight.dev->parent);
+				led_classdev_notify_brightness_hw_changed(&kbd_backlight,
+									  brightness);
+			}
 		} else {
 			key = sparse_keymap_entry_from_scancode(
 				wmi_input_dev, eventcode);
@@ -725,7 +730,12 @@ static int acpi_add(struct acpi_device *device)
 		goto out_platform_device;
 
 	/* LEDs are optional */
-	led_classdev_register(&pf_device->dev, &kbd_backlight);
+	ret = led_classdev_register(&pf_device->dev, &kbd_backlight);
+	if (ret < 0)
+		kbd_backlight_available = false;
+	else
+		kbd_backlight_available = true;
+
 	led_classdev_register(&pf_device->dev, &tpad_led);
 
 	wmi_input_setup();
@@ -744,11 +754,13 @@ static int acpi_remove(struct acpi_device *device)
 {
 	sysfs_remove_group(&pf_device->dev.kobj, &dev_attribute_group);
 
+	battery_hook_unregister(&battery_hook);
+	wmi_input_destroy();
+
+	kbd_backlight_available = false;
 	led_classdev_unregister(&tpad_led);
 	led_classdev_unregister(&kbd_backlight);
 
-	battery_hook_unregister(&battery_hook);
-	wmi_input_destroy();
 	platform_device_unregister(pf_device);
 	pf_device = NULL;
 	platform_driver_unregister(&pf_driver);
-- 
2.53.0



