Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0DDD256C84;
	Tue, 21 Jul 2026 15:55:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649311; cv=none; b=bjAl221UIa5FCCNTQc98jhKj6XInUqfdYe7KNmgzvaAsykHkBGZSRrl9iEli5TuECNn3vEJxgNIB8Jruu7i2S1DabPjRQQEODn40dCko4p/qnYAoYF+bavBJAC9p5WLxhJIplNe1lMbPMfYpN9KPzZhB+sATO3wl2OyyWFEpRlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649311; c=relaxed/simple;
	bh=LqyoVxNJKG3GrPPJyWxlpMzBR4vKzaEoT3+TgjWgHOM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ak4BBl5icB3LWCQU4cHMJodhvYkqctitR2l6KiUh0ht2nOELoZQICWS9zoYf1vxBVtI1LZboWySUJ+bMnjp6XPXoNImLMqNc88FfHZun/+yZRP4iapP/NNiWs3NKrxEJ1wXqEyVC+RmFGCwhP/ptkLQVwUpEAszrVygpoRGmayg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wt2L3Jbs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wt2L3Jbs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11FCD1F000E9;
	Tue, 21 Jul 2026 15:55:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649310;
	bh=5WMLFxL5YOeu70FqTVM6qeBZVHmv3M6mDst+u4Eirms=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Wt2L3JbsEyfds+5akf/KGlkmSWDnHjlrTCB8OPKHGUhGU3YBrNDsUSwGiyrxAaIBt
	 FRhq1Xkrzfv20CAKYKF7VBFQ8tKllJRz+XAUdb7j2TjvTPzvG32KxGrCYuUFq4lxm6
	 PeJwJYrFcvQ+st4llJBX3/xnnksSRfhABFBZRRbc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alice Guo <alice.guo@nxp.com>,
	Xu Yang <xu.yang_2@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0503/2077] arm64: dts: imx94: fix DDR PMU interrupt number
Date: Tue, 21 Jul 2026 17:02:56 +0200
Message-ID: <20260721152604.679190805@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alice Guo <alice.guo@nxp.com>

[ Upstream commit 2521addd5df7e8ab805622d4a0eff9735a45fa11 ]

The DDR Performance Monitor node was added with incorrect interrupt
number 91, which actually belongs to the wdog4 watchdog. Fix it to the
correct interrupt number 374.

Fixes: e918e5f847b3 ("arm64: dts: imx94: add DDR Perf Monitor node")
Signed-off-by: Alice Guo <alice.guo@nxp.com>
Reviewed-by: Xu Yang <xu.yang_2@nxp.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx94.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/freescale/imx94.dtsi b/arch/arm64/boot/dts/freescale/imx94.dtsi
index c460ece6070f83..379429b3072aca 100644
--- a/arch/arm64/boot/dts/freescale/imx94.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx94.dtsi
@@ -1481,7 +1481,7 @@ netc_emdio: mdio@18,0 {
 		ddr-pmu@4e090dc0 {
 			compatible = "fsl,imx94-ddr-pmu", "fsl,imx93-ddr-pmu";
 			reg = <0x0 0x4e090dc0 0x0 0x200>;
-			interrupts = <GIC_SPI 91 IRQ_TYPE_LEVEL_HIGH>;
+			interrupts = <GIC_SPI 374 IRQ_TYPE_LEVEL_HIGH>;
 		};
 	};
 };
-- 
2.53.0



