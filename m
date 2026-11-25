Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618151;
	b=IswpMt9u3phe4FpHGjCz5WC7t5QttmjmFPiYKZDrBfWzv1inpVXAgRjMPgvwkpuglFbG
	 v2QcRRF0uEj95+L1KiiOFh/YBuQ9MqkFk6PrrukBkS9kTg/px6dC6kd58kJOOjPSxmIVf
	 N47B2+m/YD5brfFj45DU8eBDhuM8b+dCG7HiL+2uDHmFAMQuDFwnsB2bAXW0ML0OHr8lN
	 9GCKV44P6oN0JACCMCumlzSH9MwcaRAykR6YSlgRULSzy0uUh6At1RzVyoyzwOT89hVKh
	 kkZ8vkWYGzYUxZ2N2wD3JRO7caoXg9Ad21GY/xj7JFqCmS2VcTpkpin9l2YcfvRZHKA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618151;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wFf3fr3o2bnfbJXvL/ApKvlvsfCch0UsTHjDiGe9HWw=;
	b=lAw21KtTIfVDZyObOW9rBR+RA7hEwDxX4ZPXgZMJilz9dA6S2ohQ+jlvlZR/qfFrc3WR
	 eV64VtJufADE2C5Mml41+/Dw5GBVjx0D/5f6cBrDXuseKhjy72yoWUxCyWkltg7UspOCB
	 L1ZHzh7pEh0+GL4lNT5Me184hXTOyeG3dWayPQWWfmTS3JRo8HjvO3OcKtSL/B2B5gpVc
	 G9962uRu3aXKU5GLzI74yx2EixPYnExTQiiJ3fyvE6MZPkTwZda1qQte8TgB2sC3wZfgB
	 +dqJrCkr3lRssiBidnlrl6gHgBHExFxIvYodGXpofYNMZySnDRLCDKyF8/LRDVkmTnQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Is4oNmiw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 407C7606A31E;
	Wed, 25 Nov 2026 14:49:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Is4oNmiw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FC441F000C4;
	Wed, 25 Nov 2026 14:49:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618151;
	bh=wFf3fr3o2bnfbJXvL/ApKvlvsfCch0UsTHjDiGe9HWw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Is4oNmiw6If1z/wCDiGZcIwejbY1tDi82VHt2fK0zXlXjcZP3MTS5IfZ7t1+3GQaj
	 Bralh25zYrqCKTWem0F3pBh++Atg70Tl9CDePjIibcK+AuYF1hgLQnj+BGoSA+Hgxr
	 IWywHQBK588/deDNOEhPIysHvMEGDOErzK4UdkU4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Binbin Deng <18983559317@163.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0189/1005] Bluetooth: hci_core: Initialize link key before publication
Date: Wed, 25 Nov 2026 15:25:27 +0100
Message-ID: <20261125143826.168365252@linuxfoundation.org>
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

From: Binbin Deng <18983559317@163.com>

[ Upstream commit ae9c8df1ffb84560ac01cbdc26cfb19027f4d25f ]

hci_add_link_key() allocates a new link key with kzalloc(), inserts it into
hdev->link_keys with list_add_rcu(), and only then initializes its address,
value, type, and PIN length.  RCU readers such as hci_find_link_key()
and the debugfs link_keys_show() do not take hci_dev_lock, so they can
traverse the new entry during that initialization window and observe
a zero or partially initialized key.

This can be triggered by racing a link-key update with another CPU looking
up or dumping keys.  In particular, userspace can issue
MGMT_OP_LOAD_LINK_KEYS while another process reads the corresponding
debugfs file.

Complete all fields of a newly allocated key before publishing it with
list_add_rcu().  Existing keys remain visible and keep their current
in-place update behavior.

Found during a static-analysis-assisted audit: candidate sites were
surfaced by a Coccinelle rule, and the reader/writer paths were
confirmed by LLM-assisted (GLM-5.3) code inspection.  The issue was
not observed at runtime; it is identified by code inspection only.

Fixes: 0378b5977013 ("Bluetooth: Convert link keys list to use RCU")
Signed-off-by: Binbin Deng <18983559317@163.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index 99caed1aeb185..b285db239e6fe 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -1252,7 +1252,6 @@ struct link_key *hci_add_link_key(struct hci_dev *hdev, struct hci_conn *conn,
 		key = kzalloc_obj(*key);
 		if (!key)
 			return NULL;
-		list_add_rcu(&key->list, &hdev->link_keys);
 	}
 
 	BT_DBG("%s key for %pMR type %u", hdev->name, bdaddr, type);
@@ -1276,6 +1275,9 @@ struct link_key *hci_add_link_key(struct hci_dev *hdev, struct hci_conn *conn,
 	else
 		key->type = type;
 
+	if (!old_key)
+		list_add_rcu(&key->list, &hdev->link_keys);
+
 	if (persistent)
 		*persistent = hci_persistent_key(hdev, conn, type,
 						 old_key_type);
-- 
2.53.0



