Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035527;
	b=cDV2hTa2jlsaqH8UJUWJV/dYc1AWjPWhkx1fhF8nviYe8W+RQKVkstjf5PxHsHC603g5
	 OrJG9MkBaH1g+iFhYFKAwuQGfGLvqToGsyZkis58YQyybdt3xzlsIec71HIHjEhmrpL7z
	 KHdNENuI2AUzGQLnWRZ3KG3nITcoPVnDzequsAljgU1E1JfLFmDD/5xJnwRdYLtXFwrTw
	 GvBwfeS1gMsCu40/E/o2tHcJvidEaF8HJkLpvraTPJ2sCnDNuDJqbFEP3Uvxx/gRsxQei
	 0zIF7jiVCGHcOpGQH5xKF0VPMAXTZCcdBOQNTOSuzTtS9deURKjY4dic311kqOXY2Hw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035527;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8KS9MlDq+KGFsMd1cyzgIrSI2ah9ClnY6ssOBuSXGH4=;
	b=BFcddfLZpOPxJK9EfE9wyB21bFL8rXdux7P6gL4S6s4JGBLaJ87DFZ4bjisRz2eb7uTJ
	 8NNN2LZCDrkSLzJ5Ng8VrwBxQ0fljBfz/M8GdlQA9mI++ZWRsuw5nU0UyPqQyy1a7lPyz
	 3Y6zuP642Xl0xCi2LiiCZjFYFQuNrAceZa4F/M2Q9rT5XRTj/hwdldNtRxWDgKDqYQcXU
	 5QPciXnq3E4OgpKZyqCJkX2PqMp9devMIu0MZfd2/fM+c1BQse9JZ93x7b/NlwJj8xjh8
	 QH2E0wtV3USGKnvN67SQKKepCVTQXpDT6uP4yZGSXRceP+yIEbpnErV55sYsjiGYypw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kcYSDE7l;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C641606A31C;
	Wed, 18 Nov 2026 20:58:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kcYSDE7l
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E0111F000C4;
	Wed, 18 Nov 2026 20:58:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035527;
	bh=8KS9MlDq+KGFsMd1cyzgIrSI2ah9ClnY6ssOBuSXGH4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kcYSDE7l4zLPCZfLEvqDKP8Yka4szed7Xn+bfw2DsscoYMTfmOUHa1jhif5Y9pAtM
	 dPHYsBbiHHtS7v9VvwrvlnRqFz3KOGp+lBnnlQws+vnJ/VKPApx5PnHfu3T3Q2JFey
	 DGfBHKOYrji3RwS9eiabbIhcKp9X+oj5p7ulzmdU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabor Tanz <gabor.tanz@gmail.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.6 0734/3318] HID: quirks: Always poll the Anne Pro 2 with product ID a292
Date: Wed, 18 Nov 2026 15:22:36 +0100
Message-ID: <20261118150340.575767489@linuxfoundation.org>
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

From: Gabor Tanz <gabor.tanz@gmail.com>

commit cbc13a78a89d087252947d0a51048e576cfcb3ef upstream.

The wired Anne Pro 2 identifying as 04d9:a292 stops delivering keyboard
input after a period of inactivity. Unplugging and reconnecting the
keyboard restores input.

Keeping ObinsKit running prevents the problem. A read-only userspace
reader that keeps USB HID interface 1 open also prevents it, as does
usbhid.quirks=0x04d9:0xa292:0x00000400 without either application running.

Commit ca28aff0e1dc ("HID: quirks: Always poll Obins Anne Pro 2
keyboard") added HID_QUIRK_ALWAYS_POLL for product ID a293.
The variant identifying as 04d9:a292 exhibits the same symptom.
Apply the quirk to this product ID as well.

Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Gabor Tanz <gabor.tanz@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-ids.h    |    1 +
 drivers/hid/hid-quirks.c |    1 +
 2 files changed, 2 insertions(+)

--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -704,6 +704,7 @@
 #define USB_DEVICE_ID_HOLTEK_ALT_MOUSE_A081	0xa081
 #define USB_DEVICE_ID_HOLTEK_ALT_MOUSE_A0C2	0xa0c2
 #define USB_DEVICE_ID_HOLTEK_ALT_KEYBOARD_A096	0xa096
+#define USB_DEVICE_ID_HOLTEK_ALT_KEYBOARD_A292	0xa292
 #define USB_DEVICE_ID_HOLTEK_ALT_KEYBOARD_A293	0xa293
 
 #define USB_VENDOR_ID_IMATION		0x0718
--- a/drivers/hid/hid-quirks.c
+++ b/drivers/hid/hid-quirks.c
@@ -102,6 +102,7 @@ static const struct hid_device_id hid_qu
 	{ HID_USB_DEVICE(USB_VENDOR_ID_HAPP, USB_DEVICE_ID_UGCI_FIGHTING), HID_QUIRK_BADPAD | HID_QUIRK_MULTI_INPUT },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_HAPP, USB_DEVICE_ID_UGCI_FLYING), HID_QUIRK_BADPAD | HID_QUIRK_MULTI_INPUT },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_HOLTEK_ALT, USB_DEVICE_ID_HOLTEK_ALT_KEYBOARD_A096), HID_QUIRK_NO_INIT_REPORTS },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_HOLTEK_ALT, USB_DEVICE_ID_HOLTEK_ALT_KEYBOARD_A292), HID_QUIRK_ALWAYS_POLL },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_HOLTEK_ALT, USB_DEVICE_ID_HOLTEK_ALT_KEYBOARD_A293), HID_QUIRK_ALWAYS_POLL },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_HP, USB_PRODUCT_ID_HP_LOGITECH_OEM_USB_OPTICAL_MOUSE_0A4A), HID_QUIRK_ALWAYS_POLL },
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_HP, USB_PRODUCT_ID_HP_ELITE_PRESENTER_MOUSE_464A), HID_QUIRK_MULTI_INPUT },


