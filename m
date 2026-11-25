Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624300;
	b=RPpplPS01obYCphZxJ2sqVnQnJnkRcj9B5HJ4bNpovAQcGVfRVW44wbmL45bXNx94DYb
	 VqgfN5xVmvmESV+vm0Hd/My9vu+s9nUO1UjK8dFhVtkhCxZk1hYGxzl1P31j6gWZmOVic
	 05FCusPS1ehmwWgcIx8HmHynF/3unfQB6/Y1Fa1rrrlv5l2xiiVqBN7kjMcQqu5gHYyRx
	 tn0K//FF35kVg8lxMCymoWZLOC7WIGXjVpEjCShlVcM7ODbM95mWwUSxj4Rz1GE1KBzU8
	 0FMaGP/ytAhrwYATYL5MHoGe3qy+QGs9EfKU3oBZ5R1JZjZdKRTSMbbEkwC1KEuRvaw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624300;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3zbkirBq7du5fDBtvvz3pKHr84Hg90vArtLGBRhIpVo=;
	b=vhqF1aY3d499EgWRsLbXwAULvBJ3jp5yfEt029YBVm2sBn7+2jLgm9Y0aeeNmQU2dNUt
	 C8k4qIPch4lmucAqQeZAp+gnKhW5bt90dtcNvUHhbL8B3VWNuJ4EPJw++UYOHWdgGlW/9
	 L4CYJa7gd8jYF03MJQmkyVzfkXFxwVayDix1e/OeOZ+IhYLy/RWV5yQ2j6NIq89PQmMnY
	 KppYrWGh4pnliUecvE213nWdrpr7c8ACuTLEaLbepuYbIEcmCazOG4XwfAq8RSfu5XWYa
	 7wrrxuZhmKA8/PvI+CLZrGZi3GnLoItUMeFIJKshCe9Rnp9xaNfdfGuGjr8xjpnFIxQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mMaXWwGV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03BDC606A33A;
	Wed, 25 Nov 2026 16:31:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mMaXWwGV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB08B1F000C4;
	Wed, 25 Nov 2026 16:31:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624299;
	bh=3zbkirBq7du5fDBtvvz3pKHr84Hg90vArtLGBRhIpVo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mMaXWwGVkoYWfsV2vUczTMw5dLH2LQY+WJBYdp8Nf8S8WXnjYHgtv+yhNaZu/q3B1
	 0G7MkZD30cSaYZbwKVwse3F2dTIn/BSwmoglZM037yu1hcD7VSKov3dR6C57uZrGOU
	 BnPS2u+ISgMBW0HpBrcd5r4rDCvbgA5Farn/mQhU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Binbin Deng <18983559317@163.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 148/816] Bluetooth: hci_core: Initialize IRK before publication
Date: Wed, 25 Nov 2026 15:28:16 +0100
Message-ID: <20261125143852.623150615@linuxfoundation.org>
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

From: Binbin Deng <18983559317@163.com>

[ Upstream commit f0cf5a24cefeb629876bd15d668ff062c8655e28 ]

hci_add_irk() initializes the identity address and address type of a newly
allocated IRK, publishes it on hdev->identity_resolving_keys, and only then
initializes its value and RPA.  RCU readers such as hci_find_irk_by_rpa()
and the debugfs identity_resolving_keys_show() can traverse the new entry
during that window and see a zero or partially initialized IRK.

The race is reachable by racing an IRK addition with another CPU resolving
or dumping IRKs.  In particular, userspace can issue MGMT_OP_LOAD_IRKS
while another process reads the corresponding debugfs file or triggers RPA
resolution.

Initialize the IRK value and RPA before publishing a newly allocated IRK.
Existing IRKs remain published and continue to be updated in place.

Found during a static-analysis-assisted audit: candidate sites were
surfaced by a Coccinelle rule, and the reader/writer paths were
confirmed by LLM-assisted (GLM-5.3) code inspection.  The issue was
not observed at runtime; it is identified by code inspection only.

Fixes: adae20cb2d20 ("Bluetooth: Convert IRK list to RCU")
Assisted-by: GLM-5.3 coccinelle
Signed-off-by: Binbin Deng <18983559317@163.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_core.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index 3a713084fd534..5d1acf534a796 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -1353,9 +1353,10 @@ struct smp_ltk *hci_add_ltk(struct hci_dev *hdev, bdaddr_t *bdaddr,
 struct smp_irk *hci_add_irk(struct hci_dev *hdev, bdaddr_t *bdaddr,
 			    u8 addr_type, u8 val[16], bdaddr_t *rpa)
 {
-	struct smp_irk *irk;
+	struct smp_irk *irk, *old_irk;
 
-	irk = hci_find_irk_by_addr(hdev, bdaddr, addr_type);
+	old_irk = hci_find_irk_by_addr(hdev, bdaddr, addr_type);
+	irk = old_irk;
 	if (!irk) {
 		irk = kzalloc(sizeof(*irk), GFP_KERNEL);
 		if (!irk)
@@ -1364,12 +1365,14 @@ struct smp_irk *hci_add_irk(struct hci_dev *hdev, bdaddr_t *bdaddr,
 		bacpy(&irk->bdaddr, bdaddr);
 		irk->addr_type = addr_type;
 
-		list_add_rcu(&irk->list, &hdev->identity_resolving_keys);
 	}
 
 	memcpy(irk->val, val, 16);
 	bacpy(&irk->rpa, rpa);
 
+	if (!old_irk)
+		list_add_rcu(&irk->list, &hdev->identity_resolving_keys);
+
 	return irk;
 }
 
-- 
2.53.0



