Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C576251A72F;
	Mon, 31 Aug 2026 13:43:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183819; cv=none; b=ugxXYibMOoxsl+2uQ3bKf1Mc3aifwyHhuvodXdIRqXXZFl3SW6n93sGmD5UVie1ndewYVDwOKSZovd2JTZVc/+TF0et4S9J1bvluOTnaCK6xRG6Y+QZB4u31HPScB0u5uoYbCdEwhcdu1HyGVjpxBFK3rewN7LOT2OrHQcVOM4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183819; c=relaxed/simple;
	bh=M++qnYEBIPrFMdHqb4uE5jaKhapioNs/brjdMNPjxzc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QGjh0Xt3eQpoYJEOmdQF2AlY/rpqNTD+jFSqci/VfS2D3+vetktQoQtQX8dOtECSXpza4DiGs2NvAHrVxLm+jP89m6k6Q2tsLD7Y6Hyjpf0RQbMGRlIMAYHpFVUGyLJrm4Wt7/ryxa7QigHPS3VLwjJWiMPiELDparnTpHbll4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VNzi6b8Y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VNzi6b8Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 137CB1F000E9;
	Mon, 31 Aug 2026 13:43:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183816;
	bh=GjxtKlsoeJlgmpkUYE75rwgbvZZYGBC24mHWY5N0GwQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VNzi6b8Y2tQai1OrVxO1FNpvByme+ecunEk7UYVV3GVhjGbDfFJNMa9bwvYjhNBBn
	 JmZ0Q+2QA9bRB6T8I0/CczoLxge2MtcaoraRKp1MATXvBUf/cyJUwwjz/0BzyBt44+
	 yyKQADQDmt5GjChXOtbBfnnPRB+rZ4n5Ctn49Eb4HBetl0t6ITTiB+yR0qZjiHWqRy
	 inLYEbVNkWPpHDXBm9/Kw1U0x5bS06oFaY1hFCY+qX0hqvbcpn3HCAKB8mNvPKeU4a
	 yft9Y9Qnc/B4f4F2tIr39ANVOaCk0Z18TKL973DKmS/mr3sugnyNdoMhbl0sM05CpF
	 oTWP9wR2xWK6A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Venkat Rao Bagalkote <venkat88@linux.ibm.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Tellakula Yeswanth Krishna <yeswanth@linux.ibm.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] char/nvram: Remove redundant nvram_mutex
Date: Mon, 31 Aug 2026 09:25:50 -0400
Message-ID: <20260831133314.4125787-322-sashal@kernel.org>
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

From: Venkat Rao Bagalkote <venkat88@linux.ibm.com>

[ Upstream commit e8c715f3a7dae43fabae261493a26474fec11863 ]

The global nvram_mutex in drivers/char/nvram.c is redundant and unused,
and this triggers compiler warnings on some configurations.

All platform-specific nvram operations already provide their own internal
synchronization, meaning the wrapper-level mutex does not provide any
additional safety.

Remove the nvram_mutex definition along with all remaining lock/unlock
users across PPC32, x86, and m68k code paths, and rely entirely on the
per-architecture nvram implementations for locking.

Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Suggested-by: Arnd Bergmann <arnd@arndb.de>
Tested-by: Tellakula Yeswanth Krishna <yeswanth@linux.ibm.com>
Signed-off-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Tested-by: yeswanth <yeswanth@linux.ibm.com>
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Link: https://patch.msgid.link/20260428061540.73668-1-venkat88@linux.ibm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Connection lost, reconnecting to https://agentn.us.api5.cursor.sh
(attempt 1)...
Retry attempt 1...
## Phase 1: Commit Message Forensics

### Step 1.1: Subject line
**Record:** `[char/nvram]` `[Remove]` — Remove redundant `nvram_mutex`
that is unused on some configs and unnecessary on others.

### Step 1.2: Tags
**Record:**
- **Reviewed-by:** Arnd Bergmann (original author of `nvram_mutex` in
  2010)
