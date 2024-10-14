Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A6081B4F1E;
	Mon, 14 Oct 2024 14:59:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917973; cv=none; b=Y8k5pVmWCuEMLRVjHhwkaCLLjB+4olDY84E/uBjSFKk3jqLh2wNqLQauaraBX2NBvOXTM9KYM1XL0fH4YHzSoGgsRnBay4Y4w12CkNvsRJ9ssW3AEteUJA5eBSJ2gcb1o8jNW0W9enNxKUbDNg9q511ufpix8K9jsOLoXUmJXOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917973; c=relaxed/simple;
	bh=yRiY+REprViNb2OjIHE2+/0AV0JXw1NdZFkygrC8daE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K3OqRGaFL+heRcWG3IBovsJRctU9ddbw9tbxPiHMUwzUGg9bIEhXfxdY7EyyX+ss2D4pImjAlLUUElsiaYy1K6tZr+EUiwv+wO9xqMO7La3CEsezTzSX2UH/gAiySlByCbM9XUwgAf/CPy65B/5pkW948dcBjzdn2cEFkCYMlGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d7uiup3I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d7uiup3I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC821C4CEC3;
	Mon, 14 Oct 2024 14:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917972;
	bh=yRiY+REprViNb2OjIHE2+/0AV0JXw1NdZFkygrC8daE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d7uiup3IsXT8VX4F6ZwqP78e6QPWbxQ8rPQs3yuVthXr35XewjJo8tllqvCnLzd5J
	 wiuwli/0iZE/q53s3k9cq1NW7QhzjRCTNNL/0SSzc8r6taSaxBFmotghJmgpC0OD8l
	 P3B9ma5OutKMzVOl4Hip6FqvP5k56RFw3q9lcr4w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Ye Li <ye.li@nxp.com>,
	Abel Vesa <abel.vesa@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 185/798] clk: imx: composite-7ulp: Check the PCC present bit
Date: Mon, 14 Oct 2024 16:12:19 +0200
Message-ID: <20241014141225.202654384@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 4eedd45dbaa83..5429b76f4f72c 100644
--- a/drivers/clk/imx/clk-composite-7ulp.c
+++ b/drivers/clk/imx/clk-composite-7ulp.c
@@ -14,6 +14,7 @@
 #include "../clk-fractional-divider.h"
 #include "clk.h"
 
+#define PCG_PR_MASK		BIT(31)
 #define PCG_PCS_SHIFT	24
 #define PCG_PCS_MASK	0x7
 #define PCG_CGC_SHIFT	30
@@ -80,6 +81,12 @@ static struct clk_hw *imx_ulp_clk_hw_composite(const char *name,
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



