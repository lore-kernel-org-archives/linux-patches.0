Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1818233CCA;
	Fri, 24 Nov 2023 19:19:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aFbff8UN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F1A8C433C8;
	Fri, 24 Nov 2023 19:19:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700853585;
	bh=MOYFS0H1DQySzGWM62eUddA3LEU8KBe7Ha48UfDz80U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aFbff8UNLUOUuyebv+g/a7pQMW5j03xrcKZ7IhfcVlqjBzDpnMsmuHqW23HWhDc/f
	 DSQgfsSj+l613KltbnVjz96A9iEIQe2yRffH6JV7NK8bb6gdlZBXlWwNdbu+/nRi0S
	 sHLCF5Muv2IlrXmsxJ5Laui8rnw9vZuJ8iS18XdA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 248/297] arm64: dts: qcom: ipq6018: switch TCSR mutex to MMIO
Date: Fri, 24 Nov 2023 17:54:50 +0000
Message-ID: <20231124172008.867005087@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172000.087816911@linuxfoundation.org>
References: <20231124172000.087816911@linuxfoundation.org>
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

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit f5e303aefc06b7508d7a490f9a2d80e4dc134c70 ]

The TCSR mutex bindings allow device to be described only with address
space (so it uses MMIO, not syscon regmap).  This seems reasonable as
TCSR mutex is actually a dedicated IO address space and it also fixes DT
schema checks:

  qcom/ipq6018-cp01-c1.dtb: hwlock: 'reg' is a required property
  qcom/ipq6018-cp01-c1.dtb: hwlock: 'syscon' does not match any of the regexes: 'pinctrl-[0-9]+'

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20220909092035.223915-12-krzysztof.kozlowski@linaro.org
Stable-dep-of: 72fc3d58b87b ("arm64: dts: qcom: ipq6018: Fix tcsr_mutex register size")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/ipq6018.dtsi | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/ipq6018.dtsi b/arch/arm64/boot/dts/qcom/ipq6018.dtsi
index 13651a5ac5a69..43339557d7e5a 100644
--- a/arch/arm64/boot/dts/qcom/ipq6018.dtsi
+++ b/arch/arm64/boot/dts/qcom/ipq6018.dtsi
@@ -129,12 +129,6 @@
 		};
 	};
 
-	tcsr_mutex: hwlock {
-		compatible = "qcom,tcsr-mutex";
-		syscon = <&tcsr_mutex_regs 0 0x80>;
-		#hwlock-cells = <1>;
-	};
-
 	pmuv8: pmu {
 		compatible = "arm,cortex-a53-pmu";
 		interrupts = <GIC_PPI 7 (GIC_CPU_MASK_SIMPLE(4) |
@@ -253,9 +247,10 @@
 			#reset-cells = <1>;
 		};
 
-		tcsr_mutex_regs: syscon@1905000 {
-			compatible = "syscon";
-			reg = <0x0 0x01905000 0x0 0x8000>;
+		tcsr_mutex: hwlock@1905000 {
+			compatible = "qcom,ipq6018-tcsr-mutex", "qcom,tcsr-mutex";
+			reg = <0x0 0x01905000 0x0 0x1000>;
+			#hwlock-cells = <1>;
 		};
 
 		tcsr: syscon@1937000 {
-- 
2.42.0



