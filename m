Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CDE1311C27;
	Thu, 19 Feb 2026 02:05:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771466711; cv=none; b=KaBh9GFGvvOnLADnOSuvzmW7OJ2UWEGZglMW+qW38gNdH5cp2XQrxbHTdFHFssoHVlNjSBeZBFcsa/6AOxmQxbYAYs8POElw02hUpRw6uo77zPea8wf0iT7+gUcSmdxlmRQa5oK2SKFnFy5I62qnBBkorkJSwLZRvndakR/XjlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771466711; c=relaxed/simple;
	bh=Z3fUAAbQXGFdlQbONURw12JtANNmbkXVjuTdQg/02uw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tZzs3ob3Y+UgAUIvNBDzlWstH52zT6/eJyNymrUjqokdfaxYnvIbx3tfmrwcJlB6RWv49wg5sHe+Y4a0xjhcAs6/8Ix0DLO4B7iqHu4I9QRLGtEzzVbqveIiVATe88njpf6HKphybSHZmY9kuTy9bEnL9T9bmhVog7ekAnKxKs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OudGccxz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OudGccxz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74221C116D0;
	Thu, 19 Feb 2026 02:05:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771466711;
	bh=Z3fUAAbQXGFdlQbONURw12JtANNmbkXVjuTdQg/02uw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OudGccxzoq3dLyhQEh3ItVzmP3YhMYEOoLmeFHFmYR7095oN8hnhUn3wGwsmIM6UN
	 7EEeoe0LW3hG2N0GkW4nqO50+FRvlyH/xUyko+eJei4SOs5qU/WPxVhR++XCxkJ0Fl
	 o+IBPWqMbZIYXFRAoIK4KdZ9LKBII2+J0NcgQOCD+Py3ovENQO2dEdLF26TBUXTQVe
	 mTU9ppciJrOOwVjF6wCSjuWF4FcdqKusZrkf8rOCB931H4Z2Nc81RvmJLv4frjQOTf
	 Vx+auLD/LmTGRfJH3I6ZW+7fCPgqgwyV143lU08Nw1Hw33OJdNHCgk5HCqowXIOIuV
	 yAeTo/tW+PXPQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Aleksandar Gerasimovski <aleksandar.gerasimovski@belden.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-phy@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-5.15] phy: mvebu-cp110-utmi: fix dr_mode property read from dts
Date: Wed, 18 Feb 2026 21:04:13 -0500
Message-ID: <20260219020422.1539798-37-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260219020422.1539798-1-sashal@kernel.org>
References: <20260219020422.1539798-1-sashal@kernel.org>
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

From: Aleksandar Gerasimovski <aleksandar.gerasimovski@belden.com>

[ Upstream commit e2ce913452ab56b3330539cc443b97b7ea8c3a1a ]

The problem with the current implementation is that it does not consider
that the USB controller can have multiple PHY handles with different
arguments count, as for example we have in our cn9131 based platform:
"phys = <&cp0_comphy1 0>, <&cp0_utmi0>;".

