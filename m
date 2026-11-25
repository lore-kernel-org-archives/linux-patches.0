Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624364;
	b=k5Q3O5cklOAixGU+5D2Mwjs6JLe/eR5Zdn5yOao1OuiUYB8an9LfzOMjR8FcBFUl1uro
	 4LOSG13l8o8T6IfcsG2IZdPPMaYPFhLYXzVVGjypT5YLlQFojf6ZswQwvN3361AUwgrpC
	 v5OMvX3fuUlNx5yNmJYtDVdhpqiTIvEUu6i+njJ0w0kRS7LRZhogbvPAefgJF9XDcKZR0
	 Hec4exkzda4/WnQu7TQjU4wEWv5Om7myE9OFkfoQj8JRbqWN9ZTLskLenxMyuiKGPsbG1
	 nCo4Im/vRaLiyI2+grjJ5GEju8tAZUAzvZGtpZLRIpPxVWGZC13kRjNI2ruU1ahUD7A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624364;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MNqA6AqLYzNbzxM3jWDrSV4NZ7ZgKmjNxDCficsl6Mw=;
	b=XeeUhSVM1OI2ZvORhn6BTRG2a4uBh/NuJTwQtOtijL1iEowlm3zRzyINt2qhrMsBkBFY
	 SjjxrSCJtvLZiOcOgrUKxiZdnpcafHTKGHncYhnuSiMHoGd/FTJGEH031WlT6OuHhROW1
	 dd3sPQ4nBVA2SPg7mzs5DqIaMlIglvepXH0UZyNyfJ3c0Or3f5BABF2kWqg4pxpFBAFQC
	 YXDKWHXQpZ7cWIO7sS8Avjrotmkv92qxLGx3sE6onU5/C+baG0tsOh9w2h1wmVm3YOOYa
	 BRZCRLUDFMq+LLrAHn0L+nkIwizM93Q563H9R2zQ1xfZnwCHMBmemP2eg3sDmid5bBA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Eotid2oi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02AB8606A33B;
	Wed, 25 Nov 2026 16:32:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Eotid2oi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F7151F000D8;
	Wed, 25 Nov 2026 16:32:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624363;
	bh=MNqA6AqLYzNbzxM3jWDrSV4NZ7ZgKmjNxDCficsl6Mw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Eotid2oiVNqOdP9XI0rLritWzNaSqOYgbiD93pfvRa8fYSLF0zAC4Wa1OLS+bHSOA
	 p8UUzf7JBmkYnklZBvk6aHwnO7xix1/NUwQIlJvFgr/VGnFGJnlaKoiOOoYvrjS9qt
	 PGXHm3YQx/v9Te2qps54AU8UbHMEeXM3BiEd6ph8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yifan Zhang <yfzhang23@stu.pku.edu.cn>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 167/816] Bluetooth: validate retained LE Set CIG Parameters command length
Date: Wed, 25 Nov 2026 15:28:35 +0100
Message-ID: <20261125143853.060501169@linuxfoundation.org>
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
index e408c0e1d58bc..9e5b71786122e 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -3843,13 +3843,16 @@ static u8 hci_cc_le_set_cig_params(struct hci_dev *hdev, void *data,
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



