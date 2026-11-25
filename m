Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621329;
	b=qRTHIfagH0K0bHte2l8Wzi9dYPpFcYNgS81Agu26rNchtAQEEmj/5BffGQ/bWd9qSKUo
	 imoHvL8CCC+5gZ5Cji0Ah0i4AF5pujndHnR6zr8GOH29eGKmJWvxc5DYExWUi/SKTbyLs
	 DwzjaHlan7FsGt7xVqCi1npOKLD3CVWIUy4f2hPvvwMRvxLDndvDXVyWOn6Bl+8o77Vcs
	 ygDEBpogvfNDmuIZIR4e5EWkM8+2Hc2LYiH1kne+7qnRWPlPtb0n1SImqyIRWTx3WCy33
	 t3hKMAXNS0lbj99wPiobLwGPY430bxzMRHCuapVd03XlRRiFkgBkluC376OsbXSRJhQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621329;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pki2jLGcsKulCrvPGrf8BBT9o8gDJOhK3Pb7qKJG3eg=;
	b=vpSjZnvem4Fe/HGzEARa1FoXnj9LSrr7ZrtbhttxzETdDCJNCht7MHpd0rDjqbxpsN6u
	 /ybuVHSN/LhXBZOc5Z/pcuJY7ONl2H+rKpNjEoqy1fmSKigthITC1M6XfIX7JSERFfeyv
	 vp4KxFNFxbewEsOGNLB60LDTq2ctxZyV5Ag9R4q21VHhcaaQGcnFbEUFnXVbwzvVZQ3ya
	 SKHGWmIcv6+NA0evHvVei5zrB+qQEqUGAhsiY1WlYTUqFunUNTmSLvOjd0KsTVU2BH26+
	 uV7jPiu9urrJcWNxPXBAbO+jeC00Ctq8nWn+G7Pl7vddMxwjHrCVNHuG6l0sDZ9G8GA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="plv/Cb70";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4D81606A321;
	Wed, 25 Nov 2026 15:42:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=plv/Cb70
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E5E91F00A3D;
	Wed, 25 Nov 2026 15:42:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621329;
	bh=pki2jLGcsKulCrvPGrf8BBT9o8gDJOhK3Pb7qKJG3eg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=plv/Cb70O1QEahVYf+WfltE2HCQb4piIr5FIcm4+V/YTI4flgTwkHI9RBWKO20Uif
	 SlWtwdYkcgngmvLrPP0cgRwAkAK63W+05k5ePTL/8xINKnZU/Qk9GTLDwyqeMFc6ss
	 sLFk4X/nmgQ0xFLycBmQMLrp5DUk/wnwNAr5oVFo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yifan Zhang <yfzhang23@stu.pku.edu.cn>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 191/990] Bluetooth: validate retained LE Set CIG Parameters command length
Date: Wed, 25 Nov 2026 15:25:58 +0100
Message-ID: <20261125143826.569404320@linuxfoundation.org>
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
index 1897663dfbdb2..af7f1de7d657d 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -3853,13 +3853,16 @@ static u8 hci_cc_le_set_cig_params(struct hci_dev *hdev, void *data,
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



