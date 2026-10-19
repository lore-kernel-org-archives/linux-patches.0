Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23F4A61DA79;
	Mon, 19 Oct 2026 14:04:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418667; cv=none; b=bww87Xdn0yepiR3r/MnsOs3dI/r3gQ2IH+UjQveTUz2WwW5z/nIc2mpTKSf8mJAoF1WcOgcANi2ixvihdK0g7dJkEY6KXKDRmMl+67s5Xbn0ZaF24+PJPuufdHR920tY46QrwWdWWAaDwxR4Rm7kIdsjo5EAm2OjwtLgdcRrjbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418667; c=relaxed/simple;
	bh=Xa/7laRkhtSqx6fA/C4Claq8lVDYzuobGSO2IEk9o58=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BwUd2P3Rgwp9yzxiQVdnUvXaesRi9OB550eqEdejao8ed8JdyiqapJaxhTmhHGVBqowW6OM2mgGK0BsNrCVTALHTLuz2FoV/thV+ZFkoVggjdmViCRvaLUtSkSX6K3zs7afQBAfLgoEyuRv+mRV5kTLIBYfTh5rmnw6uugtxav0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n4Xa0uom; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n4Xa0uom"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C4001F000C6;
	Mon, 19 Oct 2026 14:04:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418665;
	bh=wPLsolSHy5G3t1s/OeGFs3ZlIn1jgnWjkEOthznxXEU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n4Xa0uomWZ2BJqXHPE3NjziLZR3wq4284HX0DgJLYMnGksIipt3+QtchCZIsO6x91
	 SeF+cHAqtdTMK0ttYBN3c+3h8MjOpTkIUkZ+DDFMj0YS7hBGtPPbNaInYmu2yllBU9
	 fMl/gJJZKnIWOTHqOzHPoKftLHLTNLrhcZtefvpcKn+D9aTgkgkXSOo9dVs4ABY9rN
	 ZEddKAx+jQq81P9XCwrD2gD71l6XQbSE7BzLLsp6Y1CNWzmv+Q90OHW5uExiXHT/km
	 5ssXCzYTJ2YGbrzQs2UTPtp3UD0s1eAVVnzKstzp+hwWhVRQq+O0NNB4yJosBIgORn
	 HiodOOU6ETUcg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Kry=C5=A1tof=20=C4=8Cern=C3=BD?= <cleverline1mc@gmail.com>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] w1: ds2482: add OF device match table
Date: Mon, 19 Oct 2026 09:51:41 -0400
Message-ID: <20261019135441.1420968-410-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261019135441.1420968-1-sashal@kernel.org>
References: <20261019135441.1420968-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.57
Content-Transfer-Encoding: 8bit

From: Kryštof Černý <cleverline1mc@gmail.com>

[ Upstream commit 53f33fd74d3993af0fbb5494b5be709f6ca6b712 ]

Add an of_device_id table and hook it into the i2c driver so the
ds2482/ds2484 can be matched and auto-probed from Device Tree.

This allows automatic module loading when instantiated via DT.

Signed-off-by: Kryštof Černý <cleverline1mc@gmail.com>
Link: https://patch.msgid.link/20260612-w1-of-autoload-v1-1-74e8a17626e6@gmail.com
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The local tree is **6.18.y** (`v6.18.53` / `make kernelversion` =
6.18.53). At `v6.18.53` the ds2482 driver, DT binding, and Tarragon DTS
already exist, but the OF match table does not. This patch is the
missing device-ID/autoload piece for that existing hardware.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: PARSE THE SUBJECT LINE**
Record: **[w1/ds2482] [add] [OF `of_device_id` table so ds2482/ds2484
match and autoload from Device Tree]**

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
Record:
- **Link:** `https://patch.msgid.link/20260612-w1-of-
  autoload-v1-1-74e8a17626e6@gmail.com`
- **Signed-off-by:** Kryštof Černý `<cleverline1mc@gmail.com>` (author)
- **Signed-off-by:** Krzysztof Kozlowski `<krzk@kernel.org>` (W1
  maintainer; applied the patch)
