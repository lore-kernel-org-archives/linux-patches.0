Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEBD762A0F;
	Tue, 23 Jan 2024 01:56:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974985; cv=none; b=UscXdLNgQ9t92kXqE6t2kuj4V7g4xW9T/P1NUbEzmllBu0s6YBpzGJ6U1hXdXdeBnLBcgpK055JMS7TiCPHaeN1OM/sr+KLyosYT3gd9HYYjxaKIzkQXQbpQIGyUVyr+Tt3Vz9401SUhxq3z7BoadK2Seu2NRlBcrn9biaHCaxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974985; c=relaxed/simple;
	bh=B+TSbABwFxL+YhSZG7aipl+y5sXHAAcq1Bztbs5sFjY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KZOguxK3y/F/SYJPBqwhavaXv5mFbfGj+VN2yRBtg9QjY3kdg3Jj6KsDx9JFXREWZ8+ibOYOk6lLsQiGEF8JYiYPKZz0N6uHu58+ccwjMUgq8KYDItqoh9At7+WGQj4TX2yzQVHGVdu7UkL3t1N/2qH4KN8NsJRzc1IvV2VtAYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tIjdN6T1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tIjdN6T1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12A1AC433F1;
	Tue, 23 Jan 2024 01:56:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974985;
	bh=B+TSbABwFxL+YhSZG7aipl+y5sXHAAcq1Bztbs5sFjY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tIjdN6T1q+CcwjnY3lBcpzJ4A3v1mzxElb1TFbNxcMHfNQYwdtxfdlBxMqQBzECbb
	 132S6vYvkvRehMWZzeA2q6Mar7UEHotPT1QsRC+jOBQaYx6ZIu3ZuviKgVgbQCa+pB
	 u1Q7yjj/JAmiHcFcpB7w30+L/ida5S0fDzEXID/I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 181/583] arm64: dts: qcom: sc7280: Mark SDHCI hosts as cache-coherent
Date: Mon, 22 Jan 2024 15:53:52 -0800
Message-ID: <20240122235817.554474887@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index e6798447b29a..ec5c36425a22 100644
--- a/arch/arm64/boot/dts/qcom/sc7280.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7280.dtsi
@@ -925,6 +925,7 @@ sdhc_1: mmc@7c4000 {
 
 			bus-width = <8>;
 			supports-cqe;
+			dma-coherent;
 
 			qcom,dll-config = <0x0007642c>;
 			qcom,ddr-config = <0x80040868>;
@@ -3291,6 +3292,7 @@ sdhc_2: mmc@8804000 {
 			operating-points-v2 = <&sdhc2_opp_table>;
 
 			bus-width = <4>;
+			dma-coherent;
 
 			qcom,dll-config = <0x0007642c>;
 
-- 
2.43.0



