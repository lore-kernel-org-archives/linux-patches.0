Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8CB3126C02;
	Tue, 16 Dec 2025 11:17:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765883848; cv=none; b=ofNbm45szfO1B+IaahVttShqo558UmZei6Rc2cSeACvz7p1QrzIcIBCfzT0gq6gmwfmP0aAYlQNlumBQmudrUZHRE6VAB/X2+XAUDdU5M0fnPzaJnyeni8eo6SGet7iHb4hLUHG15/GzHfhLUoB9ANcXWsWF7XNE2Hprd/5e3f0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765883848; c=relaxed/simple;
	bh=7S0OUiJQ3jWgUjEMF4ppgnpMR6BWvTkn/sj2aAJIigY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VOddxS8AKfLntwRNuJXrWk0OC6Mi9WknEQhBc/8bAImwPYEgdarIDo+X7vXLLeQBwC/nqWVrrsQMybawE3oN+4SRdNLbiqO+oXw8f+FjO5Cji2T/DVIfY2LjNfZ4WtXqqtIGP0FLXYrr60R2+T+R0bR+sEav14MDK9b4a6TyL2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EnIZyAQ3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EnIZyAQ3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09DFCC4CEF1;
	Tue, 16 Dec 2025 11:17:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765883848;
	bh=7S0OUiJQ3jWgUjEMF4ppgnpMR6BWvTkn/sj2aAJIigY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EnIZyAQ3TrHDgjyOBhE8rwpqxlh3xJPFYcSho2YE3/nLENZeGdUgVbyGGLfqtANEt
	 +/dAyetDqEUwJ8MO+iiw58sycWF3wdhojTOiq5OC+GpYiQKowa+zOFl2MKhQKuDdYq
	 5F4eW75jmNSD/kxjDU0OiqGMvwrM7mjZYNxS070I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 018/354] clk: renesas: Use str_on_off() helper
Date: Tue, 16 Dec 2025 12:09:45 +0100
Message-ID: <20251216111321.568612451@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit aff664cc8cbc5c28e5aa57dc4201c34497f3c871 ]

Use the str_on_off() helper instead of open-coding the same operation.
Note that this does change the case of the flags, which doesn't matter
much for debug messages.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/622f8554dcb815c8fc73511a1a118c1724570fa9.1745840497.git.geert+renesas@glider.be
Stable-dep-of: b91401af6c00 ("clk: renesas: cpg-mssr: Read back reset registers to assure values latched")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/renesas/renesas-cpg-mssr.c | 3 ++-
 drivers/clk/renesas/rzg2l-cpg.c        | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/renesas/renesas-cpg-mssr.c b/drivers/clk/renesas/renesas-cpg-mssr.c
index ecb7e2024d589..22699a47e675c 100644
--- a/drivers/clk/renesas/renesas-cpg-mssr.c
+++ b/drivers/clk/renesas/renesas-cpg-mssr.c
@@ -27,6 +27,7 @@
 #include <linux/psci.h>
 #include <linux/reset-controller.h>
 #include <linux/slab.h>
+#include <linux/string_choices.h>
 
 #include <dt-bindings/clock/renesas-cpg-mssr.h>
 
@@ -205,7 +206,7 @@ static int cpg_mstp_clock_endisable(struct clk_hw *hw, bool enable)
 	int error;
 
 	dev_dbg(dev, "MSTP %u%02u/%pC %s\n", reg, bit, hw->clk,
-		enable ? "ON" : "OFF");
+		str_on_off(enable));
 	spin_lock_irqsave(&priv->rmw_lock, flags);
 
 	if (priv->reg_layout == CLK_REG_LAYOUT_RZ_A) {
diff --git a/drivers/clk/renesas/rzg2l-cpg.c b/drivers/clk/renesas/rzg2l-cpg.c
index e2ecc9d36e051..e4f2d974f38a1 100644
--- a/drivers/clk/renesas/rzg2l-cpg.c
+++ b/drivers/clk/renesas/rzg2l-cpg.c
@@ -27,6 +27,7 @@
 #include <linux/pm_domain.h>
 #include <linux/reset-controller.h>
 #include <linux/slab.h>
+#include <linux/string_choices.h>
 #include <linux/units.h>
 
 #include <dt-bindings/clock/renesas-cpg-mssr.h>
@@ -1222,7 +1223,7 @@ static int rzg2l_mod_clock_endisable(struct clk_hw *hw, bool enable)
 	}
 
 	dev_dbg(dev, "CLK_ON 0x%x/%pC %s\n", CLK_ON_R(reg), hw->clk,
-		enable ? "ON" : "OFF");
+		str_on_off(enable));
 
 	value = bitmask << 16;
 	if (enable)
-- 
2.51.0



