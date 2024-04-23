Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AD49143C41;
	Tue, 23 Apr 2024 21:45:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908704; cv=none; b=XmW0kbj+WawZp077oKXBdtqW8Mte+k6/HxR986KklW4HbenWYZFKLus8glAbQJN4yNv96TfBR0AwP3uHquGeynjAuvnoXLT24+jRQqarZw/QtxpbEygAFhUo12HlPDxEs/iHn3AvQx7MV/aC9OWWu/J71/7m77HoGEJWLIC7HTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908704; c=relaxed/simple;
	bh=5+CVJ8flXCCw6Th7FklOt5yiLITg37hTxRPA/OYgj0U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XFo0UTGIJ8zPljqxBGz9LR968HIIve6TiccO+j9a16n9KBZwBqj9nHAmjCJZjAp1mPxb3qWkiA2LB26i81L4Fg9ixZxGrWemILAiiscRzm5+xOXPAQ1h3CABRgQLD4zWmnrEkIfD04p4zqdmcYqXPS3FgEi6c2Qk9DTIi0Hykm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Slc1nyrI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Slc1nyrI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3CF9C3277B;
	Tue, 23 Apr 2024 21:45:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908703;
	bh=5+CVJ8flXCCw6Th7FklOt5yiLITg37hTxRPA/OYgj0U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Slc1nyrILL5Gkx9q5Azecx/nrfxfJjBzoxaYwwqcF3Bm7Nm+5PZ3xdSfzsEQFHtjL
	 gD2R3WBOb9EO1WC4pG9C4+1xvD4RG7uN99bInvOAcyEyDmhYsXKnwIGlGUCJGyMl79
	 T20lCMQOF+PrRGVBgy+vLFy+PGNoK09mE0CtCmT4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Yang <mmyangfl@gmail.com>,
	Jiri Kosina <jkosina@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 058/141] HID: kye: Sort kye devices
Date: Tue, 23 Apr 2024 14:38:46 -0700
Message-ID: <20240423213855.137512391@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213853.356988651@linuxfoundation.org>
References: <20240423213853.356988651@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Yang <mmyangfl@gmail.com>

[ Upstream commit 8c7b79bc04abb67e7f5864e94286a800b42aa96c ]

Sort kye devices by their Produce IDs.

Signed-off-by: David Yang <mmyangfl@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-ids.h    |  2 +-
 drivers/hid/hid-kye.c    | 62 ++++++++++++++++++++--------------------
 drivers/hid/hid-quirks.c |  6 ++--
 3 files changed, 35 insertions(+), 35 deletions(-)

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 1be454bafcb91..405d88b08908d 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -717,10 +717,10 @@
 #define USB_DEVICE_ID_KYE_GPEN_560	0x5003
 #define USB_DEVICE_ID_KYE_EASYPEN_I405X	0x5010
 #define USB_DEVICE_ID_KYE_MOUSEPEN_I608X	0x5011
-#define USB_DEVICE_ID_KYE_MOUSEPEN_I608X_V2	0x501a
 #define USB_DEVICE_ID_KYE_EASYPEN_M610X	0x5013
 #define USB_DEVICE_ID_KYE_PENSKETCH_M912	0x5015
 #define USB_DEVICE_ID_KYE_EASYPEN_M406XE	0x5019
+#define USB_DEVICE_ID_KYE_MOUSEPEN_I608X_V2	0x501A
 
 #define USB_VENDOR_ID_LABTEC		0x1020
 #define USB_DEVICE_ID_LABTEC_WIRELESS_KEYBOARD	0x0006
diff --git a/drivers/hid/hid-kye.c b/drivers/hid/hid-kye.c
index da903138eee49..dc57e9d4a3e20 100644
--- a/drivers/hid/hid-kye.c
+++ b/drivers/hid/hid-kye.c
@@ -602,6 +602,18 @@ static __u8 *kye_report_fixup(struct hid_device *hdev, __u8 *rdesc,
 			rdesc[74] = 0x08;
 		}
 		break;
