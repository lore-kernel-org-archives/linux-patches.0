Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75C2A2472B7;
	Tue,  5 Aug 2025 13:12:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754399522; cv=none; b=hBM1uqixAfSPKR2/qdN+69tmbaqsq23vAL+58vRiMbb5QGNg2lh6rjHwMIX9JvkMBVbkc/9mxk3shfFtv+Cqhv8F3XLuXIsxF+53/apM8Ou/Kk8xt++5+IQl/chfMwdVKZ5WOvFgTPD/+yuBkxlJ8iTdSdjqY8N3n+wrz71D8jw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754399522; c=relaxed/simple;
	bh=JLR7knPcYjEDtXFlGhqz4++ofr2Y/Icxu/xtWDVSxZM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=kZW07oQnYqnzB5V9PfxnvYCifvOpR/mFjuWG4UUw8x7RNt4Q5En1HesSdlrzvDKTWSoQGzgf+JDwCWl3or5fjJSAnpnQhZY5GTE+c/Kh3B3bv4tU8ReCOIgYXqPLg1ImhIepchx6SXkkwxyCstKldn9OYRP6JjMgx2nHw6FfjNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l8ZI86RX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l8ZI86RX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96A1AC4CEF0;
	Tue,  5 Aug 2025 13:12:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754399522;
	bh=JLR7knPcYjEDtXFlGhqz4++ofr2Y/Icxu/xtWDVSxZM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l8ZI86RX9tF4njFWA/wlWPmG1sJStRJ2mhPMZuBY/QcWFy4e8jOnss1q8b7csCfeK
	 YvQfwAB6eALeld4RTjG0F64knXeHE186pj0/B2R9hwE+qKImZ5u+mwVuMhVTO73gEL
	 vIvkhCxlq7MKlOzj8CojFe3OzValIUFBadfNwOwST8Kms9yZJx5fap1W5aB1FAZXZz
	 KAFqxG4Nb9EivcFIciiJMGqQdYMxXrioBxkcxnN+c4Ep02Qmf2jTZFfCB7NCNNcp7R
	 1g6SsFrnzq5fAcINk17dwK8Fxj12xSLEvGVwCALh3l2lHOgjKtYDlBmJKFunSrnjx+
	 i4DsEaprP+qhQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Pei Xiao <xiaopei01@kylinos.cn>,
	Thierry Reding <treding@nvidia.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	pdeschrijver@nvidia.com,
	pgaikwad@nvidia.com,
	thierry.reding@gmail.com,
	jonathanh@nvidia.com,
	linux-tegra@vger.kernel.org
Subject: [PATCH AUTOSEL 6.16-6.6] clk: tegra: periph: Fix error handling and resolve unsigned compare warning
Date: Tue,  5 Aug 2025 09:09:35 -0400
Message-Id: <20250805130945.471732-60-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250805130945.471732-1-sashal@kernel.org>
References: <20250805130945.471732-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.16
Content-Transfer-Encoding: 8bit

From: Pei Xiao <xiaopei01@kylinos.cn>

[ Upstream commit 2dc2ca9000eea2eb749f658196204cb84d4306f7 ]

./drivers/clk/tegra/clk-periph.c:59:5-9: WARNING:
	Unsigned expression compared with zero: rate < 0

The unsigned long 'rate' variable caused:
- Incorrect handling of negative errors
- Compile warning: "Unsigned expression compared with zero"

Fix by changing to long type and adding req->rate cast.

Signed-off-by: Pei Xiao <xiaopei01@kylinos.cn>
Link: https://lore.kernel.org/r/79c7f01e29876c612e90d6d0157fb1572ca8b3fb.1752046270.git.xiaopei01@kylinos.cn
Acked-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The return type is indeed `long`, which can represent negative error
codes. Now let me verify the proposed fix addresses this issue correctly
by looking at the patch again and understanding the cast:

The fix changes:
1. `unsigned long rate` to `long rate` - This allows the variable to
   hold negative values
2. Adds a cast when assigning to `req->rate`: `req->rate = (unsigned
   long)rate` - This is safe because we only do this assignment after
   checking that rate is not negative

**Backport Status: YES**

This commit should be backported to stable kernel trees for the
following reasons:

1. **It fixes a real bug** that was introduced in v6.10 (commit
   4d78bd80cef7): The original code declares `rate` as `unsigned long`
   while `div_ops->round_rate()` returns a `long` that can be negative
   to indicate errors. The comparison `if (rate < 0)` on line 59 will
   never be true for an unsigned variable, causing error conditions from
   the underlying clock driver to be ignored and potentially passed as
   valid (very large) rate values.

2. **The fix is minimal and contained**: The change only modifies two
   lines - changing the variable type from `unsigned long` to `long` and
   adding an explicit cast when assigning to `req->rate`. This is a
   surgical fix that doesn't alter the logic or introduce new features.

3. **Low risk of regression**: The fix properly handles the error case
   that was being missed before. The cast to `unsigned long` when
   assigning to `req->rate` is safe because it only happens after
   verifying the rate is not negative. This maintains compatibility with
   the existing API while fixing the error handling.

4. **Affects a critical subsystem**: Clock drivers are fundamental to
   system operation. Incorrect error handling in clock rate calculations
   could lead to system instability, incorrect clock frequencies being
   set, or error conditions being silently ignored.

5. **The bug has clear symptoms**: The commit message mentions both a
   compile-time warning ("Unsigned expression compared with zero") and
   incorrect runtime behavior (error values not being properly handled).
   This makes it easy to verify the fix addresses real issues.

6. **Applies to currently supported stable kernels**: The bug was
   introduced in v6.10, which is still within the stable kernel
   maintenance window. The fix should be backported to v6.10.y stable
   series to ensure proper error handling in Tegra peripheral clock
   operations.

The commit perfectly aligns with stable kernel criteria: it fixes a
clear bug without adding features or making architectural changes, and
the risk of introducing new issues is minimal given the straightforward
nature of the fix.

 drivers/clk/tegra/clk-periph.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/tegra/clk-periph.c b/drivers/clk/tegra/clk-periph.c
index 0626650a7011..c9fc52a36fce 100644
--- a/drivers/clk/tegra/clk-periph.c
+++ b/drivers/clk/tegra/clk-periph.c
@@ -51,7 +51,7 @@ static int clk_periph_determine_rate(struct clk_hw *hw,
 	struct tegra_clk_periph *periph = to_clk_periph(hw);
 	const struct clk_ops *div_ops = periph->div_ops;
 	struct clk_hw *div_hw = &periph->divider.hw;
-	unsigned long rate;
+	long rate;
 
 	__clk_hw_set_clk(div_hw, hw);
 
@@ -59,7 +59,7 @@ static int clk_periph_determine_rate(struct clk_hw *hw,
 	if (rate < 0)
 		return rate;
 
-	req->rate = rate;
+	req->rate = (unsigned long)rate;
 	return 0;
 }
 
-- 
2.39.5

