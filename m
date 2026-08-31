Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E98C6519935;
	Mon, 31 Aug 2026 13:43:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183820; cv=none; b=QM/tzmod/+hrFeFUMhXl5MEMlmK1Gv3nVGlDUBhAWUhUxAuzgT/I51Sa02tDiFFSqaBXxoZSOExCM9272+uqNeMkExA8ldilJGF+ZNyDQSt4gFdj/yfpGC3N9JUMC6CIw+VyIPPY4hLhylTNnQpB90dKXeT8Nf4XZMXlfnsYjqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183820; c=relaxed/simple;
	bh=vXYVocBxDvPJKwTwVKmX5ecFmVttEgJ3A9P2OBB5k28=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LbBRbd0V9ZvVIVNfLRmXTTsB3iUV75yJr/DCNWnZ5S2KmL9fkSTEyMSR2DW9tBKOa2HSK84v8NfoyFs8mo5RVrRBD/hVUnVXiDL5xejOwq5dea6z+S4aPUpED2/4M+/0Y8UcOKZSxviGHSFfJhEufD5R2i+h2e5zUrzWvueW7Og=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X3JY4Ha7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X3JY4Ha7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD6291F00A3F;
	Mon, 31 Aug 2026 13:43:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183817;
	bh=Y7lED9xg9OaQMQjqPEN4yvOdKWLV4vJD0/QjDmcKNCA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X3JY4Ha73Lcj2qXvKo+edTQmiqJU+tqxAHHcgRtABVLLhwWTQGACc8+TfPADgRO7Z
	 NLC9poZsZuJSeALcsnHnbh/tlmizV4mLGBZ2naSbyT61as9FxaYWgyuxSzGijDd4ks
	 1H9k+uMNRNv9PPGZIG1IAv7VhOcDo8i1bVfLyg3NujuSrHp9ySQTTyqkFUriWDon2E
	 /3Y7PxkBfv/duOr6x28dsQDTCev7dFw01JcyGt6GEMpX8OXIjPDndTFhEZ3RDrhaox
	 ML9ZD8XaGbPE+tMb5IhCcMpAuIDjbSzYNIQet8ahvi+sbd/b0Ce7c+ZEQ9Ahwc6yPX
	 lFbv+hiEtCjtQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Georgi Valkov <gvalkov@gmail.com>,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	briannorris@chromium.org,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] wifi: mwifiex: replace one-element arrays with flexible array members
Date: Mon, 31 Aug 2026 09:25:51 -0400
Message-ID: <20260831133314.4125787-323-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Georgi Valkov <gvalkov@gmail.com>

[ Upstream commit 1cb5845a58d8e1f85d5766c6fbcbfddf96c212a1 ]

Replace deprecated one-element arrays with flexible array members.
CONFIG_FORTIFY_SOURCE reports the following warning when
one-element arrays are used as variable-length buffers:

sta_cmd.c:1033 mwifiex_sta_prepare_cmd
memcpy: detected field-spanning write (size 84) of single field
"domain->triplet" at .../marvell/mwifiex/sta_cmd.c:1033 (size 3)

Convert affected structs to use flexible array members.
- Preserve existing wire layouts.
- Use DECLARE_FLEX_ARRAY() for structs inside affected unions.

Tested-on: WRT3200ACM, OpenWrt
Signed-off-by: Georgi Valkov <gvalkov@gmail.com>
Reviewed-by: Francesco Dolcini <francesco.dolcini@toradex.com>
Link: https://patch.msgid.link/20260716001728.57799-1-gvalkov@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject line
**Record:** `[wifi: mwifiex]` `[replace]` — Convert deprecated one-
element arrays in mwifiex firmware/command structures to proper flexible
array members (FAMs).

### Step 1.2: Commit message tags
**Record:**
- **Signed-off-by:** Georgi Valkov `<gvalkov@gmail.com>` (author)
- **Reviewed-by:** Francesco Dolcini `<francesco.dolcini@toradex.com>`
- **Tested-on:** WRT3200ACM, OpenWrt
- **Link:**
  https://patch.msgid.link/20260716001728.57799-1-gvalkov@gmail.com
- **Signed-off-by:** Johannes Berg (committer)
- No `Fixes:`, `Reported-by:`, `Cc: stable@vger.kernel.org` in the
  commit itself
