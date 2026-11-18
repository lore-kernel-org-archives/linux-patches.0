Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038481;
	b=i7zltxYDZNxesIaSu+Suf5OmD4s9XcJ6Ugj53kR4ZBOWmywHt4hNAE2Dkirvpe/HyEbm
	 MW1Lzv2tUyoBi05/bwd/5rvVykwDGAMgbI+SvA/PKFfXzyTqhVaPZAfcSrlVXFzSCxryb
	 4l5GtQ7KOQorXT79wNmTD7VP6wjbLqbsgOy4N7ojFJLlBrGRAOqIf4SbpA5olk7Yb/8SH
	 iS1P6bCByZbFkBLluizjMhMQLp8WP8bt2+MGWRMmq8OTjBeLtdNLktOzS/HX+KnmVGun+
	 HT1wqktG5hFCnmTOgnbKGTTatywkeoussy1+jtoGlPWR6MIRSRmR2kkRsY8hVxtDw4w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038481;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6pl1Bo8GImsbtiErjko2N8AXnJwKoulKBW91VoHmkG8=;
	b=Ri3IcDX7JSwi/aR2LWeAa0V6C19We2ffciHRAnz/FuXJKeZHboF93A6TfmCBXNPrjc/w
	 ZCN5cGfWvfHvlnqSY6prjnymBd5iBWodZ8atbTAHoMzdxu8dkAGW0+x3b+uunTbgPjFWJ
	 apg9BHb30G44S8HKJLNJ5EZhVDkwBHKZiNi5utVGvV7m5LbMmvP6IL6X+OOo85NPtREzj
	 2sYiBxiR++DIxwvzB/1jSjUypTrfcJdgseDMhlC4SFOt/16hDLaLfboMGX1IkBFEBgRIc
	 c9iIlfcROrNYQp/2d7gQ8vS7xPyEfGa7wmOkTkg2tTz7wZAYgQW0N6QpZOoY3jcaxEQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VQIsNcih;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8476606A320;
	Wed, 18 Nov 2026 21:48:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VQIsNcih
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41B291F000C8;
	Wed, 18 Nov 2026 21:48:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038480;
	bh=6pl1Bo8GImsbtiErjko2N8AXnJwKoulKBW91VoHmkG8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VQIsNcihYm02gZS33HKR17LNHj2aBZfKSYXrCE42AagV0Yar1VAHWv+wuamZ2nafG
	 zrwhP2ljMtQxRSWVE/FhA5GBIFB+MEVLYV1x3YkB0/D2qsv1vkKGbgzkL+SAXVKZYU
	 B8yxuEdznO1kQnruMCXTSq+jG0CxLbyqEjKA6Kfc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukas Wunner <lukas@wunner.de>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1758/3318] platform/x86: Use device_show_string() helper for sysfs attributes
Date: Wed, 18 Nov 2026 15:39:40 +0100
Message-ID: <20261118150414.594595678@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
Stable-dep-of: 3d9a175707ee ("platform/x86: asus-wmi: fix TUF keyboard power state shutdown naming")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/asus-wmi.c     | 62 ++++++++---------------------
 drivers/platform/x86/toshiba_acpi.c |  9 +----
 2 files changed, 18 insertions(+), 53 deletions(-)

diff --git a/drivers/platform/x86/asus-wmi.c b/drivers/platform/x86/asus-wmi.c
index d83d3f4a56aab..a3ebea7f0108a 100644
--- a/drivers/platform/x86/asus-wmi.c
+++ b/drivers/platform/x86/asus-wmi.c
@@ -926,17 +926,12 @@ static ssize_t kbd_rgb_mode_store(struct device *dev,
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
 
@@ -978,17 +973,12 @@ static ssize_t kbd_rgb_state_store(struct device *dev,
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
 
@@ -2505,13 +2495,6 @@ static ssize_t pwm1_enable_store(struct device *dev,
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
@@ -2546,13 +2529,6 @@ static ssize_t fan2_input_show(struct device *dev,
 	return sysfs_emit(buf, "%d\n", value * 100);
 }
 
-static ssize_t fan2_label_show(struct device *dev,
-					  struct device_attribute *attr,
-					  char *buf)
-{
-	return sysfs_emit(buf, "%s\n", ASUS_GPU_FAN_DESC);
-}
-
 /* Middle/Center fan on modern ROG laptops */
 static ssize_t fan3_input_show(struct device *dev,
 					struct device_attribute *attr,
@@ -2571,13 +2547,6 @@ static ssize_t fan3_input_show(struct device *dev,
 	return sysfs_emit(buf, "%d\n", value * 100);
 }
 
-static ssize_t fan3_label_show(struct device *dev,
-					  struct device_attribute *attr,
-					  char *buf)
-{
-	return sysfs_emit(buf, "%s\n", ASUS_MID_FAN_DESC);
-}
-
 static ssize_t pwm2_enable_show(struct device *dev,
 				struct device_attribute *attr,
 				char *buf)
@@ -2674,15 +2643,16 @@ static ssize_t pwm3_enable_store(struct device *dev,
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
 /* Fan3 - Middle/center fan */
 static DEVICE_ATTR_RW(pwm3_enable);
 static DEVICE_ATTR_RO(fan3_input);
-static DEVICE_ATTR_RO(fan3_label);
+static DEVICE_STRING_ATTR_RO(fan3_label, 0444, ASUS_MID_FAN_DESC);
 
 /* Temperature */
 static DEVICE_ATTR(temp1_input, S_IRUGO, asus_hwmon_temp1, NULL);
@@ -2693,11 +2663,11 @@ static struct attribute *hwmon_attributes[] = {
 	&dev_attr_pwm2_enable.attr,
 	&dev_attr_pwm3_enable.attr,
 	&dev_attr_fan1_input.attr,
-	&dev_attr_fan1_label.attr,
+	&dev_attr_fan1_label.attr.attr,
 	&dev_attr_fan2_input.attr,
-	&dev_attr_fan2_label.attr,
+	&dev_attr_fan2_label.attr.attr,
 	&dev_attr_fan3_input.attr,
-	&dev_attr_fan3_label.attr,
+	&dev_attr_fan3_label.attr.attr,
 
 	&dev_attr_temp1_input.attr,
 	NULL
@@ -2714,17 +2684,17 @@ static umode_t asus_hwmon_sysfs_is_visible(struct kobject *kobj,
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
 	} else if (attr == &dev_attr_fan3_input.attr
-	    || attr == &dev_attr_fan3_label.attr
+	    || attr == &dev_attr_fan3_label.attr.attr
 	    || attr == &dev_attr_pwm3_enable.attr) {
 		if (asus->mid_fan_type == FAN_TYPE_NONE)
 			return 0;
diff --git a/drivers/platform/x86/toshiba_acpi.c b/drivers/platform/x86/toshiba_acpi.c
index 26991b2f7ae91..669af07433482 100644
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



