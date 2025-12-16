Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D16213233EE;
	Tue, 16 Dec 2025 11:19:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765883997; cv=none; b=vFbpJBIpa9OytKTd8qHL71eQem9vDTQhzj2/lWbtjuvXEwTqFH+UYnnLZv2BjWaJdTYPOHcbKJ0VbeuCuKKIeXgHt48e+TvMAxGJoPgkUoe4zaGnzug4WJTmTSQu0JJ32okdyNKN+fYmKfssXLZ7byPZtP6HnaiEzN7V+0BTqfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765883997; c=relaxed/simple;
	bh=FmBCAYbOSsq0TDZqV5wRcRICqVhS6shirKlBVPQV2+8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y314lLI4GSDXs9UO+LXSm198OT4VVQj75bVDGaA9leqxRztal74qpemqwCgQB5M3Trqskx8ZzBCYJCSkwMwb4kAbSY4GKjA9gsqi9KE+PhUFn5rNW/j0GK+jxAEKgPv/PQYqPOuwOL5/LIS/hbKGhfxPxba+QpRzYyXKmq+Npco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gqvws/A1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gqvws/A1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51481C4CEF1;
	Tue, 16 Dec 2025 11:19:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765883997;
	bh=FmBCAYbOSsq0TDZqV5wRcRICqVhS6shirKlBVPQV2+8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gqvws/A1cuPgw1tun1dUOsTAktSPI3u0o3PvpHJR+emqYmqndBBF+fv3733y1fc+I
	 fZVQu5xIaIAMuseHw+6TNCqYsOHbU51QzHt8q+Jdsu8LXx0jrX4e72y/zgAgSetEWs
	 V/8nEYiQwKAPdgVHoukErQCuJf/5P6SurrYma61I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Taniya Das <taniya.das@oss.qualcomm.com>,
	Luca Weiss <luca.weiss@fairphone.com>,
	Abel Vesa <abel.vesa@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 060/354] clk: qcom: camcc-sm6350: Fix PLL config of PLL2
Date: Tue, 16 Dec 2025 12:10:27 +0100
Message-ID: <20251216111323.093910157@linuxfoundation.org>
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

From: Luca Weiss <luca.weiss@fairphone.com>

[ Upstream commit ab0e13141d679fdffdd3463a272c5c1b10be1794 ]

The 'Agera' PLLs (with clk_agera_pll_configure) do not take some of the
parameters that are provided in the vendor driver. Instead the upstream
configuration should provide the final user_ctl value that is written to
the USER_CTL register.

Fix the config so that the PLL is configured correctly, and fixes
CAMCC_MCLK* being stuck off.

Fixes: 80f5451d9a7c ("clk: qcom: Add camera clock controller driver for SM6350")
Suggested-by: Taniya Das <taniya.das@oss.qualcomm.com>
Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
Reviewed-by: Abel Vesa <abel.vesa@linaro.org>
Reviewed-by: Taniya Das <taniya.das@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20251021-agera-pll-fixups-v1-1-8c1d8aff4afc@fairphone.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/camcc-sm6350.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/clk/qcom/camcc-sm6350.c b/drivers/clk/qcom/camcc-sm6350.c
index 454763425f611..9a62228c314c1 100644
--- a/drivers/clk/qcom/camcc-sm6350.c
+++ b/drivers/clk/qcom/camcc-sm6350.c
@@ -144,15 +144,11 @@ static struct clk_alpha_pll_postdiv camcc_pll1_out_even = {
 static const struct alpha_pll_config camcc_pll2_config = {
 	.l = 0x64,
 	.alpha = 0x0,
-	.post_div_val = 0x3 << 8,
-	.post_div_mask = 0x3 << 8,
-	.aux_output_mask = BIT(1),
-	.main_output_mask = BIT(0),
-	.early_output_mask = BIT(3),
 	.config_ctl_val = 0x20000800,
 	.config_ctl_hi_val = 0x400003d2,
 	.test_ctl_val = 0x04000400,
 	.test_ctl_hi_val = 0x00004000,
+	.user_ctl_val = 0x0000030b,
 };
 
 static struct clk_alpha_pll camcc_pll2 = {
-- 
2.51.0



