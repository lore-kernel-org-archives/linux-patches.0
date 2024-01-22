Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A761360252;
	Tue, 23 Jan 2024 00:47:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970860; cv=none; b=rTp4QBm8aMEfJ6ZF03VdwYT29l6aTNUo4lkWB+ARJQ36mS1wenLjb3xYIKjSQR3NOGGmyqrjiBpfSlw7zXpoxEhNYH/MT2Rg3gxlC57sDyP1CRr2bIcVknscu5SVTsyq627SLDT3zh/hw16cYxf4NL9nW0/1zYPgSZMXi6oMr8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970860; c=relaxed/simple;
	bh=U8ZXkWxBZA4wKpKbuKm+YjOHiq61Lh18Qh345EZ828Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FrIfe6ifKt8bN5+oF2XkiQH85PGLt4S+A9WnNSUxtmbcc2SRSQeju55LYtiok83cm8w6WmtRoPouGAy4I1XhYJZDH86eHdqvX+mBQe8hCIHu6gNjd16w4eJ7Vjt3iSOJVxsEZD7A3kBI+6PL2bIj3PhG9S2jZ6DpGnqn7SMSoww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DbbEv+15; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DbbEv+15"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26953C433C7;
	Tue, 23 Jan 2024 00:47:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970860;
	bh=U8ZXkWxBZA4wKpKbuKm+YjOHiq61Lh18Qh345EZ828Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DbbEv+15esNiVEwFS+VuqbKWwbsjVPgvp9wpWdlHLWmYWDrJb05FR6B/qnylAvOjP
	 NoM2ZZK6FzczBOq15U1YGM9OepA6yR6PLg7hR9xDjFtkz5BL8HKook4hMfB7IbnPPU
	 zogv51AERgfbekep+n0iWhbnL2nUGUWzHCHsDLQQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 127/417] arm64: dts: qcom: sc7280: Mark SDHCI hosts as cache-coherent
Date: Mon, 22 Jan 2024 15:54:55 -0800
Message-ID: <20240122235756.204138750@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 8a23250d5951..7fc8c2045022 100644
--- a/arch/arm64/boot/dts/qcom/sc7280.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7280.dtsi
@@ -888,6 +888,7 @@ sdhc_1: mmc@7c4000 {
 
 			bus-width = <8>;
 			supports-cqe;
+			dma-coherent;
 
 			qcom,dll-config = <0x0007642c>;
 			qcom,ddr-config = <0x80040868>;
@@ -3271,6 +3272,7 @@ sdhc_2: mmc@8804000 {
 			operating-points-v2 = <&sdhc2_opp_table>;
 
 			bus-width = <4>;
+			dma-coherent;
 
 			qcom,dll-config = <0x0007642c>;
 
-- 
2.43.0



