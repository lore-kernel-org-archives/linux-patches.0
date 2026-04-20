Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5323F2D77E5;
	Mon, 20 Apr 2026 15:48:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776700119; cv=none; b=BIE6J1UXxRstX9gCXuuueeCso0n9yLBkqRdkRxXaQ4WBwKtcH4iJ+XBBqCFSSevOwTFL6TjQ+7zxrnhA8Df58hmAvcUfbPskpqqawDexeGvAFOPrzAEzTzSIO3C0GEvSIG5KjXYDW99+iN5o9DZKdA5ToCr53/cDa/gcYNycsY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776700119; c=relaxed/simple;
	bh=mzb714d35MQ2otQmJfjFsw7+07T5Ey6xG63wWizeHAg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VAsOwOtr4XtgJw7XWS+EUkOZWyi/RrcUKrkCGilGB0gPAEewMtESMOzSUn10Pr8iAz9ERE2/Re+rFL1bBgBhobOvP3iSQfD0mJdkqlEWP/8BoScsYSUZRC/uOtH3wW/x2MpwD0lFFe0C9GaCFnCWJpKGrnokRp/aCaSv7WReJls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I5FXC0vx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I5FXC0vx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD943C19425;
	Mon, 20 Apr 2026 15:48:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776700119;
	bh=mzb714d35MQ2otQmJfjFsw7+07T5Ey6xG63wWizeHAg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I5FXC0vxZZvdslOpQIdPApMXs9JTlb/AODWC2ZdswJ61zG/NWb/kMDTamC/yuLg9c
	 pjI2eyczeGGFqZGTcZqgmwNVC9DkRkVxakQ8eltOYU5LQ2ADnjYm6aNxrXSZJ5JawE
	 HEtfBmOHaZ8pna1g8b7Y1a8LMvKTAfKj/sPhCu+A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>,
	Peng Fan <peng.fan@nxp.com>,
	Fabio Estevam <festevam@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 050/220] arm64: dts: imx8mq: Set the correct gpu_ahb clock frequency
Date: Mon, 20 Apr 2026 17:39:51 +0200
Message-ID: <20260420153935.841845902@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153934.013228280@linuxfoundation.org>
References: <20260420153934.013228280@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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
index 607962f807beb..6a25e219832ce 100644
--- a/arch/arm64/boot/dts/freescale/imx8mq.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mq.dtsi
@@ -1632,7 +1632,7 @@ gpu: gpu@38000000 {
 			                         <&clk IMX8MQ_GPU_PLL_OUT>,
 			                         <&clk IMX8MQ_GPU_PLL>;
 			assigned-clock-rates = <800000000>, <800000000>,
-			                       <800000000>, <800000000>, <0>;
+			                       <800000000>, <400000000>, <0>;
 			power-domains = <&pgc_gpu>;
 		};
 
-- 
2.53.0



