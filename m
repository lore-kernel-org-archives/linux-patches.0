Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043383;
	b=Mx2dp0eERYzvbuJs6t6S31uEZdgXSR46aEEyA50SKiRIkW5VXjQdpuyD8DDyw9dgxCm+
	 yeUnGV7XgFgSfVKqlaq2Y/sBg10SENE4S8vkYArbDgfRAyi7vxrg4idGl7yHv8XAA133l
	 f3ZyCsNK9M4sQJ7rzomk5XOTOtJbxii2+FF9vN7tEHDyEC2BwXgCRV3+Z5CzJtRclEBE+
	 E5KinO73Fey/kr667bxPp1aObyzfOwwzRhf/ZERkNZGLYMBJKysJJG5297qgfZDy2YavR
	 RCu1YwOMRLGmi++rS/MJUUMNk4+c8bvCbTNYRPXQFbTa9TTUtEw7FktctRm4zwnBvWA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043383;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JxoMnJQrVC2VsQatidknaAb+GJ47OPUvQ8IdIrnpRJw=;
	b=MM1FTwEURc3ZW6JxT114pIG80TNZm43Z6KaoFgreJb5A7ZkwIKS7CIkNj07lzrZrT7CV
	 bbwfXg3RB/xEiTdOzi7aNJidW7XpPZQpTUUFwzeO+GnJ6igx+fERR0mrm1J+QWBXjwm3J
	 zWePaDqVomMu9EV4QAY4kDbLHbVfx20mnSJJeb7RHonmi/iKhH4jqbm/wCGF8utBvneaJ
	 EBRso4w5XWJhlfW/wZ0YnDEDY9S7q763t60Yfwf13jP5AEPLQBQSfwNuuQQlEW61nUZeW
	 fpJYPo6fgjocJUwl3vwGqgfdtNMSaXC9O34l4pj4PVWcnrkWzzpvXnHCyQPaurKLqQw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CT9+MEzf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FEEC606A320;
	Wed, 18 Nov 2026 23:09:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CT9+MEzf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF6BA1F000C4;
	Wed, 18 Nov 2026 23:09:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043383;
	bh=JxoMnJQrVC2VsQatidknaAb+GJ47OPUvQ8IdIrnpRJw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CT9+MEzfgfrQa++WnG7mRvhKBbQhvZvyDKHc3YhRmJrpO70CJ8xBAAm2O9PY339To
	 AL1owofRjk1c5Od1f9J/D2YqMwTbljiftJ+qmT44fq8YNlflj5HB842ZWTfRcqEZXr
	 h7R/gU7p7kR+ucYhHh8KMPv4u8Oyw3DL1gNFGavA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuxiang Lin <mclyxfdw@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0189/2857] HID: quirks: add ALWAYS_POLL quirk for AULA Mini 60 HE Pro Dongle
Date: Wed, 18 Nov 2026 15:20:23 +0100
Message-ID: <20261118150208.160652038@linuxfoundation.org>
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

From: Yuxiang Lin <mclyxfdw@gmail.com>

[ Upstream commit 2884e21b18613708f050ec75330b265dd07ecc03 ]

The AULA Mini 60 HE Pro wireless keyboard dongle (USB ID
0c45:fefe) becomes unresponsive after roughly one minute of idle.
No error appears in dmesg; the only recovery is physically
replugging the dongle.

This has been reproduced across kernels 6.8, 6.14 and 7.1.3.

Testing shows HID_QUIRK_ALWAYS_POLL alone resolves the issue,
verified via usbhid.quirks=0x0c45:0xfefe:0x400.

Signed-off-by: Yuxiang Lin <mclyxfdw@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-ids.h    | 1 +
 drivers/hid/hid-quirks.c | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 4d185a3a4d2ad..0176d074ebea9 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -723,6 +723,7 @@
 #define USB_DEVICE_ID_JESS_YUREX	0x1010
 #define USB_DEVICE_ID_ASUS_MD_5112	0x5112
 #define USB_DEVICE_ID_REDRAGON_ASURA	0x760b
+#define USB_DEVICE_ID_AULA_MINI_60_HE_PRO 0xfefe
 
 #define USB_VENDOR_ID_JESS2		0x0f30
 #define USB_DEVICE_ID_JESS2_COLOR_RUMBLE_PAD 0x0111
diff --git a/drivers/hid/hid-quirks.c b/drivers/hid/hid-quirks.c
index 683b3a2251ed6..1d2f0b260ab63 100644
--- a/drivers/hid/hid-quirks.c
+++ b/drivers/hid/hid-quirks.c
@@ -113,6 +113,8 @@ static const struct hid_device_id hid_quirks[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_HP, USB_PRODUCT_ID_HP_PIXART_OEM_USB_OPTICAL_MOUSE_1f4a), HID_QUIRK_ALWAYS_POLL },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_IDEACOM, USB_DEVICE_ID_IDEACOM_IDC6680), HID_QUIRK_MULTI_INPUT },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_INNOMEDIA, USB_DEVICE_ID_INNEX_GENESIS_ATARI), HID_QUIRK_MULTI_INPUT },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_JESS, USB_DEVICE_ID_AULA_MINI_60_HE_PRO),
+		HID_QUIRK_ALWAYS_POLL },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_KYE, USB_DEVICE_ID_PIXART_USB_OPTICAL_MOUSE_ID2), HID_QUIRK_ALWAYS_POLL },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_KYE, USB_DEVICE_ID_KYE_MOUSEPEN_I608X), HID_QUIRK_MULTI_INPUT },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_KYE, USB_DEVICE_ID_KYE_EASYPEN_M610X), HID_QUIRK_MULTI_INPUT },
-- 
2.53.0