- No `Fixes:`, `Reported-by:`, `Tested-by:`, `Reviewed-by:`, `Acked-
  by:`, or `Cc: stable` (absence of the last two is expected for this
  review)
- Pipeline-only tags ignored: `[Upstream commit
  53f33fd74d3993af0fbb5494b5be709f6ca6b712]`, Sasha Levin SOB

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Record:
- **Bug:** ds2482/ds2484 described in DT with `maxim,ds2482` /
  `maxim,ds2484` do not autoload the module.
- **Symptom:** 1-wire master never binds unless the module is loaded by
  hand or built-in.
- **Root cause (author):** no `of_device_id` table, so OF matching and
  OF module aliases are missing.
- **Version info:** none in the message. Upstream date is 12 Jun 2026
  (after 6.18); this is a backport candidate into 6.18.y.

Cover-letter text (after `---`, not in the git body) is more explicit:
without the OF table, “the driver is not matched because no of_device_id
table is registered.” That is **partly overstated** for bind-after-load
(see Phase 5); the autoload failure is real.

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: **Not a disguised cleanup.** It is an explicit hardware-
match/autoload fix: add OF IDs to an existing I2C driver. Same class as
PCI/USB/ACPI ID additions.

---

## PHASE 2: DIFF ANALYSIS

**Step 2.1: INVENTORY THE CHANGES**
Record:
- **File:** `drivers/w1/masters/ds2482.c` — **+8 / -0**
- **Added:** `ds2482_of_match[]`, `MODULE_DEVICE_TABLE(of,
  ds2482_of_match)`
- **Changed:** `ds2482_driver.driver.of_match_table`
- **Scope:** single-file surgical ID table; no probe/remove logic change

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Record:
- **Before:** driver only has `i2c_device_id` (`ds2482`, `ds2484`) and
  `MODULE_DEVICE_TABLE(i2c, ...)`. `of_match_table` is NULL.
- **After:** same probe/remove; OF compatible strings `maxim,ds2482` /
  `maxim,ds2484` are advertised and hooked into the I2C driver.
- **Path affected:** DT instantiation / module autoload, not the 1-wire
  transfer path.

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Record: **[Hardware IDs / OF autoload]**
Verified I2C/OF behavior in this tree:
- `i2c_device_uevent()` (`drivers/i2c/i2c-core-base.c`) calls
  `of_device_uevent_modalias()` first. If the client has an `of_node`,
  that succeeds and **no** `i2c:` `MODALIAS` is added.
- `of_modalias()` emits `of:N<name>T<type>C<compatible>` (e.g.
  `Cmaxim,ds2484`).
- `MODULE_DEVICE_TABLE(i2c, ds2482_id)` only produces `i2c:ds2482` /
  `i2c:ds2484`, which do **not** match that OF alias.
- Once the module **is** loaded, `i2c_device_match()` still falls
  through to `i2c_match_id()`; DT `client->name` is filled by
  `of_alias_from_compatible()` (`maxim,ds2484` → `ds2484`). So bind
  works if someone `modprobe`s. The break is **coldplug autoload**.

**Step 2.4: ASSESS THE FIX QUALITY**
Record: **Obviously correct, minimal.** Compatible strings match
`Documentation/devicetree/bindings/w1/maxim,ds2482.yaml`. `of_device_id`
comes from `linux/mod_devicetable.h` via `linux/i2c.h`; no extra
include. Probe is unchanged. Regression risk is **very low** (autoload
of an already-supported driver).

---

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: BLAME THE CHANGED LINES**
Record: At `v6.18.53` there is **no** OF table. Surrounding
`i2c_device_id` / `i2c_driver` date to `50fa2951bd744d` (2017). DS2484
I2C ID: `58ecb03fc74a5` (6 Apr 2023). DT binding: `22ab6c515d960` (same
day, same series). The omission is the binding-without-OF-table gap
since **2023**, well before 6.18.

**Step 3.2: FOLLOW THE FIXES: TAG**
Record: **No `Fixes:` tag.** Not applicable. Buggy state is long-
standing missing OF aliases, not a recent regression commit.

