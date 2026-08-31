Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EE3C533582;
	Mon, 31 Aug 2026 13:45:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183908; cv=none; b=tNvWkZssmHXWl9XAnzYKaP9wxH6S4iuCFP+K0FHZVGPYTKkG2gmw8uG0lQVMuXeTHLmZQHK8ZmHolMKvDUVOdT2hTyL7udD41Aq1Cmebxgg/Fj//344lJMRqgHocydrc/pplHy2qz2SBFurwat9cU6MTSeQiKvM9sbTl7uBTd3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183908; c=relaxed/simple;
	bh=sid1sV8s4q74X6o+frYf112Qrz0DPI3Du+XUomqiJzk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FFd6R/CNLWD33gZ/oH9hYpEkfK9mLnK8iK9JsLrc7vq/wEWWGqqTCp6E23w3Yk1EUfKpoaXM4ak0HPk+WMYT0ovrQLj5voCUUSVqCJYO4vR9Xmal3/isgOGhL2Eb9jMuGGsxANiRODy8rzycdK60roqOjijQdRA9p+hCg+pc81w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BLDTigrU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BLDTigrU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB77A1F00A3F;
	Mon, 31 Aug 2026 13:45:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183906;
	bh=oN6+Wuu9JYt/03J6GSnpQ/bNKMItuNfqEycApNwj0K8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BLDTigrUYHoCwOkyh1u3i3xKAmhXNDAeTJbKyGhQlxdkxCMYaXacx8B7z7UKxMFyX
	 1N1BPTJo69f/SM0zgqT91UNOOErrzyrfIXC0ICvuPwegKTj6tj7m8DuM6orCpQdT5a
	 kab+/mBN7Ae0ulc1sCGCvXGQKfj6HaPxe321xxXj1KumwY8xDv8pBfGkLyO8TSaF/Q
	 Y/fX2Dcqfo+hLkk5ryDC0O4gVfy3Oh5Rv2DrdJH5BrIgEQZiKH9jldVVV4OAtoSoax
	 1Tvv+f35qAW9e049YweHldMlxHrWGtVV4g2tRQsFvww2KHmdM1jqK2w4NmyBxWKdX7
	 IgDWcC79FFZaw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] wifi: iwlwifi: validate SEC_RT TLV minimum size
Date: Mon, 31 Aug 2026 09:26:41 -0400
Message-ID: <20260831133314.4125787-373-sashal@kernel.org>
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

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

[ Upstream commit d13d5d299c11b7bd3362d5692c56225d9e176664 ]

Reject firmware section TLVs that are shorter than the offset field
before subtracting sizeof(offset) from the section size.

This prevents size underflow for malformed TLVs.

Assisted-by: GitHubCopilot:GPT-5.3-Codex
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Link: https://patch.msgid.link/20260717173215.17b040b27edc.I6b32d1e9ad707417e2e604f08a63582456209372@changeid
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

**Step 1.1 — Subject line**

Record: `[wifi: iwlwifi]` `[validate]` — validate minimum size of SEC_RT
firmware section TLVs before parsing.

**Step 1.2 — Tags**

Record:
- `Assisted-by: GitHubCopilot:GPT-5.3-Codex`
- `Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>`
- `Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>`
- `Link: https://patch.msgid.link/20260717173215.17b040b27edc...`

Notable patterns: No `Fixes:`, `Reported-by:`, `Cc:
stable@vger.kernel.org`, `Tested-by:`, or `Reviewed-by:` tags. Absence
of stable tags is expected for manual review. Intel internal fixes
series (patch 5/5).

**Step 1.3 — Body analysis**

Record:
- **Bug:** `iwl_store_ucode_sec()` subtracts `sizeof(offset)` from TLV
  length without verifying the TLV is at least that large.
- **Symptom:** Integer underflow on `sec->size` for malformed TLVs
  (`tlv_len` 0–3).
- **Root cause:** `sec->size = size - sizeof(sec_parse->offset)` with
  signed `int size`; negative result assigned to `size_t` becomes a very
  large value.
- **Version info:** None in commit message.

**Step 1.4 — Hidden bug fix?**

Record: Yes — described as validation, but it is a real memory-safety
bug fix (underflow → huge allocation + out-of-bounds `memcpy`).

