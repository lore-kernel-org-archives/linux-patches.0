Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F7AAFBE0;
	Mon, 11 Dec 2023 18:31:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pdO3FmVG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA14EC433C7;
	Mon, 11 Dec 2023 18:31:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702319479;
	bh=JaYVdzekSto4l4YC6yOr4llAmNtTabPm8VfgtI7BON0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pdO3FmVGALRtdfF0CBCEqq8dMVZ9i7bbFuOQ9jh7TryymZmkq9Jrt9m/uWm4qV8QK
	 gtk3EPzkrTdwc9UmULrvphQ9F7BdWeHscL5AGt3NtSDX1KZLlCKpVx5GdgFsA8e+pI
	 eXIraiOJFYqQ2aSrO7GkD4uLCWeYgJRan0/Qdsb8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacky Bai <ping.bai@nxp.com>,
	Peng Fan <peng.fan@nxp.com>,
	Liu Ying <victor.liu@nxp.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 121/244] arm64: dts: imx93: correct mediamix power
Date: Mon, 11 Dec 2023 19:20:14 +0100
Message-ID: <20231211182051.241259896@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182045.784881756@linuxfoundation.org>
References: <20231211182045.784881756@linuxfoundation.org>
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

From: Peng Fan <peng.fan@nxp.com>

[ Upstream commit d4cb68a5d3a1ed30ecaf1591eb901523faa13496 ]

"nic_media" clock should be enabled when power on/off mediamix, otherwise
power on/off will fail. Because "media_axi_root" clock is the parent of
"nic_media" clock, so replace "media_axi_clock" clock with "nic_media"
clock in mediamix node.

Link: https://github.com/nxp-imx/linux-imx/commit/ce18e6d0071ae9df5486af8613708ebe920484be
Fixes: f2d03ba997cb ("arm64: dts: imx93: reorder device nodes")
Fixes: e85d3458a804 ("arm64: dts: imx93: add src node")
Reviewed-by: Jacky Bai <ping.bai@nxp.com>
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Liu Ying <victor.liu@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx93.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/freescale/imx93.dtsi b/arch/arm64/boot/dts/freescale/imx93.dtsi
index dcf6e4846ac9d..943b7e6655634 100644
--- a/arch/arm64/boot/dts/freescale/imx93.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx93.dtsi
@@ -373,7 +373,7 @@
 					compatible = "fsl,imx93-src-slice";
 					reg = <0x44462400 0x400>, <0x44465800 0x400>;
 					#power-domain-cells = <0>;
-					clocks = <&clk IMX93_CLK_MEDIA_AXI>,
+					clocks = <&clk IMX93_CLK_NIC_MEDIA_GATE>,
 						 <&clk IMX93_CLK_MEDIA_APB>;
 				};
 			};
-- 
2.42.0



