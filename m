Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5199E11CA1
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:02:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC73DC433D2;
	Mon,  8 May 2023 11:02:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683543741;
	bh=865hdjsEY5J1SVyzYwdLAhFd8+p+pWMEW234uVFTuYU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u5Gm3WYwOn4YtPHHdOdS6FVklzTbo0HIONuz2R0sMwjfDf8XD+ptCMvQwygePC7kU
	 f2s3FaDBul3F5/W4oBTbVaKX/XqKFNMAjQzmYDRzXEjHsqHD7E8T0IYV3n1avRKqcZ
	 Fjag2yPNZhRyLyu9WxiZO9y141zWSKkUjg6RHXPo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 187/694] arm64: dts: qcom: sm8550: Fix the PCI I/O port range
Date: Mon,  8 May 2023 11:40:22 +0200
Message-Id: <20230508094438.498406162@linuxfoundation.org>
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

[ Upstream commit 565c633940312b4eea7785a0a58e1944258c47e9 ]

For 1MiB of the I/O region, the I/O ports of the legacy PCI devices are
located in the range of 0x0 to 0x100000. Hence, fix the bogus PCI addresses
(0x60200000, 0x40200000) specified in the ranges property for I/O region.

While at it, let's use the missing 0x prefix for the addresses.

Fixes: 7d1158c984d3 ("arm64: dts: qcom: sm8550: Add PCIe PHYs and controllers nodes")
Reported-by: Arnd Bergmann <arnd@arndb.de>
Link: https://lore.kernel.org/linux-arm-msm/7c5dfa87-41df-4ba7-b0e4-72c8386402a8@app.fastmail.com/
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20230228164752.55682-5-manivannan.sadhasivam@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8550.dtsi | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8550.dtsi b/arch/arm64/boot/dts/qcom/sm8550.dtsi
index ebc391bf1e4cc..ad42c451891d1 100644
--- a/arch/arm64/boot/dts/qcom/sm8550.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8550.dtsi
@@ -1653,8 +1653,8 @@
 			reg-names = "parf", "dbi", "elbi", "atu", "config";
 			#address-cells = <3>;
 			#size-cells = <2>;
-			ranges = <0x01000000 0x0 0x60200000 0 0x60200000 0x0 0x100000>,
-				 <0x02000000 0x0 0x60300000 0 0x60300000 0x0 0x3d00000>;
+			ranges = <0x01000000 0x0 0x00000000 0x0 0x60200000 0x0 0x100000>,
+				 <0x02000000 0x0 0x60300000 0x0 0x60300000 0x0 0x3d00000>;
 			bus-range = <0x00 0xff>;
 
 			dma-coherent;
@@ -1745,8 +1745,8 @@
 			reg-names = "parf", "dbi", "elbi", "atu", "config";
 			#address-cells = <3>;
 			#size-cells = <2>;
-			ranges = <0x01000000 0x0 0x40200000 0 0x40200000 0x0 0x100000>,
-				 <0x02000000 0x0 0x40300000 0 0x40300000 0x0 0x1fd00000>;
+			ranges = <0x01000000 0x0 0x00000000 0x0 0x40200000 0x0 0x100000>,
+				 <0x02000000 0x0 0x40300000 0x0 0x40300000 0x0 0x1fd00000>;
 			bus-range = <0x00 0xff>;
 
 			dma-coherent;
-- 
2.39.2



