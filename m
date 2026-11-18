Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016668;
	b=mCipmLig67+YEcMUPMwxxgFxxp05vOcAgNAfloqGlkdcSWfRxU6xgN+QLKRpY3p7q/eG
	 I4TYjDSOMp1E+LtURFXvMowxYiWK//lUBL1ZW/AN6yadnQcmiv99SnVPNXjYflSFbuMNC
	 HLXBpRENlT+1mJLmnBenBqc2CPwiYyJblSiBwvdvKRiaiH2wXstehLIWivnIA6GvdGQdD
	 7u/7wS2WNWhNqceJoP65WXzAbOs+RpRGs9+cf8fh+PZmM2oDBcnVPtRrORYS8P2bvO9HY
	 q+q2cDLvQVe7PH83TvcH4f+D7aXc3EuTNULpZi3ipkaUqtkYO1uo18BHBpuuILmZ/gQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016668;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0YzDUMi/TTO4BbCDIQ9Dj05ESwtyicstdb81tpN10bA=;
	b=asXANBgwZZMLeMjYtWibVFop0iXXefjmhsDXim1KssfLRE8wWOjTypV0ejYxvod+CnMc
	 q7JYF3b//EJwQVfp1y8TkfJoi4SSmQ6PjyOExTNPzGsDfKzURS7CPs/p6+/rarkdT5wq6
	 2IgEAo/1TW63bSt9JCR9fCGn6Q2NntmbVCTJmOIU/sPQp43SOViEFvlpcv1TKGd7doxIe
	 ZVi1Y5LaHP1AMhYByTGZyz6XNFZaXDn+MJVhv6XEheg5v2/FU7XmMiEoOUm3z6a4JQkJA
	 iqWUcSDXMCVRmaNPjqm4Z9HZtijqpXM53uwaVQ7PFU1Y/vPzUT3eVCf0Mdmp21zOCZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rA3SO0R5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A95C606A320;
	Wed, 18 Nov 2026 15:44:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rA3SO0R5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B4CA1F000C4;
	Wed, 18 Nov 2026 15:44:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016668;
	bh=0YzDUMi/TTO4BbCDIQ9Dj05ESwtyicstdb81tpN10bA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rA3SO0R5dOl1Xja7FkwraR68CpQLZ3ctZlW9siZP2ybi70iqUa8t3jMmFP5gXHlzy
	 5a1krCiNMa4XqfEPcCuP4JYuppzDwrNqCmSuoBC7Uf1Vb/lIHfWZP28pbV2SYnXctl
	 KrYywIwx7UBouuxzCwmKlBEJr/VYB0Ujv0wZuuMQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Luca Ceresoli <luca.ceresoli@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0559/2651] PCI: dra7xx: Fix clock enable leak on probe failure
Date: Wed, 18 Nov 2026 15:29:59 +0100
Message-ID: <20261118150307.865048664@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Felix Gu <ustc.gu@gmail.com>

[ Upstream commit 768e5d0936d00d663ce2b8c192cc6ab0b61ad461 ]

dra7xx_pcie_probe() enables the optional clock but never disables it
when probing fails afterwards.

Switch to devm_clk_get_optional_enabled(), which disables the clock
automatically on failure.

Fixes: 5af9405397bf ("PCI: dra7xx: Get an optional clock")
Signed-off-by: Felix Gu <ustc.gu@gmail.com>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
Link: https://patch.msgid.link/20260822-dra7xx-v1-1-23e204d5548b@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pci-dra7xx.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/pci/controller/dwc/pci-dra7xx.c b/drivers/pci/controller/dwc/pci-dra7xx.c
index 6c9e881776002..3460a83b43959 100644
--- a/drivers/pci/controller/dwc/pci-dra7xx.c
+++ b/drivers/pci/controller/dwc/pci-dra7xx.c
@@ -726,15 +726,11 @@ static int dra7xx_pcie_probe(struct platform_device *pdev)
 	if (!phy)
 		return -ENOMEM;
 
-	dra7xx->clk = devm_clk_get_optional(dev, NULL);
+	dra7xx->clk = devm_clk_get_optional_enabled(dev, NULL);
 	if (IS_ERR(dra7xx->clk))
 		return dev_err_probe(dev, PTR_ERR(dra7xx->clk),
 				     "clock request failed");
 
-	ret = clk_prepare_enable(dra7xx->clk);
-	if (ret)
-		return ret;
-
 	for (i = 0; i < phy_count; i++) {
 		snprintf(name, sizeof(name), "pcie-phy%d", i);
 		phy[i] = devm_phy_get(dev, name);
-- 
2.53.0



