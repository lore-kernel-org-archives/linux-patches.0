Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA9418F74
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:05:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AD80C433C8;
	Sun, 16 Jul 2023 20:05:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689537913;
	bh=8Opw2j0BGEwHN1MeAS3eZDWs3Kl/+aKqzOJJnYnVFpA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0ZjKYZd8qyeatKm+nH/aKgFZD+lDPZOYhYKfLeFpv8yxERllumKHQHFGl8q2fw2MB
	 ULOkwZMEJ6+IgvEm83GJ2oN4H9qeCSH+ZzD0twcE3RbyooLa/7suog6OmEawlF1TcR
	 s5xOzdMo2M58vPfOgCNBzSDMF4jLjzgHymUn26WQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Devi Priya <quic_devipriy@quicinc.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 265/800] arm64: dts: qcom: ipq9574: Update the size of GICC & GICV regions
Date: Sun, 16 Jul 2023 21:41:58 +0200
Message-ID: <20230716194955.252198930@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Devi Priya <quic_devipriy@quicinc.com>

[ Upstream commit 6fb45762691d12d9812c41d20b2f5db1412047ae ]

Update the size of GICC and GICV regions to 8kB as the GICC_DIR & GICV_DIR
registers lie in the second 4kB region. Also, add target CPU encoding.

Fixes: 97cb36ff52a1 ("arm64: dts: qcom: Add ipq9574 SoC and AL02 board support")
Signed-off-by: Devi Priya <quic_devipriy@quicinc.com>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20230425084010.15581-2-quic_devipriy@quicinc.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/ipq9574.dtsi | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/ipq9574.dtsi b/arch/arm64/boot/dts/qcom/ipq9574.dtsi
index 0ed19fbf7d87d..6e3a88ee06152 100644
--- a/arch/arm64/boot/dts/qcom/ipq9574.dtsi
+++ b/arch/arm64/boot/dts/qcom/ipq9574.dtsi
@@ -173,14 +173,14 @@ blsp1_uart2: serial@78b1000 {
 		intc: interrupt-controller@b000000 {
 			compatible = "qcom,msm-qgic2";
 			reg = <0x0b000000 0x1000>,  /* GICD */
-			      <0x0b002000 0x1000>,  /* GICC */
+			      <0x0b002000 0x2000>,  /* GICC */
 			      <0x0b001000 0x1000>,  /* GICH */
-			      <0x0b004000 0x1000>;  /* GICV */
+			      <0x0b004000 0x2000>;  /* GICV */
 			#address-cells = <1>;
 			#size-cells = <1>;
 			interrupt-controller;
 			#interrupt-cells = <3>;
-			interrupts = <GIC_PPI 9 IRQ_TYPE_LEVEL_HIGH>;
+			interrupts = <GIC_PPI 9 (GIC_CPU_MASK_SIMPLE(4) | IRQ_TYPE_LEVEL_HIGH)>;
 			ranges = <0 0x0b00c000 0x3000>;
 
 			v2m0: v2m@0 {
-- 
2.39.2



