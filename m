Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53B2B54645C;
	Mon, 19 Oct 2026 14:06:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418824; cv=none; b=gi6tPC6QMJGvgIiZNEDYzWKI47Eh0UgyqbsG2RJOF+lxfjU19Yh4mRZV3Xwc7rFh/z90iRrte0TU+aZf0N19OwtPI6b54FR6W7J+lMzVOG/3gxkqdKRS47pUX2qvmrE9r49IZP8ruWtXbog5HLPGUiYWAefrZpJ6IFnuVocpd+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418824; c=relaxed/simple;
	bh=oxdSTRluYO2IE/oTg/gORSQtPQDBuYNfMVkbEt1vNWU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EOPqdpLElVNfrQhwe/7wARl/hKYX8IMvqLX5SVTMtiTXBu/IHbGND7VziHXy3ZVetEI8p4mcudmC8pvFvWxrWa7VfOO779vW6PfEGkyRk7e4yREfIA7umPFv4654Rq1zgKbITNrp2/rWLwVSeyyTNKeNJIdsUkUy2UYWnHM3I6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g5lNz9W+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g5lNz9W+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41C281F000C9;
	Mon, 19 Oct 2026 14:06:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418812;
	bh=LZCg7XlqP+XFJwUJDmW26gdSPgM58euZsKhP6jYBkzg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g5lNz9W+uXosFNBf12ZfaG4IuAXuO5H5d/G9RacnBZLH+3cYsCqDH+bGpcEYeEn8C
	 +bSm/s6dwypwB3R6N1PPoJMhIf457jIPCS+vb/86W12izz95ekWXPh0EPkASjADb6k
	 sNJqe6W1Uk0PkE4ytbsXvuXFoKPdCzutBeNPmrGUqqUNMI5F+orwITXrHGL/NJUtHI
	 nDHOKoubIjXhGOiaLIuPYk1GWlSnkyGELihD109KT9KdLrrvJvNRi2VH6z7SyYASF9
	 +IpEPcdBk6y1JJycpqvnHlECMNTAtYEYJdUuvje52s5HiqZqRE2vMYMdgzf/ywDjOB
	 FN292QrYDPk9w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Paritosh Potukuchi <paritoshpotukuchi@gmail.com>,
	Paritosh Potukuchi <paritosh.potukuchi@amd.com>,
	Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	shyam-sundar.s-k@amd.com,
	linux-i2c@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] i2c: amd-asf: Validate firmware-reported length
Date: Mon, 19 Oct 2026 09:53:25 -0400
Message-ID: <20261019135441.1420968-514-sashal@kernel.org>
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

From: Paritosh Potukuchi <paritoshpotukuchi@gmail.com>

[ Upstream commit b2f4816a378dc840b605a1235b80e57c5f85b46c ]

The firmware may sometimes return a length greater than the
allocated buffer size, which can lead to out-of-bounds access
and a kernel panic.

Currently, the driver does not validate the length read from
firmware.

Add a check to ensure the firmware-reported length stays within
the bounds of the data buffer.

Signed-off-by: Paritosh Potukuchi <paritosh.potukuchi@amd.com>
Acked-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://lore.kernel.org/r/20260612101815.4124804-1-paritosh.potukuchi@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit message forensics

**Step 1.1 — Subject line**
Record: **[i2c/amd-asf] [Validate] firmware-reported length used as a
copy bound**

**Step 1.2 — Tags** (pipeline markers ignored: `[Upstream commit ...]`,
`Signed-off-by: Sasha Levin`)
Record:
- Signed-off-by: Paritosh Potukuchi &lt;paritosh.potukuchi@amd.com&gt;
  (author)
- Acked-by: Shyam Sundar S K &lt;Shyam-sundar.S-k@amd.com&gt; (original
  driver author)
- Signed-off-by: Andi Shyti &lt;andi.shyti@kernel.org&gt; (I2C
  maintainer)
- Link: https://lore.kernel.org/r/20260612101815.4124804-1-
  paritosh.potukuchi@amd.com
- No Fixes:, Reported-by, Tested-by, Reviewed-by, or Cc: stable (absence
  expected)

**Step 1.3 — Body**
Record: Firmware can return a length larger than the allocated buffer;
that produces **out-of-bounds access and a kernel panic**. The driver
never checked the length read from firmware. The fix is a bounds check
against the data buffer. No stack trace, reproducer, or version range is
given.

