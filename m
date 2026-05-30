Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF76D344D80;
	Sat, 30 May 2026 16:22:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780158142; cv=none; b=rwuLrSE8QGyMhN+Yqg9f0XbbNhUESsXAr/ZJl+6r5v7cttwc/1mQsfscKnee8hjc7aHxrFC1bs2TK7Up2krAKf34ehENhpOMSAvriEUfh6rlU+9U8oCwlg5MPytWaSnjh9oGkZlaIjcfnf8ufmgEsB86HM4e3JsPAd3BUsqYiKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780158142; c=relaxed/simple;
	bh=qWZ0VHnNPay+L0A2FC2wjitLxNIS5NEpjqDkqHcjG6o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NMGa/AUawPEqbpZ3//eX3DTAwPoOLroLOW4yDAgayILNyRaULxtD7/xjPdP10bZq0TtdxS+iKJs1RWnuSdzKbllF2j6ikMyj6lFFwX/MWV9NBvDV+ThNbnvKJvpdMXaL1C/S/YIREHsiJ5BcDkpPQY09vDU4Xevq0voYrSn+Nq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C7hJDs8I; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C7hJDs8I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8699E1F00893;
	Sat, 30 May 2026 16:22:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780158140;
	bh=rfG/L77EsyD79xF3ERrGcUgXUwGWZQ0asQlbZ5oPwZs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C7hJDs8Iq859V8AGj8Fc/iuRGK7PZqkzmpTMlKO8djb0O4TR0V3te+6AWCyHJoA/x
	 OK056ybV+36U/kObhdxDHhxXeXrxAZSEAFgzFRwwFXlySdaMf4Jof2xw0AGJgLRDGv
	 ZsT/5lpJv76RqDyvAEH9vrgjdn4rMyPpXiVY0yNU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>,
	Peng Fan <peng.fan@nxp.com>,
	Fabio Estevam <festevam@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 025/969] arm64: dts: imx8mq: Set the correct gpu_ahb clock frequency
Date: Sat, 30 May 2026 17:52:29 +0200
Message-ID: <20260530160301.142864562@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>

[ Upstream commit 1f99b5d93d99ca17d50b386a674d0ce1f20932d8 ]

According to i.MX 8M Quad Reference Manual, GPU_AHB_CLK_ROOT's maximum
frequency is 400MHz.

Fixes: 45d2c84eb3a2 ("arm64: dts: imx8mq: add GPU node")
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>
Reviewed-by: Peng Fan <peng.fan@nxp.com>
Reviewed-by: Fabio Estevam <festevam@gmail.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mq.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mq.dtsi b/arch/arm64/boot/dts/freescale/imx8mq.dtsi
index e642cb7d54d77..25b0017eb7363 100644
--- a/arch/arm64/boot/dts/freescale/imx8mq.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mq.dtsi
@@ -1411,7 +1411,7 @@ gpu: gpu@38000000 {
 			                         <&clk IMX8MQ_GPU_PLL_OUT>,
 			                         <&clk IMX8MQ_GPU_PLL>;
 			assigned-clock-rates = <800000000>, <800000000>,
-			                       <800000000>, <800000000>, <0>;
+			                       <800000000>, <400000000>, <0>;
 			power-domains = <&pgc_gpu>;
 		};
 
-- 
2.53.0



