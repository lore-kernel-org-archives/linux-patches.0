Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FE353C484;
	Wed, 15 Nov 2023 19:40:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EyO1398v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98BFEC433C9;
	Wed, 15 Nov 2023 19:40:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077236;
	bh=jrJUT2NshPAfo/GySlB202AiIWyDDakqP7ItitQniHY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EyO1398vqFctDRpJrTW8mwOAxdd9Dq00q8EDzowl2B+Cee94scYtTQYQgiPzYmNL/
	 Uyt2w5LfvSlVvC4OQCQ0LLwnD2gXhsnx6/0fp/0L2JNmJ3q7x745yIZxCZaBgHcjci
	 kp2WrfbgXpBdXb97v94RhyqWrKYyGZzHWSYMlrtQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Michael Turquette <mturquette@baylibre.com>,
	Stephen Boyd <sboyd@kernel.org>,
	linux-clk@vger.kernel.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 180/603] clk: linux/clk-provider.h: fix kernel-doc warnings and typos
Date: Wed, 15 Nov 2023 14:12:05 -0500
Message-ID: <20231115191625.702120178@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index ec32ec58c59f7..ace3a4ce2fc98 100644
--- a/include/linux/clk-provider.h
+++ b/include/linux/clk-provider.h
@@ -74,7 +74,7 @@ void clk_hw_forward_rate_request(const struct clk_hw *core,
 				 unsigned long parent_rate);
 
 /**
- * struct clk_duty - Struture encoding the duty cycle ratio of a clock
+ * struct clk_duty - Structure encoding the duty cycle ratio of a clock
  *
  * @num:	Numerator of the duty cycle ratio
  * @den:	Denominator of the duty cycle ratio
@@ -129,7 +129,7 @@ struct clk_duty {
  * @restore_context: Restore the context of the clock after a restoration
  *		of power.
  *
- * @recalc_rate	Recalculate the rate of this clock, by querying hardware. The
+ * @recalc_rate: Recalculate the rate of this clock, by querying hardware. The
  *		parent rate is an input parameter.  It is up to the caller to
  *		ensure that the prepare_mutex is held across this call. If the
  *		driver cannot figure out a rate for this clock, it must return
@@ -456,7 +456,7 @@ struct clk *clk_register_fixed_rate(struct device *dev, const char *name,
  * clock with the clock framework
  * @dev: device that is registering this clock
  * @name: name of this clock
- * @parent_name: name of clock's parent
+ * @parent_data: name of clock's parent
  * @flags: framework-specific flags
  * @fixed_rate: non-adjustable clock rate
  * @fixed_accuracy: non-adjustable clock accuracy
@@ -471,7 +471,7 @@ struct clk *clk_register_fixed_rate(struct device *dev, const char *name,
  * the clock framework
  * @dev: device that is registering this clock
  * @name: name of this clock
- * @parent_name: name of clock's parent
+ * @parent_data: name of clock's parent
  * @flags: framework-specific flags
  * @fixed_rate: non-adjustable clock rate
  */
@@ -649,7 +649,7 @@ struct clk_div_table {
  * Clock with an adjustable divider affecting its output frequency.  Implements
  * .recalc_rate, .set_rate and .round_rate
  *
- * Flags:
+ * @flags:
  * CLK_DIVIDER_ONE_BASED - by default the divisor is the value read from the
  *	register plus one.  If CLK_DIVIDER_ONE_BASED is set then the divider is
  *	the raw value read from the register, with the value of zero considered
@@ -1130,11 +1130,12 @@ struct clk_hw *clk_hw_register_fixed_factor_parent_hw(struct device *dev,
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
@@ -1191,7 +1192,7 @@ void clk_hw_unregister_fractional_divider(struct clk_hw *hw);
  * Clock with an adjustable multiplier affecting its output frequency.
  * Implements .recalc_rate, .set_rate and .round_rate
  *
- * Flags:
+ * @flags:
  * CLK_MULTIPLIER_ZERO_BYPASS - By default, the multiplier is the value read
  *	from the register, with 0 being a valid value effectively
  *	zeroing the output clock rate. If CLK_MULTIPLIER_ZERO_BYPASS is
-- 
2.42.0



