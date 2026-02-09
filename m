Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CC8D2DB7B4;
	Mon,  9 Feb 2026 14:47:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770648448; cv=none; b=DbklP13RyuHrjrwo2mDmqKGRB2T/6fUZLOugEXX1+EOkgyTpzx3kNHa03hWq+m/eEddyz32grQCRbnUT+j2cRVclevASeJBlXvMRh+sUIwMzm1ED5cjBJFzFOIxMJM8Nsy0VFDywadn7JCsolpbq6nQ80YAnPrj25G6aJ2a5f0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770648448; c=relaxed/simple;
	bh=piC711j8k1MUg8FeV9eF4VbDNBYsSKLq/V49Re2mAYc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Gd+l2V0D+4lrYdfk2Tp5zZ825NiIsB97LryahD4/yr5kVDC/qP5i+/wRKFNgQzFi21VWMc0CpAIDE5VkMljQe/jPCLupsGi3QRX/OfTpAAkuynW5No5ZViDb55XjtnZte4bEDPzyk+QzHp4/phi8xJggmcTtw33bI48wIXgOSuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ntCxPo5L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ntCxPo5L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3C24C19422;
	Mon,  9 Feb 2026 14:47:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770648448;
	bh=piC711j8k1MUg8FeV9eF4VbDNBYsSKLq/V49Re2mAYc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ntCxPo5LvMpy3AUP4TT6nHZFbpso0IuUNfn1Vt0Xy0L5HYRzPDoEgPap94mmA+ZhQ
	 oBRPva4zjexuFPmKWfEAoogWyzceMpNIAD88zfsjB8bH3SXMFSkuhzJlCspaZWkWod
	 Em75qaTZOw9CIrlwjHSV2v3ZbCt1PBqXQvrLwMMc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Rodrigo=20Lugathe=20da=20Concei=C3=A7=C3=A3o=20Alves?= <lugathe2@gmail.com>,
	Terry Junge <linuxhid@cosmicgizmosystems.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 40/86] HID: Apply quirk HID_QUIRK_ALWAYS_POLL to Edifier QR30 (2d99:a101)
Date: Mon,  9 Feb 2026 15:24:03 +0100
Message-ID: <20260209142306.227972235@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142304.770150175@linuxfoundation.org>
References: <20260209142304.770150175@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rodrigo Lugathe da Conceição Alves <lugathe2@gmail.com>

[ Upstream commit 85a866809333cd2bf8ddac93d9a3e3ba8e4f807d ]

The USB speaker has a bug that causes it to reboot when changing the
brightness using the physical knob.

Add a new vendor and product ID entry in hid-ids.h, and register
the corresponding device in hid-quirks.c with the required quirk.

Signed-off-by: Rodrigo Lugathe da Conceição Alves <lugathe2@gmail.com>
Reviewed-by: Terry Junge <linuxhid@cosmicgizmosystems.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-ids.h    | 3 +++
 drivers/hid/hid-quirks.c | 1 +
 2 files changed, 4 insertions(+)

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index fbbd1dc5582eb..931746cf36302 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -429,6 +429,9 @@
 #define USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_A001	0xa001
 #define USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_C002	0xc002
 
+#define USB_VENDOR_ID_EDIFIER		0x2d99
+#define USB_DEVICE_ID_EDIFIER_QR30	0xa101	/* EDIFIER Hal0 2.0 SE */
+
 #define USB_VENDOR_ID_ELAN		0x04f3
 #define USB_DEVICE_ID_TOSHIBA_CLICK_L9W	0x0401
 #define USB_DEVICE_ID_HP_X2		0x074d
diff --git a/drivers/hid/hid-quirks.c b/drivers/hid/hid-quirks.c
index b2a3ce7bfb6b6..1f531626192cd 100644
--- a/drivers/hid/hid-quirks.c
+++ b/drivers/hid/hid-quirks.c
@@ -81,6 +81,7 @@ static const struct hid_device_id hid_quirks[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_DRAGONRISE, USB_DEVICE_ID_DRAGONRISE_PS3), HID_QUIRK_MULTI_INPUT },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_DRAGONRISE, USB_DEVICE_ID_DRAGONRISE_WIIU), HID_QUIRK_MULTI_INPUT },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_DWAV, USB_DEVICE_ID_EGALAX_TOUCHCONTROLLER), HID_QUIRK_MULTI_INPUT | HID_QUIRK_NOGET },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_EDIFIER, USB_DEVICE_ID_EDIFIER_QR30), HID_QUIRK_ALWAYS_POLL },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ELAN, HID_ANY_ID), HID_QUIRK_ALWAYS_POLL },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ELO, USB_DEVICE_ID_ELO_TS2700), HID_QUIRK_NOGET },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_EMS, USB_DEVICE_ID_EMS_TRIO_LINKER_PLUS_II), HID_QUIRK_MULTI_INPUT },
-- 
2.51.0



