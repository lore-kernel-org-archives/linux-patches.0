Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F1F51170E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:03:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95A27C433CA;
	Mon, 11 Sep 2023 14:03:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694440987;
	bh=lI43M3o8MaSl4Gl0wyYl26uLCRABMF5017jQrIYHFec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YZi8WzuzUV5fHqX7x+F74Bta4y2zGUXF553+0fvjqIamsYlAPkyXVHlq8vy0mQmqO
	 KV6390rgjFiYVmuf+uZ5n5x0VsBg3r0xfq16UiypgMWd3TTpW2fJAxbRLofxxNl/DK
	 fbVAJZZdghKdtJhTd++oevXpbUsvodUzu4ofYZDU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 229/739] arm64: dts: qcom: sm8350: Add missing LMH interrupts to cpufreq
Date: Mon, 11 Sep 2023 15:40:28 +0200
Message-ID: <20230911134657.569780871@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Dybcio <konrad.dybcio@linaro.org>

[ Upstream commit 951151c2bb548e0f6b2c40ab4c48675f5342c914 ]

Add the missing interrupts that communicate the hardware-managed
throttling to Linux.

Fixes: ccbb3abb23a5 ("arm64: dts: qcom: sm8350: Add cpufreq node")
Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20230705-topic-sm8350_fixes-v1-3-0f69f70ccb6a@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8350.dtsi | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/sm8350.dtsi b/arch/arm64/boot/dts/qcom/sm8350.dtsi
index 318ec37da5cd6..35b68de50e227 100644
--- a/arch/arm64/boot/dts/qcom/sm8350.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8350.dtsi
@@ -3399,6 +3399,13 @@ cpufreq_hw: cpufreq@18591000 {
 			      <0 0x18593000 0 0x1000>;
 			reg-names = "freq-domain0", "freq-domain1", "freq-domain2";
 
+			interrupts = <GIC_SPI 30 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 31 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 19 IRQ_TYPE_LEVEL_HIGH>;
+			interrupt-names = "dcvsh-irq-0",
+					  "dcvsh-irq-1",
+					  "dcvsh-irq-2";
+
 			clocks = <&rpmhcc RPMH_CXO_CLK>, <&gcc GCC_GPLL0>;
 			clock-names = "xo", "alternate";
 
-- 
2.40.1