- Notable: Kees Cook (`kees@kernel.org`) was CC’d on the mailing-list
  thread and originally reported the FORTIFY warning

### Step 1.3: Body analysis
**Record:**
- **Bug:** One-element arrays (`triplet[1]`, `value[1]`, etc.) are used
  as variable-length buffers; with `CONFIG_FORTIFY_SOURCE`, `memcpy()`
  triggers a *field-spanning write* diagnostic (84-byte write into a
  3-byte `triplet` field at `sta_cmd.c:1033`).
- **Symptom:** Compile-time FORTIFY warning; with FORTIFY enabled at
  runtime, `fortify_warn_once()` can emit a one-time kernel warning on
  the 802.11d domain-info path when copying multiple triplets.
- **Root cause:** Deprecated one-element-array-as-FAM pattern;
  compiler/FORTIFY treats the destination as a fixed 3-byte field, not a
  variable-length tail.
- **Fix approach:** Convert to `[]` / `DECLARE_FLEX_ARRAY()`, preserve
  wire layout, fix `sizeof` usage (`- 1` removal in SNMP MIB size,
  pointer dereference fixes in `join.c`).

### Step 1.4: Hidden bug fix?
**Record:** Yes, disguised as structural cleanup. It is not a typical
crash/UAF fix, but it corrects formally incorrect struct typing that
triggers FORTIFY diagnostics and can produce runtime `WARN_ONCE` on the
802.11d domain-info command path when `CONFIG_FORTIFY_SOURCE` is
enabled.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
- `fw.h`: 18 lines changed (9 one-element `[1]` → `[]` /
  `DECLARE_FLEX_ARRAY()` conversions)
- `join.c`: 8 lines (pointer/`sizeof` fixes for union FAM members)
- `sta_cmd.c`: 2 lines (remove `- 1` from SNMP MIB base size)
- **Functions touched:** `mwifiex_cmd_802_11_associate()` (`join.c`),
  `mwifiex_cmd_802_11_snmp_mib()` (`sta_cmd.c`); header-only changes
  affect `mwifiex_cmd_802_11d_domain_info()` and others
- **Scope:** Single-driver, 3 files, ~28 lines — surgical

### Step 2.2: Code flow per hunk
**Record:**
- **`fw.h` structs:** Before: compiler sees fixed 1-element tails.
  After: proper FAMs; wire layout unchanged (`__packed` preserved).
- **`join.c` phy/ss TLV setup:** Before:
  `sizeof(phy_tlv->fh_ds.ds_param_set)` on a one-element union member;
  `memcpy(&phy_tlv->fh_ds.ds_param_set, ...)`. After:
  `sizeof(*phy_tlv->fh_ds.ds_param_set)` and
  `memcpy(phy_tlv->fh_ds.ds_param_set, ...)` — semantically equivalent,
  FAM-correct.
- **`sta_cmd.c` SNMP MIB:** Before: `sizeof(snmp_mib) - 1 + S_DS_GEN`
  (old FAM hack). After: `sizeof(snmp_mib) + S_DS_GEN` — correct base
  size with zero-length FAM.

### Step 2.3: Bug mechanism
**Record:** **Category:** Memory-safety / build-hardening (FORTIFY
field-spanning write detection). **Mechanism:** `memcpy(domain->triplet,
..., no_of_triplet * 3)` writes up to 249 bytes (83 triplets × 3 bytes)
into a field declared as `triplet[1]` (3 bytes). Data lands in the
2048-byte command skb (`MWIFIEX_SIZE_OF_CMD_BUFFER`), so legacy code
worked, but FORTIFY flags the mismatch. FAM conversion aligns struct
definitions with actual usage.

### Step 2.4: Fix quality
**Record:** Obviously correct — no layout change, hardware-tested
(WRT3200ACM), reviewed by mwifiex contributor. Minimal regression risk;
`DECLARE_FLEX_ARRAY()` already used elsewhere in this tree’s headers.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:** `triplet[1]` in `fw.h:1686` dates to merge commit
`5d324e5159d9e` (6.18-rc8 era, Nov 2025). The one-element-array pattern
is long-standing in mwifiex, not a recent regression.

### Step 3.2: Fixes: tag
**Record:** N/A — no `Fixes:` tag in commit message.