**Step 1.4 — Hidden bug fix?**
Record: **No.** This is an explicit OOB/panic fix, not cleanup disguised
as a fix.

---

## Phase 2: Diff analysis

**Step 2.1 — Inventory**
Record: One file, `drivers/i2c/busses/i2c-amd-asf-plat.c`, **+4 / −0**.
Function: `amd_asf_process_target()`. Surgical single-function change.

**Step 2.2 — Code flow**
Before (verified in `v6.18.53`):

```92:94:drivers/i2c/busses/i2c-amd-asf-plat.c
                len = inb_p(ASFDATARWPTR);
                for (idx = 0; idx < len; idx++)
                        data[idx] = inb_p(ASFINDEX);
```

`data` is `u8 data[ASF_BLOCK_MAX_BYTES]` (72). `len` is `u8`, so
firmware can return 0–255. The loop writes past the stack buffer when
`len > 72`. A later loop in the same function also indexes `data[idx]`
with the same `len`.

After: if `len > ASF_BLOCK_MAX_BYTES`, return before the copy.

**Step 2.3 — Bug mechanism**
Record: **(d) Memory safety — buffer overflow / OOB.** Firmware-supplied
I/O length used as loop bound with no clamp. Same pattern already exists
on the host write path (`amd_asf_access()`: `if (len == 0 || len >
ASF_BLOCK_MAX_BYTES)`).

**Step 2.4 — Fix quality**
Record: Minimal and obviously correct for stopping the overflow.
Comparison is `>` against a 72-byte array (index 0..71), so `len == 72`
is valid. Regression risk is low on the success path. On the error path
the early `return` skips bank-status clear and `ASFSETDATARDPTR` reset;
that can leave hardware stuck after a firmware bug, but that path
already panicked. No API, locking, or data-structure change.

---

## Phase 3: Git history

**Step 3.1 — Blame**
Record: Buggy loop introduced in `9b25419ad3971` (“i2c: amd-asf: Add
routine to handle the ASF slave process”, 2024-09-23). First in
**v6.13-rc1**. Present in this 6.18.y tree.

**Step 3.2 — Fixes: tag**
Record: None. Introducer is `9b25419ad3971`, confirmed ancestor of
`v6.18.53`.

**Step 3.3 — File history**
Record: Related commits already in `v6.18.53`:
- `a5089cd23b10c` — initialize `len` (Fixes: 9b25419ad397)
- `b719afaa1e5d8` — set `cmd` on error
No extra prerequisite is required for this bounds check. Standalone.

**Step 3.4 — Author**
Record: First I2C commit from Paritosh Potukuchi. Acked by original AMD
ASF author Shyam Sundar S K. Applied by I2C maintainer Andi Shyti.

**Step 3.5 — Dependencies**
Record: Uses existing `ASF_BLOCK_MAX_BYTES` and the existing loop. `git
diff v6.18.53 d88d3b2633b03^ -- drivers/i2c/busses/i2c-amd-asf-plat.c`
is empty; `git apply --check` against the 6.18.53 file succeeded.
**Applies standalone and cleanly.**

---

## Phase 4: Mailing list / external research

**Step 4.1 — Original discussion**
Record: `b4 dig -c b2f4816a378dc840b605a1235b80e57c5f85b46c` matched
https://patch.msgid.link/20260612093502.3805287-1-
paritosh.potukuchi@amd.com
Thread saved to mbox (lore HTTP 403 via WebFetch/curl).

Revisions:
- v1 (2026-06-12 09:35): same check, broken indentation
- v2 (2026-06-12 10:18): indentation fixed (subject still `[PATCH]`, not
  `[PATCH v2]`)
- Applied version adds a blank line before the `if` (Andi added it on
  apply)

Andi asked how often this happens and whether it should be considered a
fix. Shyam acked without quantifying frequency and without NAK. Andi
merged to `i2c/i2c-for-7.2`. No reviewer asked for `Cc: stable`. No NAK.

**Step 4.2 — Recipients (`b4 dig -w`)**
Record: Author, shyam-sundar.s-k@amd.com, andi.shyti@kernel.org,
linux-i2c, linux-kernel. Right maintainers were on the patch.

**Step 4.3 — Bug report**
Record: No syzbot/bugzilla link. Report is the patch itself from AMD,
describing firmware returning too-large length and a panic.

**Step 4.4 — Series**
Record: Standalone single patch, not part of a multi-patch series.

