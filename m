Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 221183081CB;
	Tue,  2 Sep 2025 13:24:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756819453; cv=none; b=ECUaKPaw0upWY7o59nD9nPxxUSqD258vlswAZ5e93AnDDo46jAzsReF660+7VM4VvUrxoC4YIDg+cRT0wYF/fJJOFMlcTSmPolq5OiOddSFFq4Jam6K9WHBs0EKcm0WDKMOvNHAb0C0dRB8OyfSG7t5JaXyP4bzdulIQv4i1z1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756819453; c=relaxed/simple;
	bh=2IfSLyLEHvz7fBzaABOlSuNPAVfJou80ygluktP9SDw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TGk31rcX46OnC+KJewo7t74cv4dNW2LT5KhZ+OLVYsrvMm0lEg0C1s9YHlNj3HGANAsu1AbuQBqTkUbSR+EwKq9xhZiHQcXQgbk2n2tniDW0FCOZnRILFttTll4a2q0NAMOkrtReJx0kpA56ca7jKDJk+xDowSqCFA9grSk7igY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WsYQasUW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WsYQasUW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 816BAC4CEED;
	Tue,  2 Sep 2025 13:24:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756819453;
	bh=2IfSLyLEHvz7fBzaABOlSuNPAVfJou80ygluktP9SDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WsYQasUWcChwF+JfBEDpAPABf3sgvxLmVhp3f6XC7K9ky1s8hMSWU6Mrr6m7ypVhN
	 fLfZnJcDjENDXP+991Iu080tutRI8xFjOtiAtgpAflcBWCcx2otYWLeVKM5rOjx3Ze
	 RntDgRGWE+W9j523Sfj1qINuleUZte/My6DfNX/Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?=E5=8D=A2=E5=9B=BD=E5=AE=8F?= <luguohong@xiaomi.com>,
	=?UTF-8?q?Jos=C3=A9=20Exp=C3=B3sito?= <jose.exposito89@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 039/142] HID: input: rename hidinput_set_battery_charge_status()
Date: Tue,  2 Sep 2025 15:19:01 +0200
Message-ID: <20250902131949.644046700@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131948.154194162@linuxfoundation.org>
References: <20250902131948.154194162@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index ff1784b5c2a47..262787e6eb204 100644
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -595,6 +595,20 @@ static void hidinput_cleanup_battery(struct hid_device *dev)
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
@@ -617,20 +631,6 @@ static void hidinput_update_battery(struct hid_device *dev, int value)
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
@@ -642,14 +642,14 @@ static void hidinput_cleanup_battery(struct hid_device *dev)
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
 
@@ -1515,7 +1515,7 @@ void hidinput_hid_event(struct hid_device *hid, struct hid_field *field, struct
 		return;
 
 	if (usage->type == EV_PWR) {
-		bool handled = hidinput_set_battery_charge_status(hid, usage->hid, value);
+		bool handled = hidinput_update_battery_charge_status(hid, usage->hid, value);
 
 		if (!handled)
 			hidinput_update_battery(hid, value);
-- 
2.50.1