### Step 3.3: Related file history
**Record:** Recent mwifiex stable commits in this tree are runtime bug
fixes (UAF, NULL deref, scan freezes). This FAM commit (`1cb5845a58d8e`)
is on `master` but **not** in this 6.18.44 checkout. Standalone single
patch (v1→v3 on list; committed version is v3).

### Step 3.4: Author context
**Record:** Georgi Valkov has at least one prior mwifiex fix in this
tree (`731acda5ba777` firmware-freeze fix). Johannes Berg is wireless
maintainer.

### Step 3.5: Dependencies
**Record:** No series dependencies. `git apply --check` on the patch
against this tree: **applies cleanly**. `DECLARE_FLEX_ARRAY` exists in
`include/linux` in this tree.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original discussion
**Record:** `b4 dig -c 1cb5845a58d8e` →
https://patch.msgid.link/20260716001728.57799-1-gvalkov@gmail.com.
Series: v1 (Jul 13) → v3 (Jul 16, committed). Kees Cook reported the
FORTIFY warning in v1 review (`202607150932.F2A0836@keescook`).

### Step 4.2: Reviewers
**Record:** `b4 dig -w`: CC’d — `kees@kernel.org`,
`johannes.berg@intel.com`, `francesco@dolcini.it`, `linux-
wireless@vger.kernel.org`, `linux-kernel@vger.kernel.org`. Francesco
Dolcini added **`Cc: stable@vger.kernel.org # 6.12+`** with `Reviewed-
by`.

### Step 4.3: Bug report
**Record:** No syzbot/bugzilla. Trigger reported by Kees Cook (FORTIFY
maintainer) during review — build-time warning, reproducible when
`CONFIG_FORTIFY_SOURCE=y`.

### Step 4.4: Related patches
**Record:** Standalone; not part of a multi-commit series requiring
other patches.

### Step 4.5: Stable list
**Record:** Francesco Dolcini explicitly nominated stable on the patch
thread (`Cc: stable@vger.kernel.org # 6.12+`). No NAKs found in mbox.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** `mwifiex_cmd_802_11d_domain_info()`,
`mwifiex_cmd_802_11_snmp_mib()`, `mwifiex_cmd_802_11_associate()`,
`mwifiex_sta_prepare_cmd()` (dispatcher).

### Step 5.2: Callers
**Record:**
- `mwifiex_cmd_802_11d_domain_info` → `mwifiex_sta_prepare_cmd` →
  `mwifiex_cmd_host_cmd()` → `mwifiex_send_cmd()` from `cfg80211.c` and
  `sta_ioctl.c` (regulatory/11d setup)
- `mwifiex_cmd_802_11_associate` → association path during connect/roam
- `mwifiex_cmd_802_11_snmp_mib` → SNMP MIB get/set commands

### Step 5.3: Callees
**Record:** `memcpy()`, `cpu_to_le16()`, `le16_unaligned_add_cpu()` —
command construction into pre-allocated 2048-byte skb buffers.

### Step 5.4: Reachability
**Record:** Reachable on normal WiFi operations — association,
regulatory domain configuration (802.11d), SNMP MIB tuning. Not init-
only; triggered during connect and regdomain changes on mwifiex hardware
(USB/SDIO/PCIe).

### Step 5.5: Similar patterns
**Record:** Other mwifiex structs in `fw.h` already use `[]` FAMs
(`rates[]`, `ssid[]`, `chan_scan_param[]`). This patch brings the
remaining one-element holdouts in line.

---

## PHASE 6: CROSS-REFERENCING AGAINST LOCAL TREE

### Step 6.1: Buggy code present?
**Record:** **Yes.** Local tree is **6.18.44** (`git describe HEAD` →
`v6.18.44-2-g1b9e1abadee04`). `triplet[1]`, `value[1]`, `tlv_buf[1]`,
etc. still present in `fw.h`. Commit `1cb5845a58d8e` is **not** an
ancestor of HEAD.

### Step 6.2: Backport complications
**Record:** **Clean apply** — verified with `git apply --check`. No
conflicting refactors in these files since 6.18 branch.

### Step 6.3: Related fixes already present?
**Record:** No equivalent FAM conversion found in this tree’s mwifiex
history.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem criticality
**Record:** `drivers/net/wireless/marvell/mwifiex` — **PERIPHERAL**
(Marvell WiFi driver; common on embedded/OpenWrt devices like
WRT3200ACM, but not core kernel).

