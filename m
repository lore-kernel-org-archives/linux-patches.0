Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049014;
	b=l8ltzPseiKVJwMI+YZs3EZ80rUu+R0y9ytpbr/bLudx0LYIdFF5SYfppDAvsem6BdCPw
	 FQT1qYcDQsTqhmH2+HCUYfoSbSgCoLB8oqsoBQaCr/e4YtzyFZe1Ggg61PTnvE/brB3B0
	 6KOB9CFmTjqfWfHhzYvQBknxv2jgbEkhwBr91GZ2gbJ3n6tIFIKcijYRCN9/ad57ggcPK
	 np6Xja3FR3zpAZIZ4F4H421c0/GPgveJhE3a+xajxUAd9MEoV8WExFaTKfYGCB73jtqeb
	 SQKJOKdo/KODbyU9uZWKbRHj27j+Vk1UAKqb8qt0O2Hj1jZ6cv6SWJUR6oTbtR89PaQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049014;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PBrJ2GEV3GQ1O8S0d8MumvQnAfAx0fsbTEs0U8pky8A=;
	b=jcEJGUo0VwRCUComUCRcl1wTQWUvaNP6CaPQrcbzWXZogoRdZkeRyab0lUJfTo1lmEx+
	 MMhE3hrpcXHQZ7bWhvAiUC5gm/DYcf3hz8GHVc4dO4H31SR1y0KcaZj36ub/RMvEOuSt2
	 +1o4NvDzEdUfT+TQO/NdBT9ILPopdHOoysMxRsDMjJin4qWrdz1FJ9RvVZqnI+pQklJRJ
	 zhETy0CLr9dLjqW+rFQfgMpkFmHICcIsHM6gW/CjLfspY430u4XkDE9FwPTS+salBVXFE
	 6j7XnhiDgwQTDbIgrr7AzJDBwUdxl6nLZgxF2fU3M2HIuvfniTHudFIt4pHKounFgKQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HPFcpSBN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00EEE606A330;
	Thu, 19 Nov 2026 00:43:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HPFcpSBN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 546461F000C5;
	Thu, 19 Nov 2026 00:43:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049013;
	bh=PBrJ2GEV3GQ1O8S0d8MumvQnAfAx0fsbTEs0U8pky8A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HPFcpSBNZxfZ9ZjllNFspVpheETanutj3ePUn1OT/eEQBYeMgkBVRz6Osd5MQ/E0I
	 uaJ/JHf8dmm7ynV7nnUBl0Z6WxRWrjfryGGAtSSwQjckBRQqfM6h+tU3v7+X8yrlkX
	 y7ytZoyEfSaXUOtMct4NbJAnwoNb7D2vODM5v7Gw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linkai Gong <gonglinkai@kylinos.cn>,
	Peng Fan <peng.fan@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2201/2857] clk: imx: composite-93: return timeout from gate enable
Date: Wed, 18 Nov 2026 15:53:55 +0100
Message-ID: <20261118150320.679767299@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linkai Gong <gonglinkai@kylinos.cn>

[ Upstream commit 246d9fa6b83d2d3c524aad28de1ab5db5cecf048 ]

imx93_clk_composite_wait_ready() already reports a busy timeout, but
imx93_clk_composite_gate_enable() ignores that and always returns 0.
The clk framework then marks the clock enabled and lets consumers run
while the CCM slice is still busy.

Propagate the timeout so enable fails instead of looking successful.

Fixes: 4a3de5aa7743 ("clk: imx: clk-composite-93: check slice busy")
Signed-off-by: Linkai Gong <gonglinkai@kylinos.cn>
Reviewed-by: Peng Fan <peng.fan@nxp.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260907022214.1076402-1-gonglinkai@kylinos.cn
Signed-off-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/imx/clk-composite-93.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/clk/imx/clk-composite-93.c b/drivers/clk/imx/clk-composite-93.c
index 74a66b0203e4b..095f5242d5d22 100644
--- a/drivers/clk/imx/clk-composite-93.c
+++ b/drivers/clk/imx/clk-composite-93.c
@@ -43,11 +43,12 @@ static int imx93_clk_composite_wait_ready(struct clk_hw *hw, void __iomem *reg)
 	return ret;
 }
 
-static void imx93_clk_composite_gate_endisable(struct clk_hw *hw, int enable)
+static int imx93_clk_composite_gate_endisable(struct clk_hw *hw, int enable)
 {
 	struct clk_gate *gate = to_clk_gate(hw);
 	unsigned long flags;
 	u32 reg;
+	int ret;
 
 	if (gate->lock)
 		spin_lock_irqsave(gate->lock, flags);
@@ -61,17 +62,17 @@ static void imx93_clk_composite_gate_endisable(struct clk_hw *hw, int enable)
 
 	writel(reg, gate->reg);
 
-	imx93_clk_composite_wait_ready(hw, gate->reg);
+	ret = imx93_clk_composite_wait_ready(hw, gate->reg);
 
 	if (gate->lock)
 		spin_unlock_irqrestore(gate->lock, flags);
+
+	return ret;
 }
 
 static int imx93_clk_composite_gate_enable(struct clk_hw *hw)
 {
-	imx93_clk_composite_gate_endisable(hw, 1);
-
-	return 0;
+	return imx93_clk_composite_gate_endisable(hw, 1);
 }
 
 static void imx93_clk_composite_gate_disable(struct clk_hw *hw)
-- 
2.53.0



