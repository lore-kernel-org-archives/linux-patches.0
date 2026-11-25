Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621267;
	b=bPZ7BbwWEaFKWIMc9evw+PHs4tg1yTf7EimB0Wxkoltu0kRUwoZBlaGTagwRr3Q1JpXj
	 nHXWpNJrpbfIp45T1fnIlb3Ta8clrXMFQORd5bng3Hs0wbs5i6ieT2C8EWh+/MhSM94gs
	 A80i5prR+l1FcY07jrjgMfKgEpk7J8asCX7i6aCmqlgK29zMvMxg4/tFLRf01r9n5ft0Z
	 06Ga7EEjZQIB5evEJrjUhzCZ/8xXCoBEJl5XkZKQ32Mp8QirHvyiD3wwOnK/Z+XnBCAWE
	 4gFKqDN1MtXMAfTLdJiFnJJTrnJ/LXu+9y0FUaEm7cXVg7dzxq/MELhS7uSAGdcn04w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621267;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aEJS/coLuiNb4GnO5xprKHY7NlQ0AucQ3ZLUl8kCgus=;
	b=LxLkgeh4eJn19BqL1jLHUmtiVJu0irUbUZPmWI18hvj8/cIEnrnsy6PaTLwRuH8tNv1a
	 CwmvVWOKJ4zvHsQIDTNx+TZxJQhbv3VbmNTIGCKimRcGglrD9QXMP2cGyA8lROaHwIApt
	 qfJ87kL/ADD2laxNu3Jl4TH5tNVhFOq/1hPhrHa5GViRUqDbGN/H8wEjiZy7XLG2liPvj
	 Ya4MdoCH2QJsgZT2+X6f53KC4kgp4Esg/4NBkIJzbjjCI796t6hnvaKFnwe5ZEL1nK2sd
	 Lz/BIRDy3+hRxU89h5xEoSpV8XwzfJkqiak1Iku0CWX1wUOnfFY9JCUw0zyCvKBj5Sw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=E5rIHgZe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B10CF60A2612;
	Wed, 25 Nov 2026 15:41:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=E5rIHgZe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADC231F000D0;
	Wed, 25 Nov 2026 15:41:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621267;
	bh=aEJS/coLuiNb4GnO5xprKHY7NlQ0AucQ3ZLUl8kCgus=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E5rIHgZeaAb0+LO8DkFXzLnZTXU8o5GL6Ps0F+8q6R+GSiaTPUoHC5nPuelOK5zsG
	 xpUzsAk7JSv5fBqROXXuSkjkGNtk4/g92Pgvgtju36Nruv9V9bpuhw5fh2SbH8ghSL
	 aFJ4i39Smd8e2rzilWzegdC6gymiVvuFMagAMF2k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Binbin Deng <18983559317@163.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 174/990] Bluetooth: hci_core: Initialize LTK before publication
Date: Wed, 25 Nov 2026 15:25:41 +0100
Message-ID: <20261125143826.167594896@linuxfoundation.org>
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

[ Upstream commit 4335849380aa1081ee9a1c2b934cbdda0961fa57 ]

hci_add_ltk() publishes a newly allocated LTK on hdev->long_term_keys
before initializing its address, type, value, authentication state,
encryption size, EDIV, and random value.  hci_find_ltk() and the debugfs
long_term_keys_show() traverse this list under RCU and can therefore see
a zero or partially initialized key before those stores complete.

The race is reachable by racing an LTK addition with another CPU looking
up or dumping long-term keys.  For example, userspace can issue
MGMT_OP_LOAD_LONG_TERM_KEYS while another process reads the corresponding
debugfs file.

Initialize all fields of a new LTK before list_add_rcu() makes it visible
to RCU readers.  Existing LTKs remain published and continue to be updated
in place.

Found during a static-analysis-assisted audit: candidate sites were
surfaced by a Coccinelle rule, and the reader/writer paths were
confirmed by LLM-assisted (GLM-5.3) code inspection.  The issue was
not observed at runtime; it is identified by code inspection only.

Fixes: 970d0f1b2803 ("Bluetooth: Convert LTK list to RCU")
Assisted-by: GLM-5.3 coccinelle
Signed-off-by: Binbin Deng <18983559317@163.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index 70f7e4da66f33..49788a7bdba29 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -1335,7 +1335,6 @@ struct smp_ltk *hci_add_ltk(struct hci_dev *hdev, bdaddr_t *bdaddr,
 		key = kzalloc(sizeof(*key), GFP_KERNEL);
 		if (!key)
 			return NULL;
-		list_add_rcu(&key->list, &hdev->long_term_keys);
 	}
 
 	bacpy(&key->bdaddr, bdaddr);
@@ -1347,6 +1346,9 @@ struct smp_ltk *hci_add_ltk(struct hci_dev *hdev, bdaddr_t *bdaddr,
 	key->enc_size = enc_size;
 	key->type = type;
 
+	if (!old_key)
+		list_add_rcu(&key->list, &hdev->long_term_keys);
+
 	return key;
 }
 
-- 
2.53.0



