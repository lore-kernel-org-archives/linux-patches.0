Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B451A1F09B3;
	Fri, 21 Nov 2025 13:20:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731244; cv=none; b=XGOKdq5O7u3GgRZ82GqACbqYghBs1AugI1K0V1aLU/lqh/sADW4nIM5WZfpaH2T7wtG9rCnfS161qdpFFTxpponeRodCrbTJrDEREWHKTh23CUljrTX1jkg7lIxUor1PqAYWg7esXWMO6VGmiKnzJsempVwmL94CpW+4kda/AkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731244; c=relaxed/simple;
	bh=fTIN3qyeRNeHEXB7Lgn+kGx+Ik/t1iYfdibrj2yCKLI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fpKGateoYOryqPok8oh9S056ySpcOCoSQsvmHSr3GPHT7DgwVaqAScRs4SwmuT1b+uPaFfqDANpS2ntbDKt6KXqE0YIelio39rGhvi9DrvwBfKvkGIqphl4ho8JE8EX91DvPF262il5a3dlmJVQZKDqioJW3jLh9OuI0cMrh7L4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DjM/l0mA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DjM/l0mA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DD07C4CEF1;
	Fri, 21 Nov 2025 13:20:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731244;
	bh=fTIN3qyeRNeHEXB7Lgn+kGx+Ik/t1iYfdibrj2yCKLI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DjM/l0mAwXNbyQ6DeDc1xdIREVsNcKM7DuKybhKL9FLn6kMeoXecxy208HFvLpMdb
	 pdRpZpGfa9MjsTtHkJXyCgHXHF0LY2fcBK/IReNLeQ34wYAg7LdEfWiU42iokRpWzH
	 jToLL4+Iqq1WiQjeDFAd7C82NW8oavCFEaXNAO98=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jo=C3=A3o=20Paulo=20Gon=C3=A7alves?= <joao.goncalves@toradex.com>,
	Frank Li <Frank.Li@nxp.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 140/247] arm64: dts: imx8-ss-img: Avoid gpio0_mipi_csi GPIOs being deferred
Date: Fri, 21 Nov 2025 14:11:27 +0100
Message-ID: <20251121130159.751265668@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: João Paulo Gonçalves <joao.goncalves@toradex.com>

[ Upstream commit ec4daace64a44b53df76f0629e82684ef09ce869 ]

The gpio0_mipi_csi DT nodes are enabled by default, but they are
dependent on the irqsteer_csi nodes, which are not enabled. This causes
the gpio0_mipi_csi GPIOs to be probe deferred. Since these GPIOs can be
used independently of the CSI controller, enable irqsteer_csi by default
too to prevent them from being deferred and to ensure they work out of
the box.

Fixes: 2217f8243714 ("arm64: dts: imx8: add capture controller for i.MX8's img subsystem")
Signed-off-by: João Paulo Gonçalves <joao.goncalves@toradex.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8-ss-img.dtsi | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8-ss-img.dtsi b/arch/arm64/boot/dts/freescale/imx8-ss-img.dtsi
index 2cf0f7208350a..a72b2f1c4a1b2 100644
--- a/arch/arm64/boot/dts/freescale/imx8-ss-img.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8-ss-img.dtsi
@@ -67,7 +67,6 @@ img_subsys: bus@58000000 {
 		power-domains = <&pd IMX_SC_R_CSI_0>;
 		fsl,channel = <0>;
 		fsl,num-irqs = <32>;
-		status = "disabled";
 	};
 
 	gpio0_mipi_csi0: gpio@58222000 {
@@ -144,7 +143,6 @@ img_subsys: bus@58000000 {
 		power-domains = <&pd IMX_SC_R_CSI_1>;
 		fsl,channel = <0>;
 		fsl,num-irqs = <32>;
-		status = "disabled";
 	};
 
 	gpio0_mipi_csi1: gpio@58242000 {
-- 
2.51.0