**Step 4.5 — Stable list**
Record: lore.kernel.org/stable returned 403. Mbox has no “stable”
mention. **UNVERIFIED** whether stable@ discussed it separately.

---

## Phase 5: Code semantic analysis

**Step 5.1 — Functions**
Record: `amd_asf_process_target()` only.

**Step 5.2 — Callers**
Record: Not called directly. Registered as delayed-work callback in
`amd_asf_probe()` via `devm_delayed_work_autocancel(...,
amd_asf_process_target)`. Scheduled from `amd_asf_irq_handler()` when
ASF target IRQ bit 6 is set (`schedule_delayed_work(&dev->work_buf,
HZ)`). Workqueue context, not IRQ context.

**Step 5.3 — Callees**
Record: `inb_p`/`outb_p` (port I/O), then (after this hunk)
`i2c_slave_event()`. No alloc/lock in the changed path.

**Step 5.4 — Reachability**
Record: Reached when AMD ASF slave/target interrupt fires
(`CONFIG_I2C_AMD_ASF`, ACPI `AMDI001A`). Trigger is firmware/BMC ASF
traffic, not a generic unprivileged syscall. Still a host kernel stack
overflow if firmware reports `len > 72`.

**Step 5.5 — Similar patterns**
Record: Host path already bounds-checks in `amd_asf_access()` (`len == 0
|| len > ASF_BLOCK_MAX_BYTES`) and `amd_asf_xfer()` (`msgs->len >
ASF_BLOCK_MAX_BYTES - 3`). Slave/target path was the missing check.

---

## Phase 6: Local tree (`v6.18.53` / 6.18.y)

**Step 6.1 — Does the buggy code exist?**
Record: **Yes.** `git merge-base --is-ancestor d88d3b2633b03 v6.18.53`
failed (fix not in 6.18.53). `git show
v6.18.53:drivers/i2c/busses/i2c-amd-asf-plat.c` has the unbounded loop.
Driver added in v6.13; bug since then.

**Step 6.2 — Backport difficulty**
Record: **Clean apply.** Parent of the candidate matches 6.18.53 file
content; `git apply --check` succeeded.

**Step 6.3 — Related fixes already here?**
Record: Uninit-`len` and error-`cmd` fixes are in 6.18.53. **No existing
bounds check** on this firmware length.

---

## Phase 7: Subsystem context

**Step 7.1**
Record: **drivers/i2c** (AMD ASF bus driver). Criticality:
**PERIPHERAL** (AMD ASF/DASH, depends on `I2C_PIIX4`), but a host panic
still matters for those systems.

**Step 7.2**
Record: Small, mature-enough driver (landed v6.13, a few follow-up fixes
through 6.15). Not staging.

---

## Phase 8: Impact and risk

**Step 8.1 — Who is affected**
Record: **Driver-specific / config-specific:** `CONFIG_I2C_AMD_ASF` on
AMD systems with ASF (`AMDI001A`).

**Step 8.2 — Trigger**
Record: ASF target interrupt + firmware length &gt; 72. Frequency not
quantified on-list (Andi asked; Shyam only acked). Not a normal syscall
path; firmware/BMC-driven. Unprivileged userspace generally cannot set
that I/O length directly.

**Step 8.3 — Failure mode**
Record: Stack buffer overflow (up to 183 bytes past a 72-byte stack
array), then OOB read in the second loop. Commit states **kernel
panic**. Severity: **CRITICAL** (crash; stack smash).

**Step 8.4 — Risk vs benefit**
Record: Benefit **high** for ASF users (panic/OOB). Risk **very low** (4
lines, success path unchanged, same check already used on the write
path). Early-return skips HW cleanup only on the already-broken firmware
path.

---

## Phase 9: Synthesis

**For backporting**
- Real stack OOB from unvalidated firmware length → panic
- Tiny, obviously correct, matches existing driver checks
- Driver and buggy loop are in this 6.18.53 tree (since v6.13)
- Applies cleanly; no missing helpers
- Acked by original driver author; applied by I2C maintainer

**Against**
- AMD-only driver, not a core path
- Frequency of bad firmware length never quantified
- Early return does not reset ASF bank/pointer (error-path
  incompleteness, not a happy-path regression)
- No Fixes:/Cc: stable (not a negative per rules)

**Unresolved**
- Stable mailing list search (lore 403)
- Exact field reproduction rate (unverified beyond AMD’s “may
  sometimes”)

**Stable rules**
1. Obviously correct and tested? **PASS** — 4-line bound check;
   maintainer applied after ack
