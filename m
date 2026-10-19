Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ED035B22E5;
	Mon, 19 Oct 2026 14:00:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418429; cv=none; b=UlMtaC0DYQB9OcCVgeujerhhODEpJB3kSnRMXCjXGV/mPz2cxydKFmllrgBj2Mz7UxWb57SScJPLlhmfBylT3tJd9CmVdCT3lVsDIEZbh+eoU/thg52MoGya45gC6VszorC/Wg848wVfVWkECYA5afCEz70Wd/qG/X7hbpEFnTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418429; c=relaxed/simple;
	bh=M3PzNG+O285to9tkI+ssnnxPTk7gn8r8kfAlSyeXO+E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hYlnoCK93FYqRfQD78zFOsP65Tf2zi33LR0F4CyC7PMdi0Uzc+eBtbWVRlM+H1Lj18X2J/oTxUU1SbgQdJrM+GVXxujC01OaVzaEuJVlpPq49iS6nc94IsB1hT0louGKF8c15go9wDBFmgQOomwZ/uvSZ3UMf1giSkxE2m/UJeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LfkFchot; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LfkFchot"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 196D61F000C4;
	Mon, 19 Oct 2026 14:00:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418427;
	bh=JacI1PS0XwMOWP778EnHVdGmIAyo9cuU52auPMAJsoE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LfkFchotC3QxoscvW1UDJoVgkWT4XWJUrj+aW9Q5Un4OJX3bwWnLMS+INDAgac/SP
	 Q060nztt6GHOKvvsW+4QERmfnPXkNVaQ2FSUuRhRcP4nikLvGSNcpQ0L9Mp/nUAmxd
	 A3VPaX33sThOT0IgqMcZYZVHgw8jN9wOZo8izP0vVlHJ5aTx/qBhkynEDGjk3lxnPJ
	 6ezA3LByQk0cnjLfhdeFh9AumjVmVRdli/AmU+oAKyK52tTnzzEvS/EOvf/bcOD4Rs
	 mSnVaUKIJ8i/SoobJhJERlSbIBYuQkO5bem1H6K/wNi9tNF/494dhYO5tSjyRwEcxE
	 1VP6j+ceuiE6Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>,
	khilman@baylibre.com,
	linux-arm-kernel@lists.infradead.org,
	linux-amlogic@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] soc: amlogic: meson-clk-measure: remove debugfs tree
Date: Mon, 19 Oct 2026 09:48:52 -0400
Message-ID: <20261019135441.1420968-241-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261019135441.1420968-1-sashal@kernel.org>
References: <20261019135441.1420968-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.57
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 67481152be2ec5de3529664c82054b43d6d4b9f5 ]

meson_msr_probe() creates a debugfs tree with entries that reference
devm-managed measurement table entries and the driver's private regmap
state. The driver has no remove callback, so unbinding the device can
leave those debugfs entries behind after the private data is released.

Store the debugfs root and remove the subtree from a new remove callback.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patch.msgid.link/20260615091531.21964-1-pengpeng@iscas.ac.cn
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit message forensics

**Step 1.1 — Subject**
- Record: `[soc: amlogic: meson-clk-measure]` `[remove]` `[tear down
  leftover debugfs on driver unbind]`

**Step 1.2 — Tags**
- `Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>` (Amlogic SoC
  maintainer; also committed the patch)
- `Link:
  https://patch.msgid.link/20260615091531.21964-1-pengpeng@iscas.ac.cn`
- `Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>` (author)
- `Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>`
  (maintainer)
- No `Fixes:`, no `Reported-by:`, no `Tested-by:`, no `Cc: stable`
  (absence is expected)
- No syzbot / bugzilla / CVE tags

**Step 1.3 — Body**
- Record: `[Bug: probe creates debugfs entries that point at devm-
  managed `msr_table` and private regmap state, but the driver had no
  remove callback.]`