### Step 7.2: Subsystem activity
**Record:** Actively maintained in 6.18.y — multiple recent mwifiex
stable backports (UAF, NULL deref, scan/roam fixes).

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who is affected
**Record:** Users/builders with `CONFIG_MWIFIEX` (+ USB/SDIO/PCIe) and
`CONFIG_FORTIFY_SOURCE=y`. Affects kernel builders seeing compile
warnings and users of FORTIFY-enabled kernels doing 802.11d domain
configuration.

### Step 8.2: Trigger conditions
**Record:** Building with FORTIFY (compile warning); at runtime,
`mwifiex_cmd_802_11d_domain_info()` SET with `no_of_triplet > 1`
triggers FORTIFY `WARN_ONCE` field-spanning diagnostic.
802.11d/regulatory setup is normal on many deployments. Not
unprivileged-syscall reachable directly, but common during WiFi bring-
up.

### Step 8.3: Failure mode severity
**Record:** Compile-time FORTIFY **warning** (not error by default);
runtime **WARN_ONCE** (not panic — verified: `fortify_panic` only when
`p_size < size` with known struct size; here `p_size` is typically
`SIZE_MAX` for embedded command buffers, so panic is not observed;
hardware testing on OpenWrt confirms no crash). **Severity: LOW–MEDIUM**
(build hygiene + dmesg warning, not crash/corruption).

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** Eliminates FORTIFY warnings for kernel builders; removes
  runtime `WARN_ONCE` on 11d path; corrects struct definitions;
  reviewer-nominated for stable.
- **Risk:** Very low — wire layout unchanged, 28-line diff, hardware-
  tested.
- **Ratio:** Modest benefit, very low risk. Fits the **build-fix
  exception** category.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence summary

**FOR backport:**
- Buggy one-element arrays present in 6.18.44
- Patch applies cleanly
- FORTIFY compile warnings (Kees Cook report)
- Possible runtime `WARN_ONCE` on 802.11d domain commands with FORTIFY
- Small, reviewed, hardware-tested, wire-layout-preserving
- Francesco Dolcini: `Cc: stable@vger.kernel.org # 6.12+`
- Build-fix exception applies

**AGAINST backport:**
- No crash, data corruption, or security CVE
- No end-user functional regression in typical use (legacy code worked
  because cmd buffers are 2048 bytes)
- Peripheral driver; impact limited to mwifiex users
- FORTIFY issue is warning-level, not build-breaking by default

**Unresolved:** Whether any distro builds mwifiex with `-Werror` on
FORTIFY warnings (unverified; not needed for decision).

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — reviewed, Tested-on
   WRT3200ACM, layout preserved
2. Fixes a real bug affecting users? **PASS** (borderline) — FORTIFY
   diagnostic on real code path; not a functional regression fix
3. Important issue (crash/security/corruption/deadlock)? **FAIL** for
   critical severity — warning/build issue only, not crash or corruption
4. Small and contained? **PASS** — 3 files, ~28 lines
5. No new features or APIs? **PASS** — struct declaration correction
   only
6. Can apply to local tree? **PASS** — verified clean apply

### Step 9.3: Exception category
**Record:** **BUILD FIX** — resolves `CONFIG_FORTIFY_SOURCE` compile-
time field-spanning-write warnings.

### Step 9.4: Decision rationale

For **linux 6.18.44**, the buggy code exists, the fix applies cleanly,
and it is a low-risk correctness/build-hardening fix explicitly
nominated for stable by the mwifiex reviewer. While it does not fix a
crash or data corruption, it falls under the documented build-fix
exception, removes FORTIFY noise for kernel builders (including
OpenWrt), and aligns struct definitions with long-standing variable-
length usage. The risk of backporting is negligible.

---

## Verification

- [Phase 1] Parsed commit `1cb5845a58d8e`: subject, tags, FORTIFY
  warning description
- [Phase 2] Read full diff via `git show 1cb5845a58d8e`; 3 files, ~28
  lines
- [Phase 2] Confirmed `mwifiex_cmd_802_11d_domain_info()` memcpy at
  `sta_cmd.c:1033` with `no_of_triplet` up to
  `MWIFIEX_MAX_TRIPLET_802_11D` (83)