In such case calling "of_usb_get_dr_mode_by_phy" with -1 (no phy-cells)
leads to not proper phy detection, taking the "marvell,cp110-utmi-phy"
dts definition we can call the "of_usb_get_dr_mode_by_phy" with 0
(#phy-cells = <0>) and safely look for that phy.

Signed-off-by: Aleksandar Gerasimovski <aleksandar.gerasimovski@belden.com>
Link: https://patch.msgid.link/20260106150643.922110-1-aleksandar.gerasimovski@belden.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have a clear understanding of the bug. Let me verify the behavior
difference more carefully:

## Understanding the Bug

When `arg0 = -1`:
- The function uses `of_parse_phandle()` (line 303-306), which simply
  returns the nth phandle node **without** parsing `#phy-cells`. It sets
  `args.args_count = 0`.
- The matching at line 316-317: `args.np == np && (args.args_count == 0
  || args.args[0] == arg0)` — since `args_count = 0`, it matches on the
  `np` comparison alone.

The problem: When the controller has `phys = <&cp0_comphy1 0>,
<&cp0_utmi0>;`, there are two phandle entries. The first (`cp0_comphy1`)
has `#phy-cells = <1>` (it takes argument `0`), and the second
(`cp0_utmi0`) has `#phy-cells = <0>`.

With `arg0 = -1`, `of_parse_phandle()` is used, which doesn't understand
`#phy-cells`. It simply iterates through raw phandle entries. Since
`cp0_comphy1` has an extra cell (`0`), `of_parse_phandle()` at index 0
returns `cp0_comphy1`, at index 1 it might return the `0` argument cell
(not a valid phandle) rather than `cp0_utmi0`. This leads to incorrect
PHY matching — the function can't properly find the UTMI PHY when mixed
`#phy-cells` counts are present.

With `arg0 = 0`:
- The function uses `of_parse_phandle_with_args()` (line 307-312), which
  correctly parses `#phy-cells` for each phandle and properly skips over
  argument cells. This means index 0 correctly refers to `cp0_comphy1`
  (with its argument `0`) and index 1 correctly refers to `cp0_utmi0`.
- At line 316-317: for `cp0_utmi0`, `args.args_count = 0` (since `#phy-
  cells = <0>`), so the match succeeds correctly.

This is a real functional bug fix — on platforms with mixed PHY types,
the UTMI PHY won't be correctly identified for its dual-role mode,
potentially causing the USB port to be configured incorrectly
(defaulting to HOST mode with a warning instead of detecting the correct
mode).

## Stable Kernel Criteria Assessment

1. **Fixes a real bug**: Yes — on cn9131-based platforms (and likely
   others) with mixed PHY types, the UTMI PHY dr_mode detection fails,
   leading to incorrect USB configuration.

2. **Obviously correct and tested**: The fix is a one-line change from
   `-1` to `0`. The commit author is from Belden (likely has the
   hardware). The change matches the documented `#phy-cells = <0>` for
   this PHY type. Using `of_parse_phandle_with_args()` (triggered by
   arg0 >= 0) is the correct approach when different PHYs have different
   `#phy-cells` counts.

3. **Small and contained**: Single character change in one file. Minimal
   risk.

4. **No new features**: This is purely a bug fix.

5. **User impact**: Without this fix, USB dual-role mode detection fails
   on affected platforms. The PHY defaults to HOST mode when it might
   need to be PERIPHERAL mode (or vice versa), which means USB
   functionality is broken for those configurations.

## Risk Assessment

- **Risk**: Extremely low. The change from `-1` to `0` for a PHY with
  `#phy-cells = <0>` is semantically equivalent for single-PHY
  configurations. For multi-PHY configurations with mixed `#phy-cells`,
  it's a correctness fix.
- **Regression potential**: Very low. The `of_parse_phandle_with_args()`
  path is well-tested across the kernel. The only behavior change is
  that mixed-PHY configurations now work correctly.
- **Scope**: Single driver, single line, Marvell ARM platform specific.

## Verification

- **Function `of_usb_get_dr_mode_by_phy` analyzed**: Read the
  implementation at `drivers/usb/common/common.c:290-331`. Verified that
  `arg0 = -1` uses `of_parse_phandle()` (no `#phy-cells` awareness)
  while `arg0 >= 0` uses `of_parse_phandle_with_args()` (proper `#phy-
  cells` parsing).
- **Device tree binding confirmed**: The Explore agent verified that
  `Documentation/devicetree/bindings/phy/marvell,armada-cp110-utmi-
  phy.yaml` specifies `#phy-cells: const: 0`, meaning arg0 = 0 is the
  correct semantic match.
- **Driver history verified**: `git log` shows the driver was introduced
  in commit `2fc989f74b8da` ("drivers: phy: add support for Armada CP110
  UTMI PHY"), and the `-1` argument has been there since inception. The
  file has had only 3 subsequent commits before this fix, none related
  to dr_mode.
- **Matching logic verified**: At line 316-317, when `args.args_count ==
  0` (which is the case for `#phy-cells = <0>`), the match succeeds on
  `args.np == np` alone, so the value `0` doesn't cause a spurious
  mismatch.
- **Bug mechanism verified**: With mixed `#phy-cells` (e.g., `phys =
  <&cp0_comphy1 0>, <&cp0_utmi0>`), `of_parse_phandle()` (used with
  arg0=-1) doesn't account for the argument cell `0` after
  `cp0_comphy1`, leading to incorrect phandle indexing.

## Conclusion

This is a clear, minimal, one-line bug fix for incorrect device tree PHY
matching on Marvell CP110 UTMI platforms. It fixes a real functional
issue (incorrect USB dual-role mode detection) that affects users with
mixed-PHY configurations. The fix is obviously correct, has near-zero
regression risk, and follows the established pattern used by other PHY
drivers.

**YES**

 drivers/phy/marvell/phy-mvebu-cp110-utmi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/phy/marvell/phy-mvebu-cp110-utmi.c b/drivers/phy/marvell/phy-mvebu-cp110-utmi.c
index 59903f86b13f5..dd3e515a8e865 100644
--- a/drivers/phy/marvell/phy-mvebu-cp110-utmi.c
+++ b/drivers/phy/marvell/phy-mvebu-cp110-utmi.c
@@ -338,7 +338,7 @@ static int mvebu_cp110_utmi_phy_probe(struct platform_device *pdev)
 			return -ENOMEM;
 		}
 
-		port->dr_mode = of_usb_get_dr_mode_by_phy(child, -1);
+		port->dr_mode = of_usb_get_dr_mode_by_phy(child, 0);
 		if ((port->dr_mode != USB_DR_MODE_HOST) &&
 		    (port->dr_mode != USB_DR_MODE_PERIPHERAL)) {
 			dev_err(&pdev->dev,
-- 
2.51.0

