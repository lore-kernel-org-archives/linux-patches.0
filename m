Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C050BA45
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:00:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93AECC433D2;
	Tue,  7 Mar 2023 17:59:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678211999;
	bh=I1aRTm62cR23RCzWCFw6yjB5pLeA/rKdemBCYUR9i8c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hP0qFOzrsl58XoMNC2iRh2Fc/x0DEMcceuZtvC4y6r9WV96hTLIXxaqiE8TKbCr+N
	 B33ODvNfckFVCufi346G5cZiv6wHb3OGsusKJvmmJISPLt5g6SzHSQqrIziiYrZW7N
	 qX2X7t5ILmCwP3z4Ydx8bCzcboVf/MO0vRCbFFRg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robert Marko <robimarko@gmail.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 043/885] arm64: dts: qcom: ipq8074: correct PCIe QMP PHY output clock names
Date: Tue,  7 Mar 2023 17:49:37 +0100
Message-Id: <20230307170003.544841752@linuxfoundation.org>
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

[ Upstream commit 0e8b90c0256cf9c9589e2cee517dedc987a34355 ]

Current PCIe QMP PHY output name were changed in ("arm64: dts: qcom: Fix
IPQ8074 PCIe PHY nodes") however it did not account for the fact that GCC
driver is relying on the old names to match them as they are being used as
the parent for the gcc_pcie0_pipe_clk and gcc_pcie1_pipe_clk.

This broke parenting as GCC could not find the parent clock, so fix it by
changing to the names that driver is expecting.

Fixes: 942bcd33ed45 ("arm64: dts: qcom: Fix IPQ8074 PCIe PHY nodes")
Signed-off-by: Robert Marko <robimarko@gmail.com>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20230113164449.906002-9-robimarko@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/ipq8074.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/ipq8074.dtsi b/arch/arm64/boot/dts/qcom/ipq8074.dtsi
index ae143159a8256..05b97b05d4462 100644
--- a/arch/arm64/boot/dts/qcom/ipq8074.dtsi
+++ b/arch/arm64/boot/dts/qcom/ipq8074.dtsi
@@ -222,7 +222,7 @@ pcie_phy0: phy@84200 {
 				#clock-cells = <0>;
 				clocks = <&gcc GCC_PCIE0_PIPE_CLK>;
 				clock-names = "pipe0";
-				clock-output-names = "pcie_0_pipe_clk";
+				clock-output-names = "pcie20_phy0_pipe_clk";
 			};
 		};
 
@@ -250,7 +250,7 @@ pcie_phy1: phy@8e200 {
 				#clock-cells = <0>;
 				clocks = <&gcc GCC_PCIE1_PIPE_CLK>;
 				clock-names = "pipe0";
-				clock-output-names = "pcie_1_pipe_clk";
+				clock-output-names = "pcie20_phy1_pipe_clk";
 			};
 		};
 
-- 
2.39.2



