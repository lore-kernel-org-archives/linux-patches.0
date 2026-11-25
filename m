Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621290;
	b=zBlwVMJyZ5NEC2Q8cUWm5bupRu+akm2bUolvLVgtpg5899yKlUHz96iWX8KZpCJtlDQ9
	 S+ZjFw/rc5JTtNev1ehHP6Tf2FL4NiWkBxEVltkcKcFcNGjDvZGfDKPf43o/fiwB3VrW7
	 IuIRoy0/HpLcRE7OAgWTUyEK6mnJsn76HnOTm8IwWzqS97EqNLsNBvPIS61zyrRVWgo2n
	 ZlTyexlS/H7dyK32pNspttiT6Z/8iEkYXZTWiKt1smf/RFmLz8wy4FglyRL5GYoJmlnuz
	 bs07ucdBL5MR6tEU0zJZYiwU1EOaUKzuM4eftvUP+XtuC7HctKnAeRTINHMqdnrHDdA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621290;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=unfsBDMjDDbIFm/CMxvDlc5ZgJU5EuXdhfFf5C/T2sk=;
	b=XwFodqDAyw0DY5JI5+n0EkTANURujCpnS8M5CaRLlGEy3WxwleQm90rgB1cPZHmdwZ4Q
	 55fSqhLcYDHvy2aZ6Mp77SYdk6VYVjZQkG3ZZYASudq+UiK27+2xxu0d4FYucJ0M9VFGo
	 zkW4CKTgenQbpqPIs+m5rl4DI3qAlY9ozORmo/0L7yD6yW7UQdoy3qzIXD+l3WP8yXFdN
	 6eGSBWI664a2mqe5rYNmCgatCEOissiJrqj72LfAlhx2a8/TxoS6t9ZGtsWKYwGF1xTqv
	 2DNEpEGNXsiNZWq5owLbQhy7LVjpYvYhpMGwHJdw5PTV38o2E1/njHfFuMmvLOJO89Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u1QNc1RP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5B0460A5BE6;
	Wed, 25 Nov 2026 15:41:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u1QNc1RP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABC071F000C4;
	Wed, 25 Nov 2026 15:41:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621290;
	bh=unfsBDMjDDbIFm/CMxvDlc5ZgJU5EuXdhfFf5C/T2sk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u1QNc1RPGHJjjs3+N4fhJgvZFbWC+dGejsPXS7mQwrBEcGXv4dOo+w9mmYdx1B72P
	 Yx6PRuV5FvJtptQFTGhHjxuIbdBPrHp6Z+Kxs2MHrITkEAbL/7UYhDWH/tk8zIRVC7
	 KmjjJkmNVuIOVawz5BkwQ61PUvxrgugzTVKPYRFI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Lu <chris.lu@mediatek.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 180/990] Bluetooth: btmtk: derive the firmware ISO setting from MTK_ISO_THRESHOLD
Date: Wed, 25 Nov 2026 15:25:47 +0100
Message-ID: <20261125143826.308007622@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 1518b93f4676d..5863b63f5d3f0 100644
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



