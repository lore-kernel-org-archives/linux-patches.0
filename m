Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0A2D310783;
	Tue,  2 Sep 2025 13:39:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756820397; cv=none; b=Uz14FaZqIfqrkl1tVl5RUu8FeFFNa08w5hssLs8AHRgJE9hBclz5DrDphDs7O4sBH/zmP66uWTFphB42SFoAZOJFL062Ak9S9IIXuXBpNqUZVeeTMr66dkSYhZCrukDNxbqWVCntGJhw7Xc7XTTT1wwF1Au3mCfAPXOidobOv9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756820397; c=relaxed/simple;
	bh=6D7bzOKIWPJ9n7R4Pdn6xKudinKCJ4p9PcrlA+dWjZI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Aeuko65d4ZWB8jkDhbakZ7uO4ej9KT7FVpZ0G8KPVQ0ePxYdXHVYBWp9KAoJWXFcg9xC1+EdZ/kxvqyNhOwA2WLf6NYXglqt4RyfPEROQM2jZyWCGNYtXxTytJ9ifGHSSTL1lzbrk7TenqUcq+dzyoAz61NvujGDrEKPX3uOIec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K4Jwdoxs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K4Jwdoxs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 121B8C4CEED;
	Tue,  2 Sep 2025 13:39:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756820397;
	bh=6D7bzOKIWPJ9n7R4Pdn6xKudinKCJ4p9PcrlA+dWjZI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K4JwdoxsV3JQSJ5OpgErJKDo0oPu57oH9n4RiKO6v0gORDH1FaCLZ2iZQKH+XTSGE
	 nR+7wU3QSFm12kT9zFNLZs0jw1RkKtQ3hEvatvL/kLfETXIpB+3kP2atzCM5b7xF6C
	 taiYb7TIai0/PNEQYICUaNXZVTaEDyQ2F29YFIHU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?=E5=8D=A2=E5=9B=BD=E5=AE=8F?= <luguohong@xiaomi.com>,
	=?UTF-8?q?Jos=C3=A9=20Exp=C3=B3sito?= <jose.exposito89@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 16/50] HID: input: rename hidinput_set_battery_charge_status()
Date: Tue,  2 Sep 2025 15:21:07 +0200
Message-ID: <20250902131931.164924208@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131930.509077918@linuxfoundation.org>
References: <20250902131930.509077918@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: José Expósito <jose.exposito89@gmail.com>

[ Upstream commit a82231b2a8712d0218fc286a9b0da328d419a3f4 ]

In preparation for a patch fixing a bug affecting
hidinput_set_battery_charge_status(), rename the function to
hidinput_update_battery_charge_status() and move it up so it can be used
by hidinput_update_battery().

Refactor, no functional changes.

Tested-by: 卢国宏 <luguohong@xiaomi.com>
Signed-off-by: José Expósito <jose.exposito89@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Stable-dep-of: e94536e1d181 ("HID: input: report battery status changes immediately")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-input-test.c | 10 +++++-----
 drivers/hid/hid-input.c      | 38 ++++++++++++++++++------------------
 2 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/drivers/hid/hid-input-test.c b/drivers/hid/hid-input-test.c
index 77c2d45ac62a7..6f5c71660d823 100644
--- a/drivers/hid/hid-input-test.c
+++ b/drivers/hid/hid-input-test.c
@@ -7,7 +7,7 @@
 
 #include <kunit/test.h>
 
-static void hid_test_input_set_battery_charge_status(struct kunit *test)
+static void hid_test_input_update_battery_charge_status(struct kunit *test)
 {
 	struct hid_device *dev;
 	bool handled;
@@ -15,15 +15,15 @@ static void hid_test_input_set_battery_charge_status(struct kunit *test)
 	dev = kunit_kzalloc(test, sizeof(*dev), GFP_KERNEL);
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, dev);
 
-	handled = hidinput_set_battery_charge_status(dev, HID_DG_HEIGHT, 0);
+	handled = hidinput_update_battery_charge_status(dev, HID_DG_HEIGHT, 0);
 	KUNIT_EXPECT_FALSE(test, handled);
 	KUNIT_EXPECT_EQ(test, dev->battery_charge_status, POWER_SUPPLY_STATUS_UNKNOWN);
 