---

## Phase 2: Diff Analysis

**Step 2.1 — Inventory**

Record:
- **File:** `drivers/net/wireless/intel/iwlwifi/iwl-drv.c` (+4 / −1)
- **Function:** `iwl_store_ucode_sec()`
- **Scope:** Single-file, surgical fix

**Step 2.2 — Code flow change**

Record:
- **Hunk 1 (parameter type):** `int size` → `size_t size` (matches
  `tlv_len` as `u32` and `sec->size` as `size_t`).
- **Hunk 2 (validation):** Before casting `data` to `struct
  fw_sec_parsing *` and subtracting offset size, reject `size <
  sizeof(sec_parse->offset)` with `-EINVAL`.
- **Before:** Malformed TLV with `tlv_len < 4` → read past TLV data,
  underflow `sec->size` → huge `size_t`.
- **After:** Early rejection before offset read or size subtraction.

**Step 2.3 — Bug mechanism**

Record:
- **Category:** Buffer overflow / out-of-bounds read + integer
  underflow.
- **Mechanism:** With `tlv_len=1`, `sec->size = 1 - 4 = -3` (signed) →
  `SIZE_MAX-2` as `size_t`. Later `iwl_alloc_fw_desc()` does
  `vmalloc(sec->size)` and `memcpy(data, sec->data, desc->len)` far
  beyond the firmware buffer.

**Step 2.4 — Fix quality**

Record: Obviously correct minimum-length check; minimal change; low
regression risk. Pre-existing issue: callers ignore
`iwl_store_ucode_sec()` return value, but the fix still prevents storing
a corrupted section entry.

---

## Phase 3: Git History Investigation

**Step 3.1 — Blame**

Record: `iwl_store_ucode_sec()` and the vulnerable subtraction are
present in current `stable/linux-6.18.y` checkout (`v6.18.44`). Shallow
repo limits deep blame; function is long-standing MVM firmware parsing
code.

**Step 3.2 — Fixes: tag**

Record: Not applicable — no `Fixes:` tag.

**Step 3.3 — Related changes**

Record:
- Part of `[PATCH iwlwifi-fixes 0/5]` series (July 17, 2026).
- Patch 1/5 (`acad742714bdc` — bound aligned TLV advance) is a related
  but separate fix in the same file; **not** in 6.18.y yet.
- This patch (5/5) is standalone and applies cleanly without patch 1/5.
- Similar backported fix already in tree: `eae7fdf7d4469` (validate pnvm
  payload length).

**Step 3.4 — Author context**

Record: Emmanuel Grumbach and Miri Korenblit are iwlwifi maintainers.
Multiple similar validation fixes from same authors are already in
6.18.y.

**Step 3.5 — Dependencies**

Record: No dependencies on other series patches. `git apply --check`
succeeds on current tree. Standalone.

---

## Phase 4: Mailing List and External Research

**Step 4.1 — Original discussion**

Record:
- `b4 dig -c d13d5d299c11b`: https://patch.msgid.link/20260717173215.17b
  040b27edc.I6b32d1e9ad707417e2e604f08a63582456209372@changeid
- Series: v1 only, patch 5/5 of 5.
- Cover letter: "A few fixes from our internal tree."
- No reviewer replies, NAKs, or stable nominations in thread.

**Step 4.2 — Reviewers**

Record: `b4 dig -w`: To johannes@sipsolutions.net; Cc linux-
wireless@vger.kernel.org, Emmanuel Grumbach. No explicit review acks in
thread.

**Step 4.3 — Bug report**

Record: No external bug report, syzbot, or sanitizer report. Intel
internal finding (Copilot-assisted).

**Step 4.4 — Series context**

Record: 5-patch series; patches 1–4 touch different files (`iwl-drv.c`,
`iwl-dbg-tlv.c`, `acpi.c`, `uefi.c`). Only patch 5/5 is under review
here.

**Step 4.5 — Stable list**

Record: No stable@vger.kernel.org discussion found for this specific
fix.

---

## Phase 5: Code Semantic Analysis

**Step 5.1 — Key functions**

