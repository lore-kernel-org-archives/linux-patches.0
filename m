Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28C5C125DF
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:02:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85EA7C433D2;
	Mon,  8 May 2023 11:02:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683543747;
	bh=+nLrGbl44S0LQLclq3/9ImQjdgUkiwCwC8p0PthSIjo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aKQ9UqbN7EnBreZFcIcFgNkL00C3E3vfDuRLTBb27RFbqI1cWTBg1wpDQMtzooe6+
	 m31bXGVRsA2BGgSCD6b2XRtZlrpOc/R4L9+cwN71fg53OjX3NBlCtvckIyFfXbPS+X
	 eAIR2LluWRfXaTugttwDtZZeAO+DIVPqah2CuPTU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 189/694] arm64: dts: qcom: ipq6018: Fix the PCI I/O port range
Date: Mon,  8 May 2023 11:40:24 +0200
Message-Id: <20230508094438.556992350@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094432.603705160@linuxfoundation.org>
References: <20230508094432.603705160@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

[ Upstream commit 75a6e1fdb351189f55097741e8460ca3f9b2883f ]

For 64KiB of the I/O region, the I/O ports of the legacy PCI devices are
located in the range of 0x0 to 0x10000. Hence, fix the bogus PCI address
(0x20200000) specified in the ranges property for I/O region.

While at it, let's use the missing 0x prefix for the addresses.

Fixes: 095bbdd9a5c3 ("arm64: dts: qcom: ipq6018: Add pcie support")
Reported-by: Arnd Bergmann <arnd@arndb.de>
Link: https://lore.kernel.org/linux-arm-msm/7c5dfa87-41df-4ba7-b0e4-72c8386402a8@app.fastmail.com/
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20230228164752.55682-7-manivannan.sadhasivam@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/ipq6018.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/ipq6018.dtsi b/arch/arm64/boot/dts/qcom/ipq6018.dtsi
index bbd94025ff5d8..9ff4e9d45065b 100644
--- a/arch/arm64/boot/dts/qcom/ipq6018.dtsi
+++ b/arch/arm64/boot/dts/qcom/ipq6018.dtsi
@@ -738,8 +738,8 @@
 			phys = <&pcie_phy0>;
 			phy-names = "pciephy";
 
-			ranges = <0x81000000 0 0x20200000 0 0x20200000 0 0x10000>,
-				 <0x82000000 0 0x20220000 0 0x20220000 0 0xfde0000>;
+			ranges = <0x81000000 0x0 0x00000000 0x0 0x20200000 0x0 0x10000>,
+				 <0x82000000 0x0 0x20220000 0x0 0x20220000 0x0 0xfde0000>;
 
 			interrupts = <GIC_SPI 52 IRQ_TYPE_LEVEL_HIGH>;
 			interrupt-names = "msi";
-- 
2.39.2



