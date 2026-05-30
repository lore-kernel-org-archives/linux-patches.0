Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2A6C2641C6;
	Sat, 30 May 2026 18:21:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780165287; cv=none; b=GjUnRmBaDZVIcvC6fGt4Up5Zd8l4prFnVseN1FQnM3Eajmhd1lcN2w6T49flYD49I1l7416yGRmo+Gunyb3PR0N+Jt/BO8TwaSKM406xdD7ljE5uw0o04hFInxDaXem5+zcs5c16sT5t1uNck4Pq3LKJ6PDKWTQvusyllWw/yw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780165287; c=relaxed/simple;
	bh=9FdTAwNprs6qjMD6qbHPcgRtsVu/seDXslU9JMEBUO4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GIXmCdzLMcyJ9YL+EBDJkNcDklN3JImlv+dhGLIlYrBr8n6YZ9rjmJQdK1ShIHR4hsbQEYy3S7qrDp256nq0x9nYeuwTpZ7YWgKN4BjpFbv0o7sNL00dCCnsDRy5na01vjc7rJ+RApPQAZ9nBvz1B1M7dEtMkErDr4wcwWsgBek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cq6gQlzH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cq6gQlzH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D92391F00893;
	Sat, 30 May 2026 18:21:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780165286;
	bh=MXeBigRS+2dlS1u9emjK3aDRUIkUXsKIR7lh4mDzzdA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cq6gQlzHxmCL/EsR9Ev7jPE6Fczgrka6uwHdsG5OPMlYytYRoGZKHviTqGm5X+708
	 tXJZdrOXeEv343CpvtmSsWjwU1TMpQsZuoqbDDDMtzBgCZpE/q6dP1iezXDQReRg72
	 +mxwv1EngXKVuXaMT7UnlKgo3yzlMk21Wb8X5vbE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>,
	Peng Fan <peng.fan@nxp.com>,
	Fabio Estevam <festevam@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 014/589] arm64: dts: imx8mq: Set the correct gpu_ahb clock frequency
Date: Sat, 30 May 2026 17:58:15 +0200
Message-ID: <20260530160224.954121247@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 8d0d41973ff54..995cbe6cf0a26 100644
--- a/arch/arm64/boot/dts/freescale/imx8mq.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mq.dtsi
@@ -1137,7 +1137,7 @@ gpu: gpu@38000000 {
 			                         <&clk IMX8MQ_GPU_PLL_OUT>,
 			                         <&clk IMX8MQ_GPU_PLL>;
 			assigned-clock-rates = <800000000>, <800000000>,
-			                       <800000000>, <800000000>, <0>;
+			                       <800000000>, <400000000>, <0>;
 			power-domains = <&pgc_gpu>;
 		};
 
-- 
2.53.0



