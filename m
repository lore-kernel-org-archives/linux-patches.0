Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E7F62D7D59;
	Wed, 25 Feb 2026 07:00:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002800; cv=none; b=k4raM65x6c+aLLWiPXlEiEYuUboqeoiCqWAdWO+QZnu9yd6pb4gy+C/Pg1TW0WcOA1SdGqtcwN/xZGX/EandAuFvk265ErNNS4x9AOT0CZB0ivnbXBkHzeQtCpb2m96hhQaq3dSJD3EiIsMLNYAtFAWmbxmTBLhRjIc0IT0pHUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002800; c=relaxed/simple;
	bh=wtf9XbNa/HNW4G0ox8nS3eLQP0E1ioruvPogU5FzYdg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eW8ymrIa3m17EC9zjIa0Eo9rQ7cz3fKCBolKPH/7ooO6vWsBf7BxfbMjLgat2a2gNrae0wcdn7bClD4JzwdJi3XLToLSkVr3jOve8AUhXecph8yCvSG/Vpsrz2bDZ6O+gAn4AA3qsLaM2kaXvvCKmOhlWy7v+81MIhSwZb77UCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f8Cj0kKO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f8Cj0kKO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9E8FC19422;
	Wed, 25 Feb 2026 06:59:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002800;
	bh=wtf9XbNa/HNW4G0ox8nS3eLQP0E1ioruvPogU5FzYdg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f8Cj0kKO4265NQsqn0RNRmPuElsmd5HMG9l0BbLVulOJoaufYoAkl5IKPD6osghmg
	 Y4mCR8C0nDOMCGFIQjcGdzrXoe47w1/3Sy5ep44Y+m7xCm4x4P3SGYSaj3D/Qil9VY
	 ee6wkm8CBi7P3YBNRL2NxEqzItLMIJO1E/jmVl2o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongliang Wang <wanghongliang@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 641/641] net: stmmac: dwmac-loongson: Set clk_csr_i to 100-150MHz
Date: Tue, 24 Feb 2026 17:26:07 -0800
Message-ID: <20260225012404.035482553@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Huacai Chen <chenhuacai@loongson.cn>

commit e1aa5ef892fb4fa9014a25e87b64b97347919d37 upstream.

Current clk_csr_i setting of Loongson STMMAC (including LS7A1000/2000
and LS2K1000/2000/3000) are copy & paste from other drivers. In fact,
Loongson STMMAC use 125MHz clocks and need 62 freq division to within
2.5MHz, meeting most PHY MDC requirement. So fix by setting clk_csr_i
to 100-150MHz, otherwise some PHYs may link fail.

Cc: stable@vger.kernel.org
Fixes: 30bba69d7db40e7 ("stmmac: pci: Add dwmac support for Loongson")
Signed-off-by: Hongliang Wang <wanghongliang@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Link: https://patch.msgid.link/20260203062901.2158236-1-chenhuacai@loongson.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c
@@ -90,8 +90,8 @@ static void loongson_default_data(struct
 	/* Get bus_id, this can be overwritten later */
 	plat->bus_id = pci_dev_id(pdev);
 
-	/* clk_csr_i = 20-35MHz & MDC = clk_csr_i/16 */
-	plat->clk_csr = STMMAC_CSR_20_35M;
+	/* clk_csr_i = 100-150MHz & MDC = clk_csr_i/62 */
+	plat->clk_csr = STMMAC_CSR_100_150M;
 	plat->core_type = DWMAC_CORE_GMAC;
 	plat->force_sf_dma_mode = 1;
 


