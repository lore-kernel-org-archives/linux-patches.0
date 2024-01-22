Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F7D913398C;
	Tue, 23 Jan 2024 00:22:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969325; cv=none; b=Lc+KIqJJ23UGVNmbwtVH/FCb2iAINESpLlZhw68OXjItl2lVs3zjDuqK0KuGD4M8AnRwhwHhtBi60D0R3JOZISZmbkocIGNz0xbJGNGKmCax09PZ1FwOAn+FLBcLdu7hf8tYHnSczeJUxSaz+o7BuGe2BFcjdhSSREw98zQ1kVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969325; c=relaxed/simple;
	bh=RvB0GYgQgFGeOeHMOc67KM7ijicOp+rv1xT+j1N8pk4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iHA1r689w4mFfeAqyS6uMNkbxPHWs/jTIt/KCv4wigE3GaM0fuQD4PVIo5X/V2CKToy/RP/N2xSLImrI2Qx4IKwVnRDh0MbhQd1ylxNtvij4sZ34lX8ulyEErQj+kStBaa/JzgFwsRt5IvTe6oKW/nqT06QAQ9b4EsLjM5GputQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZA60EO4h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZA60EO4h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2933DC433F1;
	Tue, 23 Jan 2024 00:22:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969325;
	bh=RvB0GYgQgFGeOeHMOc67KM7ijicOp+rv1xT+j1N8pk4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZA60EO4hxG69SyMbLF6w9e9anUgbg/JYpqTba7ketEq6qBlIzxHqibV5UACtrdSKI
	 zIs92jFktp+Vi6kGLeGiQyynLnbivN5UyNu2h5Vk0Kfe6KnnCN6nWlVGnhkNPqMKoq
	 dzeWlft6idz1Irgj8vDKyPkXs2ru6WNwqqXHCFK0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adam Ford <aford173@gmail.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 174/641] arm64: dts: imx8mm: Reduce GPU to nominal speed
Date: Mon, 22 Jan 2024 15:51:18 -0800
Message-ID: <20240122235823.453719473@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index 738024baaa57..54faf83cb436 100644
--- a/arch/arm64/boot/dts/freescale/imx8mm.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mm.dtsi
@@ -1408,7 +1408,7 @@ gpu_3d: gpu@38000000 {
 			assigned-clocks = <&clk IMX8MM_CLK_GPU3D_CORE>,
 					  <&clk IMX8MM_GPU_PLL_OUT>;
 			assigned-clock-parents = <&clk IMX8MM_GPU_PLL_OUT>;
-			assigned-clock-rates = <0>, <1000000000>;
+			assigned-clock-rates = <0>, <800000000>;
 			power-domains = <&pgc_gpu>;
 		};
 
@@ -1423,7 +1423,7 @@ gpu_2d: gpu@38008000 {
 			assigned-clocks = <&clk IMX8MM_CLK_GPU2D_CORE>,
 					  <&clk IMX8MM_GPU_PLL_OUT>;
 			assigned-clock-parents = <&clk IMX8MM_GPU_PLL_OUT>;
-			assigned-clock-rates = <0>, <1000000000>;
+			assigned-clock-rates = <0>, <800000000>;
 			power-domains = <&pgc_gpu>;
 		};
 
-- 
2.43.0



