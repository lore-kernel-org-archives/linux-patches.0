Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CC90605C7;
	Tue, 23 Jan 2024 00:47:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970825; cv=none; b=shUFqzfsqmoieI0PLg69QWAha4qV/SCvDeI4bIqKHMN4OtYIxNysKgKkWY2taqrwyiCnhCB8+nQZe8t6+1ROxOAXeb6CKokATCaNCsiYw3abbK8Q/Xkwh099OdOkijJOXKCGuqeFYECkn+n0jMAkX/71QdHk6d3ONSJW/2Bd7cc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970825; c=relaxed/simple;
	bh=zgKVYtrTvXtsR4PezK4ofzyElyN/2kN0TCq0g2PPUWM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bfXcruXcu+PyzFN8zDK0zgiS6ZDYdDR6G/wYoSi2537Q7pBO8CP55qh3RfsBvgU6/n1DqpU+qqMisOOwPneTDqUFtLpsLFLw3PfJ5XoY4rc0Fb7AI0N3lKRAV5E3I6o3uA1Avd0uQiDngykyyJzhgmDyRJBJwpYjZFBIm2lqqcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Izl3TutO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Izl3TutO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4D03C433C7;
	Tue, 23 Jan 2024 00:47:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970824;
	bh=zgKVYtrTvXtsR4PezK4ofzyElyN/2kN0TCq0g2PPUWM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Izl3TutOefe2dZkF17ruXFoPvdM87AI+JAKjfLPpGOM5DV8saJEPiJK9u6cqQRrnR
	 GiRQj8QuufY20CBgpI9rKfcPstI4CIVmsNKgrYdNaR7fL5tkB34/Yv3pxxe3C2fL4k
	 EabvgGiBJN8LQgi8ff3FA0RecV6EeCxfG3hxI3nM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adam Ford <aford173@gmail.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 115/417] arm64: dts: imx8mm: Reduce GPU to nominal speed
Date: Mon, 22 Jan 2024 15:54:43 -0800
Message-ID: <20240122235755.756664787@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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

From: Adam Ford <aford173@gmail.com>

[ Upstream commit 1f794d3eed5345413c2b0cf1bcccc92d77681220 ]

When the GPU nodes were added, the GPU_PLL_OUT was configured
for 1000MHz, but this requires the SoC to run in overdrive mode
which requires an elevated voltage operating point.

Since this may run some boards out of spec, the default clock
should be set to 800MHz for nominal operating mode. Boards
that run at the higher voltage can update their clocks
accordingly.

Fixes: 4523be8e46be ("arm64: dts: imx8mm: Add GPU nodes for 2D and 3D core")
Signed-off-by: Adam Ford <aford173@gmail.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mm.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mm.dtsi b/arch/arm64/boot/dts/freescale/imx8mm.dtsi
index d583db18f74c..7a410d73600b 100644
--- a/arch/arm64/boot/dts/freescale/imx8mm.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mm.dtsi
@@ -1303,7 +1303,7 @@ gpu_3d: gpu@38000000 {
 			assigned-clocks = <&clk IMX8MM_CLK_GPU3D_CORE>,
 					  <&clk IMX8MM_GPU_PLL_OUT>;
 			assigned-clock-parents = <&clk IMX8MM_GPU_PLL_OUT>;
-			assigned-clock-rates = <0>, <1000000000>;
+			assigned-clock-rates = <0>, <800000000>;
 			power-domains = <&pgc_gpu>;
 		};
 
@@ -1318,7 +1318,7 @@ gpu_2d: gpu@38008000 {
 			assigned-clocks = <&clk IMX8MM_CLK_GPU2D_CORE>,
 					  <&clk IMX8MM_GPU_PLL_OUT>;
 			assigned-clock-parents = <&clk IMX8MM_GPU_PLL_OUT>;
-			assigned-clock-rates = <0>, <1000000000>;
+			assigned-clock-rates = <0>, <800000000>;
 			power-domains = <&pgc_gpu>;
 		};
 
-- 
2.43.0



