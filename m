Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A7D93AA182;
	Sat, 30 May 2026 17:37:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780162631; cv=none; b=tSHV155uyX9XxginoOuZNajj7AOKduuq6LdqHkrK6y1Ic4wfbVZfJ8BOfv6arZ7Uh4t2JMXak6yy4I+XncZyz4vqHzI/TT2+eMZHSzXS/wjooMy0bQKwJjCv+m21DOdG1o17X9898ICWwp91si2dBfWECiuY7yXqLoNUAaxlf0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780162631; c=relaxed/simple;
	bh=Cr/Ytsi5kDMnl0l79wH7seCcnbox1dP6sEjY2CHECSg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bFAj0XsDZOXv9v2V+/yYQXVRzGyXBwhwVhrqUrOj9cJtqalnh4jaXyIUo3l8ZViFcfrtQ+0eR9T2hEpv1wlMvOUYvZAvxNnBJvwcHUBrW4qEFg7TZBkvArkdvXENuWAv8dg6DssLvjvo7rqtzM5Q0iFnC/xWWupgs0MNiDeppFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hKoC3vm7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hKoC3vm7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E9B31F00893;
	Sat, 30 May 2026 17:37:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780162629;
	bh=Vgkd4CKvMeed8LhN+8EVVU7Oz9Ml6+UMKq1GTQdvAxY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hKoC3vm7aXHSxyc9TDNsgLoSZQmosqTfMN4sEPkOnCzIsMtVb0wKlW5j5r8ZQnRsn
	 OkzGVl34kbEfllHY1CMc73K723q1pJqWAPm/XcKnQw+aFKaXAQvKCfdAZ2So5yssry
	 f/HEbR7S4nn3Uv1Nf3WEavxr35oKxffb6+zgght8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>,
	Peng Fan <peng.fan@nxp.com>,
	Fabio Estevam <festevam@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 018/776] arm64: dts: imx8mq: Set the correct gpu_ahb clock frequency
Date: Sat, 30 May 2026 17:55:32 +0200
Message-ID: <20260530160240.735311284@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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
index e41e1c553bd37..12a33ac9e7543 100644
--- a/arch/arm64/boot/dts/freescale/imx8mq.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mq.dtsi
@@ -1362,7 +1362,7 @@ gpu: gpu@38000000 {
 			                         <&clk IMX8MQ_GPU_PLL_OUT>,
 			                         <&clk IMX8MQ_GPU_PLL>;
 			assigned-clock-rates = <800000000>, <800000000>,
-			                       <800000000>, <800000000>, <0>;
+			                       <800000000>, <400000000>, <0>;
 			power-domains = <&pgc_gpu>;
 		};
 
-- 
2.53.0



