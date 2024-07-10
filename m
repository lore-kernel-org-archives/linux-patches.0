Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BDE234545;
	Wed, 10 Jul 2024 17:08:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720631282; cv=none; b=Z+bsYBBxvPyKua4CtSL9YxI9ROIa3UrdGnLj6ORioyTUf9cZoJV2T/viCiGN8bvyU3ERAd0hXlo3g+rHCwZTUzXLaaQIeYKtzZj3VgeDYGzu43n82V54+3rBONn8/zkFeTxb8VkfsqbFMG8gkkqWapWYlX3lfOa8QXNnrMEHHYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720631282; c=relaxed/simple;
	bh=yCXjZ5t+wLkF4jfSXS3RJ3beU8mDIWCl3YtDGYE1JFE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=A5CTS+kkzd+pBwvOCkNIWcQppjhlrZa0zki8p3mnWB8uy/x34RvY/Jhb9nfOTjRgBJprPZEbLvu+L4+LCQoAn/06TNCLHoaaZJ6BxjgVfMaEJ3WMn4NgRBZPSh/F5SVC2Ppp3Abt9AzilH/ScCvlYEa1AOT6/tahXvudYfG0TkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Pvtu1C3u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Pvtu1C3u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54F82C32781;
	Wed, 10 Jul 2024 17:08:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720631281;
	bh=yCXjZ5t+wLkF4jfSXS3RJ3beU8mDIWCl3YtDGYE1JFE=;
	h=From:Date:Subject:To:Cc:From;
	b=Pvtu1C3uJ3zW+aleaBmVsAoqDNxbnudCCx4mHaoLN67zWJ04g6jPaGZkiY5k8Du9h
	 In+XFS1ZtKi9OScZ8FLX2XEme/1Xj2M0BwZ8VkGVLDaHHlsXxbtS12i0WD6tfP/Qct
	 Fm3QqoyWMWCo1dsStEvYtArhv/3GWWzMBXIYmt6YrGIQ3q+iIX3DqO3i31X/3tDEC3
	 szdMDBwbUplm5mUnPvp6oF9NXKaAHdQuIbDi77Tz5gcBzC6gbyV4iZjPZsrtkCIyW5
	 rCuHlC6NxZwwIbo2vvE0d81M2Z0qgGxLFPh/89t6ATWuDOxe6h7S13WGOdqv5u0EsP
	 8EtTb/iayD6yA==
From: Nathan Chancellor <nathan@kernel.org>
Date: Wed, 10 Jul 2024 10:07:52 -0700
Subject: [PATCH] clk: sophgo: Avoid -Wsometimes-uninitialized in
 sg2042_clk_pll_set_rate()
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240710-clk-sg2042-fix-sometimes-uninitialized-pll_set_rate-v1-1-538fa82dd539@kernel.org>
X-B4-Tracking: v=1; b=H4sIAOe/jmYC/x2NwQrCMBAFf6Xs2YU0VCz+ikiJyWtdTNOSTUUs/
 XeDxznMzE6KLFC6NjtlvEVlSRXaU0P+6dIEllCZrLGdubSGfXyxTtZ0lkf5sC4zisxQ3pIkKeK
 ifBF4jXFQlCG7Au4D0PnxYXp/plpeM6r7v97ux/EDxS5tB4UAAAA=
To: Michael Turquette <mturquette@baylibre.com>, 
 Stephen Boyd <sboyd@kernel.org>, Chen Wang <unicorn_wang@outlook.com>, 
 Inochi Amaoto <inochiama@outlook.com>
Cc: linux-clk@vger.kernel.org, llvm@lists.linux.dev, 
 patches@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=3702; i=nathan@kernel.org;
 h=from:subject:message-id; bh=yCXjZ5t+wLkF4jfSXS3RJ3beU8mDIWCl3YtDGYE1JFE=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDGl9+z9m6Gm2tbv/F1C5xVNt/Vp88pFe642RWRqbRRiEO
 54lX/zTUcrCIMbFICumyFL9WPW4oeGcs4w3Tk2CmcPKBDKEgYtTACYiI8TIMDvMTnGhJIvuLqms
 P48a5A/XipQY3ehvqF5unP3b+tcCWYb/QTFhH1uiDgTZ7VH/7zdhJ49t+dadtw+8eb3i4vfoX/9
 F+AA=
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

