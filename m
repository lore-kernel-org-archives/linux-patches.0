Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030728;
	b=V3ZiE83DT7ipwbVCJowINgqe1jQvpFOsmqJEqAZImlK7dkVHYlYVqQdgC0Mssz7st93H
	 iP/DPdiStCHOo++oCpVCXB3asoax7Zpjxt6nPmfjrLaRjXugE3eyyqpDBUlg86I++mRwQ
	 jmkIRJclRoprvBWJHAbKrmrYUQoUyxP5kSemSv7Vv/08vazhyavAaPaeocEUK5RA59pXl
	 PZXz6Wy2dbBsk/vnJsRsA5kU8OKI9P151k+uTSEjeAmRxvLtb4qT0L71etkr55OIeon7G
	 Tbta8sdNNucI67CQ1m3tkIB/4cX9MDZ27uGXnNHv3rDOtJC+JFKxNu8LU7XeA8IPIKw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030728;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hgADEpnhjWXd35TwK4IKc5Wa/c+L5my/ZHJWNu5W6a4=;
	b=eRnOCIyEQZlDFa5kpt03xUj/0VDXrebNGF6olEBdvIfSJEXTOuuJr3FQcHIVjrOu80sz
	 UumXdxBHcWBrQZs05Z7nMQ9DyZSSPbP9HwbVfckdvnsMYWGuRweOvghUPHM9lASlIhlzi
	 STPAWPeYp9mZ/UdsFox8OoR9mARdjnkpshsrfps5cJPIy0kdBX9FAP9LKjNcJPBjYvm9v
	 YcSwcAFBm1d0QAGBAyn4IzUC+Fo8OJNm5CjC1RHDhdMa5jw2KudpixOBDKdK2HdlJYegT
	 x61vter4OrM1crTi2NXdAyn+PrraEY1HrCv5G1zlSnLHWlMSyYtx9AgMlhJAzVJwNXQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zoW3pSD2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ED8D606A333;
	Wed, 18 Nov 2026 19:38:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zoW3pSD2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8721E1F000C4;
	Wed, 18 Nov 2026 19:38:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030728;
	bh=hgADEpnhjWXd35TwK4IKc5Wa/c+L5my/ZHJWNu5W6a4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zoW3pSD2PJeYDEreBfsSAUB+sBwkM4NMn7++ngLQhnAyjO6sbSGoKNs2c0tvthvN6
	 3WqfSNJF0WaNFF3PqTV541Xu5qbX/0uZ4VV4fJDYg44y2xAdUb+4M15fJDQjmHX3rq
	 t02TaoP/Zd4LZUR8yGpHRB3QG4lZs53gvUnRb5OI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linkai Gong <gonglinkai@kylinos.cn>,
	Peng Fan <peng.fan@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0807/1756] clk: imx: composite-93: return timeout from gate enable
Date: Wed, 18 Nov 2026 15:48:54 +0100
Message-ID: <20261118150041.771103819@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 6c6c5a30f3282..c2c4140c7f7e0 100644
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