Record: `iwl_store_ucode_sec()` (modified); callers in
`iwl_parse_tlv_firmware()` switch cases.

**Step 5.2 — Callers**

Record: Called from 7 sites in `iwl_parse_tlv_firmware()` for:
- `IWL_UCODE_TLV_SEC_RT`, `SEC_INIT`, `SEC_WOWLAN`
- `IWL_UCODE_TLV_SECURE_SEC_RT`, `SECURE_SEC_INIT`, `SECURE_SEC_WOWLAN`
- `IWL_UCODE_TLV_SEC_RT_USNIFFER`

All during firmware image parsing at driver probe / firmware load.

**Step 5.3 — Callees**

Record: `krealloc()`, `le32_to_cpu()`; stores into `img->sec[]` consumed
later by `iwl_alloc_ucode_mem()` → `iwl_alloc_fw_desc()` → `vmalloc()` +
`memcpy()`.

**Step 5.4 — Reachability**

Record:
- `iwl_req_fw_callback()` → `iwl_parse_tlv_firmware()` →
  `iwl_store_ucode_sec()`
- Triggered on every iwlwifi device probe when loading TLV-format MVM
  firmware from `/lib/firmware`.
- Malformed firmware (corrupted file) triggers the bug; legitimate Intel
  firmware is unaffected.

**Step 5.5 — Similar patterns**

Record: Same file has explicit `invalid_tlv_len` checks for many TLV
types, but SEC_RT family lacks minimum-length validation. `pnvm.c` has
similar unchecked `tlv_len - sizeof(*section)` (separate issue). Patch
1/5 in the same series addresses aligned-length underflow in the TLV
walker.

---

## Phase 6: Cross-Referencing Against Local Tree

**Step 6.1 — Buggy code in tree?**

Record: **Yes.** Local tree is `linux-6.18.y` at `v6.18.44`. Current
`iwl-drv.c` lacks the minimum-size check; vulnerable line is:

```515:515:drivers/net/wireless/intel/iwlwifi/iwl-drv.c
        sec->size = size - sizeof(sec_parse->offset);
```

Commit `d13d5d299c11b` is on `master` but not yet in this stable branch.

**Step 6.2 — Backport complications**

Record: Clean apply (`git apply --check` passes). No conflicts expected.

**Step 6.3 — Related fixes already present?**

Record: No equivalent SEC_RT minimum-size fix in tree. Related pnvm
validation fix (`eae7fdf7d4469`) is already backported.

---

## Phase 7: Subsystem and Maintainer Context

**Step 7.1 — Subsystem**

Record: `drivers/net/wireless/intel/iwlwifi` — IMPORTANT (widely
deployed WiFi driver on Intel laptops/desktops).

**Step 7.2 — Activity**

Record: Actively maintained; multiple validation fixes backported to
6.18.y in 2025–2026.

---

## Phase 8: Impact and Risk Assessment

**Step 8.1 — Who is affected**

Record: iwlwifi users loading TLV-format MVM firmware (`CONFIG_IWLMVM`).
Affects driver probe path on Intel WiFi hardware.

**Step 8.2 — Trigger conditions**

Record: Firmware image containing SEC_RT-family TLV with `tlv_len <
sizeof(__le32)` (0–3 bytes). Requires replacing/corrupting firmware file
(typically root). Not triggerable by normal Intel firmware. Corrupted
downloads or malicious firmware replacement are realistic vectors.

**Step 8.3 — Failure severity**

Record:
- Huge `sec->size` → `vmalloc()` of enormous size (OOM pressure)
- `memcpy()` out-of-bounds read from firmware buffer → kernel crash or
  info leak
- **Severity: HIGH** (memory safety during probe)

**Step 8.4 — Risk vs benefit**

Record:
- **Benefit:** HIGH — prevents OOB read and runaway allocation on
  malformed input
- **Risk:** VERY LOW — 4-line defensive check, no API changes
- **Ratio:** Strongly favors backport

---

## Phase 9: Final Synthesis

**Step 9.1 — Evidence summary**

FOR:
- Real integer underflow → OOB read bug
- HIGH severity if triggered
- Small, obviously correct fix
- Code exists in 6.18.y; applies cleanly
- Consistent with other iwlwifi validation fixes already in stable
- Maintainer-authored