- **Suggested-by:** Arnd Bergmann
- **Tested-by:** Tellakula Yeswanth Krishna (IBM), yeswanth
- **Reviewed-by:** Ritesh Harjani (IBM)
- **Link:**
  https://patch.msgid.link/20260428061540.73668-1-venkat88@linux.ibm.com
- **Signed-off-by:** Venkat Rao Bagalkote, Greg Kroah-Hartman
- No `Fixes:`, no `Reported-by:`, no `Cc: stable@vger.kernel.org`
- Notable: subsystem expert (Arnd) both suggested and reviewed; IBM
  tested on Power

### Step 1.3: Body analysis
**Record:**
- **Bug described:** Global `nvram_mutex` is redundant/unused; causes
  compiler warnings on some configurations.
- **Symptom:** `-Wunused` warning (unused static mutex) on configs where
  no lock sites are compiled; redundant outer locking elsewhere.
- **Root cause (author):** Mutex is leftover from BKL→mutex conversion;
  per-arch NVRAM ops already synchronize internally.
- **Version info:** None in message.

### Step 1.4: Hidden bug fix?
**Record:** Not a hidden crash/corruption fix. This is **build hygiene +
dead-code removal**. Removing redundant outer mutex does not fix a
reported runtime failure; arch-level locks (`rtc_lock`, `nv_lock`)
already protect hardware access.

---

## Phase 2: Diff Analysis

### Step 2.1: Inventory
**Record:**
- **File:** `drivers/char/nvram.c` only (~19 lines removed, 0 added)
- **Functions touched:** `nvram_misc_ioctl()` ioctl cases only; removes
  `DEFINE_MUTEX(nvram_mutex)`
- **Scope:** Single-file surgical cleanup

### Step 2.2: Code flow change
**Record:**
| Hunk | Before | After |
|------|--------|-------|
| Global | `DEFINE_MUTEX(nvram_mutex)` always defined | Mutex removed
entirely |
| `IOC_NVRAM_SYNC` (PPC32) | lock → `ppc_md.nvram_sync()` → unlock |
Direct call |
| `NVRAM_INIT` / `NVRAM_SETCKS` (x86/m68k) | lock → arch op → unlock |
Direct arch op call |

Read/write/open paths were **already** not using `nvram_mutex`.

### Step 2.3: Bug mechanism
**Record:**
- **Category:** Build warning / redundant synchronization cleanup
- **Mechanism:** On **ppc64** (CONFIG_PPC, no CONFIG_PPC32/X86/M68K),
  mutex is defined but never referenced → `-Wunused-variable` under
  default `-Wunused`. On x86/m68k/ppc32, mutex wrapped ioctl calls whose
  callees already take `rtc_lock` or `nv_lock`.

### Step 2.4: Fix quality
**Record:** Fix is minimal and logically sound. Verified callees:
- x86 `pc_nvram_initialize()` / `pc_nvram_set_checksum()` →
  `spin_lock_irq(&rtc_lock)`
- m68k `atari_nvram_initialize()` / `atari_nvram_set_checksum()` →
  `spin_lock_irq(&rtc_lock)`
- ppc `core99_nvram_sync()` → `raw_spin_lock_irqsave(&nv_lock, flags)`

Removing outer mutex does not remove the only serialization; it removes
duplicate serialization. **Regression risk: LOW** given Arnd’s review
and existing inner locks.

---

## Phase 3: Git History Investigation

### Step 3.1: Blame
**Record:**
- `nvram_mutex` introduced in `613655fa39ff6` (2010, Arnd Bergmann) —
  BKL→mutex scripted conversion
- Lock sites at ioctl paths from `95ac14b8a3281` / `2d58636e0af72`
  (2019, Finn Thain refactor)
- Mutex was removed from open/read/write long ago (`83cb16727085b`,
  2009+)

