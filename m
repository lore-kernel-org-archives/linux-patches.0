Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF7D943636C
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:52:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301154; cv=none; b=io4P4F3YCF6bYo9tKR/R+hbTOC8Hm4eZlgyIXoTXFF4Zqiik11RLKfY1YjKy7103ajqKkzevv8/18uC/0Ka6u4ySHYCpT5uN7iofyhmd+B5ALaSLvtQMHWKhhPa/wApTAEWV4o6dKwukLZ8Hz9M0Y9B8NkNomqTqvGrjDoqazu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301154; c=relaxed/simple;
	bh=tn3n7rs5eJ+ZaXqxsYGPGpvMuAfVq8Xos9IhrLHeoJc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QHhEfAq4t6eTHHZZsJRoXkmwZ5+ymmyt0r3M2uwpwFCfECITZyQDW9FXA25W9rNiGQKd1yU3/Kxp5WPzq2jtkAEWmTkQhLeIU3luDnlwcA6yJGyzx3bCoJZDNbAsyxTJCGuERDArGCY8rCMIAJTU1MDi+WOYSaTYByYMW+Qxfo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NCiQN4uj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NCiQN4uj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D145C19423;
	Sat, 28 Feb 2026 17:52:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301154;
	bh=tn3n7rs5eJ+ZaXqxsYGPGpvMuAfVq8Xos9IhrLHeoJc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NCiQN4ujxuBLopKQHnVOY3TdD9QmPve1MnMxOjHeqijEd0vz/3yxHTeZ0G8J/ndSA
	 D+Zfc6euZJY8IhYnW3mJCECzAn4CXh14sqD6LnoN10nOfyY2BhW+RC5oduATRUPe6W
	 7ogswLJuRZCIKVBYKgsnUyzJSazZE1WVvCU24hN6gochSt9NkSJkiEllZyqSuEtsie
	 u9J+yKHctOqkvj1PGW1oNs+n4xOLJ23fOb8CWXGmz3rludm2XEFglrTKo095hCJ3Gt
	 LxFUti08PNXEEXhOZ25eq/dWwU1qlJugXGkve54jp9IvW4pQu6R3U7C8fYwdvSBlPF
	 606pIHjuTnKKg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Biju Das <biju.das.jz@bp.renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 318/752] clk: renesas: rzg2l: Deassert reset on assert timeout
Date: Sat, 28 Feb 2026 12:40:29 -0500
Message-ID: <20260228174750.1542406-318-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Biju Das <biju.das.jz@bp.renesas.com>

[ Upstream commit 0b0201f259e1158a875c5fd01adf318ae5d32352 ]

If the assert() fails due to timeout error, set the reset register bit
back to deasserted state. This change is needed especially for handling
assert error in suspend() callback that expect the device to be in
operational state in case of failure.

Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://patch.msgid.link/20260108123433.104464-2-biju.das.jz@bp.renesas.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/renesas/rzg2l-cpg.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/clk/renesas/rzg2l-cpg.c b/drivers/clk/renesas/rzg2l-cpg.c
index 07909e80bae24..db85b1b43737b 100644
--- a/drivers/clk/renesas/rzg2l-cpg.c
+++ b/drivers/clk/renesas/rzg2l-cpg.c
@@ -1647,6 +1647,7 @@ static int __rzg2l_cpg_assert(struct reset_controller_dev *rcdev,
 	u32 mask = BIT(info->resets[id].bit);
 	s8 monbit = info->resets[id].monbit;
 	u32 value = mask << 16;
+	u32 mon;
 	int ret;
 
 	dev_dbg(rcdev->dev, "%s id:%ld offset:0x%x\n",
@@ -1667,10 +1668,10 @@ static int __rzg2l_cpg_assert(struct reset_controller_dev *rcdev,
 		return 0;
 	}
 
-	ret = readl_poll_timeout_atomic(priv->base + reg, value,
-					assert == !!(value & mask), 10, 200);
-	if (ret && !assert) {
-		value = mask << 16;
+	ret = readl_poll_timeout_atomic(priv->base + reg, mon,
+					assert == !!(mon & mask), 10, 200);
+	if (ret) {
+		value ^= mask;
 		writel(value, priv->base + CLK_RST_R(info->resets[id].off));
 	}
 
-- 
2.51.0

