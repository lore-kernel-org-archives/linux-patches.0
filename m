Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CC54131746;
	Thu, 25 Apr 2024 16:56:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714064184; cv=none; b=rizXfR5z/jih3+oXhCATha8ltO3BHmDAtNDymdVt76+7ZeJXM/iXk+lU89NOSAvZhBUvrYY4Ex5EVPkIK+yshORQ5K5xd6HeluICfJ+8YOFLjKWIynvWRHRNnBzWziFRUee1lLW/blC5VizRl+a1C8RFmMOk7q4OHI3x8OhQNGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714064184; c=relaxed/simple;
	bh=xOZM1ewaEE8webcrxae6fRZ3lapbeFGOs6WCFr8o9mU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=gxF35AdsrsXXz0H0t7cdXiR/0YoXhIQ8f90no21ZkbQBeyl4QDKvIxNaCBYeA2RytJebMLvRqjHdy6VhaegLU8GPz0jRoa2S8ucp3XwjSLGZ5dQuXgJVvzOJuqYP8+XkIOsHkaoj1sdZGjypcIK0pqEtYBUSAwKMzf5Cb83PwNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aBmRapsv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aBmRapsv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86EC4C4AF0D;
	Thu, 25 Apr 2024 16:56:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714064184;
	bh=xOZM1ewaEE8webcrxae6fRZ3lapbeFGOs6WCFr8o9mU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=aBmRapsv6IaKBvdiQYhwCmEf62JM5xoaIdiZiuzQMg+cDdNZ5fUPBS0dvn02e3av9
	 zI2nOSy20qcJz3Vvu6so2xEacDjHl5ORFeYDK8ApeaQwQJkHbbQ8Bf4QDslxjjJv+Y
	 oLDNM5DU10WXbvFj1NVqBfIxdsS7RjR25TBTrRN5h7Avx0QCbfSFuzbilZlZ3xr82q
	 y13aputd6YFD4hjuFFtnmMn9BNWvTaMgZ6K+Y/I/ZlpdYlOhKVjAewRdxcu/yBXU+9
	 O2Ga2ovz2u7oU/CviciWQV/ZmGoZ6mwAqQnM6aHY3q94S0XD0Gwv4eKiMzUYVsLSgB
	 c1kRGKIZXJn/Q==
From: Nathan Chancellor <nathan@kernel.org>
Date: Thu, 25 Apr 2024 09:55:52 -0700
Subject: [PATCH 2/2] clk: bcm: rpi: Assign ->num before accessing ->hws
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240425-cbl-bcm-assign-counted-by-val-before-access-v1-2-e2db3b82d5ef@kernel.org>
References: <20240425-cbl-bcm-assign-counted-by-val-before-access-v1-0-e2db3b82d5ef@kernel.org>
In-Reply-To: <20240425-cbl-bcm-assign-counted-by-val-before-access-v1-0-e2db3b82d5ef@kernel.org>
To: Michael Turquette <mturquette@baylibre.com>, 
 Stephen Boyd <sboyd@kernel.org>, 
 Florian Fainelli <florian.fainelli@broadcom.com>
Cc: Kees Cook <keescook@chromium.org>, 
 "Gustavo A. R. Silva" <gustavoars@kernel.org>, 
 bcm-kernel-feedback-list@broadcom.com, linux-clk@vger.kernel.org, 
 linux-rpi-kernel@lists.infradead.org, linux-arm-kernel@lists.infradead.org, 
 linux-hardening@vger.kernel.org, patches@lists.linux.dev, 
 llvm@lists.linux.dev, stable@vger.kernel.org, 
 Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.14-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1678; i=nathan@kernel.org;
 h=from:subject:message-id; bh=xOZM1ewaEE8webcrxae6fRZ3lapbeFGOs6WCFr8o9mU=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDGla3abTn9y8tqDHMf/Qn/N85dnXVnov523rf7SlcaFbR
 2b1jttqHaUsDGJcDLJiiizVj1WPGxrOOct449QkmDmsTCBDGLg4BWAiPKUM/1MLZtRPneq48r76
 vu2NLyLVtxv1zLwQaPcvwZZv+ulgOV1GhgXn/XQKJgfuK7uWwHxp29VlqtZzb4XqTdmabG4lH3B
 DkwMA
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

Commit f316cdff8d67 ("clk: Annotate struct clk_hw_onecell_data with
__counted_by") annotated the hws member of 'struct clk_hw_onecell_data'
with __counted_by, which informs the bounds sanitizer about the number
of elements in hws, so that it can warn when hws is accessed out of
bounds. As noted in that change, the __counted_by member must be
initialized with the number of elements before the first array access
happens, otherwise there will be a warning from each access prior to the
initialization because the number of elements is zero. This occurs in
raspberrypi_discover_clocks() due to ->num being assigned after ->hws
has been accessed:

  UBSAN: array-index-out-of-bounds in drivers/clk/bcm/clk-raspberrypi.c:374:4
  index 3 is out of range for type 'struct clk_hw *[] __counted_by(num)' (aka 'struct clk_hw *[]')

Move the ->num initialization to before the first access of ->hws, which
clears up the warning.

Cc: stable@vger.kernel.org
Fixes: f316cdff8d67 ("clk: Annotate struct clk_hw_onecell_data with __counted_by")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 drivers/clk/bcm/clk-raspberrypi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/bcm/clk-raspberrypi.c b/drivers/clk/bcm/clk-raspberrypi.c
index 829406dc44a2..4d411408e4af 100644
--- a/drivers/clk/bcm/clk-raspberrypi.c
+++ b/drivers/clk/bcm/clk-raspberrypi.c
@@ -371,8 +371,8 @@ static int raspberrypi_discover_clocks(struct raspberrypi_clk *rpi,
 			if (IS_ERR(hw))
 				return PTR_ERR(hw);
 
-			data->hws[clks->id] = hw;
 			data->num = clks->id + 1;
+			data->hws[clks->id] = hw;
 		}
 
 		clks++;

-- 
2.44.0

