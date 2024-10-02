Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C7801D0491;
	Wed,  2 Oct 2024 14:08:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878129; cv=none; b=sX/ci0NZx3sV+V+5R902AzazbrOw23EB9d9IPF8vno5oXJLFqaCtVp4Ei3aZbT8nlhWqXpBXApQeRFBK+O/pneAnGYSjomRDbByekgYiIOcigiKtPSkC+Xb6ftymTUTUivyDJyrST5TaRZa0SdlA5+X86FElRsygFR7wteOomBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878129; c=relaxed/simple;
	bh=/9w09zOLUljfFvhq85jY/vx1DD+wjXBUEG46fADEu5Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PxMpVAJQ/PHN0Tvi2PqdiaFKZ/RZbnDyJewpm8P0z001yrsgZ76s2wa2zvtuPGj6DRSxDZtFQP3/USWWxXJiPS7n/MNorIxyOLmZD+viweSF/7sL3/2zs3/vCwIFmNvO/CMvxFZBuu4q8e/wEE7OWmxTYLYSFcUgIv5EU21qcxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hqiLViAs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hqiLViAs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC6EDC4CEC2;
	Wed,  2 Oct 2024 14:08:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878129;
	bh=/9w09zOLUljfFvhq85jY/vx1DD+wjXBUEG46fADEu5Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hqiLViAszn4+A6hOefszGYzeug/PyrmJ0wuJLqSbouEHwoBOwsR00wy5ZbGPgR7wp
	 eYgqkDV7XMGBYkLvHFU4MwgmFUoQBDJk35BSiblLK6dDR80jg+Rg+KoxtnFV6JFthM
	 +I2oUGaD+GYUdm4h/FSYKXSgz8jmNCjjJhJU5Wfs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Ye Li <ye.li@nxp.com>,
	Abel Vesa <abel.vesa@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 312/634] clk: imx: composite-7ulp: Check the PCC present bit
Date: Wed,  2 Oct 2024 14:56:52 +0200
Message-ID: <20241002125823.422213480@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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



