Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047051;
	b=tgIip5e9bDpV6DnHtSdAHTGsPIYdGCPi112cjkM5ENxvmUrM8PxPyJwFh+yCNWhAXavS
	 QkRdBZsYLqtwRT9fjkGtAYmjIrKopC2NVke71hK2VEyO+TPhgB3ZllckxU1WqXqSiZ+x1
	 ThHKl8uRHpjF2w8R4HD/1HaPm/fuK+JqYVDI8BENeSCPZjE594debxZ1dToxbz40NMrk1
	 fWJ94umZsMqyY/OUJoUk54+WceKvfncN0PBHqWIzBcflsCESXS/+tDjonr1WSi36CMQjS
	 FkCx257fLg5L1ouWP1VQ0oAnk21M7aXJtwwld1h82LzAREaFNbk5HZYix6V9opeNVEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047051;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ISiIl40HFvpRW5IlWwenZeKTdQ+faI9WfFUHV9cx6uI=;
	b=03qIPREqKndUUCCKv5Xc/UniXUREpeIucWTCd1X+Zl2RwN0jT2LcJYkzCRFzQeppdR7L
	 KaEQ6aiTRxlj3/J3ZWKj88IGYwDKKG7OBJdkQJPSXBJxGJtnVcIqiK6rEfqYVlyTHVQzC
	 8peJcYp0zKSfeqTM6EbK22I5dPRlF0EO1RHvI2EX3NBmDxYOINg0k6n8VUulapwx+vNOd
	 RmPnMVdkt0Zl/dT6Yie8j5tg55MSDXCmjhfNTjvqf/EkAir+bJwzAwKl1dva/aexAhx6H
	 M9CQ6klX92HA2G51T2ooki5R6FK4DvBgO9q9huNC4oj4Nh5cgUT7kAODHYeoB7zTl+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DKIRpJwZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDE46606A32C;
	Thu, 19 Nov 2026 00:10:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DKIRpJwZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00CDD1F000C5;
	Thu, 19 Nov 2026 00:10:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047051;
	bh=ISiIl40HFvpRW5IlWwenZeKTdQ+faI9WfFUHV9cx6uI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DKIRpJwZpQiLUmLpx9suSp/g8u/0J7bXZXPchdkUcUSqeukJfrVra2cbOtrZsNHbq
	 W3apum60PM6i3jIS0Q0ux4N8EaLaktLNL1Pzap4h7GyFLBBOo2xlzxOUMaa5WAdcB7
	 Q3IW1v/W1OV1z+gBr6rRUIftumE9czVfEJYhs4nE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukas Wunner <lukas@wunner.de>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1499/2857] platform/x86: Use device_show_string() helper for sysfs attributes
Date: Wed, 18 Nov 2026 15:42:13 +0100
Message-ID: <20261118150255.314731425@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lukas Wunner <lukas@wunner.de>

[ Upstream commit 3182459b7bff642eb968d6203a08aea3862436c1 ]

Deduplicate sysfs ->show() callbacks which expose a string at a static
memory location.  Use the newly introduced device_show_string() helper
in the driver core instead by declaring those sysfs attributes with
DEVICE_STRING_ATTR_RO().

No functional change intended.

Signed-off-by: Lukas Wunner <lukas@wunner.de>
Acked-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/3ae8c9a73fbb291c1c863777af175c657a2a10e9.1713608122.git.lukas@wunner.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

The third ASUS fan and ThinkPad auxiliary MAC attributes are absent,
so omit their conversions. Keep the conversions for the existing
keyboard, CPU/GPU fan and Toshiba version attributes.

Stable-dep-of: 3d9a175707ee ("platform/x86: asus-wmi: fix TUF keyboard power state shutdown naming")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/asus-wmi.c     | 49 ++++++++---------------------
 drivers/platform/x86/toshiba_acpi.c |  9 ++----
 2 files changed, 15 insertions(+), 43 deletions(-)

diff --git a/drivers/platform/x86/asus-wmi.c b/drivers/platform/x86/asus-wmi.c
index e1ea260046c3c..4ed10997426a6 100644
--- a/drivers/platform/x86/asus-wmi.c
+++ b/drivers/platform/x86/asus-wmi.c
@@ -796,17 +796,12 @@ static ssize_t kbd_rgb_mode_store(struct device *dev,
 }
 static DEVICE_ATTR_WO(kbd_rgb_mode);
 
-static ssize_t kbd_rgb_mode_index_show(struct device *device,
-						 struct device_attribute *attr,
-						 char *buf)
-{
-	return sysfs_emit(buf, "%s\n", "cmd mode red green blue speed");
-}
-static DEVICE_ATTR_RO(kbd_rgb_mode_index);
+static DEVICE_STRING_ATTR_RO(kbd_rgb_mode_index, 0444,
+			     "cmd mode red green blue speed");
 
 static struct attribute *kbd_rgb_mode_attrs[] = {
 	&dev_attr_kbd_rgb_mode.attr,
-	&dev_attr_kbd_rgb_mode_index.attr,
+	&dev_attr_kbd_rgb_mode_index.attr.attr,
 	NULL,
 };
 
@@ -848,17 +843,12 @@ static ssize_t kbd_rgb_state_store(struct device *dev,
 }
 static DEVICE_ATTR_WO(kbd_rgb_state);
 
