Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CC3E1A3A80;
	Mon,  2 Jun 2025 13:58:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748872726; cv=none; b=FcZKYDuDXNk1SURaU8xRMdobNpG8TBHWiCkdIPfYKYed34oV6uQ5gVVDHdpLbYJEIfe0/D4o07nEMGuqqxhm7Y+BCygBnAL17K/xgYEW9pIuVGPA9OK0wBU564NBcE0AQ4lA+6ftPmRC6WqFUBElmGVnYcWLOqT5eE+d260khXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748872726; c=relaxed/simple;
	bh=34E/o1Mb9Db+l9KYIRha/s+43PtO+1ShtCkeoKE5/vw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QuYHN2MGvroLEtws2Cij0Mj4JmsFsd9mvAbJyXCne57RSHmbHzMLDPOzOv6lo903Z+NVZ896OQ2f41j5kSdIQHDPpXftLTuivxlr1dTc85yEDc5hSaqSahNQrm6oIbiZ9XdQXn+52zmP0TVIQJpHK63hPpkhIMQ9nuLWLbN/0Bg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fQakY95m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fQakY95m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C41D5C4CEEB;
	Mon,  2 Jun 2025 13:58:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748872726;
	bh=34E/o1Mb9Db+l9KYIRha/s+43PtO+1ShtCkeoKE5/vw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fQakY95mewTojopQvx9YO/jfuoT8UIFIzUfGMiadbq6L8vvr3ASXzH1aLzkBtSFgz
	 SWQ94+gI9Mzua7JTM0rl6NXr1TNEXRDdSaklyJJJKfnC1FRalaiCKIbyFGnvP7aOts
	 kHBeZvUnKidTBbRO/UAn54D1Gn32hHDJhyHE7G3w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Milton Barrera <miltonjosue2001@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 50/73] HID: quirks: Add ADATA XPG alpha wireless mouse support
Date: Mon,  2 Jun 2025 15:47:36 +0200
Message-ID: <20250602134243.671703010@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134241.673490006@linuxfoundation.org>
References: <20250602134241.673490006@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index 288a2b864cc41..1062731315a2a 100644
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