Clang warns (or errors with CONFIG_WERROR=y):

  drivers/clk/sophgo/clk-sg2042-pll.c:396:6: error: variable 'ret' is used uninitialized whenever 'if' condition is true [-Werror,-Wsometimes-uninitialized]
    396 |         if (sg2042_pll_enable(pll, 0)) {
        |             ^~~~~~~~~~~~~~~~~~~~~~~~~
  drivers/clk/sophgo/clk-sg2042-pll.c:418:9: note: uninitialized use occurs here
    418 |         return ret;
        |                ^~~
  drivers/clk/sophgo/clk-sg2042-pll.c:396:2: note: remove the 'if' if its condition is always false
    396 |         if (sg2042_pll_enable(pll, 0)) {
        |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    397 |                 pr_warn("Can't disable pll(%s), status error\n", pll->hw.init->name);
        |                 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    398 |                 goto out;
        |                 ~~~~~~~~~
    399 |         }
        |         ~
  drivers/clk/sophgo/clk-sg2042-pll.c:393:9: note: initialize the variable 'ret' to silence this warning
    393 |         int ret;
        |                ^
        |                 = 0
  1 error generated.

sg2042_pll_enable() only ever returns zero, so this situation cannot
happen, but clang does not perform interprocedural analysis, so it
cannot know this to avoid the warning. Make it clearer to the compiler
by making sg2042_pll_enable() void and eliminate the error handling in
sg2042_clk_pll_set_rate(), which clears up the warning, as ret will
always be initialized.

Fixes: 48cf7e01386e ("clk: sophgo: Add SG2042 clock driver")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 drivers/clk/sophgo/clk-sg2042-pll.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/drivers/clk/sophgo/clk-sg2042-pll.c b/drivers/clk/sophgo/clk-sg2042-pll.c
index aa142897aa5e..9695e64fc23b 100644
--- a/drivers/clk/sophgo/clk-sg2042-pll.c
+++ b/drivers/clk/sophgo/clk-sg2042-pll.c
@@ -103,7 +103,7 @@ static inline void sg2042_pll_ctrl_decode(unsigned int reg_value,
 	ctrl->postdiv2 = FIELD_GET(PLLCTRL_POSTDIV2_MASK, reg_value);
 }
 
-static inline int sg2042_pll_enable(struct sg2042_pll_clock *pll, bool en)
+static inline void sg2042_pll_enable(struct sg2042_pll_clock *pll, bool en)
 {
 	u32 value;
 
@@ -132,8 +132,6 @@ static inline int sg2042_pll_enable(struct sg2042_pll_clock *pll, bool en)
 		value = readl(pll->base + R_PLL_CLKEN_CONTROL);
 		writel(value & (~(1 << pll->shift_enable)), pll->base + R_PLL_CLKEN_CONTROL);
 	}
-
-	return 0;
 }
 
 /**
@@ -393,14 +391,13 @@ static int sg2042_clk_pll_set_rate(struct clk_hw *hw,
 	int ret;
 
 	spin_lock_irqsave(pll->lock, flags);
-	if (sg2042_pll_enable(pll, 0)) {
-		pr_warn("Can't disable pll(%s), status error\n", pll->hw.init->name);
-		goto out;
-	}
+
+	sg2042_pll_enable(pll, 0);
+
 	ret = sg2042_get_pll_ctl_setting(&pctrl_table, rate, parent_rate);
 	if (ret) {
 		pr_warn("%s: Can't find a proper pll setting\n", pll->hw.init->name);
-		goto out2;
+		goto out;
 	}
 
 	value = sg2042_pll_ctrl_encode(&pctrl_table);
@@ -408,9 +405,9 @@ static int sg2042_clk_pll_set_rate(struct clk_hw *hw,
 	/* write the value to top register */
 	writel(value, pll->base + pll->offset_ctrl);
 
-out2:
-	sg2042_pll_enable(pll, 1);
 out:
+	sg2042_pll_enable(pll, 1);
+
 	spin_unlock_irqrestore(pll->lock, flags);
 
 	pr_debug("--> %s: pll_set_rate: val = 0x%x\n",

---
base-commit: 54cb3bb483379b0c070528974843e06aecbc9390
change-id: 20240710-clk-sg2042-fix-sometimes-uninitialized-pll_set_rate-8dee4cfb08c5

Best regards,
-- 
Nathan Chancellor <nathan@kernel.org>

