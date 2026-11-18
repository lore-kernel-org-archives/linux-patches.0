Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025292;
	b=Il+oDfrg2rGH/H+n/logoZ3HZ09Ux4QZDd/6BgYogkCs+kYoqj1qLeCSnHFjFkhD240t
	 Rai92OfBNGuO7xb/E9kRVlPAQnvW2KX4XUTtzt96au/ej7/JoaRj7QE6mi0L9XLAXXTsL
	 OmtGjGSAv4cg9ErWoOszn1cVn+YQgKugR1DiUdfmbM8/VK1+zoB1SP7UdZDucXkaCBDU4
	 CdwZPE9OY8WC6JOJ7iGLTay7w/oJhaJtY+qljZ7oca1zhsyIVODWeZaFwLXBsj/C4bqPQ
	 e+QPzA7m8fvyvAeDtfXDYEDnoQIMAQf3VEZOzpBve2/Y87mOEjry2ULfQFBHaj/jQrA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025292;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kopvyYy8hISqS7ccHIE2/PvtUyTaZgmG/+tgJEMYm5o=;
	b=Z9vsWKrQ3cRDvAqNBdvSIKSjE3lXsvGBQXX0qVsnO5TqoTNIJX3YDBsNetT5Qv1jaZVl
	 uyhcuKaFptYlYkqWWJgN48XWUU4RTOWVD3GBBg+xDr5bBcUhT0gwe/55uECye7E0WZa1p
	 fzg2KUsGva6lFSNqrG/AoikEJwZ2RrxyCaqiSBMsbW351RA3Kj1xuu2MM2FmH05x8gp6z
	 iZ9e1bBmSF6xAzMRdRebhyerNcbh9Ju52XBYJX7S7s+eha2kVLnCmoBafce0H1+B7EuRl
	 mksze4pw5pIa4OTJVIWCS2OZwZmbncGScPKc4D24JwBj/tsScRL0Ua5rTla2ZWFRLYQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xuZ+VGjo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC8DA60A262F;
	Wed, 18 Nov 2026 18:08:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xuZ+VGjo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A47F1F000D2;
	Wed, 18 Nov 2026 18:08:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025292;
	bh=kopvyYy8hISqS7ccHIE2/PvtUyTaZgmG/+tgJEMYm5o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xuZ+VGjoZtbMjdFNILAYazggV6SHXzaRdqAVoatpqZAGIc4AuuY5zoHIb/f3mouqn
	 YkVSECEXe+Saz2D+JYeVSGo3Z0BIcu+pSIMlM7Z332oQJMOawAZt22er/ImyWTCONc
	 gt4LiSVrbvd/YL3s0HN5i0EucRkc3hF5SpAOvvOE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linkai Gong <gonglinkai@kylinos.cn>,
	Peng Fan <peng.fan@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1029/2151] clk: imx: composite-93: return timeout from gate enable
Date: Wed, 18 Nov 2026 15:46:04 +0100
Message-ID: <20261118150159.862201535@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 513d74a39d3bd..7c89df9327199 100644
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



