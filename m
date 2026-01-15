Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6FFB4C81;
	Thu, 15 Jan 2026 17:38:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498703; cv=none; b=LfvEGbNWWK6tSe3ffF2iJXVlOKanCu0fiUmBsR0amM4osriSO4P9cBDQnPv6wAZ5Baq5lwia3/NqI07LDQRxy3vkzAM/e/7uLqCvFK40m/cWiOvYikyQnqchKCawNbN6lFlnv/CYDcs1kn4G1oTA/I3zeWAj/VXZnWjIx3qdEWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498703; c=relaxed/simple;
	bh=JHVU0FYmKGztC6lmbFOpkBMOu0Pi9TiLl+lobgQ8v1s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gSifiHV3CZsfZgMFFCIsBYwSREtsPYw0FvO9ANWHcs+je1v/Bxzsz5r/fVWk5c5jrelgJa874KS1ADdQOWhPidmKpK/hZctCn7RvNTP14hhZRUCv7uVt7H2coaDKDbiIAffuuUrUigv4s/LosoeNqTq0qaMIdEp4Y4iWhdRg6Zw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xmL5uFsN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xmL5uFsN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 536F9C116D0;
	Thu, 15 Jan 2026 17:38:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498703;
	bh=JHVU0FYmKGztC6lmbFOpkBMOu0Pi9TiLl+lobgQ8v1s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xmL5uFsN1AoMKGwCov1u2qiuM2dNFUnfW9+LWqjeb2dYNxxFRuTBOwhp+CFcx8XTI
	 RkarxoR8ccK+39JdxUQ9msnEn+MqBR5h8z7J3G1y+jxECT9uwc5aY9akEKRBiZQIbf
	 dAgT/axZEIppF+53UGIK4gUwy9e/zGoSGMI72Ceo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Haibo Chen <haibo.chen@nxp.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 523/554] arm64: dts: add off-on-delay-us for usdhc2 regulator
Date: Thu, 15 Jan 2026 17:49:49 +0100
Message-ID: <20260115164305.258250389@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haibo Chen <haibo.chen@nxp.com>

[ Upstream commit ca643894a37a25713029b36cfe7d1bae515cac08 ]

For SD card, according to the spec requirement, for sd card power reset
operation, it need sd card supply voltage to be lower than 0.5v and keep
over 1ms, otherwise, next time power back the sd card supply voltage to
3.3v, sd card can't support SD3.0 mode again.

To match such requirement on imx8qm-mek board, add 4.8ms delay between
sd power off and power on.

Fixes: 307fd14d4b14 ("arm64: dts: imx: add imx8qm mek support")
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Haibo Chen <haibo.chen@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8qm-mek.dts | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/freescale/imx8qm-mek.dts b/arch/arm64/boot/dts/freescale/imx8qm-mek.dts
index 470e4e4aa8c78..059f8c0ab93d9 100644
--- a/arch/arm64/boot/dts/freescale/imx8qm-mek.dts
+++ b/arch/arm64/boot/dts/freescale/imx8qm-mek.dts
@@ -34,6 +34,7 @@ reg_usdhc2_vmmc: usdhc2-vmmc {
 		regulator-max-microvolt = <3000000>;
 		gpio = <&lsio_gpio4 7 GPIO_ACTIVE_HIGH>;
 		enable-active-high;
+		off-on-delay-us = <4800>;
 	};
 };
 
-- 
2.51.0