**Step 3.3: CHECK FILE HISTORY**
Record (this tree, `-- drivers/w1/masters/ds2482.c`):
- `172f24df0dab4` signedness fix (in 6.18)
- `6e0bb206c6af6` regulator support (in 6.18)
- `58ecb03fc74a5` DS2484 I2C ID (in 6.18)
Standalone; series name is `w1-of-autoload-v1-1` (**1/1**). No
prerequisite refactor.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Record: Author is a contributor, not the W1 maintainer. Other ds2482
work includes regulator support and a datasheet URL fix. **Krzysztof
Kozlowski** is `MAINTAINERS` owner for `W1 DALLAS'S 1-WIRE BUS` and
applied this patch.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Record: **None.** Uses existing `of_device_id` / `MODULE_DEVICE_TABLE` /
`i2c_driver.of_match_table`. Compatible strings already documented.
**Applies standalone.**

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
Record:
- `b4 dig -c 53f33fd74d3993af0fbb5494b5be709f6ca6b712` →
  https://patch.msgid.link/20260612-w1-of-
  autoload-v1-1-74e8a17626e6@gmail.com
- `b4 dig -a`: **v1 only**; that version was applied.
- Maintainer apply mail (29 Jun 2026): “Applied, thanks!” → `https://git
  .kernel.org/krzk/linux-w1/c/53f33fd74d3993af0fbb5494b5be709f6ca6b712`
- No NAK, no requested respin, no reviewer risk flags.

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
Record (`b4 dig -w`): To **Krzysztof Kozlowski** (W1 maintainer); Cc
Miroslav Ondra, linux-kernel. No separate Reviewed-by; maintainer
applied it.

**Step 4.3: SEARCH FOR THE BUG REPORT**
Record: No bugzilla/syzbot link. Cover letter describes DT autoload
failure. Cc of Miroslav Ondra suggests a real user/context, but that is
not a formal report.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Record: **Standalone 1/1.** Binding + I2C ID were added together in 2023
(`22ab6c515d960` + `58ecb03fc74a5`); this commit finishes the OF alias
side.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Record: lore.kernel.org/stable search returned **403**. **UNVERIFIED**
whether this hash was discussed on stable@ separately. Same *class* of
fix is already in this 6.18.y tree, e.g. `039e490e3ac47` (“i3c: master:
adi: add OF module alias for autoloading”), `2e199e3ede9c1` (drm/tve200
OF alias), `1a2dc9bf3b15d` (backlight ktz8866 autoload).

---

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: IDENTIFY KEY FUNCTIONS**
Record: No function body edits. Data: `ds2482_of_match`,
`ds2482_driver`. Probe remains `ds2482_probe` (does not use
`of_match_data`).

**Step 5.2: TRACE CALLERS**
Record: I2C core `i2c_device_match()` / `i2c_device_uevent()` /
`modalias_show`. Triggered when an I2C adapter walks DT children
(`of_i2c_register_devices`). Not a syscall hot path; device enumeration
/ udev coldplug.

**Step 5.3: TRACE CALLEES**
Record: `MODULE_DEVICE_TABLE` → modpost aliases. `of_match_table` →
`of_match_device` / `i2c_of_match_device`. No alloc/lock/I/O change.

**Step 5.4: FOLLOW THE CALL CHAIN**
Record: DT node `compatible = "maxim,ds2484"` → I2C client → uevent
`MODALIAS=of:...Cmaxim,ds2484` → kmod/udev. **Reachable on any DT board
with this chip and `CONFIG_W1_MASTER_DS2482=m`.** Confirmed in this
tree: `arch/arm/configs/imx_v6_v7_defconfig` has
`CONFIG_W1_MASTER_DS2482=m`; `imx6ull-tarragon-common.dtsi` has
`compatible = "maxim,ds2484"` at `onewire@18`; four Tarragon `.dts`
files include that.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Record: Other W1 masters already ship OF tables (`w1-gpio.c`,
`w1-uart.c`, `mxc_w1.c`, `omap_hdq.c`, `amd_axi_w1.c`). ds2482 was the
I2C W1 master missing it.

