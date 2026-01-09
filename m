Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41A7F32FA3D;
	Fri,  9 Jan 2026 11:50:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767959451; cv=none; b=hWYEiXROlXnvrSaN9JHaJ7mWUQ9LhGvHvgOim+d0h0eujYhVA8Rf0KQSFpQ0iEbcelwUlxwIGAiomQZtqvF/Q9F9I9A/znnVfo1NR57Vsi0gDQJqkMLg1uTmyHCkysPID0b8iYwsRCUx16BR0R5LgpJ4NRAOYICHBjLGXpBnGzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767959451; c=relaxed/simple;
	bh=2eubite9mVKnzvmQlUuBaVHYI9yHoZzWZ/yyVX/+KPw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ueZ8KUJMLoCFfwh/T2v9El5EzW2x7QO1hkAWeJ+/p5mAmHKzcF2obtMkCHyyWB9lF8jyI8nWPtMrW0xy36sv6MiB+y8YcZ1STfDP+fahVirkBhwBpMA7t1vq99k8Sfu2/BB7L2P32DbSZyK49kvIuTKAw88jj4sEH3QG4npgqu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J6MrWCnj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J6MrWCnj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94D44C4CEF1;
	Fri,  9 Jan 2026 11:50:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767959451;
	bh=2eubite9mVKnzvmQlUuBaVHYI9yHoZzWZ/yyVX/+KPw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J6MrWCnjjq3lVO8wj3RHzzviMxGwzdwQphWCTS/h1Tw8BdXn/z6OaxejrlXj/rd4h
	 ZonHvAac48ZuBgSq7i2YbODXjHoMhzqnpgUbYlVroDb/qD6DaQCOMobDWh75WoA8c3
	 lUmWmDuZhI5Vx4XB+bW3lu3QY7yaXNAhMEsEvwo4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 056/737] clk: renesas: Use str_on_off() helper
Date: Fri,  9 Jan 2026 12:33:15 +0100
Message-ID: <20260109112136.101163831@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 55ac571c73884..908bb9517cc1b 100644
--- a/drivers/clk/renesas/renesas-cpg-mssr.c
+++ b/drivers/clk/renesas/renesas-cpg-mssr.c
@@ -27,6 +27,7 @@
 #include <linux/psci.h>
 #include <linux/reset-controller.h>
 #include <linux/slab.h>
+#include <linux/string_choices.h>
 
 #include <dt-bindings/clock/renesas-cpg-mssr.h>
 
@@ -200,7 +201,7 @@ static int cpg_mstp_clock_endisable(struct clk_hw *hw, bool enable)
 	int error;
 
 	dev_dbg(dev, "MSTP %u%02u/%pC %s\n", reg, bit, hw->clk,
-		enable ? "ON" : "OFF");
+		str_on_off(enable));
 	spin_lock_irqsave(&priv->rmw_lock, flags);
 
 	if (priv->reg_layout == CLK_REG_LAYOUT_RZ_A) {
diff --git a/drivers/clk/renesas/rzg2l-cpg.c b/drivers/clk/renesas/rzg2l-cpg.c
index ab71f9cd250b0..4bba49215c710 100644
--- a/drivers/clk/renesas/rzg2l-cpg.c
+++ b/drivers/clk/renesas/rzg2l-cpg.c
@@ -27,6 +27,7 @@
 #include <linux/pm_domain.h>
 #include <linux/reset-controller.h>
 #include <linux/slab.h>
+#include <linux/string_choices.h>
 #include <linux/units.h>
 
 #include <dt-bindings/clock/renesas-cpg-mssr.h>
@@ -988,7 +989,7 @@ static int rzg2l_mod_clock_endisable(struct clk_hw *hw, bool enable)
 	}
 
 	dev_dbg(dev, "CLK_ON 0x%x/%pC %s\n", CLK_ON_R(reg), hw->clk,
-		enable ? "ON" : "OFF");
+		str_on_off(enable));
 
 	value = bitmask << 16;
 	if (enable)
-- 
2.51.0