+	case USB_DEVICE_ID_GENIUS_GILA_GAMING_MOUSE:
+		rdesc = kye_consumer_control_fixup(hdev, rdesc, rsize, 104,
+					"Genius Gila Gaming Mouse");
+		break;
+	case USB_DEVICE_ID_GENIUS_MANTICORE:
+		rdesc = kye_consumer_control_fixup(hdev, rdesc, rsize, 104,
+					"Genius Manticore Keyboard");
+		break;
+	case USB_DEVICE_ID_GENIUS_GX_IMPERATOR:
+		rdesc = kye_consumer_control_fixup(hdev, rdesc, rsize, 83,
+					"Genius Gx Imperator Keyboard");
+		break;
 	case USB_DEVICE_ID_KYE_EASYPEN_I405X:
 		if (*rsize == EASYPEN_I405X_RDESC_ORIG_SIZE) {
 			rdesc = easypen_i405x_rdesc_fixed;
@@ -638,18 +650,6 @@ static __u8 *kye_report_fixup(struct hid_device *hdev, __u8 *rdesc,
 			*rsize = sizeof(pensketch_m912_rdesc_fixed);
 		}
 		break;
-	case USB_DEVICE_ID_GENIUS_GILA_GAMING_MOUSE:
-		rdesc = kye_consumer_control_fixup(hdev, rdesc, rsize, 104,
-					"Genius Gila Gaming Mouse");
-		break;
-	case USB_DEVICE_ID_GENIUS_GX_IMPERATOR:
-		rdesc = kye_consumer_control_fixup(hdev, rdesc, rsize, 83,
-					"Genius Gx Imperator Keyboard");
-		break;
-	case USB_DEVICE_ID_GENIUS_MANTICORE:
-		rdesc = kye_consumer_control_fixup(hdev, rdesc, rsize, 104,
-					"Genius Manticore Keyboard");
-		break;
 	}
 	return rdesc;
 }
@@ -717,26 +717,26 @@ static int kye_probe(struct hid_device *hdev, const struct hid_device_id *id)
 	}
 
 	switch (id->product) {
+	case USB_DEVICE_ID_GENIUS_MANTICORE:
+		/*
+		 * The manticore keyboard needs to have all the interfaces
+		 * opened at least once to be fully functional.
+		 */
+		if (hid_hw_open(hdev))
+			hid_hw_close(hdev);
+		break;
 	case USB_DEVICE_ID_KYE_EASYPEN_I405X:
 	case USB_DEVICE_ID_KYE_MOUSEPEN_I608X:
-	case USB_DEVICE_ID_KYE_MOUSEPEN_I608X_V2:
 	case USB_DEVICE_ID_KYE_EASYPEN_M610X:
-	case USB_DEVICE_ID_KYE_EASYPEN_M406XE:
 	case USB_DEVICE_ID_KYE_PENSKETCH_M912:
+	case USB_DEVICE_ID_KYE_EASYPEN_M406XE:
+	case USB_DEVICE_ID_KYE_MOUSEPEN_I608X_V2:
 		ret = kye_tablet_enable(hdev);
 		if (ret) {
 			hid_err(hdev, "tablet enabling failed\n");
 			goto enabling_err;
 		}
 		break;
-	case USB_DEVICE_ID_GENIUS_MANTICORE:
-		/*
-		 * The manticore keyboard needs to have all the interfaces
-		 * opened at least once to be fully functional.
-		 */
-		if (hid_hw_open(hdev))
-			hid_hw_close(hdev);
-		break;
 	}
 
 	return 0;
@@ -749,23 +749,23 @@ static int kye_probe(struct hid_device *hdev, const struct hid_device_id *id)
 static const struct hid_device_id kye_devices[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_KYE, USB_DEVICE_ID_KYE_ERGO_525V) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_KYE,