---

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Record: **Yes, at `v6.18.53`.** `git grep` of `of_match` / `maxim,ds248`
in `drivers/w1/masters/ds2482.c` at `v6.18.53` is empty. Binding file
and Tarragon DTS **are** in 6.18.53. Bug present since the 2023
binding/ID series.

(HEAD on `autosel` already contains candidate `af5503abcf293`; that is
pipeline state, not a reason to skip the technical decision.)

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Record: **Clean apply with fuzz.** GNU `patch --dry-run` of the upstream
hunk onto `v6.18.53:drivers/w1/masters/ds2482.c`: **Hunk #1 succeeded at
549 (offset 4 lines).** Context (`MODULE_DEVICE_TABLE(i2c, ds2482_id)`
and `.name = "ds2482"`) matches. Only nearby difference is `{ "ds2482"
}` vs `{ .name = "ds2482" }`, outside the hunk.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
Record: **No alternate OF table** at `v6.18.53`. I2C ID table is present
but does not generate OF aliases.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
Record: **[drivers/w1 I2C master] [PERIPHERAL]** — 1-wire bridge used on
specific boards (Tarragon i.MX6ULL industrial). Not core mm/net, but
real shipping hardware.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
Record: Mature, low-churn driver (present since ~2005). Occasional fixes
(signedness, regulator). Maintainer-applied patch.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: DETERMINE WHO IS AFFECTED**
Record: **Driver-specific / platform-specific.** Users with
DS2482/DS2484 in DT and the driver as a module. In-tree: Tarragon
(`imx6ull-tarragon-*`) plus any out-of-tree DT using the documented
compatibles.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**
Record: **Every boot** on those boards if `ds2482` is modular. Not a
race. Unprivileged users cannot trigger a crash; they just never get
1-wire. Built-in (`=y`) already works via `i2c_device_id`.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**
Record: **Device does not probe until manual `modprobe ds2482`.** 1-wire
sensors (e.g. w1_therm) stay missing. **Severity: MEDIUM** (functional
hardware miss, not oops/corruption). Covered by the **device-ID / DT
enablement** stable exception.

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**
Record: **Benefit: medium** for affected boards (hardware works out of
the box). **Risk: very low** (8 lines, IDs only, probe unchanged).
**Ratio: favorable.**

---

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: COMPILE THE EVIDENCE**

**FOR backporting:**
- Existing driver in 6.18.y; only OF IDs are new (device-ID exception).
- DT binding and Tarragon DTS already use `maxim,ds2484`; imx defconfig
  builds the driver as `=m`.
- Verified: DT I2C uevents use OF modalias only; without
  `MODULE_DEVICE_TABLE(of)` autoload fails.
- 8-line, obviously correct table matching the binding.
- Standalone v1, applied by the W1 maintainer; no NAKs.
- Same pattern already present in this 6.18.y series (OF module alias
  backports).
- Applies cleanly to `v6.18.53`.

**AGAINST:**
- Not a crash, UAF, deadlock, or CVE.
- Author slightly overstated “driver is not matched”; `id_table` still
  binds after a manual load.
- Peripheral W1 chip, limited population.
- Workaround: `modprobe ds2482` or `=y`.

**UNRESOLVED:**
- lore.kernel.org/stable HTTP 403; no confirmation of a prior stable@
  thread for this SHA.

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — standard OF ID table;
   maintainer applied v1.
2. Fixes a real bug that affects users? **PASS** — modular DT boards do
   not autoload; Tarragon is in-tree.
3. Important issue? **PASS** under the device-ID/hardware-enablement
   exception (severity MEDIUM, not a panic).
4. Small and contained? **PASS** — +8 lines, one file.
5. No new features or APIs? **PASS** — IDs for hardware the driver
   already supports.
