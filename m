Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042482;
	b=yAOWNDK0LuerTHcpUBEERMWGvtO+xugXkhn/rxI7BpixTx5TCp2+8qLoFph9aciNEm/k
	 GRsLA2yWrXZJmrDnudDXhdWe25AnWEide3hA8L7cN7tAcTjmQ8ECSzBPXWN1f/8oztVpH
	 vutnPGFpNAj46IDzFGHbt5u+caZWHj/SBwXg/PhX+FkYkiC+UuLpUP/IurUdLVqm9LAYI
	 1wuRbBeexayjmpCG7QfLa4q00lyfXTRGjSZaFRNzFESSbX21fp7rgbk1JJcDQXbaERtos
	 fi64kdbyQRUC2nbtlWlrvuniWNBiRgxwN6zxhaX0xo9UkaOr3c6RadE1gKIhII+fflg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042482;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hSwAxusSCDA/zyivC4o9AdGS8veDNdVHknhxu0yaGvc=;
	b=yTOHySabmToTUuEXAFccy1z75eonuwduH1nwxBbzA+6qPXqGcc8ULMkW1U78/i5S8uF9
	 I6rd8LTtZsn9S/RgrdKyeD97NMInj0q3jxvx8ZjfNNM/jGxNqNpjx11nFkxnJV+oEyt0O
	 ciZ9m2xIAQVGQkS8wFLSZiFOHRxyD5fp2ufazyPRlIUb+CUU0yvZAAD7iVDp4vM0/A8OU
	 FOOssPaU+GBo3xTyQj9dgZ04Cn9JOxFDwBSNbhcVHMOc8v2XUJc/K2/1Kfv98OITC6FRM
	 NiAxa9clSwGuq2N5r+EpSMIVo+iHSUibE6oAfrgXPVxVdSJzzlSAPaEOAiQABmoO5Hw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TvZ0lJR4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24315606A320;
	Wed, 18 Nov 2026 22:54:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TvZ0lJR4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 796A21F000C4;
	Wed, 18 Nov 2026 22:54:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042482;
	bh=hSwAxusSCDA/zyivC4o9AdGS8veDNdVHknhxu0yaGvc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TvZ0lJR4OiVilTLAJ+8e8q4hI4qUkSD88JB0WSx/5iqudbc1WI2Dl8ZShDzvn8Pnj
	 lrAcCAKN89Pg25m8xLB+olsOFHd5pQ62NL2pol0Hc7dFBFsYLdvVaEDMRh93GXLPtp
	 A9cTkrN8plcyiHiHxOHjWtca9EtmM+T7PZZ6N+Ag=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Binbin Deng <18983559317@163.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3185/3318] net: atlantic: Unregister before clearing RXNFC rules
Date: Wed, 18 Nov 2026 16:03:27 +0100
Message-ID: <20261118150455.356013576@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 775cbbc1aa421..6da729c386196 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c
@@ -346,9 +346,9 @@ static void aq_pci_remove(struct pci_dev *pdev)
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