-	handled = hidinput_set_battery_charge_status(dev, HID_BAT_CHARGING, 0);
+	handled = hidinput_update_battery_charge_status(dev, HID_BAT_CHARGING, 0);
 	KUNIT_EXPECT_TRUE(test, handled);
 	KUNIT_EXPECT_EQ(test, dev->battery_charge_status, POWER_SUPPLY_STATUS_DISCHARGING);
 
-	handled = hidinput_set_battery_charge_status(dev, HID_BAT_CHARGING, 1);
+	handled = hidinput_update_battery_charge_status(dev, HID_BAT_CHARGING, 1);
 	KUNIT_EXPECT_TRUE(test, handled);
 	KUNIT_EXPECT_EQ(test, dev->battery_charge_status, POWER_SUPPLY_STATUS_CHARGING);
 }
@@ -63,7 +63,7 @@ static void hid_test_input_get_battery_property(struct kunit *test)
 }
 
 static struct kunit_case hid_input_tests[] = {
-	KUNIT_CASE(hid_test_input_set_battery_charge_status),
+	KUNIT_CASE(hid_test_input_update_battery_charge_status),
 	KUNIT_CASE(hid_test_input_get_battery_property),
 	{ }
 };
diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
index b0091819fd58a..51be30b7c1851 100644
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -609,6 +609,20 @@ static void hidinput_cleanup_battery(struct hid_device *dev)
 	dev->battery = NULL;
 }
 
+static bool hidinput_update_battery_charge_status(struct hid_device *dev,
+						  unsigned int usage, int value)
+{
+	switch (usage) {
+	case HID_BAT_CHARGING:
+		dev->battery_charge_status = value ?
+					     POWER_SUPPLY_STATUS_CHARGING :
+					     POWER_SUPPLY_STATUS_DISCHARGING;
+		return true;
+	}
+
+	return false;
+}
+
 static void hidinput_update_battery(struct hid_device *dev, int value)
 {
 	int capacity;
@@ -631,20 +645,6 @@ static void hidinput_update_battery(struct hid_device *dev, int value)
 		power_supply_changed(dev->battery);
 	}
 }
-
-static bool hidinput_set_battery_charge_status(struct hid_device *dev,
-					       unsigned int usage, int value)
-{
-	switch (usage) {
-	case HID_BAT_CHARGING:
-		dev->battery_charge_status = value ?
-					     POWER_SUPPLY_STATUS_CHARGING :
-					     POWER_SUPPLY_STATUS_DISCHARGING;
-		return true;
-	}
-
-	return false;
-}
 #else  /* !CONFIG_HID_BATTERY_STRENGTH */
 static int hidinput_setup_battery(struct hid_device *dev, unsigned report_type,
 				  struct hid_field *field, bool is_percentage)
@@ -656,14 +656,14 @@ static void hidinput_cleanup_battery(struct hid_device *dev)
 {
 }
 
-static void hidinput_update_battery(struct hid_device *dev, int value)
+static bool hidinput_update_battery_charge_status(struct hid_device *dev,
+						  unsigned int usage, int value)
 {
+	return false;
 }
 
-static bool hidinput_set_battery_charge_status(struct hid_device *dev,
-					       unsigned int usage, int value)
+static void hidinput_update_battery(struct hid_device *dev, int value)
 {
-	return false;
 }
 #endif	/* CONFIG_HID_BATTERY_STRENGTH */
 
@@ -1509,7 +1509,7 @@ void hidinput_hid_event(struct hid_device *hid, struct hid_field *field, struct
 		return;
 
 	if (usage->type == EV_PWR) {
-		bool handled = hidinput_set_battery_charge_status(hid, usage->hid, value);
+		bool handled = hidinput_update_battery_charge_status(hid, usage->hid, value);
 
 		if (!handled)
 			hidinput_update_battery(hid, value);
-- 
2.50.1



