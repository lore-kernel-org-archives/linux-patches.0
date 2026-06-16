Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9ADC47A0CD;
	Tue, 16 Jun 2026 18:29:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781634586; cv=none; b=MlIdXEOHF3Uk8Tliy4Iynfh9zfh2A+090aNdHmCt2+fsXs3/tFgFaB0y/tqNXiqJZ0caKKoNwt41CZE4njXEQyhTOZ8PqsDbvkTE+xA+heECsNbAW2Z0qQt2OYOzwZeYifzvgNS34r3NiTYufHdVMTIgT9yRQm8JHC61pkges6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781634586; c=relaxed/simple;
	bh=nTlL5Gpw3zt4VuUO3JxkHzYxB5V1S4qe+I2AvRpTmo8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Avt2+jlJxnKoAsEz7/2saXFddUBrEkHiCIAASJgwiPe3NxsFdoBMY4/kc15/pz/g4U0F0/mAq8k/EjgzLl5ZhO28nT72zyThnvgOGnsTMnUTWJuTau9cSWpb3XwwHsX7wqwroa81C78JRdG6cIaR3n0dfgHAnQv7YoATOGI5Gzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UThe9pU3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UThe9pU3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF5E61F00A3A;
	Tue, 16 Jun 2026 18:29:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781634585;
	bh=p/tGtc5w1wIkgFr/rxF/KDVf9PflvBZtdR1bih0BOEA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UThe9pU3707ZcNErrNe2+AdUEWEImO5P6AA47zZDaEhNv9yLeTAsbn2rBdutC4Z8b
	 okM5vn5N89/o1bvOPb5kai0AKuxXea/vazIJuqbh2eVBITqxXbJci+JCKr0fwIK6jF
	 ok2ZpZymDDCJsanty5s+NMWgkvceTRzcWQm4EqAU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jimmy Hon <honyuenkwun@gmail.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 260/411] rtw88: 8821ce: Disable PCIe ASPM L1 for 8821CE using chip ID
Date: Tue, 16 Jun 2026 20:28:18 +0530
Message-ID: <20260616145114.838080524@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145100.376842714@linuxfoundation.org>
References: <20260616145100.376842714@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jimmy Hon <honyuenkwun@gmail.com>

[ Upstream commit b9eb5f0742d107ca9c0f33da58f61ce83e3ce2fc ]

Make workaround work for other 8821CE devices with different PCI ID

Signed-off-by: Jimmy Hon <honyuenkwun@gmail.com>
Reviewed-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20220407075123.420696-3-honyuenkwun@gmail.com
Stable-dep-of: eb101d2abdcc ("wifi: rtw88: check for PCI upstream bridge existence")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/realtek/rtw88/pci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/realtek/rtw88/pci.c
+++ b/drivers/net/wireless/realtek/rtw88/pci.c
@@ -1766,7 +1766,7 @@ int rtw_pci_probe(struct pci_dev *pdev,
 	}
 
 	/* Disable PCIe ASPM L1 while doing NAPI poll for 8821CE */
-	if (pdev->device == 0xc821 && bridge->vendor == PCI_VENDOR_ID_INTEL)
+	if (rtwdev->chip->id == RTW_CHIP_TYPE_8821C && bridge->vendor == PCI_VENDOR_ID_INTEL)
 		rtwpci->rx_no_aspm = true;
 
 	rtw_pci_phy_cfg(rtwdev);