- `[Symptom: after unbind, leftover debugfs files can be used after that
  memory is released.]`
- `[Version info: none in the message. Driver has existed since v5.0.]`
- `[Root cause: missing lifetime teardown for debugfs vs. devm-managed
  private data.]`

**Step 1.4 — Hidden bug fix?**
- Record: `[Not hidden. This is an explicit lifetime/UAF fix, even
  though the verb is "remove".]`

## Phase 2: Diff analysis

**Step 2.1 — Inventory**
- Record: `[drivers/soc/amlogic/meson-clk-measure.c: +14 / −0]`
- Functions: `struct meson_msr` (new `debugfs_root`),
  `meson_msr_probe()`, new `meson_msr_remove()`, `meson_msr_driver`
  table
- Scope: single-file surgical fix

**Step 2.2 — Code flow**
- Before: `meson_msr_probe()` builds `/sys/kernel/debug/meson-clk-msr/`
  (`measure_summary` plus per-clock files). File private data is
  `priv->data.msr_table` and `&priv->data.msr_table[i]`, with `.priv =
  priv`. `priv`, `msr_table`, `reg`, and `regmap` are all `devm_*`
  allocations. There was no `platform_set_drvdata()` and no `.remove`.
- After: root dentry is stored, `platform_set_drvdata()` is set, and
  `meson_msr_remove()` calls `debugfs_remove_recursive()` so the tree is
  gone before devres frees private data.
- Path: driver remove / module unload / sysfs unbind, not the normal
  measure path.

**Step 2.3 — Bug mechanism**
- Record: `[Use-after-free / leftover debugfs after unbind]`
- Mechanism: unbind runs `devres` teardown and frees `priv` /
  `msr_table` / `regmap`. Debugfs files remain. `clk_msr_summary_show()`
  does `msr_table->priv->data.msr_count`; `meson_measure_id()` then uses
  `priv->regmap` and `priv->data.reg`. That is a UAF if those files are
  read after unbind.
- Category (c)/(d): lifetime/refcount-style teardown; memory safety.

**Step 2.4 — Fix quality**
- Record: `[Obviously correct, minimal, standard pattern.]`
- `debugfs_remove()` itself already ignores `IS_ERR_OR_NULL`, so the
  extra check is redundant but harmless.
- `platform_set_drvdata()` is required for `platform_get_drvdata()` in
  remove.
- `.remove` is `void (*)(struct platform_device *)` in this tree,
  matching the new callback.
- Regression risk: low. `debugfs_remove()` uses
  `simple_recursive_removal()`, so in-flight file users are drained
  before return. No public API change.

## Phase 3: Git history

**Step 3.1 — Blame**
- Record: `[Buggy debugfs creation is from 2b45ebef39a2c ("soc: amlogic:
  Add Meson Clock Measure driver"), 2018-11-28, first in v5.0-rc1.]`
- The missing-remove bug is as old as the driver. Confirmed on the
  parent of the fix: no `platform_set_drvdata`, no `debugfs_root`, no
  remove callback.

**Step 3.2 — Fixes: tag**
- Record: `[No Fixes: tag. Introducer is 2b45ebef39a2c, present in this
  tree.]`

**Step 3.3 — File history**
- Record: `[Recent commits add SoC tables (A1/T7, S4, C3) and register-
  offset refactoring. None change debugfs lifetime.]`
- Standalone, not patch X/Y.

**Step 3.4 — Author**
- Record: `[Pengpeng Hou: only this commit on this driver.
  Reviewer/committer Neil Armstrong is the original driver author and
  Amlogic maintainer.]`

**Step 3.5 — Dependencies**
- Record: `[None. Uses existing `debugfs_create_dir` /
  `debugfs_remove_recursive` / `platform_set_drvdata`. Can apply
  standalone to this tree.]`

## Phase 4: Mailing list and external research

