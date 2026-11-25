Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618254;
	b=qgbUdZp5gygTR+USPKV1y+pys/4gDyKeejxrbiT6FyWgAyrKii0DSyK00bL3JOPk77bX
	 Z8aBnx6htRSezkfxaunzPlHGej2JwZexP9iT8UZsAoRQOlSN8QBv49NXKy9s1pHJXGVrB
	 J9DIs1HLb+uTX7HR7vl1NLyQnZDM8lz60e6iXFDd5JV0v7ZjR/8ghyemjFX5+FloE5Pae
	 MGMfHDQSL9F7MSllj8S81MTjZeP7gHlap/lLNYH6xctX/xmGkbiJ38uqo6cKulcMrs7Iy
	 fv2ADfTIh1DZxXO4y8BKhaNERw+rOI4uZwmQJMC5tdRO7yRoYoLW/8LEitKQXliqhaA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618254;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HfLcSH1Wah3be28lfOl55LyqsHHKRmFw7UkGW6m+mgk=;
	b=aUU/2YcOpnCbyL3g8CcJS8VHS2vr/tM9wpf/Dah54SWjX/13L4vQl2HcZXAh4psb+EUC
	 VYJzQEldoifHODYTGWE0LKaCgvYA6lOO5aMDrNefZ0Ey+gdAWi2HI+FZ1/nHUncuCEfrw
	 Azo7QrsTB+le0v9ZvEVTUTogL3/+V9f0q/OMBjO0hzDrSSYXRT892m1jv3Q6hOkv2A26G
	 klGqV4nnVxrzO3fSKtj5nDlaruRTrNO2pl2l/1im5n+aMARJMozm7lsa3+bkaLzhe6Q/q
	 sSp0SU69RNnSrWTeBPHgk6YiXbjxZ53mXJzGFTsekM+fjdjSMBeTUyxLDIBwge5yWJA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1GEiQu84;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A021606A31E;
	Wed, 25 Nov 2026 14:50:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1GEiQu84
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99EBE1F000C0;
	Wed, 25 Nov 2026 14:50:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618254;
	bh=HfLcSH1Wah3be28lfOl55LyqsHHKRmFw7UkGW6m+mgk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1GEiQu84cy+W6tdcylmwjlK4qmZlZzGZac/FYQsEcB3g1dvhuAwHvJMLSmdZNZY9j
	 ef8p9lTcLwb6sGURh+aAiEl1VwRSHbxboPzFyNPJB7S1/fulZRHRi81VFyFllsPi2Y
	 /Z7PLOcbcqgqYO/LkAiikz+nDBqKHgZHJJGE1L8Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yifan Zhang <yfzhang23@stu.pku.edu.cn>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0214/1005] Bluetooth: validate retained LE Set CIG Parameters command length
Date: Wed, 25 Nov 2026 15:25:52 +0100
Message-ID: <20261125143826.753979949@linuxfoundation.org>
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

From: Yifan Zhang <yfzhang23@stu.pku.edu.cn>

[ Upstream commit ed4d302af778b9e2ead28134a2196c09a4ad248a ]

hci_cc_le_set_cig_params() validates the controller response but not the
parameters of the previously sent command.  A short command can claim a
large num_cis without containing the corresponding cis[] array.  A
complete successful response then makes the handler read beyond the
command skb while looking up each CIS ID.

KASAN reports:

  BUG: KASAN: slab-out-of-bounds in hci_cc_le_set_cig_params
  Read of size 1
  hci_cc_le_set_cig_params
  hci_cmd_complete_evt
  hci_event_packet

Obtain the retained parameter length and require both the fixed header and
the complete CIS array before using the command data.

The reproducer no longer triggers a KASAN report with this change.

Fixes: 71e9588435c3 ("Bluetooth: ISO: use correct CIS order in Set CIG Parameters event")
Closes: https://lore.kernel.org/linux-bluetooth/179317463153.87610.8996555110609321376@stu.pku.edu.cn/
Signed-off-by: Yifan Zhang <yfzhang23@stu.pku.edu.cn>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_event.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 64db225a9f109..cb7abdc5546f9 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -3985,13 +3985,16 @@ static u8 hci_cc_le_set_cig_params(struct hci_dev *hdev, void *data,
 	struct hci_conn *conn;
 	u8 status = rp->status;
 	bool pending = false;
+	size_t len;
 	int i;
 
 	bt_dev_dbg(hdev, "status 0x%2.2x", rp->status);
 
-	cp = hci_sent_cmd_data(hdev, HCI_OP_LE_SET_CIG_PARAMS);
+	cp = hci_sent_cmd_data_len(hdev, HCI_OP_LE_SET_CIG_PARAMS, &len);
 	if (!rp->status &&
-	    (!cp || rp->num_handles != cp->num_cis ||
+	    (!cp || len < sizeof(*cp) ||
+	     len < struct_size(cp, cis, cp->num_cis) ||
+	     rp->num_handles != cp->num_cis ||
 	     rp->cig_id != cp->cig_id ||
 	     skb->len < array_size(rp->num_handles, sizeof(*rp->handle)))) {
 		bt_dev_err(hdev, "unexpected Set CIG Parameters response data");
-- 
2.53.0



