Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EBE32ED84B;
	Tue, 17 Jun 2025 16:31:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177881; cv=none; b=oOkkl4nWKZ3t+mqSV5l52sW2lsxrVc+phWqfAS+xMPYglWvs33vq0Riw4JWOA65FAtJ03W2rJGvTowzt2qDTD7SafC5N9oUNDPBGqDrCJ5VEQDpR82Z+HVeYvyXbM/3bTAAGg3K8JSfc1CyD5BqOnTsnyfMKbr2M5yaSB5STmW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177881; c=relaxed/simple;
	bh=WDsiezwwVM3rZj8n/8flt0+W5ThJASA3LBcoO/UL6Qo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lXZ2QxxljKuVfXEJd0IvT1aI/vqAzQ+js1lqBqKr+9b+ZIKh+zCBSsjHjqaI4o0r5R9YNNBbhjPtSin1uTg9pIhv7VufGkFrmZnWn0uBn+vpaQqkd22PO6tyh4we1HteUPoWYZ7VgdliuIMRtGJP2CXtVJM1o2dGei4O1+fPimg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nV1OpM5O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nV1OpM5O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9120C4CEE3;
	Tue, 17 Jun 2025 16:31:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177881;
	bh=WDsiezwwVM3rZj8n/8flt0+W5ThJASA3LBcoO/UL6Qo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nV1OpM5Oo/nswoRLsyqlrDBKhW+VL6FHNBDkS+Dx/0ShXxJ8drMYLPGs3v46Pc6V8
	 6509zRM1av8p8Ss5bcLmpCXChs4HciecC+m+4Oj8/JqLiQncRrXbCIvQn9uzP1Uz/D
	 aCgNSedEhSo7VjLdSAE2ZNXTjUcjRoX0Mrcnatzk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adam Ford <aford173@gmail.com>,
	Frank Li <Frank.Li@nxp.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 376/780] arm64: dts: imx8mn-beacon: Set SAI5 MCLK direction to output for HDMI audio
Date: Tue, 17 Jun 2025 17:21:24 +0200
Message-ID: <20250617152506.770476674@linuxfoundation.org>
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
index 1df5ceb113879..37fc5ed98d7f6 100644
--- a/arch/arm64/boot/dts/freescale/imx8mn-beacon-kit.dts
+++ b/arch/arm64/boot/dts/freescale/imx8mn-beacon-kit.dts
@@ -124,6 +124,7 @@
 	assigned-clock-parents = <&clk IMX8MN_AUDIO_PLL1_OUT>;
 	assigned-clock-rates = <24576000>;
 	#sound-dai-cells = <0>;
+	fsl,sai-mclk-direction-output;
 	status = "okay";
 };
 
-- 
2.39.5



