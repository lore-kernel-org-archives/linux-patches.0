Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060881;
	b=pia2p41hzz4sp+dtNgj8IZF+TiI9Qjgnxyr/otAP8tq8IRxKzMCipO2wlX5y+klRhw+8
	 NGVQQhSNPH7G0fXM6f2sv5kaqek3Fhs1RE/7j3up0Qdh8PX361i4+/2SqLgNgxy8ngT5I
	 uSWo/mlnpOIaYhsx3H6nRDq9sSojT6Hy8pVYxBctSXs8i0sUYFAaUVRpmbXyGQl9EFVby
	 9ngDgIJW3yeqeyOiltEK1ya2r0NUqZO9Ah5YeavVva0LGxXA9Dmp8BfNa40c03qIgJhnV
	 I1JTQFpLts5/FD0b53vKSowB0flNA3wyQR1kAOBDUrrs3/WZWjnexH3+jdqsAZ5clvA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060881;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WlcYXpRgLoOeVWKRES0yl06V08CbcyBBg4XvRzZnKpY=;
	b=E6b8HRykw4iA+DeU+ixYhlW2quTK7JqXlD4EFfnD8lc73QgvbssqaY2bX32x12NZDFcD
	 k+h3ae8ATprC8PtXHkav5Jyp8VLAllsp0qYwfjEkLlc7pxOdFZlAyo56z1sq4cYQLPhGl
	 0bRBCrf7+uZLC/N2D+G53czbONz5eB8OoIA0U9fTZq9ftm5M3SJ2/ZZ44PKRcwnJZzTWi
	 ANGywRR7ZOcmd/vbBezeOFyC1pC5E/jmPKYJhupBV/tDB+xlWBmD0UXzRkpm2KUp6wh4b
	 cNL5haw1/3drOOEd0fhh0cWrzYjY6wMwMZrKwgb4TN5lOtdVG7HCH8RF0VWSim6wjAw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Zv5eesHi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88254606D80C;
	Sat,  7 Nov 2026 14:14:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Zv5eesHi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 326E51F0089F;
	Sat,  7 Nov 2026 14:14:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060881;
	bh=WlcYXpRgLoOeVWKRES0yl06V08CbcyBBg4XvRzZnKpY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Zv5eesHi7yyoTW3WtZz85KC9fYXENnErz7lOgvqL3i21GDaGgFyQn2QRUgkgNLihh
	 rhFLUrtAnAUJg07wrO6MkQ9Rwn9NfTgxh4jq5zGZlKBjWtmd1v63CHaLFK4Q3b3jt0
	 OBoyWVXz0k4oZ+2bNgIWoeY6hYsgS8CI6vY3917w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuxiang Lin <mclyxfdw@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0261/1536] HID: quirks: add ALWAYS_POLL quirk for AULA Mini 60 HE Pro Dongle
Date: Sat,  7 Nov 2026 08:37:57 -0500
Message-ID: <20261107135005.014237169@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 7d63306dccbd9..7de3e011fe6cf 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -740,6 +740,7 @@
 #define USB_DEVICE_ID_JESS_YUREX	0x1010
 #define USB_DEVICE_ID_ASUS_MD_5112	0x5112
 #define USB_DEVICE_ID_REDRAGON_ASURA	0x760b
+#define USB_DEVICE_ID_AULA_MINI_60_HE_PRO 0xfefe
 
 #define USB_VENDOR_ID_JESS2		0x0f30
 #define USB_DEVICE_ID_JESS2_COLOR_RUMBLE_PAD 0x0111
diff --git a/drivers/hid/hid-quirks.c b/drivers/hid/hid-quirks.c
index 97722b8803ce6..bca15dd628f5f 100644
--- a/drivers/hid/hid-quirks.c
+++ b/drivers/hid/hid-quirks.c
@@ -113,6 +113,8 @@ static const struct hid_device_id hid_quirks[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_HP, USB_PRODUCT_ID_HP_PIXART_OEM_USB_OPTICAL_MOUSE_1f4a), HID_QUIRK_ALWAYS_POLL },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_IDEACOM, USB_DEVICE_ID_IDEACOM_IDC6680), HID_QUIRK_MULTI_INPUT },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_INNOMEDIA, USB_DEVICE_ID_INNEX_GENESIS_ATARI), HID_QUIRK_MULTI_INPUT },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_JESS, USB_DEVICE_ID_AULA_MINI_60_HE_PRO),
+		HID_QUIRK_ALWAYS_POLL },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_KYE, USB_DEVICE_ID_PIXART_USB_OPTICAL_MOUSE_ID2), HID_QUIRK_ALWAYS_POLL },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_KYE, USB_DEVICE_ID_KYE_EASYPEN_M406), HID_QUIRK_MULTI_INPUT },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_KYE, USB_DEVICE_ID_KYE_EASYPEN_M506), HID_QUIRK_MULTI_INPUT },
-- 
2.53.0



