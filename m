Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACFD82ED84B;
	Tue, 17 Jun 2025 16:31:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177874; cv=none; b=g9VnRSP1UDq/UsQkAjTBSeCRfIo09yp3ZI46aJGAONpqia9zqMyFPx6pAiRpW3nWYiT/YsfI4iAr5xQzoivzyZobRAAm7NVgfbZbtDrkv4tKIv0OtD9ENhsfZcP+RCn37t7tu8mI8KKvED3s5TtWfYVfrpER8DJTzBhBhMO8cJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177874; c=relaxed/simple;
	bh=fc4ENxM+0hsTC/3QgqpMGl6yi7VLWnMy/5IGbxhy6u4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KcTXia3PhOWV0RKV5bDMPHPezrMoCAcIr9UiDuoXBWaLce2BjDjL3NJH/7TLdCKYyi+4ClFLDHnkqO/+338dXBg9vRvEoWfReJrWRajeBtcuDdPdiJUvRjPHKJXqiUs12xk3QnTZWXSm+eUPE8UgsN/dCxbCGdrlPsBiklNdei8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2T+Wsc8J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2T+Wsc8J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA5D2C4CEE3;
	Tue, 17 Jun 2025 16:31:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177874;
	bh=fc4ENxM+0hsTC/3QgqpMGl6yi7VLWnMy/5IGbxhy6u4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2T+Wsc8JDthoNdYLw+oAbJ5pEjYeMCuEhAC5AruI7Tp+jllRj1EHVRsJporcBxudO
	 ypPAQjB8qgB8t40ABfXOgXLgziZvzic6Ttub1StKWcYoCE2gwBArSDCSii3qHLVehZ
	 mEFwh4z8hYVV+M2ixWFvdx30fHMrZU2iFJ9DxFTQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adam Ford <aford173@gmail.com>,
	Frank Li <Frank.Li@nxp.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 375/780] arm64: dts: imx8mm-beacon: Set SAI5 MCLK direction to output for HDMI audio
Date: Tue, 17 Jun 2025 17:21:23 +0200
Message-ID: <20250617152506.729480191@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adam Ford <aford173@gmail.com>

[ Upstream commit 8c716f80dfe8cd6ed9a2696847cea1affeeff6ff ]

The HDMI bridge chip fails to generate an audio source due to the SAI5
master clock (MCLK) direction not being set to output. This prevents proper
clocking of the HDMI audio interface.

Add the `fsl,sai-mclk-direction-output` property to the SAI5 node to ensure
the MCLK is driven by the SoC, resolving the HDMI sound issue.

Fixes: 8ad7d14d99f3 ("arm64: dts: imx8mm-beacon: Add HDMI video with sound")
Signed-off-by: Adam Ford <aford173@gmail.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mm-beacon-kit.dts | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/freescale/imx8mm-beacon-kit.dts b/arch/arm64/boot/dts/freescale/imx8mm-beacon-kit.dts
index 97ff1ddd63188..734a75198f06e 100644
--- a/arch/arm64/boot/dts/freescale/imx8mm-beacon-kit.dts
+++ b/arch/arm64/boot/dts/freescale/imx8mm-beacon-kit.dts
@@ -124,6 +124,7 @@
 	assigned-clock-parents = <&clk IMX8MM_AUDIO_PLL1_OUT>;
 	assigned-clock-rates = <24576000>;
 	#sound-dai-cells = <0>;
+	fsl,sai-mclk-direction-output;
 	status = "okay";
 };
 
-- 
2.39.5



