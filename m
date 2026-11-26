Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705050;
	b=SlKvtHNBuwqsSUlNtGt+CloB0IVe4pXSPcgdHpR1/SUNwZOuFOAwLHjYhsqY1V4OJO0p
	 qh5azOB9CyQxLS7YFlm44P6nqZ0ojciec/bXUA3ImiLY8pbtGoz22xsO1ujMjGGxk9bsi
	 MnzTDL4u/zwKGAK2D8Sef9aAbD5ppPMoHc/fgbGlsjbWOJgrlgI+pDqHPSPsM45uHLLOb
	 ZE3zuZ/nhVOpqpU/UnGt3xytLYBEw7QD8gjNY68GaNXhv5zdvYtnPtBQ+2c55nuRen+79
	 +pCsAbufWj/cMXpNM9f7cWiXKWN6/Fq5JazuDd1eaOkl+Z+sDjdJcoQe1dbwzL71TGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705050;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Imci1/6BvYRNpSN6RofebgbP4jDbzXFDcyegMb4Nw8c=;
	b=2p0Oyp+W5OFQVKExP2GlCe6LUfiyQO/XTp+2/SxCCiDbm5i4cpZRavJTfZQy+rWOF4xf
	 5pUNXle7J6l3Dv74DC5w3V/2Eyuz5uX7eI9ckvld5T3vLMt3SDXcAwf1dwMjCl6RZhnnF
	 +7XYWthyeBCiUX6tUZa6jGigNwAOhtA4rM8fzaXRNzzzVbg0FnJbtuqXr7YZepsIQz7nP
	 UghyYDLDM/1a/daTg+LW/y2XKedDrESpf41eO9uE0c99boMrpBDkAxop8XdLIT4u2elkH
	 P7Vh4gEzUfbkhqyvp5Kkw7BcsH1Q6bbIrpKFQa+VnL8YkdfHhaOc6O98+Koub/4qNbA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="ebKr+Ee/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A96E606A338;
	Thu, 26 Nov 2026 14:57:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ebKr+Ee/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3C9B1F000CF;
	Thu, 26 Nov 2026 14:57:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705050;
	bh=Imci1/6BvYRNpSN6RofebgbP4jDbzXFDcyegMb4Nw8c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ebKr+Ee/bVK65/ZH2PyZxp4bArk+XYXbgCxQ+0KHmmU5JRafbCxkbLj5OdgbbHRS7
	 KGo9jolc+hhFmZmAxL/dyWmTbNqlU3ylKiaAVWrWdyTv+RmkdXA51/chVvmJ7fvEsE
	 NfFP2bYGNPIMNtqp/jZ3g0etKIQSZwUaqFarq08o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Binbin Deng <18983559317@163.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 065/319] Bluetooth: hci_core: Initialize IRK before publication
Date: Thu, 26 Nov 2026 15:37:13 +0100
Message-ID: <20261126144008.205969985@linuxfoundation.org>
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
index cae27a76f44df..b544dc030904b 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -2554,9 +2554,10 @@ struct smp_ltk *hci_add_ltk(struct hci_dev *hdev, bdaddr_t *bdaddr,
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
@@ -2565,12 +2566,14 @@ struct smp_irk *hci_add_irk(struct hci_dev *hdev, bdaddr_t *bdaddr,
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



