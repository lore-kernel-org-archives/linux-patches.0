Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A70733232;
	Wed,  2 Oct 2024 14:39:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879980; cv=none; b=SDOtr0VyU/Twm5gan34esL6f9mDgUcN6vpCFtaGB4sSdwhRYWkTJtzvuz1k7jYZBEoifvG8/qcFBm5rKBawMuss3Cf0z9fKWPNoYrkWdJ7hmWGoJNggi2NRYYfC9pTy8E4VZbYYiFEy0WE4O2OyNS3Wjmk2hdAzKOjm7RI6JVx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879980; c=relaxed/simple;
	bh=Z7VrEzVX+TSWj+/E4DzE6/rJsC39Ra0+PZKZrONeZzc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QTVNdD3KxE323u7F1/QXym+eSE2OKeTZAm+sVClwMBxspvCJtgxo2vbmbysVw8Q36Cn/xNtAaBxK955tJp8RLvMKxRKrp7gBB9tmeIHnFq3wMuMuWHDVzZkPaSWQLYnn4GxXXqtQ4Y7BngFPtTLHUnUR2rAe+0Gai8MDHQwUmhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uIjDCUii; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uIjDCUii"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30B4FC4CEC2;
	Wed,  2 Oct 2024 14:39:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879980;
	bh=Z7VrEzVX+TSWj+/E4DzE6/rJsC39Ra0+PZKZrONeZzc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uIjDCUiirVfkI3BQjiHQTcSygD/Z1m/4jVA/UJ3BTLbEXvDRE6lhs0DjEs8EIkW/V
	 KKnQrvnWDDg7mwzXw/p+juZ//W4BftjG+eMByALWZIPXKbRq3OOlOe9XnajT9w3WmC
	 nfGQ2Kxmmhcz4KbN4Z+xhsyoc8NuH4fLtZybLKlo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Ye Li <ye.li@nxp.com>,
	Abel Vesa <abel.vesa@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 262/538] clk: imx: composite-7ulp: Check the PCC present bit
Date: Wed,  2 Oct 2024 14:58:21 +0200
Message-ID: <20241002125802.600108154@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ye Li <ye.li@nxp.com>

[ Upstream commit 4717ccadb51e2630790dddd222830702de17f090 ]

When some module is disabled by fuse, its PCC PR bit is default 0 and
PCC is not operational. Any write to this PCC will cause SError.

Fixes: b40ba8065347 ("clk: imx: Update the compsite driver to support imx8ulp")
Reviewed-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Ye Li <ye.li@nxp.com>
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Reviewed-by: Abel Vesa <abel.vesa@linaro.org>
Link: https://lore.kernel.org/r/20240607133347.3291040-4-peng.fan@oss.nxp.com
Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/imx/clk-composite-7ulp.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/clk/imx/clk-composite-7ulp.c b/drivers/clk/imx/clk-composite-7ulp.c
index e208ddc511339..db7f40b07d1ab 100644
--- a/drivers/clk/imx/clk-composite-7ulp.c
+++ b/drivers/clk/imx/clk-composite-7ulp.c
@@ -14,6 +14,7 @@
 #include "../clk-fractional-divider.h"
 #include "clk.h"
 
+#define PCG_PR_MASK		BIT(31)
 #define PCG_PCS_SHIFT	24
 #define PCG_PCS_MASK	0x7
 #define PCG_CGC_SHIFT	30
@@ -78,6 +79,12 @@ static struct clk_hw *imx_ulp_clk_hw_composite(const char *name,
 	struct clk_hw *hw;
 	u32 val;
 
+	val = readl(reg);
+	if (!(val & PCG_PR_MASK)) {
+		pr_info("PCC PR is 0 for clk:%s, bypass\n", name);
+		return 0;
+	}
+
 	if (mux_present) {
 		mux = kzalloc(sizeof(*mux), GFP_KERNEL);
 		if (!mux)
-- 
2.43.0