**Step 4.1 — Original discussion**
- Record: `[https://patch.msgid.link/20260615091531.21964-1-
  pengpeng@iscas.ac.cn]`
- `b4 dig -a`: only v1; that version was applied.
- Maintainer review: `Reviewed-by: Neil Armstrong`.
- Sashiko bot flagged a pre-existing probe-time race (`measure_summary`
  created before `.priv` is filled). Armstrong replied: “Impossible the
  driver is initialized way before userspace starts.” That race is not
  introduced by this patch and was not treated as a blocker.
- No NAK. No reviewer request for `Cc: stable`.

**Step 4.2 — Recipients (`b4 dig -w`)**
- Record: `[Neil Armstrong, Kevin Hilman, Jerome Brunet, Martin
  Blumenstingl, linux-amlogic, linux-arm-kernel, linux-kernel. Right
  maintainers were on the patch.]`

**Step 4.3 — Bug report**
- Record: `[No Reported-by / syzbot / bugzilla. Bug is from code
  inspection of lifetime mismatch.]`

**Step 4.4 — Series**
- Record: `[Standalone single patch. No follow-up on this file after
  67481152be2ec.]`

**Step 4.5 — Stable list**
- Record: `[UNVERIFIED: lore.kernel.org/stable returned HTTP 403.]`

## Phase 5: Code semantic analysis

**Step 5.1 — Functions**
- Record: `[meson_msr_probe, meson_msr_remove (new), meson_msr_driver;
  readers clk_msr_show / clk_msr_summary_show / meson_measure_id]`

**Step 5.2 — Callers**
- Record: `[probe/remove from the platform core on bind/unbind. Debugfs
  show via `DEFINE_SHOW_ATTRIBUTE`. `meson_msr_remove` is only the new
  driver `.remove`.]`

**Step 5.3 — Callees**
- Record: `[debugfs_create_dir/file, debugfs_remove_recursive,
  platform_set/get_drvdata, and on read: mutex + regmap MMIO.]`

**Step 5.4 — Reachability**
- Record: `[Yes. CONFIG_MESON_CLK_MEASURE is tristate, default y on
  ARCH_MESON. DT nodes exist for GX, Meson8/8b, AXG, G12A, SM1, C3, S4,
  A1, T7. Unbind is `rmmod meson-clk-measure` or sysfs unbind, then
  reading leftover debugfs. Typically root-only, but still a real kernel
  UAF.]`

**Step 5.5 — Similar patterns**
- Record: `[Same teardown exists in other SoC drivers (qcom
  smem/socinfo/aoss, ti smartreflex). This driver was the one missing
  it.]`

## Phase 6: This tree (v7.3-rc4)

**Step 6.1 — Does the buggy code exist here?**
- Record: `[Yes in this lineage. Driver is `drivers/soc/amlogic/meson-
  clk-measure.c`. Bug introduced in v5.0 (2b45ebef39a2c). This checkout
  is `v7.3-rc4-27-gf0100363d8c37` / 7.3.0-rc4. The fix landed in
  v7.3-rc1 (`git merge-base --is-ancestor 67481152be2ec v7.3-rc1`
  succeeded; it is not in v7.2).]`
- Current file already has `debugfs_root` and `meson_msr_remove()`. That
  is because the commit merged during 7.3; it is not a reason to treat
  the bug as never existing here.

**Step 6.2 — Backport difficulty**
- Record: `[Clean apply on this tree. Context matches. `.remove` is
  already void.]`

**Step 6.3 — Related fixes already here?**
- Record: `[This is the fix. No alternate teardown was present before
  it.]`

## Phase 7: Subsystem context

**Step 7.1**
- Record: `[Subsystem: drivers/soc/amlogic clock-measure debugfs helper.
  Criticality: PERIPHERAL (Amlogic-only, debugfs), but UAF is still a
  crash/memory-safety bug.]`

**Step 7.2**
- Record: `[Mature driver (2018). Recent work is new SoC tables, not
  lifetime redesign.]`

