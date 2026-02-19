Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD8BF30B50F;
	Thu, 19 Feb 2026 02:04:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771466699; cv=none; b=o8aS5C1ryTkdb2MRLxTmJ5YboUFGSNSBqE73TrdFJR8aFmGQKkb0aV+mhzG9E69ots4qyGX+TfKD7FCiPfi+Yqwb7aqfauatMDeu7WLMuWQnUEjj1/ZWEJZ0xJlQgf+8Eg7L5cjjUTiDMHcHeciNrWG2x6BvSpqPYfroMQ7B8I0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771466699; c=relaxed/simple;
	bh=VG/a/ERR2hcAd520CjwxeMsRARR+PAvUI+a5EbsPvTE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ScCsn04OsVDipFtimRNz5Cv03kFhIrGK29tY1WJ7rBtcYZ5hUTFPQlD2oHDusq3LxK62P6H/gG1CprbnZK3hM9dAzTMMmGwu45zg812KLleFkeTw611FClwJNO0/9GMkvbwxT7rS2bpMUroelCKLaZuJcDPgixm19qK7A6Qpd/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gOS/eSIC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gOS/eSIC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEF04C19422;
	Thu, 19 Feb 2026 02:04:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771466699;
	bh=VG/a/ERR2hcAd520CjwxeMsRARR+PAvUI+a5EbsPvTE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gOS/eSICkD1U/Ju2+ZCHxFP065w209fur+etkL4IG+u2PaaESLzeIj7bkHgYiDeTZ
	 OgADt9Ofl0sgNNN+XLgqiHXuZJwd+Pv83NpRgljat9+Rj1O8uebKws8aeRZ8JZJJjx
	 whWDlMkr7uf0cQecwh1qKr1oZ1DwjypoBA0I9aQN8s4OQ9e0VanIg3XIWil9cgoRD7
	 6y48GO9BCltSf2XOX3W7cN8lP09oljeklmNu8SxUHUh/dg7K+dnAdTr+aS+vLNo66l
	 J0kuO6IvlODBz6ehx4qKLE5d2LqECo2/I58Jo+2IbMcQkozpQLABgBHyu0Q/o+QIkR
	 jUm2D6KRx+dLA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: "Thomas Richard (TI.com)" <thomas.richard@bootlin.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-phy@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-6.12] phy: ti: phy-j721e-wiz: restore mux selection during resume
Date: Wed, 18 Feb 2026 21:04:04 -0500
Message-ID: <20260219020422.1539798-28-sashal@kernel.org>
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
Content-Transfer-Encoding: 8bit

From: "Thomas Richard (TI.com)" <thomas.richard@bootlin.com>

[ Upstream commit 53f6240e88c9e8715e09fc19942f13450db4cb33 ]

While suspend and resume mux selection was getting lost. So save and
restore these values in suspend and resume operations.

Signed-off-by: Thomas Richard (TI.com) <thomas.richard@bootlin.com>
Link: https://patch.msgid.link/20251216-phy-ti-phy-j721e-wiz-resume-restore-mux-sel-v1-1-771d564db966@bootlin.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Good. The current tree has the resume function but no suspend function
(the suspend slot is NULL), which matches the pre-patch state in the
diff.

## Analysis Summary

### What the commit does:

1. **Adds a new field** `mux_sel_status[WIZ_MUX_NUM_CLOCKS]` (3 ints) to
   the `struct wiz` to store mux selection state.

2. **Adds a `wiz_suspend_noirq()` callback** that reads the 3 mux
   selection values from hardware registers before suspend, saving them
   in the new array.

3. **Modifies `wiz_resume_noirq()`** to write the saved mux selection
   values back to hardware registers at the beginning of resume, before
   the rest of the initialization.

4. **Updates the PM ops macro** from
   `DEFINE_NOIRQ_DEV_PM_OPS(wiz_pm_ops, NULL, wiz_resume_noirq)` to
   `DEFINE_NOIRQ_DEV_PM_OPS(wiz_pm_ops, wiz_suspend_noirq,
   wiz_resume_noirq)`.

### Bug being fixed:

The mux clock selection values (which control how the SERDES reference
clocks are routed) are lost during suspend because the hardware state is
not preserved. On resume, `wiz_resume_noirq()` called `wiz_clock_init()`
and `wiz_init()`, but these re-initialize the clocks to default values
rather than restoring the user/driver-configured mux selections. This
means after resume, the SERDES PHY may not work correctly because the
clock routing is wrong.

### Classification: **Suspend/resume bug fix**

This is a real hardware bug that affects users who suspend and resume
systems using the TI J721E SERDES PHY (common in TI K3 SoC
automotive/industrial platforms). Without this fix, the PHY may not
function correctly after resume, potentially breaking network, PCIe,
USB, or other SERDES-based interfaces.

### Stable kernel rule compliance:

1. **Obviously correct and tested**: Simple save/restore pattern using
   existing regmap_field_read/write APIs. The author works at Bootlin
   for TI platforms.
