Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BFD0FC08
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:37:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3173C433EF;
	Mon, 15 May 2023 17:37:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684172235;
	bh=00XLg9z3RCEMN8skrqTHoZrEjLv3zZkFBJF/W/ghtHQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F7+wNbwJfbEQvg7T3yS2Fgp6oxYRKKs00EVy1TJKKya5BczVpWcBTHZf92QcsTADj
	 6iVg9auC1deh4YtV4Ivk7x8bQNSfJL9FQul+B0O647s2KFz50c26816ekcFzWy1rS6
	 wkLFyaNNFNQUnKtCphZKkrLuLp3L+d3RB0p311G0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 087/381] arm64: dts: qcom: msm8996: Fix the PCI I/O port range
Date: Mon, 15 May 2023 18:25:38 +0200
Message-Id: <20230515161740.726016194@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161736.775969473@linuxfoundation.org>
References: <20230515161736.775969473@linuxfoundation.org>
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

[ Upstream commit cf0ac10feb17661987d0018eb9475dc03e2a2253 ]

For 1MiB of the I/O region, the I/O ports of the legacy PCI devices are
located in the range of 0x0 to 0x100000. Hence, fix the bogus PCI addresses
(0x0c200000, 0x0d200000, 0x0e200000) specified in the ranges property for
I/O region.

While at it, let's also align the entries.

Fixes: ed965ef89227 ("arm64: dts: qcom: msm8996: add support to pcie")
Reported-by: Arnd Bergmann <arnd@arndb.de>
Link: https://lore.kernel.org/linux-arm-msm/7c5dfa87-41df-4ba7-b0e4-72c8386402a8@app.fastmail.com/
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20230228164752.55682-8-manivannan.sadhasivam@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/msm8996.dtsi | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/msm8996.dtsi b/arch/arm64/boot/dts/qcom/msm8996.dtsi
index bc140269e4cc5..02b5f6f1d331e 100644
--- a/arch/arm64/boot/dts/qcom/msm8996.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8996.dtsi
@@ -744,8 +744,8 @@
 
 				#address-cells = <3>;
 				#size-cells = <2>;
-				ranges = <0x01000000 0x0 0x0c200000 0x0c200000 0x0 0x100000>,
-					<0x02000000 0x0 0x0c300000 0x0c300000 0x0 0xd00000>;
+				ranges = <0x01000000 0x0 0x00000000 0x0c200000 0x0 0x100000>,
+					 <0x02000000 0x0 0x0c300000 0x0c300000 0x0 0xd00000>;
 
 				interrupts = <GIC_SPI 405 IRQ_TYPE_LEVEL_HIGH>;
 				interrupt-names = "msi";
@@ -796,8 +796,8 @@
 
 				#address-cells = <3>;
 				#size-cells = <2>;
-				ranges = <0x01000000 0x0 0x0d200000 0x0d200000 0x0 0x100000>,
-					<0x02000000 0x0 0x0d300000 0x0d300000 0x0 0xd00000>;
+				ranges = <0x01000000 0x0 0x00000000 0x0d200000 0x0 0x100000>,
+					 <0x02000000 0x0 0x0d300000 0x0d300000 0x0 0xd00000>;
 
 				interrupts = <GIC_SPI 413 IRQ_TYPE_LEVEL_HIGH>;
 				interrupt-names = "msi";
@@ -845,8 +845,8 @@
 
 				#address-cells = <3>;
 				#size-cells = <2>;
-				ranges = <0x01000000 0x0 0x0e200000 0x0e200000 0x0 0x100000>,
-					<0x02000000 0x0 0x0e300000 0x0e300000 0x0 0x1d00000>;
+				ranges = <0x01000000 0x0 0x00000000 0x0e200000 0x0 0x100000>,
+					 <0x02000000 0x0 0x0e300000 0x0e300000 0x0 0x1d00000>;
 
 				device_type = "pci";
 
-- 
2.39.2