-static ssize_t kbd_rgb_state_index_show(struct device *device,
-						 struct device_attribute *attr,
-						 char *buf)
-{
-	return sysfs_emit(buf, "%s\n", "cmd boot awake sleep keyboard");
-}
-static DEVICE_ATTR_RO(kbd_rgb_state_index);
+static DEVICE_STRING_ATTR_RO(kbd_rgb_state_index, 0444,
+			     "cmd boot awake sleep keyboard");
 
 static struct attribute *kbd_rgb_state_attrs[] = {
 	&dev_attr_kbd_rgb_state.attr,
-	&dev_attr_kbd_rgb_state_index.attr,
+	&dev_attr_kbd_rgb_state_index.attr.attr,
 	NULL,
 };
 
@@ -2087,13 +2077,6 @@ static ssize_t pwm1_enable_store(struct device *dev,
 	return count;
 }
 
-static ssize_t fan1_label_show(struct device *dev,
-					  struct device_attribute *attr,
-					  char *buf)
-{
-	return sysfs_emit(buf, "%s\n", ASUS_FAN_DESC);
-}
-
 static ssize_t asus_hwmon_temp1(struct device *dev,
 				struct device_attribute *attr,
 				char *buf)
@@ -2128,13 +2111,6 @@ static ssize_t fan2_input_show(struct device *dev,
 	return sysfs_emit(buf, "%d\n", value * 100);
 }
 
-static ssize_t fan2_label_show(struct device *dev,
-					  struct device_attribute *attr,
-					  char *buf)
-{
-	return sysfs_emit(buf, "%s\n", ASUS_GPU_FAN_DESC);
-}
-
 static ssize_t pwm2_enable_show(struct device *dev,
 				struct device_attribute *attr,
 				char *buf)
@@ -2185,11 +2161,12 @@ static ssize_t pwm2_enable_store(struct device *dev,
 static DEVICE_ATTR_RW(pwm1);
 static DEVICE_ATTR_RW(pwm1_enable);
 static DEVICE_ATTR_RO(fan1_input);
-static DEVICE_ATTR_RO(fan1_label);
+static DEVICE_STRING_ATTR_RO(fan1_label, 0444, ASUS_FAN_DESC);
+
 /* Fan2 - GPU fan */
 static DEVICE_ATTR_RW(pwm2_enable);
 static DEVICE_ATTR_RO(fan2_input);
-static DEVICE_ATTR_RO(fan2_label);
+static DEVICE_STRING_ATTR_RO(fan2_label, 0444, ASUS_GPU_FAN_DESC);
 
 /* Temperature */
 static DEVICE_ATTR(temp1_input, S_IRUGO, asus_hwmon_temp1, NULL);
@@ -2199,9 +2176,9 @@ static struct attribute *hwmon_attributes[] = {
 	&dev_attr_pwm1_enable.attr,
 	&dev_attr_pwm2_enable.attr,
 	&dev_attr_fan1_input.attr,
-	&dev_attr_fan1_label.attr,
+	&dev_attr_fan1_label.attr.attr,
 	&dev_attr_fan2_input.attr,
-	&dev_attr_fan2_label.attr,
+	&dev_attr_fan2_label.attr.attr,
 
 	&dev_attr_temp1_input.attr,
 	NULL
@@ -2218,12 +2195,12 @@ static umode_t asus_hwmon_sysfs_is_visible(struct kobject *kobj,
 		if (asus->fan_type != FAN_TYPE_AGFN)
 			return 0;
 	} else if (attr == &dev_attr_fan1_input.attr
-	    || attr == &dev_attr_fan1_label.attr
+	    || attr == &dev_attr_fan1_label.attr.attr
 	    || attr == &dev_attr_pwm1_enable.attr) {
 		if (asus->fan_type == FAN_TYPE_NONE)
 			return 0;
 	} else if (attr == &dev_attr_fan2_input.attr
-	    || attr == &dev_attr_fan2_label.attr
+	    || attr == &dev_attr_fan2_label.attr.attr
 	    || attr == &dev_attr_pwm2_enable.attr) {
 		if (asus->gpu_fan_type == FAN_TYPE_NONE)
 			return 0;
diff --git a/drivers/platform/x86/toshiba_acpi.c b/drivers/platform/x86/toshiba_acpi.c
index 3541c2048905b..7307249f812d3 100644
--- a/drivers/platform/x86/toshiba_acpi.c
+++ b/drivers/platform/x86/toshiba_acpi.c
@@ -1820,12 +1820,7 @@ static DECLARE_WORK(kbd_bl_work, toshiba_acpi_kbd_bl_work);
 /*
  * Sysfs files
  */
-static ssize_t version_show(struct device *dev,
-			    struct device_attribute *attr, char *buf)
-{
-	return sprintf(buf, "%s\n", TOSHIBA_ACPI_VERSION);
-}
-static DEVICE_ATTR_RO(version);
+static DEVICE_STRING_ATTR_RO(version, 0444, TOSHIBA_ACPI_VERSION);
 
 static ssize_t fan_store(struct device *dev,
 			 struct device_attribute *attr,
@@ -2434,7 +2429,7 @@ static ssize_t cooling_method_store(struct device *dev,
 static DEVICE_ATTR_RW(cooling_method);
 
 static struct attribute *toshiba_attributes[] = {
-	&dev_attr_version.attr,
+	&dev_attr_version.attr.attr,
 	&dev_attr_fan.attr,
 	&dev_attr_kbd_backlight_mode.attr,
 	&dev_attr_kbd_type.attr,
-- 
2.53.0