2. **Fixes a real bug**: Mux selection lost after resume = broken PHY
   after suspend/resume.
3. **Important issue**: Broken hardware functionality after
   suspend/resume.
4. **Small and contained**: ~20 lines of new code, single file, simple
   logic.
5. **No new features**: Restoring state that was lost is a bug fix, not
   a feature.

### Risk assessment:

- **Very low risk**: The save/restore pattern is straightforward and
  well-understood.
- **WIZ_MUX_NUM_CLOCKS is 3**: Only 3 register reads and 3 register
  writes are added.
- **Uses existing regmap_field APIs**: No new infrastructure needed.
- **Only affects TI J721E platforms**: Cannot cause regressions on other
  platforms.
- **Only affects suspend/resume path**: Cannot affect boot or normal
  operation.

### Dependencies:

The resume support was added in commit `b5539abdd013f` (v6.11). The
`wiz_clock_init()` function split was in commit `3c4e13cf9ead7` (also
v6.11). So this fix is applicable to stable trees v6.11+, and possibly
v6.12.y and v6.13.y LTS trees if they exist.

## Verification

- **git log** confirmed the driver was first added in commit
  `091876cc355d6` (phy: ti: j721e-wiz: Add support for WIZ module
  present in TI J721E SoC)
- **git tag --contains** confirmed resume support (`b5539abdd013f`) was
  introduced in v6.11
- **git tag --contains** confirmed `wiz_clock_init()` split
  (`3c4e13cf9ead7`) was also introduced in v6.11
- **Grep for `WIZ_MUX_NUM_CLOCKS`** confirmed it is defined as 3, making
  the save/restore loop iterate only 3 times
- **Grep for `mux_sel_status`** confirmed the field does not yet exist
  in the working tree (commit not yet applied)
- **Grep for `wiz_resume_noirq`** confirmed the current code has resume
  handler but NULL suspend handler, matching the pre-patch state
- **Read of the mux_sel_field usage** (lines 1031, 1056, 1172) confirmed
  these fields control clock mux selection in the WIZ initialization
  path
- **Unverified**: Whether any downstream users (e.g., Android, embedded
  distros) have reported this specific suspend/resume issue. The commit
  message states the problem directly but doesn't include "Reported-by:"
  tags.

## Conclusion

This is a small, well-contained suspend/resume bug fix for the TI J721E
WIZ PHY driver. It fixes a real hardware issue where clock mux
selections are lost during suspend, rendering the SERDES PHY non-
functional after resume. The fix uses a standard save/restore pattern
with minimal code additions (~20 lines in a single file). The risk of
regression is very low since it only affects the suspend/resume path on
TI K3 platforms. It meets all stable kernel criteria.

**YES**

 drivers/phy/ti/phy-j721e-wiz.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/phy/ti/phy-j721e-wiz.c b/drivers/phy/ti/phy-j721e-wiz.c
index a8b440c6c46bb..ba31b0a1f7f79 100644
--- a/drivers/phy/ti/phy-j721e-wiz.c
+++ b/drivers/phy/ti/phy-j721e-wiz.c
@@ -393,6 +393,7 @@ struct wiz {
 	struct clk		*output_clks[WIZ_MAX_OUTPUT_CLOCKS];
 	struct clk_onecell_data	clk_data;
 	const struct wiz_data	*data;
+	int			mux_sel_status[WIZ_MUX_NUM_CLOCKS];
 };
 
 static int wiz_reset(struct wiz *wiz)
@@ -1654,11 +1655,25 @@ static void wiz_remove(struct platform_device *pdev)
 	pm_runtime_disable(dev);
 }
 
+static int wiz_suspend_noirq(struct device *dev)
+{
+	struct wiz *wiz = dev_get_drvdata(dev);
+	int i;
+
+	for (i = 0; i < WIZ_MUX_NUM_CLOCKS; i++)
+		regmap_field_read(wiz->mux_sel_field[i], &wiz->mux_sel_status[i]);
+
+	return 0;
+}
+
 static int wiz_resume_noirq(struct device *dev)
 {
 	struct device_node *node = dev->of_node;
 	struct wiz *wiz = dev_get_drvdata(dev);
-	int ret;
+	int ret, i;
+
+	for (i = 0; i < WIZ_MUX_NUM_CLOCKS; i++)
+		regmap_field_write(wiz->mux_sel_field[i], wiz->mux_sel_status[i]);
 
 	/* Enable supplemental Control override if available */
 	if (wiz->sup_legacy_clk_override)
@@ -1680,7 +1695,7 @@ static int wiz_resume_noirq(struct device *dev)
 	return ret;
 }
 
-static DEFINE_NOIRQ_DEV_PM_OPS(wiz_pm_ops, NULL, wiz_resume_noirq);
+static DEFINE_NOIRQ_DEV_PM_OPS(wiz_pm_ops, wiz_suspend_noirq, wiz_resume_noirq);
 
 static struct platform_driver wiz_driver = {
 	.probe		= wiz_probe,
-- 
2.51.0

