Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018441;
	b=Dy1NQFjU9ea+Oo6dJ9Jk8EII7+Ek4gYKrZ1HDzWsYsJhzVC4fc/pUG51FTe0CgguOuY+
	 UQCrDX1V0evKCN+1+VAQI5ex5y6g/jDaa5AyBX1HVdFdkAHtYB3b4QH6xXYdXdDp7o1Jx
	 Kf+3WQ/diuHVIJ9bNl0ue6dkoBvBs2JoCmaz20nNVkqVVPzJzMYt1LT3bCMs2BVJHWqZP
	 AFzeRKug5C16xEXwFIK6NkkeHVorHjkddbiK1HqBqtLDNuu/UpmTRkUos33Z2zyhMPXqm
	 /ojPCgWPGa/eEPibdiplz4K3I4SRSaaoKFb5TrSiJI0SNVNWbiI+or5/VDmhg8ctoMg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018441;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VTt+ZbUtjGRwcMfkz2sQsOo0Fj0t9EzZoHRqv2C7hm4=;
	b=hqnlZt4OfiGPCP1aX92+LGHpFBYVk3XtEFSVXsVypR80/Q+HCBsl6KQZez5ZxytCOo0J
	 KCUlihW6gdE6b4QeSjwB4adTmUNKMT1fwPCaeKTcWzFzsPYVLv1z6mXbIaN+x5MPcvvap
	 toVFvv5XjRK+unqBYkM93HbtqGbmDA2vZgQIB2I3cUyNmDqMVnBtpvpdW+6U+C6tGEDaU
	 JauEKMdkcXknHeQj7Xj/3ZuOXQZYPv/MVppsDs0cRkJ/1OJaf/g/qIkomeMtThGOmBcIf
	 74x4FQToQkt4U6xMho6ByLfKVIKvjJeJocDvODebCmBu1gEoWpdo3YYrjWjgTaOR4YA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=C23j8R1a;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB1A1606A325;
	Wed, 18 Nov 2026 16:14:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=C23j8R1a
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DA851F000C5;
	Wed, 18 Nov 2026 16:13:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018440;
	bh=VTt+ZbUtjGRwcMfkz2sQsOo0Fj0t9EzZoHRqv2C7hm4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C23j8R1a7nD2iiomzTKYwZCIc596DmWHYZprjsm/aKjv1fjQYFeWbJtuVWm3BpSbZ
	 l79dRYWdtnHIOInmI0c02uEk9bPactjs/MdoJnPxBndZ3t4q0jf33hRpxDTzKz0Bsi
	 sK/+KGUfDLS+dcGzn5Xo/sJmZIDVp4D3nLpu1sak=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linkai Gong <gonglinkai@kylinos.cn>,
	Peng Fan <peng.fan@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1241/2651] clk: imx: composite-93: return timeout from gate enable
Date: Wed, 18 Nov 2026 15:41:21 +0100
Message-ID: <20261118150332.677176693@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index ef20ceb2d2550..953f67d13978c 100644
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



