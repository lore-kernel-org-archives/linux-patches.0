Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F259612D1;
	Tue, 23 Jan 2024 01:55:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974937; cv=none; b=dJx+r9BIhKhlaZWKbfY16edgB3FjcCNmrxPVhkZB0Ppe16dNzCHom/XnV194gdLDHeNol2aTZK8kibtNCDMkQCukjpcA2p21vA/QuSq/5EOKot7aJr7cDCBQE4DHg4fnBjE9gAgKYqDcNMVYBFQ2GtjZM24rYeqsR/OvNHnBM1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974937; c=relaxed/simple;
	bh=7NvYO46M9iIyoSA4MoM9RPX7gpfOUK3qJ7mI5siC9nc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gOSDs+3LWROy09ZeHGUj7uoMloxeWKSxTP8Fft0HeLPh8vJxPOoTegLiVX+y2NSak1ptzoQrllVnRDbmXe01dAZXX2JprnVEX+cWQy2Y55cQXCobkLxjlh2QZ3UHdRA/Skb6w7q9+wTIu1g4zF/pTPmg8BTNriFMcwfJQGahAJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tWWZNwu4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tWWZNwu4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CD62C433C7;
	Tue, 23 Jan 2024 01:55:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974937;
	bh=7NvYO46M9iIyoSA4MoM9RPX7gpfOUK3qJ7mI5siC9nc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tWWZNwu4go3KfJrFI5SvmWb9rWyG7uBHJartwLwfJWN38bw6StQ3j64ZGBdOmDuvN
	 cM9dtx9QVdcmtg+k3Ral6yjEGm/OQeiwqqQPystVTdMbE7Fkpjaaq8VnZiTseo/9Wi
	 qLPd1EdRTtgZs/qo+7iVzrEV/C6I9+1m0fWXTGfs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adam Ford <aford173@gmail.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 157/583] arm64: dts: imx8mm: Reduce GPU to nominal speed
Date: Mon, 22 Jan 2024 15:53:28 -0800
Message-ID: <20240122235816.853793691@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



