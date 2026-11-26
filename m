Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704241;
	b=1IdwLG/nPF5R5n5FD+GCYn23+jElihymBzI799Yt6osMm0xu1TTMLYA9o8KWL4ZL1AZ7
	 uig12ELzYQLqp5e0T9G8kgsVCW3OPIRNE8MD0aTVpcXjAzcDu9FqHNe4W/hnm0EFXLvVV
	 cHdzGQwezZAYCO/Jul4+7TG575FIrmvh+oEMHn0E2BtwNABLYGm5MyHxrCfuQo4x6lH0S
	 vRRuNXkVf3ZvQK1M0hq06hYjEQSq2HvEhVXa2M5kkxWrtZO++XJAhEU8h0m4RmQleasOq
	 k1FwTqxltXPBxThVUj3YB39sd2fTc/uGVBe7wZnPwO422YbziViZhEATv+mlFFQw7bg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704241;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=15AsaPIO0bQWEXxQwWLI2GaG5lV3CpGWXtIDiMZohY0=;
	b=g1C36Jh1SUwHBwu9/g73XamE9ZACwjk1iL3XY63qXcnNQlx2ZyWs5YO6jV/YWCoJfs5p
	 MzgNb+Q2SnfMy6Bctx2/s8v2gLMuZ3VsZ89Hb8tcF4o5MkN8fjPIFHSTnyrMkz/O++UcD
	 h8l1LHU8O+Dw+F92Ww3T7X4oiABMPagTQKzaQnBN5m5Ut15x0Lj5UYfh1Io31tHOhPVZk
	 lCaMyoew60xxNYyUsiAwe8DAmfOvTe6xsWbDh+heS5Et0cnCyqZvbwS7fikjolVopno0w
	 Qw13pPtq7JaJxSKzTQRa0vM9HqlQv+JQvtdmkdd4PGsrd8Addpp/FvaoK0oEn5FlJXQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="sy6H3iF/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D686606A323;
	Thu, 26 Nov 2026 14:44:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sy6H3iF/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A86B11F000C4;
	Thu, 26 Nov 2026 14:44:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704241;
	bh=15AsaPIO0bQWEXxQwWLI2GaG5lV3CpGWXtIDiMZohY0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sy6H3iF/VUHiqwaQWgJeKwyoOc6ye7K/3RBHrxbUc6CGcjtoxj2KREixYzMnLoqVE
	 YfhQfTxj7YOANNd8FpUwRnffhjwblQemV2+6+3iVFiqPakYUnczuW8xxm/pd+Gavno
	 DEOM+bFZzChJ4wxiOgqm1pKn40bzYZehE/hV7jmA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Binbin Deng <18983559317@163.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 056/265] Bluetooth: hci_core: Initialize link key before publication
Date: Thu, 26 Nov 2026 15:36:26 +0100
Message-ID: <20261126143609.009799904@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 9c144ce7ebc06..375b2534e690c 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -2479,7 +2479,6 @@ struct link_key *hci_add_link_key(struct hci_dev *hdev, struct hci_conn *conn,
 		key = kzalloc(sizeof(*key), GFP_KERNEL);
 		if (!key)
 			return NULL;
-		list_add_rcu(&key->list, &hdev->link_keys);
 	}
 
 	BT_DBG("%s key for %pMR type %u", hdev->name, bdaddr, type);
@@ -2503,6 +2502,9 @@ struct link_key *hci_add_link_key(struct hci_dev *hdev, struct hci_conn *conn,
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