## Phase 8: Impact and risk

**Step 8.1 — Who is affected**
- Record: `[Amlogic Meson users with CONFIG_MESON_CLK_MEASURE and
  CONFIG_DEBUG_FS, after driver unbind/unload.]`

**Step 8.2 — Trigger**
- Record: `[Unbind or rmmod, then open leftover debugfs. Not a boot-hot
  path. Privileged in typical debugfs setups. Deterministic UAF, not a
  heisenrace.]`

**Step 8.3 — Failure mode**
- Record: `[UAF → oops / KASAN / possible memory corruption. Severity:
  HIGH.]`

**Step 8.4 — Risk-benefit**
- Record: `[Benefit: high for the affected unbind path (prevents UAF).
  Risk: very low (14 lines, standard debugfs teardown). Ratio favors
  taking the fix.]`

## Phase 9: Synthesis

**Step 9.1 — Evidence**

For:
- Real UAF: leftover debugfs vs. `devm` private data after unbind
- Small (+14), obviously correct
- Reviewed and applied by the subsystem maintainer
- Driver and bug exist in this 7.3 tree’s history since v5.0
- `MESON_CLK_MEASURE` is tristate, so module unload is a supported path
- Same teardown pattern used elsewhere in `drivers/soc/`

Against:
- No user/syzbot report
- Debugfs, typically root-only
- Amlogic-only helper, not core kernel
- Maintainer did not nominate stable

Unresolved:
- Could not search lore.kernel.org/stable (HTTP 403)

**Step 9.2 — Stable rules**
1. Obviously correct and tested? **PASS** — standard remove +
   `debugfs_remove_recursive`; maintainer Reviewed-by
2. Real bug affecting users? **PASS** — leftover debugfs after unbind is
   a UAF
3. Important (crash/security/corruption/deadlock)? **PASS** — UAF oops /
   memory-safety; HIGH, not a theoretical warning
4. Small and contained? **PASS** — 14 lines, one file
5. No new features/APIs? **PASS**
6. Applies to this tree? **PASS** — driver present, void `.remove`, no
   missing prereqs

**Step 9.3 — Exception category**
- Record: `[None. This is a normal bugfix, not a device-
  ID/quirk/DT/build/docs exception.]`

**Step 9.4 — Decision**
This tree is 7.3-rc4. The clock-measure driver is here, the missing-
remove UAF has been here since v5.0, and the patch is a small, correct
teardown. It meets stable criteria for this checkout.

### What it fixes and why it matters
`meson_msr_probe()` publishes debugfs files whose private pointers refer
to `devm`-allocated `priv` / `msr_table` / `regmap`. Without a remove
callback those dentries survive unbind, so a later read of
`measure_summary` or a per-clock file uses freed memory. On 7.3 that is
a real module-unload/unbind UAF on Amlogic boards that ship this IP.

### Stable rules / risk
The change is 14 lines, does not add APIs, and matches
`debugfs_remove()` semantics already used by sibling SoC drivers.
Benefit is preventing a UAF; regression risk is very low.

### Concerns
No public reproducer. Trigger is privileged debugfs/unbind. That lowers
breadth, not severity. No extra commits are required on this tree.

Verification:
- [Phase 1] Parsed tags: Reviewed-by Neil Armstrong; Link to msgid
  20260615091531.21964-1; no Fixes/Reported-by/Cc:stable
- [Phase 2] Diff: +14 in meson-clk-measure.c; store debugfs root, set
  drvdata, add void remove
- [Phase 2] Pre-fix parent 67481152be2ec^: no platform_set_drvdata, no
  debugfs_root, no remove
- [Phase 2] clk_msr_summary_show uses msr_table->priv; meson_measure_id
  uses priv->regmap — UAF after unbind confirmed
