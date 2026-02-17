Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B4AD231A3B;
	Tue, 17 Feb 2026 01:01:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771290085; cv=none; b=Ivw5/197GdvQAf6X+ZW1jv/fnhDfR6kjAbcOOjQJ9eYUwTIASy7xF9xHvGk5LR6Zwrmo8XlzF2XQIyW3tuDOkYZH19n/EwOKPqSxBicjSjzmVPSytP09d5nmJQDb0cDoJWrBAnES6eJyNzS45w7nLET6n3MVxxwmvsyBD0EAraI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771290085; c=relaxed/simple;
	bh=3CQR8MNuLy3NsGjQSjNTddHYGKdbU4uYpOwzcupblxg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ucpbeOgW0iHSCGxjj8/CJdvn2vSRtoDFIh/0PmhbdEbUSeTqJ4mmf+mjamLrkBsDtuHFpZL5z+lXgcj/pqfTT4O1gj1GBb0OAhWdQ8YdGk5eubzMfAltvP1tYeqLkr1bBizf5Bf9ddKMO6Gi/nx0n96UJtzv4PlTHSx3lKyk5aY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Bwp48MMi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Bwp48MMi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D46A6C2BC87;
	Tue, 17 Feb 2026 01:01:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771290085;
	bh=3CQR8MNuLy3NsGjQSjNTddHYGKdbU4uYpOwzcupblxg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bwp48MMihd4Al5ZmBb87Sv8KwQ+2c4ApUINj/56l4mXnIWAagnXfdVj8+oPOdmjWS
	 XLhl0JT3dSeNtMHMaAk00BldL/EIAE1PF8Bf65ZpsIfzcBVPrO7jwoFoCI5HRi55ZX
	 C6PSli29FLb3zNn1UB1C9nxQK9SYSMh3hFiJvXBednk4Ne7VeAUVznVgL0+O9izm1H
	 DnsgSwjCacZ9HILf5+sfE8yyH0Y/pq+a7Ljwp/pzvT45Vr5tDzNZ+k2MC70J6rWoXB
	 vKjdz2Gt3ZX83NxwnyvN/gRmVSlbCR0PytP/iAn6onlcBC/TAL+Zfk7x4EsNhayAaS
	 CmzJLF9zcDSpw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Chuan Liu <chuan.liu@amlogic.com>,
	Jerome Brunet <jbrunet@baylibre.com>,
	Sasha Levin <sashal@kernel.org>,
	neil.armstrong@linaro.org,
	mturquette@baylibre.com,
	sboyd@kernel.org,
	khilman@baylibre.com,
	linux-amlogic@lists.infradead.org,
	linux-clk@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-6.18] clk: amlogic: remove potentially unsafe flags from S4 video clocks
Date: Mon, 16 Feb 2026 20:01:15 -0500
Message-ID: <20260217010118.3503621-4-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260217010118.3503621-1-sashal@kernel.org>
References: <20260217010118.3503621-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Chuan Liu <chuan.liu@amlogic.com>

[ Upstream commit 4aca7e92023cac5018b4053bae324450f884c937 ]

The video clocks enci, encp, vdac and hdmitx share the same clock
source. Adding CLK_SET_RATE_PARENT to the mux may unintentionally change
the shared parent clock, which could affect other video clocks.

Signed-off-by: Chuan Liu <chuan.liu@amlogic.com>
Link: https://lore.kernel.org/r/20250919-add_video_clk-v6-3-fe223161fb3f@amlogic.com
Signed-off-by: Jerome Brunet <jbrunet@baylibre.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Wait, this is very confusing. The mailing list says patch 2 adds new
clocks, but git blame shows these video clock muxes (`cts_enci_sel`,
`cts_encp_sel`, etc.) were already in the original commit from 2023. Let
me re-read the diff more carefully.

Looking at the diff again: the commit removes `CLK_SET_RATE_PARENT` from
`s4_cts_enci_sel`, `s4_cts_encp_sel`, `s4_cts_vdac_sel`, and
`s4_hdmi_tx_sel`. Git blame confirmed these structures were added in
`57b55c76aaf1b` (2023, v6.7). The patch 2 of the series adds **new**
clocks (encl, cdac, demod, adc), but the ones being **fixed** in patch 3
already existed.

This means patch 3 (our commit) is **self-contained** with respect to
the bug fix — it removes flags from clocks that already exist in stable
trees. It does NOT depend on patch 2.

## Final Analysis

### Problem Description
The `CLK_SET_RATE_PARENT` flag on the video clock mux selectors
(`cts_enci_sel`, `cts_encp_sel`, `cts_vdac_sel`, `hdmi_tx_sel`) allows
rate change requests to propagate from these muxes up to their shared
parent clock. Since all four muxes share the same parent clock sources
(vclk_div and vclk2_div families), any one of them requesting a rate
change could alter the parent, breaking the other video outputs.

