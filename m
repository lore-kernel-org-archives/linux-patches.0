Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF0BD2FB99A;
	Sat, 25 Oct 2025 16:27:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409654; cv=none; b=NU3b3ykYat5GgFeZx+RJMmd3f6wT45VsiNaFHBeLXmllKercP+ZDKx1I5N7GzL8iV+TZsJFctvmxk2mWRR71MVnjwixaDI5KMNIDTe0sIBNxAiDxVY7AD1gOD0bAOFGRz+rJFf9xRDCiTMxMdltNE19BbpgHhAxETWtmQ9GQcTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409654; c=relaxed/simple;
	bh=LGTWECTp9Sr1VtKfiq6kQy/0KDcz9C8xFM34r9ANKFg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=prFnJ7yElnVnyd3gAqO+QcpmONEfPORv0TaV+avGZqxKQxGRMtsBn8l1JsBAk+RIJ2jvhzjltRqDYDYOip9cW4QoqLnYHKDJxCVP9yMAhTwec9PSQ9mWn92L7GLyTxBmUKEiE2l1+ikUnsaGRsMit8YZ2nzMpT1xuCma0LKKPn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rZpZ9uuy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rZpZ9uuy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ADBEC4CEFB;
	Sat, 25 Oct 2025 16:27:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409654;
	bh=LGTWECTp9Sr1VtKfiq6kQy/0KDcz9C8xFM34r9ANKFg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rZpZ9uuyV/XlBxPKJ850UNKZkmpHnuWKKtsPe+aX7n1HG3EN2NGlYH7NFJpwAeIiv
	 icdIzBZ1BZf9KHNt+tGIzlnUnVHJkIHzOu3nq3GGb8aVfZaHlwCKFTUZrrQ6OZ+LIj
	 j1mi3Y4y3cgFcCoRpypYAUCJBW7XFUySLBDj965q3LhhDqf5arkDUJ3z+dTigQG48d
	 fVWWS9+PiqW4idJ5IA0ePabZTBEOIx6ZChmYfK6Max8+lNuSwXg4sb7N1NZyvx0ix4
	 5+UJK5h+k2evd7DT8EoYKszzcgRbecWd8N3WFvjQdnFVC+/LxQJMPgLxgoCG85yDwh
	 NKVy+Ob7czTTg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Harikrishna Shenoy <h-shenoy@ti.com>,
	Udit Kumar <u-kumar1@ti.com>,
	Devarsh Thakkar <devarsht@ti.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	tomi.valkeinen@ideasonboard.com,
	aradhya.bhatia@linux.dev,
	alexandre.f.demers@gmail.com
Subject: [PATCH AUTOSEL 6.17-5.4] phy: cadence: cdns-dphy: Enable lower resolutions in dphy
Date: Sat, 25 Oct 2025 12:00:38 -0400
Message-ID: <20251025160905.3857885-407-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Harikrishna Shenoy <h-shenoy@ti.com>

[ Upstream commit 43bd2c44515f8ee5c019ce6e6583f5640387a41b ]

Enable support for data lane rates between 80-160 Mbps cdns dphy
as mentioned in TRM [0] by setting the pll_opdiv field to 16.
This change enables lower resolutions like 640x480 at 60Hz.

[0]: https://www.ti.com/lit/zip/spruil1
(Table 12-552. DPHY_TX_PLL_CTRL Register Field Descriptions)

Reviewed-by: Udit Kumar <u-kumar1@ti.com>
Reviewed-by: Devarsh Thakkar <devarsht@ti.com>
Signed-off-by: Harikrishna Shenoy <h-shenoy@ti.com>
Link: https://lore.kernel.org/r/20250807052002.717807-1-h-shenoy@ti.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

- What it fixes
  - The driver rejected valid MIPI D‑PHY HS lane rates between 80–160
    Mbps, preventing low‑resolution modes (e.g., 640x480@60) from
    working on Cadence D‑PHY based platforms, despite both the MIPI
    D‑PHY spec and the SoC TRM allowing them. This commit corrects that
    oversight by:
    - Lowering the minimum accepted data lane rate from 160 Mbps to 80
      Mbps in `cdns_dphy_get_pll_cfg()` at `drivers/phy/cadence/cdns-
      dphy.c:139`.
    - Selecting a valid PLL output divider for that range (`pll_opdiv =
      16`) at `drivers/phy/cadence/cdns-dphy.c:149-150`.
  - The rest of the driver already assumes support starting at 80 Mbps:
    `cdns_dphy_tx_get_band_ctrl()` uses `tx_bands[]` that includes 80 as
    the first entry (`drivers/phy/cadence/cdns-dphy.c:112-116`), so the
    prior 160 Mbps lower bound was internally inconsistent and caused
    configuration to fail early in `cdns_dphy_get_pll_cfg()` even when
    band selection supported 80.

