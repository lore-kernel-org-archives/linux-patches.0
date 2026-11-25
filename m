Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618148;
	b=kfbU5Pjys2uv3urrW9U5LM3MILxaVrJ4ADpXDteqqh+GM03s3qS5mJCBraZ/G7sVZAmO
	 ZBcFbD7WeS0dYcYIIcjOUAngOgXri9R3ysgFlmLyXrXNFMjt50x7UqLfTYuvycflBhJ50
	 U+U6E7Z6f735/SWkdIkvgGqwp6itG+ErHHM2lChszBFZboRl3whgGQihJ/pBtT8zKQfFV
	 RN0eg/8uqpU8DvOFI8vN1T/btR/zXeq+cBHSwOhMCmzyuvtdzNUOSF6vF+aj94OPZNFiq
	 f0GYG4VHWr8aUO3OE+8jakU3t5r/K0knQW0XMtAfutJL9Q77+Yhq+Ez6B757i4jWM1g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618148;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=k4/lyylPW3dqj5Dpgl6ZIkj1INFJ3Ev9k433q8rMnws=;
	b=HsEJWfmiIJL1p5yalJYGuBlBz351QC9lyT/LVMQVzm9wIWrsv2E0Xan+r2M3fWWUmSvr
	 z3Vb6LqztYDMxIZ2KSTnBIo8LnMAiXB/1O7OFpbY7StTbGZu/HzxInQDfNyWTjo+zvr0P
	 SNhoRKF+ro31VihjWDaywsUzXv/EJckVAcENKGw4eYt0FgaDfHVbf9j14H1MKqg4OUicM
	 cGKH/eugCq1Q57PSCY3prLpgHrV771CZNYjhIA3XrKXMst3RvsncLn0gppadzxjNwP6E1
	 z8QreIoqLj2pe2HABgR6PmK5WhJ4mY+V0b7L5tzjHcwZ2XL1pNzEQD/IQphIjLTI9mg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sn0esOSd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 651A0606A31E;
	Wed, 25 Nov 2026 14:49:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sn0esOSd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AA2D1F000C0;
	Wed, 25 Nov 2026 14:49:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618148;
	bh=k4/lyylPW3dqj5Dpgl6ZIkj1INFJ3Ev9k433q8rMnws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sn0esOSd++Lky6mWB4gae4OpMg4NEkOubBCgJYtYpnmRFpKTZJzQ7ekz8p3W/Lbsp
	 f0CP1cwmQBRMgiBPQIZk7xPMQKUqeArnhdTVFJel0vKNxEbx8hLfLqMQSwKQHVd7Mo
	 03ejjEQKXLk82d+wdVIdGe5fap5dNOJg6gASMrcg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Binbin Deng <18983559317@163.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0188/1005] Bluetooth: hci_core: Initialize IRK before publication
Date: Wed, 25 Nov 2026 15:25:26 +0100
Message-ID: <20261125143826.145387165@linuxfoundation.org>
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
index becac4a223dfd..99caed1aeb185 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -1315,9 +1315,10 @@ struct smp_ltk *hci_add_ltk(struct hci_dev *hdev, bdaddr_t *bdaddr,
 struct smp_irk *hci_add_irk(struct hci_dev *hdev, bdaddr_t *bdaddr,
 			    u8 addr_type, u8 val[16], bdaddr_t *rpa)
 {
-	struct smp_irk *irk;
+	struct smp_irk *irk, *old_irk;
 
-	irk = hci_find_irk_by_addr(hdev, bdaddr, addr_type);
+	old_irk = hci_find_irk_by_addr(hdev, bdaddr, addr_type);
+	irk = old_irk;
 	if (!irk) {
 		irk = kzalloc_obj(*irk);
 		if (!irk)
@@ -1326,12 +1327,14 @@ struct smp_irk *hci_add_irk(struct hci_dev *hdev, bdaddr_t *bdaddr,
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



