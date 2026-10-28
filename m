Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793217343;
	b=ETvpYbxWSXAs/KQ+/Z+QHxBgNeneaV7j9qVb8nychpanVX5VpZWk4z4FDB99kbnOAogK
	 aFQmm/Dovlza//mbt7Abu/a0c7w2i3nU8AtpIjhNN86Qc6grzjHKoPRq+ajD6MilGzZa5
	 MQt3Bz0sONxnlI6zLZSAMIJH5aib81+LCkbcrnJ9NEOBtLo5DQ+FUkDbuvwMfkFpjezu7
	 KRd5Y/+VfCl2VASUd4EHT7zxYLpd4zs9Kqw6XglIe+0xbHKCbyzuLLVzLZx0ldey7IZNp
	 IbNC7YElamLq4yEG5S2uQFvLClKLKWr4UgaZ2tiL52/An9K5TlUpx7JtXHAZm9Pqf7w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793217343;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HQYdgqwDqXMClK9KfGGgbtXL4LbyP58kIe7Z68+N4K8=;
	b=Z52GNb7/mssSd6ndcnQ36lKewUukEUf8uyNyhjWa1rwxYQ29/+0gu5id4DxTXYgC74R2
	 AUUJ5+FTTwg/oCu1Y4iPcD0AjG/0kGpkW5JvOKA5yKOQZ/aE1O6i3DG0tMpZfbFhCYpQ0
	 YEmTa+l28Og2/CYj5WM4EWTlC5usuvoPmFLH/S/sh3d6RPYtWFXTKw5Vyz34nEyr68D7V
	 0zpU+dTR6gxqYTKFsrajtCSoE4NEQ8m+tT/QZ/ONA5WqRMgNNWcBHM7L0NFYEeA3B8q4+
	 85o+umyKs7zW3sikGxnh83mVRmHWgGNSoJ6KprPEQB8b1NNQRgcwbxNebsQmFU/vU7Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dajE1aJf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CBE3606A31D;
	Wed, 28 Oct 2026 19:55:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dajE1aJf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C96891F01825;
	Wed, 28 Oct 2026 19:55:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793217343;
	bh=HQYdgqwDqXMClK9KfGGgbtXL4LbyP58kIe7Z68+N4K8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dajE1aJfMnB2vYsT3BBvIVv3YFpl6EPk+5ABzN+MDrUh8xtvqh2l89bGpzHXiVW0+
	 ZXPZTVfTBg+tJZW5t/gx5NQ6IAMcX9yoWQpFkyEAgelm2UU672RCka97wK/0VxsvvQ
	 tFqvDrNaINRzlENbUjUCejq918vYw5FuaPY3Xhss=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1870/1887] Bluetooth: hci_core: Print number of packets in conn->data_q
Date: Wed, 28 Oct 2026 18:06:06 +0100
Message-ID: <20261028170542.008499804@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit 3c34d6428740e47b29ae3afd85d6f9eb656a3ea3 ]

This attempts to print the number of packets pending to be transmitted
in the conn->data_q.

Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Stable-dep-of: 6610c6fe4b89 ("Bluetooth: hci_core: Fix queuing tx_work after workqueue is drained")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_core.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index d01a91fa88797..aebb48bae2a48 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -3218,6 +3218,8 @@ static void hci_queue_acl(struct hci_chan *chan, struct sk_buff_head *queue,
 
 		spin_unlock_bh(&queue->lock);
 	}
+
+	bt_dev_dbg(hdev, "chan %p queued %d", chan, skb_queue_len(queue));
 }
 
 void hci_send_acl(struct hci_chan *chan, struct sk_buff *skb, __u16 flags)
@@ -3249,6 +3251,10 @@ void hci_send_sco(struct hci_conn *conn, struct sk_buff *skb)
 	hci_skb_pkt_type(skb) = HCI_SCODATA_PKT;
 
 	skb_queue_tail(&conn->data_q, skb);
+
+	bt_dev_dbg(hdev, "hcon %p queued %d", conn,
+		   skb_queue_len(&conn->data_q));
+
 	queue_work(hdev->workqueue, &hdev->tx_work);
 }
 
@@ -3312,6 +3318,8 @@ static void hci_queue_iso(struct hci_conn *conn, struct sk_buff_head *queue,
 
 		spin_unlock_bh(&queue->lock);
 	}
+
+	bt_dev_dbg(hdev, "hcon %p queued %d", conn, skb_queue_len(queue));
 }
 
 void hci_send_iso(struct hci_conn *conn, struct sk_buff *skb)
-- 
2.53.0