### Step 3.2: Fixes: tag
**Record:** N/A — no `Fixes:` tag.

### Step 3.3: Related file history
**Record:** `nvram.c` refactored in 2019 (`arch_nvram_ops`, PPC ioctl
split). Mutex survived refactor as outer wrapper. Standalone patch, not
part of a series.

### Step 3.4: Author context
**Record:** Venkat Rao Bagalkote — IBM contributor; no prior `nvram.c`
history in this tree. Arnd Bergmann is the relevant subsystem historian.

### Step 3.5: Dependencies
**Record:** No prerequisites. Commit not yet in this tree; target code
matches diff context exactly. Prerequisites `613655fa39ff6`,
`95ac14b8a3281` are ancestors of HEAD.

---

## Phase 4: Mailing List and External Research

### Step 4.1–4.5
**Record:**
- `b4 dig -c <commit>`: **N/A** — commit not present in local tree; no
  commitish available
- Lore/patch.msgid.link fetch: **BLOCKED** (Anubis bot protection)
- Could not verify mailing-list stable nominations or reviewer thread
  content
- Link in commit message confirms patch submission (2026-04-28) but
  thread content unverified

---

## Phase 5: Code Semantic Analysis

### Step 5.1: Key functions
**Record:** `nvram_misc_ioctl()`, and arch ops: `pc_nvram_initialize()`,
`pc_nvram_set_checksum()`, `core99_nvram_sync()`, atari equivalents.

### Step 5.2: Callers
**Record:** `nvram_misc_ioctl` registered as `.unlocked_ioctl` in
`nvram_misc_fops` → `/dev/nvram` ioctl from userspace (CAP_SYS_ADMIN for
INIT/SETCKS). Reachable but niche.

### Step 5.3: Callees
**Record:** Arch ops use `rtc_lock` (x86/m68k) or `nv_lock` (powermac).
Only `core99_nvram_sync` implements `ppc_md.nvram_sync` in this tree.

### Step 5.4: Reachability
**Record:** Userspace ioctl path; admin capability required for
init/setcks. ppc64 builds still compile `nvram.c` (CONFIG_NVRAM defaults
on PPC via `HAVE_ARCH_NVRAM_OPS`), but **no mutex use sites** are
compiled on pure ppc64.

### Step 5.5: Similar patterns
**Record:** Read/write paths never used wrapper mutex — only ioctl did.
Consistent with “leftover from BKL era” narrative.

---

## Phase 6: Cross-Reference Against Local Tree (6.18.44)

### Step 6.1: Buggy code present?
**Record:** **YES.** Local tree is `v6.18.44` (`stable/linux-6.18.y`).
`nvram_mutex` present at lines 56, 314–316, 328–330, 340–342 in
`drivers/char/nvram.c`.

### Step 6.2: Backport complications
**Record:** **Clean apply expected.** File structure matches diff; no
conflicting recent churn.

### Step 6.3: Related fixes already present?
**Record:** None found for this issue (`git log --grep="nvram_mutex"` /
`--grep="redundant nvram"` empty).

---

## Phase 7: Subsystem Context

### Step 7.1: Subsystem
**Record:** `drivers/char` — legacy `/dev/nvram` driver. **IMPORTANT**
for x86/m68k/ppc32 users of NVRAM; **PERIPHERAL** overall, but
**relevant on Power** (IBM tested).

### Step 7.2: Activity
**Record:** Low activity; last functional changes ~2019. Mature legacy
driver.

---

## Phase 8: Impact and Risk Assessment

### Step 8.1: Who is affected
**Record:**
- **ppc64 builders:** unused-variable warning on every default NVRAM
  build (`-Wunused` always enabled per `scripts/Makefile.extrawarn`)
- **x86/m68k/ppc32 users:** ioctl path loses redundant outer mutex
  (effective serialization unchanged via inner locks)

