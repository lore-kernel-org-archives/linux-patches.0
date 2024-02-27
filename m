Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EEA713B798;
	Tue, 27 Feb 2024 14:07:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042820; cv=none; b=QNMSuQQ8hRHYCibg7LqrzXtIt0r3oNixiOBRlE8Kxom0NEGIUd93axpuKo5k5tmnqyfRffmGCaHbWWh4WoSmcRK4Q4XQWPSF8sS0Juh0i4SxQTUZcxQKtLpO/aNXxNwEG93LtTHDY4WN86q/2RsGtI81YmOehASGOKMU0/16pQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042820; c=relaxed/simple;
	bh=jZc3hir+/AeNIkiqCrVFBbkPI/ucxYPTt9+DGGhOB28=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o0fLR3lsUEWcj2LkI34DZLXoxErrEmYhK6s1zWNg7jOgiCZrtObeSc4hZEgDpQ5j59pp08xU05tN/oPW8Mu81sYCu/tIF03qvcUe2joX3Y5Pqf40QY9s5e7l2D7j8acEeo7kOOUCaAllq4D5P0nxEqrjGXgVsqkBPDfpSLrwi4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=095Kjg2x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="095Kjg2x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D17B3C433C7;
	Tue, 27 Feb 2024 14:06:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042820;
	bh=jZc3hir+/AeNIkiqCrVFBbkPI/ucxYPTt9+DGGhOB28=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=095Kjg2x5ekp8DSi6eKrkeoM0i36LO0EhTbHKuEjwPwMS3jaz14oA5rhqU2PYGmg2
	 +Wf5qz03qjuSXdTCid3c5UDqIpucVkpsNOfrlgm9nmP4DIOWImCvMAn4YdXKSWeXqI
	 G+nTterEnBrDgOy0L472wB7HdoncwPmj73Ab4P3U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Michael Turquette <mturquette@baylibre.com>,
	Stephen Boyd <sboyd@kernel.org>,
	linux-clk@vger.kernel.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 133/245] clk: linux/clk-provider.h: fix kernel-doc warnings and typos
Date: Tue, 27 Feb 2024 14:25:21 +0100
Message-ID: <20240227131619.536216191@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131615.098467438@linuxfoundation.org>
References: <20240227131615.098467438@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit 84aefafe6b294041b7fa0757414c4a29c1bdeea2 ]

Fix spelling of "Structure".

Fix multiple kernel-doc warnings:

clk-provider.h:269: warning: Function parameter or member 'recalc_rate' not described in 'clk_ops'
clk-provider.h:468: warning: Function parameter or member 'parent_data' not described in 'clk_hw_register_fixed_rate_with_accuracy_parent_data'
clk-provider.h:468: warning: Excess function parameter 'parent_name' description in 'clk_hw_register_fixed_rate_with_accuracy_parent_data'
clk-provider.h:482: warning: Function parameter or member 'parent_data' not described in 'clk_hw_register_fixed_rate_parent_accuracy'
clk-provider.h:482: warning: Excess function parameter 'parent_name' description in 'clk_hw_register_fixed_rate_parent_accuracy'
clk-provider.h:687: warning: Function parameter or member 'flags' not described in 'clk_divider'
clk-provider.h:1164: warning: Function parameter or member 'flags' not described in 'clk_fractional_divider'
clk-provider.h:1164: warning: Function parameter or member 'approximation' not described in 'clk_fractional_divider'
clk-provider.h:1213: warning: Function parameter or member 'flags' not described in 'clk_multiplier'

