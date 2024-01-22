Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8404152DFB;
	Tue, 23 Jan 2024 00:22:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969368; cv=none; b=gQvXCCUeFZe235KPgiSNlLpkSIzL/mtNr6KBM20WO/0Qz8eza7MifciR2OeHdglVjYFfta/ZNqOiIdHrcqgH6XSlIF24Ue1GxaIswtCHbQcUq/E365qzsIPXGfEtrxOo6aAiikcYHSNyBQ/mOFezb0p1te7j0TWni5oPYgDX2AY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969368; c=relaxed/simple;
	bh=K0ClK/eDCwX/Fe+l/4hj269lOYED+04qsdAMRoFMZDM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pGJ3zn3hcdPYsXALVtw8PGXfD4sgVmhoKmlgHBRNhlog7+5OiK4pjsuYESDH620rXGbeCrqVcjbI9BFcu4K6oZCmEDMVpk8G1cYr0NU0CDSbQEJgRy5SqANRU3OmEsmq/sdLxYFlAdgxoyriCjYjYVHe8t6KjtDwXfZ6MMtSwtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e+lh0Vi3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e+lh0Vi3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75183C433C7;
	Tue, 23 Jan 2024 00:22:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969368;
	bh=K0ClK/eDCwX/Fe+l/4hj269lOYED+04qsdAMRoFMZDM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e+lh0Vi3xDmFxQuIvMPnVSx7ITklxoqSOBpCop5Eik9mbhmUqZi+Qn96XrMiy2VEx
	 aI2E5kA8+f6A6LGPn9SSwLFOW0iUnEG8lCt0eKSBhdH1A2AuaqAcKtlCcTk/o+5+LH
	 qglcI4SteSFFdgiowtsNBUXsIW6eQ1Eh8F7dWgLI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 200/641] arm64: dts: qcom: sc7280: Mark SDHCI hosts as cache-coherent
Date: Mon, 22 Jan 2024 15:51:44 -0800
Message-ID: <20240122235824.217616122@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Dybcio <konrad.dybcio@linaro.org>

[ Upstream commit 827f5fc8d912203c1f971e47d61130b13c6820ba ]

The SDHCI hosts on SC7280 are cache-coherent, just like on most fairly
recent Qualcomm SoCs. Mark them as such.

Fixes: 298c81a7d44f ("arm64: dts: qcom: sc7280: Add nodes for eMMC and SD card")
Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20231218-topic-7280_dmac_sdhci-v1-1-97af7efd64a1@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sc7280.dtsi | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/sc7280.dtsi b/arch/arm64/boot/dts/qcom/sc7280.dtsi
index 1dac0b10582e..f7f616906f6f 100644
--- a/arch/arm64/boot/dts/qcom/sc7280.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7280.dtsi
@@ -974,6 +974,7 @@ sdhc_1: mmc@7c4000 {
 
 			bus-width = <8>;
 			supports-cqe;
+			dma-coherent;
 
 			qcom,dll-config = <0x0007642c>;
 			qcom,ddr-config = <0x80040868>;
@@ -3331,6 +3332,7 @@ sdhc_2: mmc@8804000 {
 			operating-points-v2 = <&sdhc2_opp_table>;
 
 			bus-width = <4>;
+			dma-coherent;
 
 			qcom,dll-config = <0x0007642c>;
 
-- 
2.43.0



