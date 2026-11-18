Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050545;
	b=0GcOqrBES+ULOpuKNhQRbDVJooM4hImtKVEoBq54RNhxlEcakKkck37X6/xxkozVPEru
	 KCGol3exITjEixk4Np+gg/92f+ZfIljiDlSnKeUh3gGnxHynVJv4moC1U7AYnCP+k1Syv
	 uNzRxFi0y+ZjT631cy/m/PmSaxyIoIGG6SkGYIdUWrEE44m2zs77l79yOnagffiFE1fL/
	 JtyShFGfzR7tpRWzH/+m8E++PEoVw0g1rRuZUh3ChJ6Et9Rfy2vCIKzXY26+9mHWrTz99
	 jFuveHdze2SvB15k0F0rf1YKP6HzGxC70PI80boNiFUa9sM1SyEw7RX+wTVwvWa38gw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050545;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eFARFF9JdSp+BhGS9W48WonnQfSfv1DV0VSI8NnANP0=;
	b=pjDgu4A7t4sAs+heHAsOEKtpWHOzr5K79+I7nWdplyT2xh1Szi5wy/0phjig98ueraY1
	 AFaEEbYmOiSYoZX9lPH/Qv4MgEGD20D12MmXs16LlvUNmkxsI0XYFzbxi1MZ/EnrRjveP
	 jjLwzy7PhkV8J+zWw+hLb8oMqvcI/Q/Z6Lr0+bZSC9nMNmug8nG38kglF9HOdfpwPcx8Z
	 RL6MeNbr0oOoe+egXuioO5grJDRCr+A9Md363Uy21Y4rFLAxUVkX2uSyqFs+WZbQYxDLr
	 o9I/ZV17xkjFo7/nj/AstpjZ9oNciAIfHFGIy7aOVgIvL7Z/XHrn2hH+R0EPi6oatnQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="eaIY/ZQS";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF1B5606A31C;
	Thu, 19 Nov 2026 01:09:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eaIY/ZQS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08B1B1F000C4;
	Thu, 19 Nov 2026 01:09:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050545;
	bh=eFARFF9JdSp+BhGS9W48WonnQfSfv1DV0VSI8NnANP0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eaIY/ZQSeuqEAMPITZSqICQ+4pPlfp6ZITbH6yZA73+7V3ufxwa56DONeyZeY7JSI
	 dwfzTHhS8oy+vgWq1p0yPMxtW8Nl9sUHA/NCJrlFrgorhqM9MQdmM0P6C9zz78BVOm
	 Tp/RV/PEXpgKYDKarLy6yxfPHJGgskTC8pqFmVJk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Binbin Deng <18983559317@163.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2745/2857] net: atlantic: Unregister before clearing RXNFC rules
Date: Wed, 18 Nov 2026 16:02:59 +0100
Message-ID: <20261118150340.453160363@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 4bb6a58d75a43..40cb0d336944e 100644
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