Fixes: 9fba738a53dd ("clk: add duty cycle support")
Fixes: b2476490ef11 ("clk: introduce the common clock framework")
Fixes: 2d34f09e79c9 ("clk: fixed-rate: Add support for specifying parents via DT/pointers")
Fixes: f5290d8e4f0c ("clk: asm9260: use parent index to link the reference clock")
Fixes: 9d9f78ed9af0 ("clk: basic clock hardware types")
Fixes: e2d0e90fae82 ("clk: new basic clk type for fractional divider")
Fixes: f2e0a53271a4 ("clk: Add a basic multiplier clock")

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Michael Turquette <mturquette@baylibre.com>
Cc: Stephen Boyd <sboyd@kernel.org>
Cc: linux-clk@vger.kernel.org
Link: https://lore.kernel.org/r/20230930221428.18463-1-rdunlap@infradead.org
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/clk-provider.h | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/include/linux/clk-provider.h b/include/linux/clk-provider.h
index 6cace09ba63d0..7d5ca15ac66ba 100644
--- a/include/linux/clk-provider.h
+++ b/include/linux/clk-provider.h
@@ -61,7 +61,7 @@ struct clk_rate_request {
 };
 
 /**
- * struct clk_duty - Struture encoding the duty cycle ratio of a clock
+ * struct clk_duty - Structure encoding the duty cycle ratio of a clock
  *
  * @num:	Numerator of the duty cycle ratio
  * @den:	Denominator of the duty cycle ratio
@@ -116,7 +116,7 @@ struct clk_duty {
  * @restore_context: Restore the context of the clock after a restoration
  *		of power.
  *
- * @recalc_rate	Recalculate the rate of this clock, by querying hardware. The
+ * @recalc_rate: Recalculate the rate of this clock, by querying hardware. The
  *		parent rate is an input parameter.  It is up to the caller to
  *		ensure that the prepare_mutex is held across this call.
  *		Returns the calculated rate.  Optional, but recommended - if
@@ -442,7 +442,7 @@ struct clk *clk_register_fixed_rate(struct device *dev, const char *name,
  * clock with the clock framework
  * @dev: device that is registering this clock
  * @name: name of this clock
- * @parent_name: name of clock's parent
+ * @parent_data: name of clock's parent
  * @flags: framework-specific flags
  * @fixed_rate: non-adjustable clock rate
  * @fixed_accuracy: non-adjustable clock accuracy
@@ -457,7 +457,7 @@ struct clk *clk_register_fixed_rate(struct device *dev, const char *name,
  * the clock framework
  * @dev: device that is registering this clock
  * @name: name of this clock
- * @parent_name: name of clock's parent
+ * @parent_data: name of clock's parent
  * @flags: framework-specific flags
  * @fixed_rate: non-adjustable clock rate
  */
@@ -593,7 +593,7 @@ struct clk_div_table {
  * Clock with an adjustable divider affecting its output frequency.  Implements
  * .recalc_rate, .set_rate and .round_rate
  *
- * Flags:
+ * @flags:
  * CLK_DIVIDER_ONE_BASED - by default the divisor is the value read from the
  *	register plus one.  If CLK_DIVIDER_ONE_BASED is set then the divider is
  *	the raw value read from the register, with the value of zero considered
@@ -1023,11 +1023,12 @@ struct clk_hw *devm_clk_hw_register_fixed_factor(struct device *dev,
  * @mwidth:	width of the numerator bit field
  * @nshift:	shift to the denominator bit field
  * @nwidth:	width of the denominator bit field
+ * @approximation: clk driver's callback for calculating the divider clock
  * @lock:	register lock
  *
  * Clock with adjustable fractional divider affecting its output frequency.
  *
- * Flags:
+ * @flags:
  * CLK_FRAC_DIVIDER_ZERO_BASED - by default the numerator and denominator
  *	is the value read from the register. If CLK_FRAC_DIVIDER_ZERO_BASED
  *	is set then the numerator and denominator are both the value read
@@ -1086,7 +1087,7 @@ void clk_hw_unregister_fractional_divider(struct clk_hw *hw);
  * Clock with an adjustable multiplier affecting its output frequency.
  * Implements .recalc_rate, .set_rate and .round_rate
  *
- * Flags:
+ * @flags:
  * CLK_MULTIPLIER_ZERO_BYPASS - By default, the multiplier is the value read
  *	from the register, with 0 being a valid value effectively
  *	zeroing the output clock rate. If CLK_MULTIPLIER_ZERO_BYPASS is
-- 
2.43.0