-				USB_DEVICE_ID_KYE_EASYPEN_I405X) },
+				USB_DEVICE_ID_GENIUS_GILA_GAMING_MOUSE) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_KYE,
-				USB_DEVICE_ID_KYE_MOUSEPEN_I608X) },
+				USB_DEVICE_ID_GENIUS_MANTICORE) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_KYE,
-				USB_DEVICE_ID_KYE_MOUSEPEN_I608X_V2) },
+				USB_DEVICE_ID_GENIUS_GX_IMPERATOR) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_KYE,
-				USB_DEVICE_ID_KYE_EASYPEN_M610X) },
+				USB_DEVICE_ID_KYE_EASYPEN_I405X) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_KYE,
-				USB_DEVICE_ID_KYE_EASYPEN_M406XE) },
+				USB_DEVICE_ID_KYE_MOUSEPEN_I608X) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_KYE,
-				USB_DEVICE_ID_GENIUS_GILA_GAMING_MOUSE) },
+				USB_DEVICE_ID_KYE_EASYPEN_M610X) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_KYE,
-				USB_DEVICE_ID_GENIUS_GX_IMPERATOR) },
+				USB_DEVICE_ID_KYE_PENSKETCH_M912) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_KYE,
-				USB_DEVICE_ID_GENIUS_MANTICORE) },
+				USB_DEVICE_ID_KYE_EASYPEN_M406XE) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_KYE,
-				USB_DEVICE_ID_KYE_PENSKETCH_M912) },
+				USB_DEVICE_ID_KYE_MOUSEPEN_I608X_V2) },
 	{ }
 };
 MODULE_DEVICE_TABLE(hid, kye_devices);
diff --git a/drivers/hid/hid-quirks.c b/drivers/hid/hid-quirks.c
index 60884066362a1..debc49272a5c0 100644
--- a/drivers/hid/hid-quirks.c
+++ b/drivers/hid/hid-quirks.c
@@ -107,12 +107,12 @@ static const struct hid_device_id hid_quirks[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_HP, USB_PRODUCT_ID_HP_PIXART_OEM_USB_OPTICAL_MOUSE_1f4a), HID_QUIRK_ALWAYS_POLL },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_IDEACOM, USB_DEVICE_ID_IDEACOM_IDC6680), HID_QUIRK_MULTI_INPUT },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_INNOMEDIA, USB_DEVICE_ID_INNEX_GENESIS_ATARI), HID_QUIRK_MULTI_INPUT },
-	{ HID_USB_DEVICE(USB_VENDOR_ID_KYE, USB_DEVICE_ID_KYE_EASYPEN_M610X), HID_QUIRK_MULTI_INPUT },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_KYE, USB_DEVICE_ID_PIXART_USB_OPTICAL_MOUSE_ID2), HID_QUIRK_ALWAYS_POLL },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_KYE, USB_DEVICE_ID_KYE_MOUSEPEN_I608X), HID_QUIRK_MULTI_INPUT },
-	{ HID_USB_DEVICE(USB_VENDOR_ID_KYE, USB_DEVICE_ID_KYE_MOUSEPEN_I608X_V2), HID_QUIRK_MULTI_INPUT },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_KYE, USB_DEVICE_ID_KYE_EASYPEN_M610X), HID_QUIRK_MULTI_INPUT },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_KYE, USB_DEVICE_ID_KYE_PENSKETCH_M912), HID_QUIRK_MULTI_INPUT },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_KYE, USB_DEVICE_ID_KYE_EASYPEN_M406XE), HID_QUIRK_MULTI_INPUT },
-	{ HID_USB_DEVICE(USB_VENDOR_ID_KYE, USB_DEVICE_ID_PIXART_USB_OPTICAL_MOUSE_ID2), HID_QUIRK_ALWAYS_POLL },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_KYE, USB_DEVICE_ID_KYE_MOUSEPEN_I608X_V2), HID_QUIRK_MULTI_INPUT },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LENOVO, USB_DEVICE_ID_LENOVO_OPTICAL_USB_MOUSE_600E), HID_QUIRK_ALWAYS_POLL },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LENOVO, USB_DEVICE_ID_LENOVO_PIXART_USB_MOUSE_608D), HID_QUIRK_ALWAYS_POLL },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LENOVO, USB_DEVICE_ID_LENOVO_PIXART_USB_MOUSE_6019), HID_QUIRK_ALWAYS_POLL },
-- 
2.43.0



