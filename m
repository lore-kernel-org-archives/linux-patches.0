Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13E4C2EE607;
	Tue, 17 Jun 2025 15:49:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175391; cv=none; b=bke2LJbyq7kTKf715Fw57X5kdppBHrDLtveO5CkzfnjMVMenmjsFXlKw6VEgDebugx1oxpur4KxPuyH2StFQha3LzLHQ806noFDL6+z+4F+EugK4G5ufBIHf1Bz/px4uHkCnQAAV0yu9rnWG6y1dlFMutuqG2C3I49XD1SwlBMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175391; c=relaxed/simple;
	bh=px2WRvIKfWLHsq1P58JFU6KBcXQXjtzVp9vorub/pMA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IfM8w8saTr9L+35wKFW0XBrpvbMX9pV3KUtw8ZgFVLmxwhpo1PPxoKVEboBw2KGTqSl1xam2hT8Hq4XHv/ZV0moYNJ93EqFZ6PVwMReSl5eug2QKDddjL99FrWIVBYzVwe96TYAf9y6BL6u4FXsZnWWIgBKHukKDhjd1Qb/1+r8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0qK8DBk5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0qK8DBk5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F4F6C4CEE3;
	Tue, 17 Jun 2025 15:49:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175390;
	bh=px2WRvIKfWLHsq1P58JFU6KBcXQXjtzVp9vorub/pMA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0qK8DBk5HQ+wbSbnETyyU92fgSZzS1098eoHXmB1PJLgVQF+Lg5r7FlRq6fvYSp1C
	 8bLgNdYFV/cL9mzoK9Gxg71URkz2krdX1cS0d42XFP8r+AKq9MbZzTKZEjAzW1p82V
	 dPFjvNlXeP22XO7gVxf/afvt9RKo9vRuzwf2q71E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adam Ford <aford173@gmail.com>,
	Frank Li <Frank.Li@nxp.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 172/356] arm64: dts: imx8mn-beacon: Set SAI5 MCLK direction to output for HDMI audio
Date: Tue, 17 Jun 2025 17:24:47 +0200
Message-ID: <20250617152345.137449251@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
User-Agent: quilt/0.68
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

[ Upstream commit a747c4dd2a60c4d0179b372032a4b98548135096 ]

The HDMI bridge chip fails to generate an audio source due to the SAI5
master clock (MCLK) direction not being set to output. This prevents proper
clocking of the HDMI audio interface.

Add the `fsl,sai-mclk-direction-output` property to the SAI5 node to ensure
the MCLK is driven by the SoC, resolving the HDMI sound issue.

Fixes: 1d6880ceef43 ("arm64: dts: imx8mn-beacon: Add HDMI video with sound")
Signed-off-by: Adam Ford <aford173@gmail.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mn-beacon-kit.dts | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/freescale/imx8mn-beacon-kit.dts b/arch/arm64/boot/dts/freescale/imx8mn-beacon-kit.dts
index 35b8d2060cd99..dfa08be33a4f2 100644
--- a/arch/arm64/boot/dts/freescale/imx8mn-beacon-kit.dts
+++ b/arch/arm64/boot/dts/freescale/imx8mn-beacon-kit.dts
@@ -126,6 +126,7 @@
 	assigned-clock-parents = <&clk IMX8MN_AUDIO_PLL1_OUT>;
 	assigned-clock-rates = <24576000>;
 	#sound-dai-cells = <0>;
+	fsl,sai-mclk-direction-output;
 	status = "okay";
 };
 
-- 
2.39.5



