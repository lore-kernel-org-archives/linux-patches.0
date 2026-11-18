Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032954;
	b=u0EL3E7SdnmjoWfktJY/Pat5SmcMtN14LYJDNw2u9eRXKgLR0TuaqFP23PhWeRBk9POn
	 XQQwuOwS6mi5Tb9RjpiRN38kKeuPUKkXpiRe5Gbt2SCQsnAd3GkhejV/g8Nj0apb27Nnp
	 v/BGspmqZaAD7rT6QuN89uCi56Sj8nyA5WDKVonLRVncv9CDr+nAhpCBL28D+Y+U42MHv
	 p/QT/+U3qYFcHTDeMX6NBMgIaSmMAqRqO/6HsRTQ0ZZegBRWE74Iy4IjjrdCwUYMGiNfs
	 i1cQkALn6rt6ual1mF1TPudNMNyyeyyGgEA44Av+mv96G866fhVUN2uFWPaSotdb4Ew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032954;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HaCjd/HyQjK9Qxq+7ADOwj4Z/cKuUiGpNCVS1KMP/OA=;
	b=YjtqrAig3vRhkFrm6jhrXhsD3Fj/0rA6H5zB+6OmSXa5n/AJYVNktT6HOdBb6A8ifleZ
	 3nqVe/TadiMSbHQSyabLzs4qJxyWr+WXTGEFGvcHiyCmScr3q0n+ppPawjbD0rCqGRjYW
	 AleZ/bVkxdaeApIBhOsk60ojWfq7hxFrKwhOFoxeLFlGBTOlSCsnhHkk9vJksMf8+rgDy
	 9xLj35/Bcrgl7l9Hq/0Q0fMLUByTM3NGD4zl8u1hQKip6F1kdV2eeECl/oQ7kAJzTFG9e
	 BMnhJn6u29y8YNCUcFDhYohBWdZLH+WC882la1BaHmuBo0HZ7h0t1KNOd1H0glD9Z+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=chStDNtN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27A56606A334;
	Wed, 18 Nov 2026 20:15:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=chStDNtN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77FF51F000C5;
	Wed, 18 Nov 2026 20:15:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032954;
	bh=HaCjd/HyQjK9Qxq+7ADOwj4Z/cKuUiGpNCVS1KMP/OA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=chStDNtNezz7rV8rVtW9KpxHj68LUPr5PG9MGnuGGZjRs0Ss/lCXIHwCVE8j8M2ym
	 UuOJPMN/OgpSkytbhGFbDXT9FdRf5eqGkRPzkjvdyarE5tdIySyjJPGHzcnmFYdwdY
	 NP8cZhtJ6VJz4npDp7ps0QVKYshMz1uge6LqrsHA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Binbin Deng <18983559317@163.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1594/1756] net: atlantic: Unregister before clearing RXNFC rules
Date: Wed, 18 Nov 2026 16:02:01 +0100
Message-ID: <20261118150113.382686778@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

[ Upstream commit 13b364c765e69db1f8446399d8db0b331c23b50c ]

aq_pci_remove() clears the driver's RXNFC rule list before unregistering
the netdevice.  Until unregister_netdev() returns, ethtool operations can
still call aq_get_rxnfc_rule(), aq_get_rxnfc_all_rules(),
aq_add_rxnfc_rule(), or aq_del_rxnfc_rule().  Those paths traverse the
same unlocked hlist that aq_clear_rxnfc_all_rules() is mutating and
freeing.

The race is reachable by issuing RXNFC ethtool commands concurrently with
PCI device removal or driver unbind.  A reader can dereference a node that
has just been freed, and two writers can corrupt the list or free the same
rule more than once, causing KASAN reports, list corruption, or a kernel
panic.

Reverse the removal order: unregister the netdevice first, then clear the
RXNFC rules.  After unregister_netdev() returns, ethtool can no longer
enter the driver, while the PCI device is still available for the
rule-clearing routine to issue hardware commands.

Found during a static-analysis-assisted audit: candidate sites were
surfaced by a Coccinelle rule, and the reader/writer paths were
confirmed by LLM-assisted (GLM-5.3) code inspection.  The issue was
not observed at runtime; it is identified by code inspection only.

Fixes: 8d0bcb012f57 ("net: aquantia: add infrastructure for ntuple rules")
Signed-off-by: Binbin Deng <18983559317@163.com>
Link: https://patch.msgid.link/20261020022630.515209-1-18983559317@163.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c b/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c
index eb22531be554c..5e444a887283d 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c
@@ -343,9 +343,9 @@ static void aq_pci_remove(struct pci_dev *pdev)
 	struct aq_nic_s *self = pci_get_drvdata(pdev);
 
 	if (self->ndev) {
-		aq_clear_rxnfc_all_rules(self);
 		if (self->ndev->reg_state == NETREG_REGISTERED)
 			unregister_netdev(self->ndev);
+		aq_clear_rxnfc_all_rules(self);
 
 #if IS_ENABLED(CONFIG_MACSEC)
 		aq_macsec_free(self);
-- 
2.53.0



