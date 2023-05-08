Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C3E2168DE
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:35:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 662D0C433EF;
	Mon,  8 May 2023 11:35:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683545707;
	bh=1GUh7JA02UfGFPxOVD67CTmYmLHOgoWfD1FSvVtpKhA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YDniNVhNM4Eko/gOOHOuDALIlUkWhpx9QshdG+58ZGRX4RM7JBBcvQF5403kXLxjW
	 x46q4kS6hqZrIExpQ3e/RrVOa/xJkfkTDOx2o5a937LXM2psf9Rm8ZFpr51yDU03ll
	 ATvFEYlR76XhX28uVy2nyWtog6uJC58v/JkNJgEc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 098/371] arm64: dts: qcom: ipq8074: Fix the PCI I/O port range
Date: Mon,  8 May 2023 11:44:59 +0200
Message-Id: <20230508094815.935782511@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094811.912279944@linuxfoundation.org>
References: <20230508094811.912279944@linuxfoundation.org>
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

[ Upstream commit e49eafefe5ab325e38dd074f2005076ffc271e54 ]

For 64KiB of the I/O region, the I/O ports of the legacy PCI devices are
located in the range of 0x0 to 0x10000. Hence, fix the bogus PCI addresses
(0x10200000, 0x20200000) specified in the ranges property for I/O region.

While at it, let's use the missing 0x prefix for the addresses and align
them in a single line.

Fixes: 33057e1672fe ("ARM: dts: ipq8074: Add pcie nodes")
Reported-by: Arnd Bergmann <arnd@arndb.de>
Link: https://lore.kernel.org/linux-arm-msm/7c5dfa87-41df-4ba7-b0e4-72c8386402a8@app.fastmail.com/
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20230228164752.55682-6-manivannan.sadhasivam@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/ipq8074.dtsi | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/ipq8074.dtsi b/arch/arm64/boot/dts/qcom/ipq8074.dtsi
index 68e82c755986c..17eeff106bab7 100644
--- a/arch/arm64/boot/dts/qcom/ipq8074.dtsi
+++ b/arch/arm64/boot/dts/qcom/ipq8074.dtsi
@@ -661,10 +661,8 @@
 			phys = <&pcie_phy1>;
 			phy-names = "pciephy";
 
-			ranges = <0x81000000 0 0x10200000 0x10200000
-				  0 0x10000>,   /* downstream I/O */
-				 <0x82000000 0 0x10220000 0x10220000
-				  0 0xfde0000>; /* non-prefetchable memory */
+			ranges = <0x81000000 0x0 0x00000000 0x10200000 0x0 0x10000>,   /* I/O */
+				 <0x82000000 0x0 0x10220000 0x10220000 0x0 0xfde0000>; /* MEM */
 
 			interrupts = <GIC_SPI 85 IRQ_TYPE_LEVEL_HIGH>;
 			interrupt-names = "msi";
@@ -725,10 +723,8 @@
 			phys = <&pcie_phy0>;
 			phy-names = "pciephy";
 
-			ranges = <0x81000000 0 0x20200000 0x20200000
-				  0 0x10000>, /* downstream I/O */
-				 <0x82000000 0 0x20220000 0x20220000
-				  0 0xfde0000>; /* non-prefetchable memory */
+			ranges = <0x81000000 0x0 0x00000000 0x20200000 0x0 0x10000>,   /* I/O */
+				 <0x82000000 0x0 0x20220000 0x20220000 0x0 0xfde0000>; /* MEM */
 
 			interrupts = <GIC_SPI 52 IRQ_TYPE_LEVEL_HIGH>;
 			interrupt-names = "msi";
-- 
2.39.2



