Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04BA11AB51B;
	Mon, 14 Oct 2024 15:27:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919655; cv=none; b=lyYFwXNXuoKSxhGXRwcRYBJS8Q2QWULROVR+XSlrm49sIy/oATlBkwJCIG00LI+wy64UWHS/AxF/krPZwhDuUgZlxm2+bhSjSjur+P4I3bpHDZuA5gHmzAbAXfUJvRP+tiPymqPHvw0XJt2qZv2Pcdq99TiobzRtK6+0JZ6RyBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919655; c=relaxed/simple;
	bh=9TDQONxgwEy++51YkPICAkD3pNOwH0FXvABJFv95VAI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b1Pd46iVopnfpLgMNmDkhFsCCNStMMtQa8ekgBVZnqfdRuC0kkxViQybkfZFoaqkHVhWUIP3jOk9HFJM46tehFNtzDq580qg4zIeUJwWl//sqAh2PHdrI3cugcsOgYtyhY65giKY2kE7Cp0nC6gfgzSnYH5flTps1nTcJ7OaYeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pwjsSREf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pwjsSREf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B9D9C4CEC7;
	Mon, 14 Oct 2024 15:27:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919654;
	bh=9TDQONxgwEy++51YkPICAkD3pNOwH0FXvABJFv95VAI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pwjsSREfC1VDT9wF31cd66FRvm/PmO9Nl2N7s0A2MMFqGNgvlTvCWVGRG9Y7cn6r9
	 2t7C93Zr5RjnZmAJnfp3P8tde3xORqqGzFjA1oLhK94xhSPC1ySDOIHdqK0BBd9d+y
	 HJEt0CE/f88+U/awdP0JKktMGLXyEupKjB/o2Flc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Michel <alex.michel@wiedemann-group.com>,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Abel Vesa <abel.vesa@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 639/798] clk: imx6ul: fix clock parent for IMX6UL_CLK_ENETx_REF_SEL
Date: Mon, 14 Oct 2024 16:19:53 +0200
Message-ID: <20241014141243.145467547@linuxfoundation.org>
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

From: Michel Alex <Alex.Michel@wiedemann-group.com>

[ Upstream commit 32c055ef563c3a4a73a477839f591b1b170bde8e ]

Commit 4e197ee880c24ecb63f7fe17449b3653bc64b03c ("clk: imx6ul: add
ethernet refclock mux support") sets the internal clock as default
ethernet clock.

Since IMX6UL_CLK_ENET_REF cannot be parent for IMX6UL_CLK_ENET1_REF_SEL,
the call to clk_set_parent() fails. IMX6UL_CLK_ENET1_REF_125M is the correct
parent and shall be used instead.
Same applies for IMX6UL_CLK_ENET2_REF_SEL, for which IMX6UL_CLK_ENET2_REF_125M
is the correct parent.

Cc: stable@vger.kernel.org
Signed-off-by: Alex Michel <alex.michel@wiedemann-group.com>
Reviewed-by: Oleksij Rempel <o.rempel@pengutronix.de>
Link: https://lore.kernel.org/r/AS1P250MB0608F9CE4009DCE65C61EEDEA9922@AS1P250MB0608.EURP250.PROD.OUTLOOK.COM
Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/imx/clk-imx6ul.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/imx/clk-imx6ul.c b/drivers/clk/imx/clk-imx6ul.c
index ef6c94b732684..c4266d732f7c1 100644
--- a/drivers/clk/imx/clk-imx6ul.c
+++ b/drivers/clk/imx/clk-imx6ul.c
@@ -540,8 +540,8 @@ static void __init imx6ul_clocks_init(struct device_node *ccm_node)
 
 	clk_set_parent(hws[IMX6UL_CLK_ENFC_SEL]->clk, hws[IMX6UL_CLK_PLL2_PFD2]->clk);
 
-	clk_set_parent(hws[IMX6UL_CLK_ENET1_REF_SEL]->clk, hws[IMX6UL_CLK_ENET_REF]->clk);
-	clk_set_parent(hws[IMX6UL_CLK_ENET2_REF_SEL]->clk, hws[IMX6UL_CLK_ENET2_REF]->clk);
+	clk_set_parent(hws[IMX6UL_CLK_ENET1_REF_SEL]->clk, hws[IMX6UL_CLK_ENET1_REF_125M]->clk);
+	clk_set_parent(hws[IMX6UL_CLK_ENET2_REF_SEL]->clk, hws[IMX6UL_CLK_ENET2_REF_125M]->clk);
 
 	imx_register_uart_clocks();
 }
-- 
2.43.0



