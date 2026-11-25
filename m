Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621264;
	b=dcPiLjz5eV+VdjLAf98ss/+8TWyu+3lwsQZwYPmVKmOYJ3+NrgqbPCrQn5Q8xnaF+tG4
	 7sqOsg/cMvYpgSUwd+GWebtwnOyB16tUT8iiv755zhi6or2IbUl0DRpi/z57k56WITqVJ
	 O/KcWsYc9+qtZtImiKYd4dsrYF4wbx7IHsnrl028KMRdmsASBIZfarWtLXskFO18PR342
	 HO4fh8UV1Cn5YVFFEfk8hMDwbhw90Nx2ZyaXtU6AAsHYpoHEBwYpx1cwPoWlevTgS477x
	 jC9u5tXIYAFX8Jvz47dZciVTBoFgnea719+JflIdSsigAtaF2EWgCJFw2GPNMzwldgA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621264;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GrDQvsJlxM+fasNizV3O76o1in5X3mE/E9kqfa66+WQ=;
	b=TgXO9M7pf7LseBr1S5RuHmxtRn53tHXzo8nzgGG12qEsYF1KHzzkipPj0CVdnTp/PBfo
	 bbhzS9stOy41EvmWSvCu6YabEs/CKTFNXFC2jzw/6gPnTzaBh0CRiVZIm2nKlRunFHfN+
	 IW9i1ae1Dac5GKSCE22TnYSOrCedN+X+qS4Q8QUj0j0UFMiVj0yOQUOr5ZwD6Rsk2Q/zC
	 TojfhW/G3YCjIKufQBVmiNt4YIJP3Av8twKzQj6Mil3P/vj6ap6wueVkQyhQHwDy0QU5W
	 WsZEAjcSoaFyTsYw1ScMfojUeOs9KLHzTTYKZyQYstlolxXSfsMHj4h6oC8TNgYcuMw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JWxasZFR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8986C606BF69;
	Wed, 25 Nov 2026 15:41:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JWxasZFR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C1521F00A3E;
	Wed, 25 Nov 2026 15:41:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621263;
	bh=GrDQvsJlxM+fasNizV3O76o1in5X3mE/E9kqfa66+WQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JWxasZFR1+t3GrkCjUKLqyHFgheGCXaEyMdRh8q4M5MAwJgzAW0FVXJUWx0zslo2d
	 3drWNXG5v7e1l3tR3wGRuhK7j/iCDA9oJR/qiDz8oidKs+EM6Pjrxl8JN2voS/Swio
	 dbzSbc6bNS/i1rrZlEPJ3jFnDbNlU4Cwv4WU9Uvo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Binbin Deng <18983559317@163.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 173/990] Bluetooth: hci_core: Initialize link key before publication
Date: Wed, 25 Nov 2026 15:25:40 +0100
Message-ID: <20261125143826.145207345@linuxfoundation.org>
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
index 78c4be8e7109e..70f7e4da66f33 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -1288,7 +1288,6 @@ struct link_key *hci_add_link_key(struct hci_dev *hdev, struct hci_conn *conn,
 		key = kzalloc(sizeof(*key), GFP_KERNEL);
 		if (!key)
 			return NULL;
-		list_add_rcu(&key->list, &hdev->link_keys);
 	}
 
 	BT_DBG("%s key for %pMR type %u", hdev->name, bdaddr, type);
@@ -1312,6 +1311,9 @@ struct link_key *hci_add_link_key(struct hci_dev *hdev, struct hci_conn *conn,
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



