Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A394847A
	for <patches@lists.linux.dev>; Wed,  1 Mar 2023 18:12:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 046D7C433D2;
	Wed,  1 Mar 2023 18:12:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1677694324;
	bh=pTSRAXw7DYGKWZHU3UYXOHJQxgUkpC+l+eg/xofmgYo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mBxlq58pLH8Fb++qN6pqR7XEXvDI8KA6xOQNUt8kvnZ9Hhn8OkjbGosJWSdcWizNb
	 +FTvaQkPOC4fVC9rxLa/qPQjzMjicq02KIvq9Dz1Q00rfo4GyEcybt91UpkbiHEf1e
	 5B93NYPI1i7RbWXRNEOypkJ1sstKfFDKjGJXUfLk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luka Guzenko <l.guzenko@web.de>,
	Benjamin Tissoires <benjamin.tissoires@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 21/42] HID: Ignore battery for ELAN touchscreen 29DF on HP
Date: Wed,  1 Mar 2023 19:08:42 +0100
Message-Id: <20230301180658.012224300@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230301180657.003689969@linuxfoundation.org>
References: <20230301180657.003689969@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Luka Guzenko <l.guzenko@web.de>

[ Upstream commit ebebf05a4b06a1be49788ca0edf990de01c4b0d0 ]

The touchscreen reports a battery status of 0% and jumps to 1% when a
stylus is used. The device ID was added and the battery ignore quirk was
enabled for it.

Signed-off-by: Luka Guzenko <l.guzenko@web.de>
Link: https://lore.kernel.org/r/20230120223741.3007-1-l.guzenko@web.de
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-ids.h   | 1 +
 drivers/hid/hid-input.c | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 46c0ce4203c08..9e36b4cd905ee 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -413,6 +413,7 @@
 #define I2C_DEVICE_ID_HP_ENVY_X360_15T_DR100	0x29CF
 #define I2C_DEVICE_ID_HP_ENVY_X360_EU0009NV	0x2CF9
 #define I2C_DEVICE_ID_HP_SPECTRE_X360_15	0x2817
+#define I2C_DEVICE_ID_HP_SPECTRE_X360_13_AW0020NG  0x29DF
 #define I2C_DEVICE_ID_ASUS_TP420IA_TOUCHSCREEN 0x2BC8
 #define USB_DEVICE_ID_ASUS_UX550VE_TOUCHSCREEN	0x2544
 #define USB_DEVICE_ID_ASUS_UX550_TOUCHSCREEN	0x2706
diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
index 3736b0afbff73..7e94ca1822afb 100644
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -386,6 +386,8 @@ static const struct hid_device_id hid_battery_quirks[] = {
 	  HID_BATTERY_QUIRK_IGNORE },
 	{ HID_I2C_DEVICE(USB_VENDOR_ID_ELAN, I2C_DEVICE_ID_HP_SPECTRE_X360_15),
 	  HID_BATTERY_QUIRK_IGNORE },
+	{ HID_I2C_DEVICE(USB_VENDOR_ID_ELAN, I2C_DEVICE_ID_HP_SPECTRE_X360_13_AW0020NG),
+	  HID_BATTERY_QUIRK_IGNORE },
 	{ HID_I2C_DEVICE(USB_VENDOR_ID_ELAN, I2C_DEVICE_ID_SURFACE_GO_TOUCHSCREEN),
 	  HID_BATTERY_QUIRK_IGNORE },
 	{ HID_I2C_DEVICE(USB_VENDOR_ID_ELAN, I2C_DEVICE_ID_SURFACE_GO2_TOUCHSCREEN),
-- 
2.39.0



