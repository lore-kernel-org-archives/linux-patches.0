Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EFE115CAE
	for <patches@lists.linux.dev>; Tue,  8 Nov 2022 14:10:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B34AC433D6;
	Tue,  8 Nov 2022 14:10:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667916631;
	bh=0Dey/UFhuf0OrEo/sloIPYEVTEtorlx8N38Ma/FUBUs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qE8H5iaDaG7e1p2k1ltAIvcI/qbjwoWb00tyMACOVT1Ml0MCg1fIBEvQJy0US9Kan
	 sB1iUbs0fTsA51rooehsVbxOfqg45Lm9OUz3+74GIHKXDTD66Rs7dULcKAl4MsLIVh
	 eHSMyXOLQia+wvFz9um5wvCCo6XLEiV1c5AK/UkM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samuel Bailey <samuel.bailey1@gmail.com>,
	Jiri Kosina <jkosina@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 083/197] HID: saitek: add madcatz variant of MMO7 mouse device ID
Date: Tue,  8 Nov 2022 14:38:41 +0100
Message-Id: <20221108133358.610956868@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133354.787209461@linuxfoundation.org>
References: <20221108133354.787209461@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Samuel Bailey <samuel.bailey1@gmail.com>

[ Upstream commit 79425b297f56bd481c6e97700a9a4e44c7bcfa35 ]

The MadCatz variant of the MMO7 mouse has the ID 0738:1713 and the same
quirks as the Saitek variant.

Signed-off-by: Samuel Bailey <samuel.bailey1@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-ids.h    | 1 +
 drivers/hid/hid-quirks.c | 1 +
 drivers/hid/hid-saitek.c | 2 ++
 3 files changed, 4 insertions(+)

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 043cf1cc8794..256795ed6247 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -867,6 +867,7 @@
 #define USB_DEVICE_ID_MADCATZ_BEATPAD	0x4540
 #define USB_DEVICE_ID_MADCATZ_RAT5	0x1705
 #define USB_DEVICE_ID_MADCATZ_RAT9	0x1709
+#define USB_DEVICE_ID_MADCATZ_MMO7  0x1713
 
 #define USB_VENDOR_ID_MCC		0x09db
 #define USB_DEVICE_ID_MCC_PMD1024LS	0x0076
diff --git a/drivers/hid/hid-quirks.c b/drivers/hid/hid-quirks.c
index 70f602c64fd1..50e1c717fc0a 100644
--- a/drivers/hid/hid-quirks.c
+++ b/drivers/hid/hid-quirks.c
@@ -620,6 +620,7 @@ static const struct hid_device_id hid_have_special_driver[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SAITEK, USB_DEVICE_ID_SAITEK_MMO7) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_MADCATZ, USB_DEVICE_ID_MADCATZ_RAT5) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_MADCATZ, USB_DEVICE_ID_MADCATZ_RAT9) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_MADCATZ, USB_DEVICE_ID_MADCATZ_MMO7) },
 #endif
 #if IS_ENABLED(CONFIG_HID_SAMSUNG)
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SAMSUNG, USB_DEVICE_ID_SAMSUNG_IR_REMOTE) },
diff --git a/drivers/hid/hid-saitek.c b/drivers/hid/hid-saitek.c
index c7bf14c01960..b84e975977c4 100644
--- a/drivers/hid/hid-saitek.c
+++ b/drivers/hid/hid-saitek.c
@@ -187,6 +187,8 @@ static const struct hid_device_id saitek_devices[] = {
 		.driver_data = SAITEK_RELEASE_MODE_RAT7 },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SAITEK, USB_DEVICE_ID_SAITEK_MMO7),
 		.driver_data = SAITEK_RELEASE_MODE_MMO7 },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_MADCATZ, USB_DEVICE_ID_MADCATZ_MMO7),
+		.driver_data = SAITEK_RELEASE_MODE_MMO7 },
 	{ }
 };
 
-- 
2.35.1