AGAINST:
- No user/syzbot report (internal finding)
- Trigger requires malformed firmware (unusual in practice)
- Callers don't propagate `iwl_store_ucode_sec()` error (pre-existing;
  fix still prevents bad state)
- Patch 1/5 from same series is a separate related fix, not a blocker

**Step 9.2 — Stable rules checklist**

1. Obviously correct and tested? **PASS** — logic is trivial; no runtime
   tests in commit, but mechanism is verifiable by inspection.
2. Fixes a real bug? **PASS** — underflow with OOB read consequence.
3. Important issue? **PASS** — memory safety / potential crash during
   probe.
4. Small and contained? **PASS** — 4 lines, one function.
5. No new features/APIs? **PASS** — defensive validation only.
6. Can apply to local tree? **PASS** — clean apply verified.

**Step 9.3 — Exception category**

Record: Not applicable (not device ID, quirk, DT, build, or docs).

**Step 9.4 — Decision rationale**

For the locally checked-out **linux-6.18.y** tree, this commit should be
backported. The vulnerable code is present, the fix is minimal and self-
contained, and the failure mode (size underflow leading to out-of-bounds
`memcpy` during firmware parsing) is a legitimate stability/memory-
safety issue appropriate for stable.

---

## Verification

- [Phase 1] Parsed commit message and tags from user query and `git show
  d13d5d299c11b`
- [Phase 2] Read current `iwl-drv.c` lines 493–519, 150–168, 999–1044,
  1458–1474, 1646–1702
- [Phase 2] Confirmed `sec->size` is `size_t`, parameter was `int`,
  subtraction at line 515
- [Phase 3] `git describe HEAD` → `v6.18.44`; `make kernelversion` →
  `6.18.44`
- [Phase 3] `git blame` on `iwl_store_ucode_sec`; shallow repo noted
- [Phase 3] `git log stable/linux-6.18.y..master -- iwl-drv.c` — commit
  not in stable, patch 1/5 also absent
- [Phase 3] `git apply --check` of commit diff on HEAD — passes
- [Phase 4] `b4 dig -c d13d5d299c11b` — found lore URL
- [Phase 4] `b4 dig -a` — v1 only, patch 5/5
- [Phase 4] `b4 dig -w` — johannes, linux-wireless, Emmanuel Grumbach
- [Phase 4] `b4 dig -m /tmp/iwlwifi_sec_rt.mbox` — read cover letter; no
  reviews/stable/tested-by
- [Phase 5] `grep iwl_store_ucode_sec` — 7 call sites in TLV parser
- [Phase 5] Traced call chain: `iwl_req_fw_callback` →
  `iwl_parse_tlv_firmware` → `iwl_alloc_ucode` → `iwl_alloc_fw_desc`
- [Phase 6] Confirmed buggy code present at HEAD; fix absent
  (`d13d5d299c11b` only on master)
- [Phase 6] Confirmed `eae7fdf7d4469` similar pnvm fix already in stable
- [Phase 8] Confirmed TLV parser allows `tlv_len < 4` for SEC_RT cases
  (no `invalid_tlv_len` guard unlike other TLVs)

**YES**

 drivers/net/wireless/intel/iwlwifi/iwl-drv.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
index 3a4bcfd60905c..e3b1bf31ca60e 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
@@ -491,7 +491,7 @@ static void set_sec_offset(struct iwl_firmware_pieces *pieces,
  * Gets uCode section from tlv.
  */
 static int iwl_store_ucode_sec(struct fw_img_parsing *img,
-			       const void *data, int size)
+			       const void *data, size_t size)
 {
 	struct fw_sec *sec;
 	const struct fw_sec_parsing *sec_parse;
@@ -500,6 +500,9 @@ static int iwl_store_ucode_sec(struct fw_img_parsing *img,
 	if (WARN_ON(!img || !data))
 		return -EINVAL;
 
+	if (size < sizeof(sec_parse->offset))
+		return -EINVAL;
+
 	sec_parse = (const struct fw_sec_parsing *)data;
 
 	alloc_size = sizeof(*img->sec) * (img->sec_counter + 1);
-- 
2.53.0

