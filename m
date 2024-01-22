Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04E1F5916E;
	Tue, 23 Jan 2024 01:41:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974079; cv=none; b=NGjIQ3XniA4B+MpKGkBLSkV8VkE3yX8jKbMJfDrG/kCKyMaG/zG5YtCaMGjpe1TnZDiQBPDcED7F5mH0tCIIQRrOHjitPwAJ7VGx7JND8P6nonr0S0LqGYx2ypEeto2PhE8XouawuFvMYgv3MZrmjos9rTK5tWkIa3VYtvkWY7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974079; c=relaxed/simple;
	bh=CXvvlur13s+TyUnFqPpO0UBf61HOyYPfQle1QNtrKUw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rAUZ6sQ8qQipdIm5DGkuiWx+romdTZszpPBf+zoqCEvF05hXqcvhl13nMWSo+hR5XJRBPO+J+u3oHJmFC4iwYbJZ38CLtjUoA+jViecuVKEjvCRAeWRuXBbR/wW9gvP82dKumoMRiSCDpckc5zrvSS9lbCQ3XBN/UYr5CrpblpM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G6FXVcs4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G6FXVcs4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1729C43399;
	Tue, 23 Jan 2024 01:41:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974078;
	bh=CXvvlur13s+TyUnFqPpO0UBf61HOyYPfQle1QNtrKUw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G6FXVcs4rKYQb5/ebNbQTJi5SeFa7GHIco7TeASpJRSE53TINtwrX0QMcaO/jc3rW
	 8VBLcQzrhBR3CY4vwvv53w7tP1N5BC/1c3KCek1V1g6OC+2PamUyxeFYk7xuAbpHmF
	 o0+30ldY4awSUllGMaC7d+Nr4dsu6Hl02uCC45DA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 154/374] arm64: dts: qcom: sc7280: Mark SDHCI hosts as cache-coherent
Date: Mon, 22 Jan 2024 15:56:50 -0800
Message-ID: <20240122235749.978185971@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index e0c7f72773d6..929fc0667e98 100644
--- a/arch/arm64/boot/dts/qcom/sc7280.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7280.dtsi
@@ -485,6 +485,7 @@ sdhc_1: sdhci@7c4000 {
 
 			bus-width = <8>;
 			supports-cqe;
+			dma-coherent;
 
 			qcom,dll-config = <0x0007642c>;
 			qcom,ddr-config = <0x80040868>;
@@ -1174,6 +1175,7 @@ sdhc_2: sdhci@8804000 {
 			operating-points-v2 = <&sdhc2_opp_table>;
 
 			bus-width = <4>;
+			dma-coherent;
 
 			qcom,dll-config = <0x0007642c>;
 
-- 
2.43.0