2. Real bug affecting users? **PASS** — OOB/panic on ASF target RX
3. Important (crash/security/corruption/deadlock)? **PASS** — stack
   overflow → panic
4. Small and contained? **PASS** — +4 lines, one function
5. No new features/APIs? **PASS**
6. Can apply to this tree? **PASS** — clean against 6.18.53

Exception category: none needed; this is a normal crash/OOB fix.

This 6.18.y tree has the unbounded copy and not the fix. Backporting
prevents a kernel panic on AMD ASF hardware when firmware reports a
length above 72.

---

## What the commit solves, and why it matters here

`amd_asf_process_target()` copies firmware bytes into a 72-byte stack
buffer using a length read from `ASFDATARWPTR` with no cap. `len` is
`u8`, so a value 73–255 overruns the stack and can panic. This 6.18.53
tree still has that loop. The patch adds the same bound already used on
the write path. Cost is four lines; the normal path is unchanged.

---

## Verification

- **[Phase 1]** Parsed message/tags from `git show d88d3b2633b03`; no
  Fixes/Reported-by/Cc: stable; Acked-by Shyam; SOB Andi Shyti
- **[Phase 2]** Diff is +4 in `amd_asf_process_target`;
  `data[ASF_BLOCK_MAX_BYTES]` (72); `len` is `u8`; write path already
  checks `len > ASF_BLOCK_MAX_BYTES` at line 176
- **[Phase 3]** `git blame` on v6.18.53: loop from `9b25419ad3971`; `git
  describe --contains` → v6.13-rc1; `git merge-base --is-ancestor
  9b25419ad3971 v6.18.53` true
- **[Phase 3]** `git merge-base --is-ancestor d88d3b2633b03 v6.18.53`
  false (fix not in 6.18.53)
- **[Phase 3]** `a5089cd23b10c` and `b719afaa1e5d8` are ancestors of
  v6.18.53
- **[Phase 3]** `git diff v6.18.53 d88d3b2633b03^ --
  drivers/i2c/busses/i2c-amd-asf-plat.c` empty
- **[Phase 4]** `b4 dig -c b2f4816a378dc840b605a1235b80e57c5f85b46c` /
  `-a` / `-w` / `-m`; thread: v1 indent bug, v2 indent fix, Andi process
  nits + “how often?”, Shyam Ack, merged i2c-for-7.2; no NAK
- **[Phase 4]** lore WebFetch/curl 403; discussion taken from saved mbox
- **[Phase 4]** git.kernel.org commit
  `b2f4816a378dc840b605a1235b80e57c5f85b46c` exists; no Fixes/Cc: stable
  in that commit
- **[Phase 5]** `git grep amd_asf_process_target`: only definition +
  `devm_delayed_work_autocancel`; scheduled from `amd_asf_irq_handler`
- **[Phase 6]** `git describe HEAD` → `v6.18.53-5049-g0f0bdc2b0dffb`;
  `make kernelversion` → 6.18.53; buggy loop present in `v6.18.53:` file
- **[Phase 6]** `git apply --check` of this patch onto the v6.18.53
  file: rc 0
- **[Phase 7]** `CONFIG_I2C_AMD_ASF` in v6.18.53 Kconfig, depends on
  `I2C_PIIX4`, ACPI id `AMDI001A`
- **[Phase 8]** Failure mode: stack OOB → panic (from commit + code);
  trigger is firmware length, not a generic syscall
- **UNVERIFIED:** stable@ list discussion (lore 403); how often firmware
  returns len &gt; 72 (not answered on-list)

**YES**

 drivers/i2c/busses/i2c-amd-asf-plat.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/i2c/busses/i2c-amd-asf-plat.c b/drivers/i2c/busses/i2c-amd-asf-plat.c
index ca45f0f233210..f5b73c8340495 100644
--- a/drivers/i2c/busses/i2c-amd-asf-plat.c
+++ b/drivers/i2c/busses/i2c-amd-asf-plat.c
@@ -90,6 +90,10 @@ static void amd_asf_process_target(struct work_struct *work)
 		outb_p(reg, ASFDATABNKSEL);
 		cmd = inb_p(ASFINDEX);
 		len = inb_p(ASFDATARWPTR);
+
+		if (len > ASF_BLOCK_MAX_BYTES)
+			return;
+
 		for (idx = 0; idx < len; idx++)
 			data[idx] = inb_p(ASFINDEX);
 
-- 
2.53.0

