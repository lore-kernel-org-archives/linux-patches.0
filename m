Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D52953803CD;
	Tue, 10 Mar 2026 11:28:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773142124; cv=none; b=q9Z29hQv1bcnAdn8WrxRYyUsus+II8EgjUvU2tqGBFmRZiJqc7ohq1d5N44I9GgJ6cj+BR+wokyT590UB2SVQ33ac58LBCAHu5UR63xwkOO8qogzRv2mAxL6WYuWD76D6OZS7sqqAyIr1KAXumZdbeewFSQ1137+EFch3H0ZVWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773142124; c=relaxed/simple;
	bh=86cuy5bsOsXmi7He/wJYNm2GpTCDTH3NKeX6iSgsT5w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X9oJmyR4+kOBls39pUk06cj45i64bSfGgw1ecA0a0MqjvlMNbvt0rZkJRjScm6ZqFBS6XAeU1DC//57oE+CLNczR5eB5fEn4GsXMS0kpcsFpVdgoWrdwUULCNwXzUccSD3ToVvDGbFVk1h2vWgnPXLhoIjARRVpQfVU+e68X8is=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jy/KkJ9l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jy/KkJ9l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26874C2BC86;
	Tue, 10 Mar 2026 11:28:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773142124;
	bh=86cuy5bsOsXmi7He/wJYNm2GpTCDTH3NKeX6iSgsT5w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jy/KkJ9lRdW8fEJFN3tUzyp0daqtukqEbpIpjISRDzCsIbtE/7DV8WL37SCvJCLcS
	 fBB2QB4j8B2JpjRQBs32ogF5WqZKNp4gcyw+mcnT6vsP2mgd3ctSIeOR5vM3qGXiEf
	 9/rKnkNAovikrBXVckSCgTo0d7knPLx/QFHkoPEo8UULXflkxGffN1QdA8NjvsJqAB
	 /5E1vTshDdt3YwO3ct3iwaXE8QZ1qUBqS76zBOfFloh3bCLRaltE1BZURTmIjBKc1W
	 /0vRkXLdTuWWKK8PYLdO9lHlrBnCmaFeRJEKhFNw/GVqLvmG4tnh+ZhfVq7JkXzkp5
	 vFp1EUdyYNSTQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Ian Ray <ian.ray@gehealthcare.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 213/314] HID: multitouch: new class MT_CLS_EGALAX_P80H84
Date: Tue, 10 Mar 2026 07:17:52 -0400
Message-ID: <79b0dec3b975b5dfde4df6e76701ac1bdfc793a0.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Ian Ray <ian.ray@gehealthcare.com>

[ Upstream commit a2e70a89fa58133521b2deae4427d35776bda935 ]

Fixes: f9e82295eec1 ("HID: multitouch: add eGalaxTouch P80H84 support")
Signed-off-by: Ian Ray <ian.ray@gehealthcare.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-multitouch.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index 1f8accb7ff435..af19e089b0122 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -233,6 +233,7 @@ static void mt_post_parse(struct mt_device *td, struct mt_application *app);
 #define MT_CLS_SMART_TECH			0x0113
 #define MT_CLS_APPLE_TOUCHBAR			0x0114
 #define MT_CLS_YOGABOOK9I			0x0115
+#define MT_CLS_EGALAX_P80H84			0x0116
 #define MT_CLS_SIS				0x0457
 
 #define MT_DEFAULT_MAXCONTACT	10
@@ -447,6 +448,11 @@ static const struct mt_class mt_classes[] = {
 			MT_QUIRK_YOGABOOK9I,
 		.export_all_inputs = true
 	},
+	{ .name = MT_CLS_EGALAX_P80H84,
+		.quirks = MT_QUIRK_ALWAYS_VALID |
+			MT_QUIRK_IGNORE_DUPLICATES |
+			MT_QUIRK_CONTACT_CNT_ACCURATE,
+	},
 	{ }
 };
 
@@ -2223,8 +2229,9 @@ static const struct hid_device_id mt_devices[] = {
 	{ .driver_data = MT_CLS_EGALAX_SERIAL,
 		MT_USB_DEVICE(USB_VENDOR_ID_DWAV,
 			USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_C000) },
-	{ .driver_data = MT_CLS_EGALAX,
-		MT_USB_DEVICE(USB_VENDOR_ID_DWAV,
+	{ .driver_data = MT_CLS_EGALAX_P80H84,
+		HID_DEVICE(HID_BUS_ANY, HID_GROUP_MULTITOUCH_WIN_8,
+			USB_VENDOR_ID_DWAV,
 			USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_C002) },
 
 	/* Elan devices */
-- 
2.51.0

