Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624323;
	b=ydk9iJQeXmDv4v2i9QGuIY2Whgag1NWYhJ5swXk6+33mIlwif+IyJXySe8b0Io7qGVGP
	 YfebhyasRX2hgxHh8cpVHwkleHNuDD3fEk5J2qo2Q+mFCNLdBeMgVWcgej55tixiggbcd
	 OU+QUcTuf/j+XGkoWZWwqRUrDrq6BFbgIKQglSRW9VIlUOYAvETeUDYG+epDJ83kw8d5F
	 +nvmbRQJKno37+e5Fbnad9M21tgBMkuggcM86ADFYph8KOo7g/ncUhfBCbmuWquUggZuA
	 f3xuSigsvUUl5cdzf1Icu41BFhKbkX5cAmYtS9ZKPD38+poRBV5BgO5FaRWDTRgqmug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624323;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YVXPQtBVdzjSKNE0BZ+Ou7F/x5hGUIghYkd7TiAgG5M=;
	b=RTD7nyC9FwXAfxUY5CaaPSnv9giVoaTtI0sdLzHnm/JcYAizgDYoxsfzaeJtqdp7StHv
	 pCaBES/rkN86tpDtQSXMBRyQvKREZ5z5btaoS1dD96YjfA/S6GS5RH/HvTS3h0kwc7brB
	 Jn28R14Em8UXgMziHh4SMn100D9IBjadlvUDn0H930ctZLnFFUSW5POAnU+tUFhpmDNQg
	 pPmHHEtoumGCqr7FgYH5fMhjwGlSWYYT57tOnHQFcTvulrO9WUQyXqVrQIbTFyAJThk/Z
	 Sxxje8j3dchryUGl61CYi/ROf+8nP5U7JEr96yGsjT5P+XlLnRKNbp2a0HQqqVoYugg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vA0iyPXc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03C30606A683;
	Wed, 25 Nov 2026 16:32:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vA0iyPXc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F228A1F000C0;
	Wed, 25 Nov 2026 16:32:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624322;
	bh=YVXPQtBVdzjSKNE0BZ+Ou7F/x5hGUIghYkd7TiAgG5M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vA0iyPXcSo+YZrB/EKh0cFv0KrQgFhifOkosmy4avuWld5r7Va8iELl9xfQ56NeHX
	 Yi1L1K8sqefIszqKFDccAMrUos2baLJG2T4G0GW+dI3qgW5FULNdQB3+TCUDNO1h0F
	 T8YyRHoPi8+fixd4Em9wbcztw5BS1NMyHsLfT2Bs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Lu <chris.lu@mediatek.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 156/816] Bluetooth: btmtk: derive the firmware ISO setting from MTK_ISO_THRESHOLD
Date: Wed, 25 Nov 2026 15:28:24 +0100
Message-ID: <20261125143852.807075617@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

From: Chris Lu <chris.lu@mediatek.com>

[ Upstream commit 855c9a54608f1e94f4c52afe3790def30534155a ]

The ISO data transfer size is spelled out twice: as a raw byte pair in the
vendor command sent by btmtk_usb_isointf_init(), and as MTK_ISO_THRESHOLD
for the padding in btmtk_isopkt_pad(). Build the command payload from the
macro so the size is stated once, and update the setting for current
MediaTek controllers.

Fixes: ceac1cb0259d ("Bluetooth: btusb: mediatek: add ISO data transmission functions")
Signed-off-by: Chris Lu <chris.lu@mediatek.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btmtk.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/bluetooth/btmtk.c b/drivers/bluetooth/btmtk.c
index c1a73ace94938..cff351968d610 100644
--- a/drivers/bluetooth/btmtk.c
+++ b/drivers/bluetooth/btmtk.c
@@ -25,7 +25,7 @@
 #define MTK_SEC_MAP_NEED_SEND_SIZE	52
 
 /* It is for mt79xx iso data transmission setting */
-#define MTK_ISO_THRESHOLD	264
+#define MTK_ISO_THRESHOLD	342
 
 struct btmtk_patch_header {
 	u8 datetime[16];
@@ -1352,7 +1352,7 @@ static int btmtk_submit_intr_urb(struct hci_dev *hdev, gfp_t mem_flags)
 static int btmtk_usb_isointf_init(struct hci_dev *hdev)
 {
 	struct btmtk_data *btmtk_data = hci_get_priv(hdev);
-	u8 iso_param[2] = { 0x08, 0x01 };
+	__le16 iso_param = cpu_to_le16(MTK_ISO_THRESHOLD);
 	struct sk_buff *skb;
 	int err;
 
@@ -1367,7 +1367,7 @@ static int btmtk_usb_isointf_init(struct hci_dev *hdev)
 		return err;
 	}
 
-	skb = __hci_cmd_sync(hdev, 0xfd98, sizeof(iso_param), iso_param,
+	skb = __hci_cmd_sync(hdev, 0xfd98, sizeof(iso_param), &iso_param,
 			     HCI_INIT_TIMEOUT);
 	if (IS_ERR(skb)) {
 		bt_dev_err(hdev, "Failed to apply iso setting (%ld)", PTR_ERR(skb));
-- 
2.53.0



