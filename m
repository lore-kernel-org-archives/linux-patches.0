Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDC8E24A078;
	Tue, 21 Jul 2026 20:11:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664721; cv=none; b=InLy3tLvjMWwA7lFBvb5FoxNkAz3cZs3i01d5Ad5PDv0Op20YZCFGtdMz5BSzpDppxoz3pEqO+BI0reudoSWPU8w8s6B0b5DNWE4Dm+rLfhSnjAuQ1XzOPAb310u5wROa0nCY+hdimx9KLbXKQHT3JQBwCNn3GqIKP+97JOqJqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664721; c=relaxed/simple;
	bh=XyKIimOUNBPDXV6rw+VVT6+kBjgO0vHC4UQgSWttNJ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FQ6VnxknQAK+86bGjJUxdzdRKU36a1rbb04CyY+I9I1qzqsGipGh0HbUfZLw+12nGQBWeQIjGlSb6aoPykkGR8gKBo8aYlR04gPMbBLN0/Eh+QedGItuQh73vIBZGh4pTC2rpkEDvLnZrW0aq6Yj/X4s1cZGJKvelhcv5ny+wH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u72+cDHT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u72+cDHT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A0B31F000E9;
	Tue, 21 Jul 2026 20:11:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664719;
	bh=sSTRXbfpug6P5phQQ9jKpGP0vNngSE49i2JrWQrb8sw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u72+cDHTCAycN8z6FcSzWCmjECTXTgVbnVAxgedkykB8Onl/4d6F2ClxVORMLhq4n
	 lcCP2JQ89VESSAni3FAS72kqE6XtD+mKT6ZS7Z5UxS+Xwx8IXz4+zXutSUofaN0Ikd
	 gS/dq8VfLFWyuDwgBYw6ZHcWt1FtNHl2eO0nYFDo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Wang <sean.wang@mediatek.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0006/1266] Bluetooth: btmtk: apply the common btmtk_fw_get_filename
Date: Tue, 21 Jul 2026 17:07:23 +0200
Message-ID: <20260721152441.934327732@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Wang <sean.wang@mediatek.com>

[ Upstream commit 7f935b21bee4d8a9f26b57ae6c3682161b247809 ]

Apply the common btmtk_fw_get_filename to avoid the similar coding in each
driver.

Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Stable-dep-of: 5c5e8c52e3ca ("Bluetooth: btmtk: move btusb_mtk_[setup, shutdown] to btmtk.c")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btmtksdio.c |  3 +++
 drivers/bluetooth/btusb.c     | 10 ++--------
 2 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/bluetooth/btmtksdio.c b/drivers/bluetooth/btmtksdio.c
index e249aa7587833b..2be38c8e353efb 100644
--- a/drivers/bluetooth/btmtksdio.c
+++ b/drivers/bluetooth/btmtksdio.c
@@ -1111,6 +1111,9 @@ static int btmtksdio_setup(struct hci_dev *hdev)
 			return err;
 		}
 
+		btmtk_fw_get_filename(fwname, sizeof(fwname), dev_id,
+				      fw_version, 0);
+
 		snprintf(fwname, sizeof(fwname),
 			 "mediatek/BT_RAM_CODE_MT%04x_1_%x_hdr.bin",
 			 dev_id & 0xffff, (fw_version & 0xff) + 1);
diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 9b2857a8e7ac1f..048929e336cf64 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -2940,14 +2940,8 @@ static int btusb_mtk_setup(struct hci_dev *hdev)
 	case 0x7922:
 	case 0x7961:
 	case 0x7925:
-		if (dev_id == 0x7925)
-			snprintf(fw_bin_name, sizeof(fw_bin_name),
-				 "mediatek/mt%04x/BT_RAM_CODE_MT%04x_1_%x_hdr.bin",
-				 dev_id & 0xffff, dev_id & 0xffff, (fw_version & 0xff) + 1);
-		else
-			snprintf(fw_bin_name, sizeof(fw_bin_name),
-				 "mediatek/BT_RAM_CODE_MT%04x_1_%x_hdr.bin",
-				 dev_id & 0xffff, (fw_version & 0xff) + 1);
+		btmtk_fw_get_filename(fw_bin_name, sizeof(fw_bin_name), dev_id,
+				      fw_version, 0);
 
 		err = btmtk_setup_firmware_79xx(hdev, fw_bin_name,
 						btmtk_usb_hci_wmt_sync);
-- 
2.53.0