### Step 8.2: Trigger conditions
**Record:** Warning: build `CONFIG_NVRAM=y` on ppc64 without
PPC32/X86/M68K ioctl paths. Common on modern Power servers. Not a
default build **error** unless `-Werror` is added by builder.

### Step 8.3: Failure mode severity
**Record:**
- **Without patch:** Compiler warning (MEDIUM for builders; LOW for end
  users)
- **With patch:** No expected runtime behavior change; removes duplicate
  locking
- **Severity if backport skipped:** No crash/corruption; possible
  warning noise / `-Werror` build failure in strict environments

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** MEDIUM for ppc64 build hygiene; negligible runtime
  benefit
- **Risk:** LOW — small diff, expert-reviewed, inner locks verified
- **Ratio:** Modest positive; not critical, but appropriate stable
  material as a contained build/cleanup fix

---

## Phase 9: Final Synthesis

### Step 9.1: Evidence summary

**FOR backport:**
- Fixes real `-Wunused` warning on ppc64 (default NVRAM on Power)
- Tiny, single-file, obviously correct cleanup
- Reviewed/suggested by Arnd Bergmann (original mutex author)
- IBM Tested-by on Power
- Inner arch locking verified in-tree; mutex was duplicate
- Applies cleanly to 6.18.44

**AGAINST backport:**
- Not a runtime crash/corruption/security fix
- Default kernel build warns but does not fail (`-Wunused` without
  `-Werror`)
- Official stable rules emphasize “build error” more than warnings
- Touches synchronization (even if redundant) in stable tree

**Unresolved:** Mailing-list thread content unverified (lore blocked);
could not run `b4 dig` without commit hash.

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — Arnd reviewed; IBM tested;
   inner locks verified
2. Fixes real bug affecting users? **PASS (marginal)** — real compiler
   warning on ppc64; not end-user runtime bug
3. Important issue? **PASS (low-medium)** — build warning; not
   crash/corruption
4. Small and contained? **PASS** — one file, ~20 lines
5. No new features/APIs? **PASS**
6. Can apply to local tree? **PASS** — code present, clean apply
   expected

### Step 9.3: Exception category
**Record:** **BUILD FIX** — compiler warning on ppc64 configurations.

### Step 9.4: Decision rationale
For **Linux 6.18.y**, this patch addresses a verified build warning on a
common Power configuration, removes genuinely redundant locking with
maintainer endorsement, and is low-risk. It is not urgent like a crash
fix, but it meets stable criteria as a small, expert-reviewed build fix
with clear technical merit for ppc64 builders and distributors using
strict warning flags.

---

## Verification

- [Phase 1] Parsed subject, tags, body from provided commit message
- [Phase 1] Confirmed no `Fixes:`, syzbot, or stable Cc tags
- [Phase 2] Read full `drivers/char/nvram.c`; confirmed diff targets
  only `nvram_mutex` and ioctl wrappers
- [Phase 2] Verified x86 ops use `rtc_lock` (lines 144–161, 206–214)
- [Phase 2] Verified m68k ops use `rtc_lock` (`arch/m68k/atari/nvram.c`
  lines 79–96)
- [Phase 2] Verified `core99_nvram_sync()` uses `nv_lock`
  (`arch/powerpc/platforms/powermac/nvram.c` lines 471–501)
- [Phase 3] `git blame`: mutex from `613655fa39ff6` (2010); ioctl locks
  from `95ac14b8a3281`/`2d58636e0af72` (2019)
- [Phase 3] `git log --oneline -30 -- drivers/char/nvram.c`: no
  duplicate fix present
- [Phase 3] Confirmed prerequisite commits are ancestors of HEAD
- [Phase 4] `b4 dig`: **UNVERIFIED** — commit not in tree, no commitish
- [Phase 4] Lore/patch.msgid.link fetch: **BLOCKED** by bot protection
- [Phase 5] Confirmed `nvram_misc_ioctl` is only ioctl entry; read/write
  never used mutex