- [Phase 3] git blame: debugfs create from 2b45ebef39a2c (v5.0-rc1)
- [Phase 3] git describe HEAD: v7.3-rc4-27-gf0100363d8c37; Makefile
  7.3.0-rc4
- [Phase 3] git merge-base --is-ancestor 67481152be2ec v7.3-rc1: yes;
  not in v7.2
- [Phase 4] b4 dig -c 67481152be2ec:
  https://patch.msgid.link/20260615091531.21964-1-pengpeng@iscas.ac.cn
- [Phase 4] b4 dig -a: v1 only, applied as-is
- [Phase 4] b4 dig -w: Armstrong, Hilman, Brunet, Blumenstingl, linux-
  amlogic
- [Phase 4] mbox: Armstrong Reviewed-by; dismissed sashiko probe-race as
  pre-existing/impossible
- [Phase 5] Kconfig MESON_CLK_MEASURE tristate default ARCH_MESON; DT
  compatibles in meson-gx/g12/axg/sm1/s4/a1/t7/c3 dtsi
- [Phase 5] platform_driver.remove is void (*)(struct platform_device *)
  in include/linux/platform_device.h:280
- [Phase 5] debugfs_remove() already IS_ERR_OR_NULL-safe
  (fs/debugfs/inode.c:778)
- [Phase 6] File present; no later changes on this file after the fix
- [Phase 8] Failure mode: UAF on leftover debugfs after unbind, severity
  HIGH
- UNVERIFIED: lore.kernel.org/stable search (HTTP 403)

**YES**

 drivers/soc/amlogic/meson-clk-measure.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/soc/amlogic/meson-clk-measure.c b/drivers/soc/amlogic/meson-clk-measure.c
index d862e30a244ed..7ca43bcb622a2 100644
--- a/drivers/soc/amlogic/meson-clk-measure.c
+++ b/drivers/soc/amlogic/meson-clk-measure.c
@@ -7,6 +7,7 @@
 #include <linux/of_address.h>
 #include <linux/platform_device.h>
 #include <linux/bitfield.h>
+#include <linux/err.h>
 #include <linux/seq_file.h>
 #include <linux/debugfs.h>
 #include <linux/regmap.h>
@@ -50,6 +51,7 @@ struct meson_msr_data {
 struct meson_msr {
 	struct regmap *regmap;
 	struct meson_msr_data data;
+	struct dentry *debugfs_root;
 };
 
 #define CLK_MSR_ID(__id, __name) \
@@ -952,6 +954,7 @@ static int meson_msr_probe(struct platform_device *pdev)
 	       sizeof(struct msr_reg_offset));
 
 	root = debugfs_create_dir("meson-clk-msr", NULL);
+	priv->debugfs_root = root;
 	clks = debugfs_create_dir("clks", root);
 
 	debugfs_create_file("measure_summary", 0444, root,
@@ -967,9 +970,19 @@ static int meson_msr_probe(struct platform_device *pdev)
 				    &priv->data.msr_table[i], &clk_msr_fops);
 	}
 
+	platform_set_drvdata(pdev, priv);
+
 	return 0;
 }
 
+static void meson_msr_remove(struct platform_device *pdev)
+{
+	struct meson_msr *priv = platform_get_drvdata(pdev);
+
+	if (!IS_ERR_OR_NULL(priv->debugfs_root))
+		debugfs_remove_recursive(priv->debugfs_root);
+}
+
 static const struct msr_reg_offset msr_reg_offset = {
 	.duty_val = 0x0,
 	.freq_ctrl = 0x4,
@@ -1065,6 +1078,7 @@ MODULE_DEVICE_TABLE(of, meson_msr_match_table);
 
 static struct platform_driver meson_msr_driver = {
 	.probe	= meson_msr_probe,
+	.remove = meson_msr_remove,
 	.driver = {
 		.name		= "meson_msr",
 		.of_match_table	= meson_msr_match_table,
-- 
2.53.0

