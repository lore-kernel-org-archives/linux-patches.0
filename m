Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618194;
	b=YWCydv7W/o5tToMuXSTyUX3SwTAUEh1TVL2ZxL3wlRO0eU6+PfnYg6ljqIM+waaYTVSh
	 L5nGudijF+IzDgt3da4zghSTyOikkCDxMpgerHyFHSn7hE9F7SbhTtTMZTA5jxSoPH9WW
	 JdegzcW6sdSbP113YOn6wal29dEbUtuAcdJHwHJzTzBPUlH0vlvdsxjsSuEIpwKXnBLFf
	 wJXFkGfL0h/yxCaYrMeFyxGIIfCuO+AKRWfzfUdagHgSxDbR5Ko08b41b/4J7/mgjQ8Nm
	 BhVN5/zIHwWuaWjZa3IKwlmlygkVkvHq9FKiqoAEMLUbdErqOh5RH+WPm4ftyu83RZw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618194;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hlgQlzv/G/LojFyTRnD8aJLFykqD7IZzOTS1+dEckRQ=;
	b=EtAvIMIb1LtHWzoKuwwUSutT/furtLkEfZh63kJsq/rcvzttT0LdOSZgvw28cvWsPAE0
	 ExUpydjY9Zj/Pzeurz/uB6HKfQO/1SVVKJw8wILfRUyyEZCUK4VvPPi7XSdUYP9IkXyKl
	 N4fh34Sx73LRKt7Lz7SYczBi5nzpOFGjWW6z322xTMpVREaSmzoOgOD1kUQ8PYT2b3JHR
	 qgeC/bOORIiPmPy/sgWeKPTe1JgUK2mwI8mYlyopWm4Q8dRwBfXzNwA3URlgx7CCK1zoc
	 PtbYWwIPsx85r+Z7huX/InYBO3RdgYI6524CAtLcITe+dFpEXmhQeUQ6m9mt74jYT7A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IWp5EQkb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E767606A32A;
	Wed, 25 Nov 2026 14:49:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IWp5EQkb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED8201F000F0;
	Wed, 25 Nov 2026 14:49:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618193;
	bh=hlgQlzv/G/LojFyTRnD8aJLFykqD7IZzOTS1+dEckRQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IWp5EQkbWZ/T8Ada9y9QJkzPR0fpHO4GSWB3mDplgNXNuYgW7zVe/zCSkydFrv8OA
	 p835Yd9/O/Y+71G4F34mYNr6+yopofNiE90fTtZIF2z3tduBGIXLx/juFhMVF5hkgq
	 BOPwS+uKY42ikBmKVcIrj7Pe7KBAw7qb1rkkMkJ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Lu <chris.lu@mediatek.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0201/1005] Bluetooth: btmtk: derive the firmware ISO setting from MTK_ISO_THRESHOLD
Date: Wed, 25 Nov 2026 15:25:39 +0100
Message-ID: <20261125143826.448941709@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index a81ed47c2fd1f..18d9e26add2ae 100644
--- a/drivers/bluetooth/btmtk.c
+++ b/drivers/bluetooth/btmtk.c
@@ -25,7 +25,7 @@
 #define MTK_SEC_MAP_NEED_SEND_SIZE	52
 
 /* It is for mt79xx iso data transmission setting */
-#define MTK_ISO_THRESHOLD	264
+#define MTK_ISO_THRESHOLD	342
 
 struct btmtk_patch_header {
 	u8 datetime[16];
@@ -1346,7 +1346,7 @@ static int btmtk_submit_intr_urb(struct hci_dev *hdev, gfp_t mem_flags)
 static int btmtk_usb_isointf_init(struct hci_dev *hdev)
 {
 	struct btmtk_data *btmtk_data = hci_get_priv(hdev);
-	u8 iso_param[2] = { 0x08, 0x01 };
+	__le16 iso_param = cpu_to_le16(MTK_ISO_THRESHOLD);
 	struct sk_buff *skb;
 	int err;
 
@@ -1361,7 +1361,7 @@ static int btmtk_usb_isointf_init(struct hci_dev *hdev)
 		return err;
 	}
 
-	skb = __hci_cmd_sync(hdev, 0xfd98, sizeof(iso_param), iso_param,
+	skb = __hci_cmd_sync(hdev, 0xfd98, sizeof(iso_param), &iso_param,
 			     HCI_INIT_TIMEOUT);
 	if (IS_ERR(skb)) {
 		bt_dev_err(hdev, "Failed to apply iso setting (%ld)", PTR_ERR(skb));
-- 
2.53.0



