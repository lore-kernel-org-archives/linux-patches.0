Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039868;
	b=y6/DyOyl2hdQIHYGOqwEkmQ4OGZ59EYY7ByDVIBtPvJmATuEWUJfzOwDOdZDHBlccDFe
	 j0Rr+Cpx/G2cJBh284qTLFVLUF+JDOXWzJUrp0ccqULd7dnr18hO0vK0BZVDKvtl8nxey
	 4eysoxxa4ICMxYxrb1ci36tN3e7I3ZIdLX67b4kvV64byS8vuCNNzAoRdwP9iqOjTtjGa
	 iS/iKY9BA5DOUViDudQGBmhTtZ6PLNG6n6xiy8V/9llf/wbOK2/RsuZzY2eUnvjH1B3vc
	 u8WdeHLVzdxN1489qblp9EUPmvAsYa0btWy0OcLfsXuXMQWOV2WyXk5Ymtwf+bDC0FA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039868;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=++OYDUI3HqSkV0t/jD3kvMbs2KeMvnYVnimJhOKK86w=;
	b=eb/MbiMRcmWeR3wU2rB4JMyOoZOpYKvuscqnbl4LqsyHolLBKeFpLroEO1/LWsnGT6Xx
	 qhjJn9Yyk8KawXW7Ouq8mGHYYEvncKl3JJnMi2epiyVizo4hD7oIVEmmvZf8FtWnWC26Y
	 GXIE+AxYf8JP4W6L5zoS5uyszSbwBlfQmJ4t4FjjtmJexJ4O4GjKS/XMNDUKmE/1eUb35
	 AaBwEGMP0tmPS6DmZwsoWwV/thQ/B32q/R/oyvKM+772cEp48DjS4t+Bxe7DZ99GWhs07
	 dUnNOfxtVXKs4Xrtc2/KPIV1kGdgaxZUtLZMh7LV8OoCuvjBM0idAGKVdJQnAFH8edw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G8Vv5BUr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32BE8606A32A;
	Wed, 18 Nov 2026 22:11:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G8Vv5BUr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F5081F000C4;
	Wed, 18 Nov 2026 22:11:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039868;
	bh=++OYDUI3HqSkV0t/jD3kvMbs2KeMvnYVnimJhOKK86w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G8Vv5BUrwzy3R7wkiPjX9KNKaFPsrrlgqgPgi5HMeMUAVuPrHOalM+E64sZIiAT4x
	 Jml9/25n8WIFjW3aLuMAvpRBiTBAB5uDl2Sm4FMbd2757ytckzCodqiyCDy+WAh1kv
	 ysnENA7uiE8QnRlmbcPecYpnfATQX0CXPrq12+SI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Luca Ceresoli <luca.ceresoli@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2254/3318] PCI: dra7xx: Fix clock enable leak on probe failure
Date: Wed, 18 Nov 2026 15:47:56 +0100
Message-ID: <20261118150429.449434425@linuxfoundation.org>
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
index d7535db2e1bb8..b1838877d7d58 100644
--- a/drivers/pci/controller/dwc/pci-dra7xx.c
+++ b/drivers/pci/controller/dwc/pci-dra7xx.c
@@ -735,15 +735,11 @@ static int dra7xx_pcie_probe(struct platform_device *pdev)
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