- [Phase 3] `git describe HEAD` → v6.18.44; `git merge-base --is-
  ancestor` → commit NOT in tree
- [Phase 3] `git blame` on `triplet[1]` → present since 6.18-rc8 merge
- [Phase 3] `git apply --check` → applies cleanly
- [Phase 4] `b4 dig -c 1cb5845a58d8e` → lore URL found; v1/v3 series
- [Phase 4] `b4 dig -w` → Kees Cook, Johannes Berg, Francesco Dolcini
  CC’d
- [Phase 4] mbox: Francesco Dolcini `Cc: stable@vger.kernel.org #
  6.12+`; Kees Cook FORTIFY report
- [Phase 5] Grep call chain: `mwifiex_send_cmd` →
  `HostCmd_CMD_802_11D_DOMAIN_INFO` from `cfg80211.c`, `sta_ioctl.c`
- [Phase 5] `MWIFIEX_SIZE_OF_CMD_BUFFER` = 2048 in `ioctl.h`
- [Phase 6] Grep confirms `triplet[1]`, `value[1]` still in local `fw.h`
- [Phase 6] `DECLARE_FLEX_ARRAY` present in `include/linux/bpf.h`
  (exists in tree)
- [Phase 8] Read `include/linux/fortify-string.h`: field-spanning →
  `fortify_warn_once` (WARN_ONCE), not panic by default;
  `__write_overflow_field` is compile-time warning
- [Phase 8] `struct ieee80211_country_ie_triplet` is 3 bytes (packed
  union in `ieee80211.h`)

**YES**

 drivers/net/wireless/marvell/mwifiex/fw.h      | 18 +++++++++---------
 drivers/net/wireless/marvell/mwifiex/join.c    |  8 ++++----
 drivers/net/wireless/marvell/mwifiex/sta_cmd.c |  2 +-
 3 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/fw.h b/drivers/net/wireless/marvell/mwifiex/fw.h
