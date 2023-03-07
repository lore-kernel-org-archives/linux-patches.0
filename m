Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75053BA45
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:59:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE414C433D2;
	Tue,  7 Mar 2023 17:59:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678211984;
	bh=hlPByCCHPDZ8BRLUI1DXLlkMIKUFq0Blq3TF7npokN4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Sg6uO6TtMFUVFIKNFhMjX+RYHMe+c7JbWb5EqHFrWfR7h6oTXxaLGPUQSro1RDQSa
	 L4xl/gCAKbLpdH43+OaY2qHrP5JhiJaAo1sadcokZ9Lh34LCsRLRh2g8xFLg+V1Fkf
	 CxIEvUVu+G/MrbN6sD8RmB0sukHPSGlH70fOHPYU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robert Marko <robimarko@gmail.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 039/885] arm64: dts: qcom: ipq8074: fix Gen2 PCIe QMP PHY
Date: Tue,  7 Mar 2023 17:49:33 +0100
Message-Id: <20230307170003.371960795@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Robert Marko <robimarko@gmail.com>

[ Upstream commit 100d9c94ccf15b02742c326cd04f422ab729153b ]

Serdes register space sizes are incorrect, update them to match the
actual sizes from downstream QCA 5.4 kernel.

Fixes: 942bcd33ed45 ("arm64: dts: qcom: Fix IPQ8074 PCIe PHY nodes")
Signed-off-by: Robert Marko <robimarko@gmail.com>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20230113164449.906002-1-robimarko@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/ipq8074.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/ipq8074.dtsi b/arch/arm64/boot/dts/qcom/ipq8074.dtsi
index cde06bfc598bf..09ba99fc90ac4 100644
--- a/arch/arm64/boot/dts/qcom/ipq8074.dtsi
+++ b/arch/arm64/boot/dts/qcom/ipq8074.dtsi
@@ -242,9 +242,9 @@ pcie_qmp1: phy@8e000 {
 			status = "disabled";
 
 			pcie_phy1: phy@8e200 {
-				reg = <0x8e200 0x16c>,
+				reg = <0x8e200 0x130>,
 				      <0x8e400 0x200>,
-				      <0x8e800 0x4f4>;
+				      <0x8e800 0x1f8>;
 				#phy-cells = <0>;
 				#clock-cells = <0>;
 				clocks = <&gcc GCC_PCIE1_PIPE_CLK>;
-- 
2.39.2