- Change details and correctness
  - Input validation: `dlane_bps` lower bound is relaxed to `80000000UL`
    at `drivers/phy/cadence/cdns-dphy.c:139` to align with MIPI D‑PHY
    minimum rates and the TI TRM reference.
  - Divider selection: A new branch assigns `pll_opdiv = 16` for `80–160
    Mbps` at `drivers/phy/cadence/cdns-dphy.c:149-150`. Existing
    branches for higher rates remain unchanged, so behavior above 160
    Mbps is unaffected.
  - Register programming paths accept the new divider without format
    changes:
    - Reference IP path writes `OPDIV` directly via
      `DPHY_CMN_OPDIV(cfg->pll_opdiv)` at `drivers/phy/cadence/cdns-
      dphy.c:220-223`.
    - TI J721e path writes `OPDIV` via
      `FIELD_PREP(DPHY_TX_J721E_WIZ_OPDIV, cfg->pll_opdiv)` at
      `drivers/phy/cadence/cdns-dphy.c:256-259`. The field width
      supports values >= 16, so `16` encodes safely.
  - Feedback/rounding: The computed `pll_fbdiv` remains within `u16`
    range and the effective `hs_clk_rate` is returned back to the
    framework (`drivers/phy/cadence/cdns-dphy.c:152-158`), preserving
    existing rounding behavior.

- Why this is a good stable candidate
  - User‑visible bug fix: Without this change, valid and common
    low‑bandwidth display modes fail with `-EINVAL` during PHY
    configuration, even though the platform and spec support them.
  - Small, contained change: A few lines in one function in a single
    driver. No architectural rework.
  - Low regression risk:
    - No impact to configurations ≥160 Mbps.
    - The new range is guarded by the same band table already present
      and validated (`drivers/phy/cadence/cdns-dphy.c:327-343`), and
      global MIPI D‑PHY validation still runs before driver‑specific
      logic (`drivers/phy/cadence/cdns-dphy.c:313-321` and
      drivers/phy/phy-core-mipi-dphy.c).
    - Both register programming paths simply consume the new `pll_opdiv`
      value with no changes in encoding.
  - Spec and TRM alignment: Matches MIPI D‑PHY minimum data rate and the
    referenced TI TRM guidance to use `OPDIV=16` for 80–160 Mbps.

- Stable policy fit
  - Fixes an important functional gap (inability to drive valid low‑rate
    modes).
  - Minimal and localized changes with clear intent and references.
  - No new features or ABI changes; just enabling spec‑compliant
    operation previously blocked by the driver.

Given the above, this is an appropriate and low‑risk backport to stable
kernel trees.

 drivers/phy/cadence/cdns-dphy.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/phy/cadence/cdns-dphy.c b/drivers/phy/cadence/cdns-dphy.c
index de5389374d79d..1bd986cba8f7f 100644
--- a/drivers/phy/cadence/cdns-dphy.c
+++ b/drivers/phy/cadence/cdns-dphy.c
@@ -145,7 +145,7 @@ static int cdns_dsi_get_dphy_pll_cfg(struct cdns_dphy *dphy,
 
 	dlane_bps = opts->hs_clk_rate;
 
-	if (dlane_bps > 2500000000UL || dlane_bps < 160000000UL)
+	if (dlane_bps > 2500000000UL || dlane_bps < 80000000UL)
 		return -EINVAL;
 	else if (dlane_bps >= 1250000000)
 		cfg->pll_opdiv = 1;
@@ -155,6 +155,8 @@ static int cdns_dsi_get_dphy_pll_cfg(struct cdns_dphy *dphy,
 		cfg->pll_opdiv = 4;
 	else if (dlane_bps >= 160000000)
 		cfg->pll_opdiv = 8;
+	else if (dlane_bps >= 80000000)
+		cfg->pll_opdiv = 16;
 
 	cfg->pll_fbdiv = DIV_ROUND_UP_ULL(dlane_bps * 2 * cfg->pll_opdiv *
 					  cfg->pll_ipdiv,
-- 
2.51.0