6. Can apply to the local tree? **PASS** — driver/bindings/DTS in
   6.18.53; patch applies with offset 4.

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**
Record: **New device IDs (OF compatible strings) on an existing
driver.** Also DT hardware enablement for boards already described in
this tree.

**Step 9.4: DECISION**
This is the OF equivalent of adding PCI/USB IDs. The 6.18.y tree already
documents and instantiates the device; the module simply never loads.
That is a contained, low-risk fix that belongs in this stable tree.

---

### What the commit solves for this tree

On 6.18.y, `maxim,ds2482`/`maxim,ds2484` are valid and used (Tarragon).
The I2C core publishes an `of:` modalias for those nodes. Without
`of_match_table` + `MODULE_DEVICE_TABLE(of)`, kmod never loads
`ds2482.ko`, so 1-wire stays dead until a manual `modprobe`. The patch
does not add a new driver or API; it publishes the IDs the binding
already defined.

Risk is an 8-line ID table with unchanged probe. Benefit is that
existing DT hardware actually comes up on distro-style modular configs.

---

### Verification
- **[Phase 1]** Tags: Link msgid, SOB Černý + Kozlowski; no
  Fixes/Reported-by/Cc stable.
- **[Phase 1]** Cover letter (openwall/lkml): autoload/match claim;
  “driver not matched” is overstated vs `id_table`.
- **[Phase 2]** Diff: +8 in `ds2482.c`; table + `of_match_table` only.
- **[Phase 2]** `i2c_device_uevent` / `of_device_uevent_modalias` /
  `of_modalias`: OF alias only when `of_node` exists.
- **[Phase 2]** `of_alias_from_compatible` + `i2c_match_id`: bind still
  works after manual load.
- **[Phase 3]** `git describe HEAD` = `v6.18.53-5049-g0f0bdc2b0dffb`;
  `make kernelversion` = 6.18.53.
- **[Phase 3]** `git merge-base --is-ancestor af5503abcf293 v6.18.53`
  fails; `v6.18.53` grep has no OF table.
- **[Phase 3]** Binding `22ab6c515d960` and I2C ID `58ecb03fc74a5`
  **are** ancestors of `v6.18.53`.
- **[Phase 3]** `git blame` on `v6.18.53` driver struct: no
  `of_match_table`.
- **[Phase 4]** `b4 dig -c 53f33fd74d39`: lore msgid; `-a` v1 only; `-w`
  maintainer To:.
- **[Phase 4]** Kozlowski “Applied, thanks!” 29 Jun 2026.
- **[Phase 4]** lore.kernel.org/stable: **UNVERIFIED** (403).
- **[Phase 5]** `imx_v6_v7_defconfig`: `CONFIG_W1_MASTER_DS2482=m`;
  Tarragon DTS `maxim,ds2484`.
- **[Phase 5]** `ds2482_probe` does not use OF match data.
- **[Phase 6]** GNU patch onto `v6.18.53` file: success, offset 4.
- **[Phase 8]** Failure mode: no autoload → 1-wire absent; not an oops.
- **UNVERIFIED:** stable@ mailing-list discussion of this specific
  commit.

**YES**

 drivers/w1/masters/ds2482.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/w1/masters/ds2482.c b/drivers/w1/masters/ds2482.c
index 0c93bf338a6ef..e91c7b0f3617c 100644
--- a/drivers/w1/masters/ds2482.c
+++ b/drivers/w1/masters/ds2482.c
@@ -549,9 +549,17 @@ static const struct i2c_device_id ds2482_id[] = {
 };
 MODULE_DEVICE_TABLE(i2c, ds2482_id);
 
+static const struct of_device_id ds2482_of_match[] = {
+	{ .compatible = "maxim,ds2482", },
+	{ .compatible = "maxim,ds2484", },
+	{ }
+};
+MODULE_DEVICE_TABLE(of, ds2482_of_match);
+
 static struct i2c_driver ds2482_driver = {
 	.driver = {
 		.name	= "ds2482",
+		.of_match_table  = ds2482_of_match,
 	},
 	.probe		= ds2482_probe,
 	.remove		= ds2482_remove,
-- 
2.53.0

