Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705056;
	b=R056+ejn+jLi63wxDH4WRlWtCClsF2CX5lNDtRQxiztfIaUPge2StpDmSaGI3FKEZ0Ux
	 oOQsPsOS+LyJ+gMlMTa/DsIsooOEF5SCBS7QNmUekBGwKh+gMAD8MrRREG5wWb7VIUbZy
	 3fyplC2fsFDtMFTbXDAxfo+j3VAM63wBwNc8NXofYdxBIvuxMUQj8VVBlEDb+8J8avtWK
	 B5UQ0sErxRTz7Ixt7B5t5lkSTvj5omzmM2OBq6eVSOqUi/LxgbC5oojR1Q4xQblGx6UWJ
	 oXGHeL4aZrsM2lGb15Pfwfvt4lqS6gvcPSaDBiM1j+7OBZrgIUy5UIXiWHtIHDDHC7g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705056;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tOMoTsRvS55YHpw4iJ12WRv5pKxNkcKDcksiB4bb5fA=;
	b=racheR2g0Ya/ygaEme3ErHck/kRh9ZqFZokoPBO3ur4c4HXjBeulhksecNQ6vImFp4RI
	 jwwV73GUhSELcwJbE+6DcqQea90caPdaBPLZLzYcBC5Yj33lA504wO9RbikVu7uUW7TVO
	 hsApw5U9HxOzpSFntd6EwEZ2UqHTikU6NENLb8tW8F8Jrga7hATAXDxUEKRsHil5/ARm6
	 wSfwlHp7vBK46X95XHosq4tKpvZgxMgyY7A5iKzNeamE8UuHVixBG6znSBhFBSpNIezlb
	 OYDVimhQlNmJpBq8ofTQCPXpNipYeCizFmtqNy7dZ08X+YSxCUHqhThfIawaUQ9my2A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=a32P4myl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 789A2606A687;
	Thu, 26 Nov 2026 14:57:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=a32P4myl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F23B1F000EE;
	Thu, 26 Nov 2026 14:57:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705056;
	bh=tOMoTsRvS55YHpw4iJ12WRv5pKxNkcKDcksiB4bb5fA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a32P4myldJj+4ZPim1UBy2GdoVfmCNh98KMdgy92ARtA9IeP9xMVWmpFkImh5f8xu
	 JyCBlscqJ0STZfHRf7brXfwGqqgYW/LamYyO9uNkaKoM/yrCd8cPpojmRstQm7wWX9
	 mHVYTXd0kkaC3JiwV+sdYJ/fqqp5gSNO7X3ww+SA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Binbin Deng <18983559317@163.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 066/319] Bluetooth: hci_core: Initialize link key before publication
Date: Thu, 26 Nov 2026 15:37:14 +0100
Message-ID: <20261126144008.227842033@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index b544dc030904b..c5e4616edb04c 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -2491,7 +2491,6 @@ struct link_key *hci_add_link_key(struct hci_dev *hdev, struct hci_conn *conn,
 		key = kzalloc(sizeof(*key), GFP_KERNEL);
 		if (!key)
 			return NULL;
-		list_add_rcu(&key->list, &hdev->link_keys);
 	}
 
 	BT_DBG("%s key for %pMR type %u", hdev->name, bdaddr, type);
@@ -2515,6 +2514,9 @@ struct link_key *hci_add_link_key(struct hci_dev *hdev, struct hci_conn *conn,
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



