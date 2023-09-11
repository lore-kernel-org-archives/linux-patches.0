Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8EAC11710
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 15:15:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0624BC433C8;
	Mon, 11 Sep 2023 15:15:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694445316;
	bh=B7eAnGKCly1DMnmAp/N+QMOlE8FO+wCHtfxRVOMT/KI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oqa2Z2GhLtmsYHHucr2u3UBdk1BGxGS+UL0hvzU0bp22S9UIa6IwnWxJbrhQ948u/
	 8U6E6srNnSJUgyS5ZbFwxXQoVW1JwVQkRqsZWkGXIeT27G2jgp5R2+eXAzH0SbOB9t
	 wIVU80LTrozHaRAFbjY9ud7pFOAEoTjRSRB/FFcE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robert Marko <robert.marko@sartura.hr>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 305/600] ARM: dts: qcom: ipq4019: correct SDHCI XO clock
Date: Mon, 11 Sep 2023 15:45:38 +0200
Message-ID: <20230911134642.627948394@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134633.619970489@linuxfoundation.org>
References: <20230911134633.619970489@linuxfoundation.org>
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

From: Robert Marko <robert.marko@sartura.hr>

[ Upstream commit b5ed7a5c1fdb3981713f7b637b72aa390c3db036 ]

Using GCC_DCD_XO_CLK as the XO clock for SDHCI controller is not correct,
it seems that I somehow made a mistake of passing it instead of the fixed
XO clock.

Fixes: 04b3b72b5b8f ("ARM: dts: qcom: ipq4019: Add SDHCI controller node")
Signed-off-by: Robert Marko <robert.marko@sartura.hr>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20230811110150.229966-1-robert.marko@sartura.hr
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/qcom-ipq4019.dtsi | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/arm/boot/dts/qcom-ipq4019.dtsi b/arch/arm/boot/dts/qcom-ipq4019.dtsi
index 02e13d8c222a0..b5e0ed4923b59 100644
--- a/arch/arm/boot/dts/qcom-ipq4019.dtsi
+++ b/arch/arm/boot/dts/qcom-ipq4019.dtsi
@@ -228,9 +228,12 @@ sdhci: mmc@7824900 {
 			interrupts = <GIC_SPI 123 IRQ_TYPE_LEVEL_HIGH>, <GIC_SPI 138 IRQ_TYPE_LEVEL_HIGH>;
 			interrupt-names = "hc_irq", "pwr_irq";
 			bus-width = <8>;
-			clocks = <&gcc GCC_SDCC1_AHB_CLK>, <&gcc GCC_SDCC1_APPS_CLK>,
-				 <&gcc GCC_DCD_XO_CLK>;
-			clock-names = "iface", "core", "xo";
+			clocks = <&gcc GCC_SDCC1_AHB_CLK>,
+				 <&gcc GCC_SDCC1_APPS_CLK>,
+				 <&xo>;
+			clock-names = "iface",
+				      "core",
+				      "xo";
 			status = "disabled";
 		};
 
-- 
2.40.1