### Impact Assessment
- **Real bug**: Yes — when one video output (e.g., HDMI) requests a
  clock rate change, it can modify the shared parent clock, causing
  other video outputs (CVBS, encoder) to use the wrong clock rate. This
  could result in display corruption or loss of video signal.
- **Scope**: Affects all Amlogic S4 SoC users with multiple active video
  outputs, since v6.7.
- **Severity**: Medium — display corruption/failure when multiple video
  outputs are active simultaneously.

### Stable Kernel Criteria Assessment
- **Obviously correct**: Yes — removing `CLK_SET_RATE_PARENT` from
  shared mux selectors is a well-understood pattern for preventing
  unintended parent clock modifications.
- **Fixes a real bug**: Yes — prevents unintended shared parent clock
  modification affecting other video clocks.
- **Small and contained**: Yes — removes 4 lines (flag declarations)
  from a single file.
- **No new features**: Correct — purely a bug fix.
- **Risk**: Very low — removing `CLK_SET_RATE_PARENT` means the mux
  won't propagate rate changes upward, which is the desired behavior for
  shared clock sources. The downstream gate clocks still have
  `CLK_SET_RATE_PARENT`, so rate requests still propagate from the gate
  to the mux; they just stop there instead of going further up.

### Concerns
- **Dependency check**: The fix is self-contained. The affected clock
  structures exist since v6.7 (commit `57b55c76aaf1b`). No dependency on
  other patches in the series.
- **Behavioral change**: Users who relied on `CLK_SET_RATE_PARENT`
  propagation through the mux to the parent might see different
  behavior, but this "reliance" was always incorrect since it could
  break other video outputs.

## Verification

- **git blame** confirmed `s4_cts_enci_sel`, `s4_cts_encp_sel`,
  `s4_cts_vdac_sel`, `s4_hdmi_tx_sel` with `CLK_SET_RATE_PARENT` were
  introduced in `57b55c76aaf1b` (v6.7, September 2023).
- **git tag --contains 57b55c76aaf1b** confirmed the buggy code is in
  v6.7+ and v6.12.y LTS.
- **lore.kernel.org** confirmed this is patch 3/3 of the "add video-
  related clocks for S4 SoC" series, accepted December 2025 by Jerome
  Brunet.
- **lore.kernel.org patch 2** confirmed patch 2 adds **different**
  clocks (encl, cdac, demod, adc), not the ones being fixed here — the
  fix is independent.
- **Code inspection** confirmed `s4_cts_encl_sel` already lacked
  `CLK_SET_RATE_PARENT` (consistent architecture — encl was already
  correct).
- **Code inspection** confirmed downstream gate clocks (`s4_cts_enci`,
  `s4_cts_encp`) retain `CLK_SET_RATE_PARENT`, so rate propagation still
  works from gate to mux but stops at the mux level.
- **Could NOT verify** any user reports of actual display corruption
  from this bug (unverified — but the mechanism is sound and the fix is
  obvious).

The fix is small, surgical, self-contained, fixes a real clock-tree
correctness issue affecting all Amlogic S4 users since v6.7, and carries
extremely low regression risk. It meets all stable kernel criteria.

**YES**

 drivers/clk/meson/s4-peripherals.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/clk/meson/s4-peripherals.c b/drivers/clk/meson/s4-peripherals.c
index 6d69b132d1e1f..bab4f5700de47 100644
--- a/drivers/clk/meson/s4-peripherals.c
+++ b/drivers/clk/meson/s4-peripherals.c
@@ -1106,7 +1106,6 @@ static struct clk_regmap s4_cts_enci_sel = {
 		.ops = &clk_regmap_mux_ops,
 		.parent_hws = s4_cts_parents,
 		.num_parents = ARRAY_SIZE(s4_cts_parents),
-		.flags = CLK_SET_RATE_PARENT,
 	},
 };
 
@@ -1122,7 +1121,6 @@ static struct clk_regmap s4_cts_encp_sel = {
 		.ops = &clk_regmap_mux_ops,
 		.parent_hws = s4_cts_parents,
 		.num_parents = ARRAY_SIZE(s4_cts_parents),
-		.flags = CLK_SET_RATE_PARENT,
 	},
 };
 
@@ -1138,7 +1136,6 @@ static struct clk_regmap s4_cts_vdac_sel = {
 		.ops = &clk_regmap_mux_ops,
 		.parent_hws = s4_cts_parents,
 		.num_parents = ARRAY_SIZE(s4_cts_parents),
-		.flags = CLK_SET_RATE_PARENT,
 	},
 };
 
@@ -1169,7 +1166,6 @@ static struct clk_regmap s4_hdmi_tx_sel = {
 		.ops = &clk_regmap_mux_ops,
 		.parent_hws = s4_hdmi_tx_parents,
 		.num_parents = ARRAY_SIZE(s4_hdmi_tx_parents),
-		.flags = CLK_SET_RATE_PARENT,
 	},
 };
 
-- 
2.51.0

