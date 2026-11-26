Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704238;
	b=P1VLbyeU3Talo0pRY8opAuTb6LAY5lvm5Ohtk2ozSDA8mOaN1FPNwAewaX2V9Svzwqvr
	 COs1rKxSRiWq2AuBKvtojp7SvHaagcO3AtjE5asdL4Lt9VkDU41jcxtDJvMXud5wJzPxK
	 3se8WYAv70o6xXTP7x2OaNRpsQaKu/rAufD1nRXuCN4MvvOLOHDu2XH91hD0hIBETDifa
	 8/V0zSAx1pCgaSuQZPPtMmD0PHxxS/CWPVk0+7+1lduF/rP9Va3cs+z4p5Wtt2vCIAfZ7
	 j26NY3WiGMtVbBHcqmbuhLt4iiAY41yaYZy/kyT/DlWnDVlfK2OXd3B74U53FpK68Ow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704238;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=d+dk5CFi4pcxcvHJh0mesalDWGWPUM2L1ZIjPeNIKVI=;
	b=s++B8CkqLQgF0shPVKK++v3XHk47aovHmz8MWGv9a4GkonRIbmJMrxXH0RW/BHQwvwWh
	 szYRKhH4fyfM7U/F5pxTJCdmnjaiyl7NO55gLmDQIoFs4daYy1h6MsrgRQxrsou9714HK
	 oL8dJZVqI7540McGFePChuceQkG45l6X3jst/JHatd6JRjmmkuRWKj6ZZoBAkv9z24eOV
	 d6xovkl+zYp07aTTk1KNhpdxDHJesJJDCsCNAVGHZ5O+xCJ0Ww4bCAr+43x4udTQapBEm
	 4CFHxe41QOVhzUnLxDmoYPZRNBzTF/ehoeEFRU7XsJRTzRQWeRMMUDScWd1zwVvbTGw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gHHzIDDl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C40EC606A31C;
	Thu, 26 Nov 2026 14:43:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gHHzIDDl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A72B1F000C0;
	Thu, 26 Nov 2026 14:43:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704238;
	bh=d+dk5CFi4pcxcvHJh0mesalDWGWPUM2L1ZIjPeNIKVI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gHHzIDDloIVuSCUBVUldWIIiNC075yeweQuA+383OEM8wAIwoQPp98rWDEYtYrrGR
	 QhT4d47H0eX24TiOjC9Omi9M9ZOOmT1Povj512WQ4pCztLd0fDqpzpcF4BmU2RsEee
	 RA0mGOBCMxVoUmQgarfUs50rCvB8mfh+Dg9FjXWE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Binbin Deng <18983559317@163.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 055/265] Bluetooth: hci_core: Initialize IRK before publication
Date: Thu, 26 Nov 2026 15:36:25 +0100
Message-ID: <20261126143608.943783141@linuxfoundation.org>
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
index 62d652635d4f9..9c144ce7ebc06 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -2542,9 +2542,10 @@ struct smp_ltk *hci_add_ltk(struct hci_dev *hdev, bdaddr_t *bdaddr,
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
@@ -2553,12 +2554,14 @@ struct smp_irk *hci_add_irk(struct hci_dev *hdev, bdaddr_t *bdaddr,
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