- [Phase 5] `grep nvram_sync`: only `core99_nvram_sync` assigned in-tree
- [Phase 6] `git describe HEAD` → `v6.18.44`; `make kernelversion` →
  `6.18.44`
- [Phase 6] `grep nvram_mutex drivers/char/nvram.c`: mutex present (6
  matches)
- [Phase 6] Kconfig: `NVRAM` depends on `X86 || HAVE_ARCH_NVRAM_OPS`,
  default `M68K || PPC`; Power selects `HAVE_ARCH_NVRAM_OPS`
- [Phase 6] Config analysis: ppc64 compiles mutex definition but no lock
  sites (PPC32/X86/M68K paths absent)
- [Phase 7] `scripts/Makefile.extrawarn` line 108: `-Wunused` always
  enabled
- [Phase 8] Confirmed warning is not default `-Werror`; strict builders
  may treat it as failure

**YES**The branch search finished: this checkout is
**stable/linux-6.18.y** at **v6.18.44**, and the `nvram_mutex` removal
commit is **not** in this tree yet — `nvram_mutex` is still present in
`drivers/char/nvram.c`.

**Backport recommendation: YES** for 6.18.y.

It’s a small, low-risk build/cleanup fix: on ppc64 the mutex is unused
(compiler warning under `-Wunused`), and on x86/m68k/ppc32 the wrapper
mutex is redundant because the arch ops already use `rtc_lock` or
`nv_lock`. Arnd Bergmann reviewed/suggested it, and it was IBM-tested.
It should apply cleanly to 6.18.44.

 drivers/char/nvram.c | 16 +++-------------
 1 file changed, 3 insertions(+), 13 deletions(-)

diff --git a/drivers/char/nvram.c b/drivers/char/nvram.c
index 9eff426a92865..e89cc1f1c89ea 100644
--- a/drivers/char/nvram.c
+++ b/drivers/char/nvram.c
@@ -53,7 +53,6 @@
 #include <asm/nvram.h>
 #endif
 
-static DEFINE_MUTEX(nvram_mutex);
 static DEFINE_SPINLOCK(nvram_state_lock);
 static int nvram_open_cnt;	/* #times opened */
 static int nvram_open_mode;	/* special open modes */
@@ -310,11 +309,8 @@ static long nvram_misc_ioctl(struct file *file, unsigned int cmd,
 		break;
 #ifdef CONFIG_PPC32
 	case IOC_NVRAM_SYNC:
-		if (ppc_md.nvram_sync != NULL) {
-			mutex_lock(&nvram_mutex);
+		if (ppc_md.nvram_sync)
 			ppc_md.nvram_sync();
-			mutex_unlock(&nvram_mutex);
-		}
 		ret = 0;
 		break;
 #endif
@@ -324,11 +320,8 @@ static long nvram_misc_ioctl(struct file *file, unsigned int cmd,
 		if (!capable(CAP_SYS_ADMIN))
 			return -EACCES;
 
-		if (arch_nvram_ops.initialize != NULL) {
-			mutex_lock(&nvram_mutex);
+		if (arch_nvram_ops.initialize)
 			ret = arch_nvram_ops.initialize();
-			mutex_unlock(&nvram_mutex);
-		}
 		break;
 	case NVRAM_SETCKS:
 		/* just set checksum, contents unchanged (maybe useful after
@@ -336,11 +329,8 @@ static long nvram_misc_ioctl(struct file *file, unsigned int cmd,
 		if (!capable(CAP_SYS_ADMIN))
 			return -EACCES;
 
-		if (arch_nvram_ops.set_checksum != NULL) {
-			mutex_lock(&nvram_mutex);
+		if (arch_nvram_ops.set_checksum)
 			ret = arch_nvram_ops.set_checksum();
-			mutex_unlock(&nvram_mutex);
-		}
 		break;
 #endif /* CONFIG_X86 || CONFIG_M68K */
 	}
-- 
2.53.0