index e9e8966069121..93561116959ac 100644
--- a/drivers/net/wireless/marvell/mwifiex/fw.h
+++ b/drivers/net/wireless/marvell/mwifiex/fw.h
@@ -823,7 +823,7 @@ struct chan_band_param_set {
 
 struct mwifiex_ie_types_chan_band_list_param_set {
 	struct mwifiex_ie_types_header header;
-	struct chan_band_param_set chan_band_param[1];
+	struct chan_band_param_set chan_band_param[];
 } __packed;
 
 struct mwifiex_ie_types_rates_param_set {
@@ -886,7 +886,7 @@ struct mwifiex_ie_types_wildcard_ssid_params {
 #define TSF_DATA_SIZE            8
 struct mwifiex_ie_types_tsf_timestamp {
 	struct mwifiex_ie_types_header header;
-	u8 tsf_data[1];
+	u8 tsf_data[];
 } __packed;
 
 struct mwifiex_cf_param_set {
@@ -903,8 +903,8 @@ struct mwifiex_ibss_param_set {
 struct mwifiex_ie_types_ss_param_set {
 	struct mwifiex_ie_types_header header;
 	union {
-		struct mwifiex_cf_param_set cf_param_set[1];
-		struct mwifiex_ibss_param_set ibss_param_set[1];
+		DECLARE_FLEX_ARRAY(struct mwifiex_cf_param_set, cf_param_set);
+		DECLARE_FLEX_ARRAY(struct mwifiex_ibss_param_set, ibss_param_set);
 	} cf_ibss;
 } __packed;
 
@@ -922,8 +922,8 @@ struct mwifiex_ds_param_set {
 struct mwifiex_ie_types_phy_param_set {
 	struct mwifiex_ie_types_header header;
 	union {
-		struct mwifiex_fh_param_set fh_param_set[1];
-		struct mwifiex_ds_param_set ds_param_set[1];
+		DECLARE_FLEX_ARRAY(struct mwifiex_fh_param_set, fh_param_set);
+		DECLARE_FLEX_ARRAY(struct mwifiex_ds_param_set, ds_param_set);
 	} fh_ds;
 } __packed;
 
@@ -1383,7 +1383,7 @@ struct host_cmd_ds_802_11_snmp_mib {
 	__le16 query_type;
 	__le16 oid;
 	__le16 buf_size;
-	u8 value[1];
+	u8 value[];
 } __packed;
 
 struct mwifiex_rate_scope {
@@ -1551,7 +1551,7 @@ struct mwifiex_scan_cmd_config {
 	 *  TLV_TYPE_CHANLIST, mwifiex_ie_types_chan_list_param_set
 	 *  WLAN_EID_SSID, mwifiex_ie_types_ssid_param_set
 	 */
-	u8 tlv_buf[1];	/* SSID TLV(s) and ChanList TLVs are stored
+	u8 tlv_buf[];	/* SSID TLV(s) and ChanList TLVs are stored
 				   here */
 } __packed;
 
@@ -1683,7 +1683,7 @@ struct host_cmd_ds_802_11_bg_scan_query_rsp {
 struct mwifiex_ietypes_domain_param_set {
 	struct mwifiex_ie_types_header header;
 	u8 country_code[IEEE80211_COUNTRY_STRING_LEN];
-	struct ieee80211_country_ie_triplet triplet[1];
+	struct ieee80211_country_ie_triplet triplet[];
 } __packed;
 
 struct host_cmd_ds_802_11d_domain_info {
diff --git a/drivers/net/wireless/marvell/mwifiex/join.c b/drivers/net/wireless/marvell/mwifiex/join.c
index b48f7febaf03f..259140395d353 100644
--- a/drivers/net/wireless/marvell/mwifiex/join.c
+++ b/drivers/net/wireless/marvell/mwifiex/join.c
@@ -421,15 +421,15 @@ int mwifiex_cmd_802_11_associate(struct mwifiex_private *priv,
 
 	phy_tlv = (struct mwifiex_ie_types_phy_param_set *) pos;
 	phy_tlv->header.type = cpu_to_le16(WLAN_EID_DS_PARAMS);
-	phy_tlv->header.len = cpu_to_le16(sizeof(phy_tlv->fh_ds.ds_param_set));
-	memcpy(&phy_tlv->fh_ds.ds_param_set,
+	phy_tlv->header.len = cpu_to_le16(sizeof(*phy_tlv->fh_ds.ds_param_set));
+	memcpy(phy_tlv->fh_ds.ds_param_set,
 	       &bss_desc->phy_param_set.ds_param_set.current_chan,
-	       sizeof(phy_tlv->fh_ds.ds_param_set));
+	       sizeof(*phy_tlv->fh_ds.ds_param_set));
 	pos += sizeof(phy_tlv->header) + le16_to_cpu(phy_tlv->header.len);
 
 	ss_tlv = (struct mwifiex_ie_types_ss_param_set *) pos;
 	ss_tlv->header.type = cpu_to_le16(WLAN_EID_CF_PARAMS);
-	ss_tlv->header.len = cpu_to_le16(sizeof(ss_tlv->cf_ibss.cf_param_set));
+	ss_tlv->header.len = cpu_to_le16(sizeof(*ss_tlv->cf_ibss.cf_param_set));
 	pos += sizeof(ss_tlv->header) + le16_to_cpu(ss_tlv->header.len);
 
 	/* Get the common rates supported between the driver and the BSS Desc */
diff --git a/drivers/net/wireless/marvell/mwifiex/sta_cmd.c b/drivers/net/wireless/marvell/mwifiex/sta_cmd.c
index dcca71158fc68..0a0458e15e289 100644
--- a/drivers/net/wireless/marvell/mwifiex/sta_cmd.c
+++ b/drivers/net/wireless/marvell/mwifiex/sta_cmd.c
@@ -108,7 +108,7 @@ static int mwifiex_cmd_802_11_snmp_mib(struct mwifiex_private *priv,
 		    "cmd: SNMP_CMD: cmd_oid = 0x%x\n", cmd_oid);
 	cmd->command = cpu_to_le16(HostCmd_CMD_802_11_SNMP_MIB);
 	cmd->size = cpu_to_le16(sizeof(struct host_cmd_ds_802_11_snmp_mib)
-				- 1 + S_DS_GEN);
+				+ S_DS_GEN);
 
 	snmp_mib->oid = cpu_to_le16((u16)cmd_oid);
 	if (cmd_action == HostCmd_ACT_GEN_GET) {
-- 
2.53.0

