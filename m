Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040805;
	b=R6PpWsDj5Xy/dhnrptFgI41bef9fkcCEsHXInO8ibxI07Rk0j/rvboZd3CHsRuiQXfQK
	 Tka4PHiSrQ/l+sROGnmloHYSZ7YWxYXjgBXhjoLqrCINH9brIbVyI31XfccLtOBJIB8FW
	 Uru1iXm1wJEnIh36XgGYP+sl5CNsqilHCqDnCxeIOItJTZJnmLsoCTodNG4T08JnPYbtg
	 UWQ0bmpdmOeklqAmME5asZFs4JIvpfxHzgYgkORQMV77+FGTbM/bSy5v2LHRkleDHByuZ
	 vcWE0FRPVHWoF81MRY2ww+dL56Zq+F/EyLF/GHjl8rBrt8G/C7PwaT4ssrnec0+JhCg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040805;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zuXA5jnPy4TXWzhDiMm+jJOukQfzVxXjatV8YhFj+LQ=;
	b=sSSfw2T+TLX5Yvgovdg181UmLoBvnf0iuefIVNKoxp9EX1otk2W3CJQOAlPc3pv+q3YI
	 q2CEdZILossXut654cCcfIUqwB5sAMYBjfao21nB54ycO/jhFRMB554iWDDJXIfAvmL5g
	 Z6LPpnd7TVaxM8hvUWvr5C4s9jMEX5eoQ4lUhghPtva23m9NBAN8njNmbDttjTmsUu+PN
	 V1+fF+rgRqrI+YarCUbZKt7Tesu/6rrqvaMZpxLDuYFszf5j+PYfuqUI10QZaJ8i75/Lt
	 JEgHb9/t3zoL7s5un2WG9o0wRqxTZ3AE9xDZ3rGLa5OiHbMG41d2Mvvmcl24wXRSOyg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UicvjNjh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5984606A31C;
	Wed, 18 Nov 2026 22:26:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UicvjNjh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F7751F000C4;
	Wed, 18 Nov 2026 22:26:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040805;
	bh=zuXA5jnPy4TXWzhDiMm+jJOukQfzVxXjatV8YhFj+LQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UicvjNjh3WLJqTgrXxbBciBRGWRtYCc312p+s274Om8eVafdHBAXRF1K21VpcWSAW
	 f6V0b7gI8wCujKE9JZmhzRJ/InocOtiCJuflq/7dUyXnbb/7hadjfpYLmXavuFB5rY
	 xw31dmWWIcMz+3K7pkj3oHoWo9YltD/NnTjug9ss=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linkai Gong <gonglinkai@kylinos.cn>,
	Peng Fan <peng.fan@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2537/3318] clk: imx: composite-93: return timeout from gate enable
Date: Wed, 18 Nov 2026 15:52:39 +0100
Message-ID: <20261118150437.427949221@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



