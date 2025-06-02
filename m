Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0439223327;
	Mon,  2 Jun 2025 14:01:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748872912; cv=none; b=ghR4rj2zBz5D0TbkeeLXoL/9dnOHL3ZG11318TJzdRsgSMCZnUNKnVPKRYgxcqkUcgTp3lIuSbybyPJp6L6ADfeg6vyBLOALg1+90zc9CBufhOTNYZEsgb98dfjnehK+Y5Wk3Yj812/QrShk/G4Ac7w8POEElBLWMR93BHiZNkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748872912; c=relaxed/simple;
	bh=eEeXQ43vtY/W7vvaJHDC/Gx17tltqAQgNxUm/P46lpU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k18xS29judbz/IrFZLtoTJqEeSvOcL5AwrrY7u0vj7zTIW5vOF4CN7OPVlMuknpth6QKOl8qCPTC4gq90tYKsik0FkadBuFmPH1iMGEbw5PNiFWAi3snHV/iborDVhAM0ydxk3HN7MyEXSEVI6E1r1K212KjNMT6db15DplOwNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iLgBKXat; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iLgBKXat"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59000C4CEEB;
	Mon,  2 Jun 2025 14:01:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748872912;
	bh=eEeXQ43vtY/W7vvaJHDC/Gx17tltqAQgNxUm/P46lpU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iLgBKXatbxCybUx4UAwTJcMSoWENIcb3aNOXgewXo4JjrhDg2ieU6bzu4a2IzqOXG
	 7AlReTapRWyjl4RqK5aGDHjiJ2bsZbpZWbPJ/CpgRsyln89WwJsTGLdnhL4xa4FrLv
	 GEjQGflQqh2RI5no/Y/OkHlX+o7f6dGDoH8jERhE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Milton Barrera <miltonjosue2001@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 36/55] HID: quirks: Add ADATA XPG alpha wireless mouse support
Date: Mon,  2 Jun 2025 15:47:53 +0200
Message-ID: <20250602134239.704007462@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134238.271281478@linuxfoundation.org>
References: <20250602134238.271281478@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Milton Barrera <miltonjosue2001@gmail.com>

[ Upstream commit fa9fdeea1b7d6440c22efa6d59a769eae8bc89f1 ]

This patch adds HID_QUIRK_ALWAYS_POLL for the ADATA XPG wireless gaming mouse (USB ID 125f:7505) and its USB dongle (USB ID 125f:7506). Without this quirk, the device does not generate input events properly.

Signed-off-by: Milton Barrera <miltonjosue2001@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-ids.h    | 4 ++++
 drivers/hid/hid-quirks.c | 2 ++
 2 files changed, 6 insertions(+)

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 92baa34f42f28..c6424f6259487 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -41,6 +41,10 @@
 #define USB_VENDOR_ID_ACTIONSTAR	0x2101
 #define USB_DEVICE_ID_ACTIONSTAR_1011	0x1011
 
+#define USB_VENDOR_ID_ADATA_XPG 0x125f
+#define USB_VENDOR_ID_ADATA_XPG_WL_GAMING_MOUSE 0x7505
+#define USB_VENDOR_ID_ADATA_XPG_WL_GAMING_MOUSE_DONGLE 0x7506
+
 #define USB_VENDOR_ID_ADS_TECH		0x06e1
 #define USB_DEVICE_ID_ADS_TECH_RADIO_SI470X	0xa155
 
diff --git a/drivers/hid/hid-quirks.c b/drivers/hid/hid-quirks.c
index 5d7a418ccdbec..73979643315bf 100644
--- a/drivers/hid/hid-quirks.c
+++ b/drivers/hid/hid-quirks.c
@@ -27,6 +27,8 @@
 static const struct hid_device_id hid_quirks[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_AASHIMA, USB_DEVICE_ID_AASHIMA_GAMEPAD), HID_QUIRK_BADPAD },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_AASHIMA, USB_DEVICE_ID_AASHIMA_PREDATOR), HID_QUIRK_BADPAD },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_ADATA_XPG, USB_VENDOR_ID_ADATA_XPG_WL_GAMING_MOUSE), HID_QUIRK_ALWAYS_POLL },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_ADATA_XPG, USB_VENDOR_ID_ADATA_XPG_WL_GAMING_MOUSE_DONGLE), HID_QUIRK_ALWAYS_POLL },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_AFATECH, USB_DEVICE_ID_AFATECH_AF9016), HID_QUIRK_FULLSPEED_INTERVAL },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_AIREN, USB_DEVICE_ID_AIREN_SLIMPLUS), HID_QUIRK_NOGET },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_AKAI_09E8, USB_DEVICE_ID_AKAI_09E8_MIDIMIX), HID_QUIRK_NO_INIT_REPORTS },
-- 
2.39.5



