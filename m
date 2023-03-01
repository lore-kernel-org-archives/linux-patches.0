Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15B47847A
	for <patches@lists.linux.dev>; Wed,  1 Mar 2023 18:12:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AE54C433D2;
	Wed,  1 Mar 2023 18:12:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1677694347;
	bh=Ul2cX6UrFT1clrRmeOIAg5WgxINYbCha8sI77awJEH0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j/AuaJn5ngk5F7+qkMhbyCxltaRPvIobkDdvq9gj0NguiPI4yHhNhZ61r7Pzwic8Z
	 SGBDUAsL/cikwugBlRvnEceNNuY0ProUz8yHPUUbo7B1UF/gbX9eTmbPUqygAdxVbG
	 jG4pdSMrm3CN87y6JSgZj5XqxqwjnfLafMuV8TUI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marco Rodolfi <marco.rodolfi@tuta.io>,
	Jiri Kosina <jkosina@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 08/42] HID: Ignore battery for Elan touchscreen on Asus TP420IA
Date: Wed,  1 Mar 2023 19:08:29 +0100
Message-Id: <20230301180657.405911889@linuxfoundation.org>
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

From: marco.rodolfi@tuta.io <marco.rodolfi@tuta.io>

[ Upstream commit cb963b2c011a62838852c902eccb3f72e5d3dbb6 ]

This device has a touchscreen thats report a battery even if it doesn't
have one.
Ask Linux to ignore the battery so it will not always report it as low.

[jkosina@suse.cz: fix whitespace damage]
Signed-off-by: Marco Rodolfi <marco.rodolfi@tuta.io>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-ids.h   | 1 +
 drivers/hid/hid-input.c | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index d01d798ebedca..46c0ce4203c08 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -413,6 +413,7 @@
 #define I2C_DEVICE_ID_HP_ENVY_X360_15T_DR100	0x29CF
 #define I2C_DEVICE_ID_HP_ENVY_X360_EU0009NV	0x2CF9
 #define I2C_DEVICE_ID_HP_SPECTRE_X360_15	0x2817
+#define I2C_DEVICE_ID_ASUS_TP420IA_TOUCHSCREEN 0x2BC8
 #define USB_DEVICE_ID_ASUS_UX550VE_TOUCHSCREEN	0x2544
 #define USB_DEVICE_ID_ASUS_UX550_TOUCHSCREEN	0x2706
 #define I2C_DEVICE_ID_SURFACE_GO_TOUCHSCREEN	0x261A
diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
index 3ee5a9fea20e6..3736b0afbff73 100644
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -370,6 +370,8 @@ static const struct hid_device_id hid_battery_quirks[] = {
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_LOGITECH,
 		USB_DEVICE_ID_LOGITECH_DINOVO_EDGE_KBD),
 	  HID_BATTERY_QUIRK_IGNORE },
+	{ HID_I2C_DEVICE(USB_VENDOR_ID_ELAN, I2C_DEVICE_ID_ASUS_TP420IA_TOUCHSCREEN),
+	  HID_BATTERY_QUIRK_IGNORE },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ELAN, USB_DEVICE_ID_ASUS_UX550_TOUCHSCREEN),
 	  HID_BATTERY_QUIRK_IGNORE },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ELAN, USB_DEVICE_ID_ASUS_UX550VE_TOUCHSCREEN),
-- 
2.39.0



