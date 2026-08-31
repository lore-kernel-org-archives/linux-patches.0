Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56F0C54EEB3;
	Mon, 31 Aug 2026 13:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184007; cv=none; b=qP9PSvzL90Aj73NmkS3fVI7np6Fc9HgAjTQ2diBIgCjKDwXNPOCePm5f5e5zGsuvAiSc23LNbUjz2APCH3PgzVzy9tR2XYcpzhi65c+vvrqGGbcyd3xItSbqI397lKGabbxOoUar2IHjvuL6CRUzX2QCgE7ZvYc++Rf+5tXbSwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184007; c=relaxed/simple;
	bh=UYPJPppqzkAMCqdP1xVBlIiqDkd+p3fS238jn3O7YIM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kATYGioGyKzKivFmXxF/QnYhvGSxyt8qvLpzsAJeTz7nfMKZjBhbAwVB8OTsCxSZMkfvgaEL08/DXQuvaKyPqC1gi8qgMIZ81c3Ptf6RVhzH4LOngUOBKwQKdj867j0bKSY2FJRf9TVCSsYLyQIUVHun0b2S3Pt0RsoTRhvHAK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YGgWTQzh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YGgWTQzh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D81A1F00A3D;
	Mon, 31 Aug 2026 13:46:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184003;
	bh=vI53VAL6FJZXcfe47IL/ARawN3+1DnQrfMdNqhIh9IE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YGgWTQzhpAqWX9mF5W7DYNffLDDwFK0qiVrhbJWXgoLBc+TbL4EQ1Iiju2ZD3Hyz+
	 7UWtz7A1nny+KDyQYydv6XmwqJK5OF3suWC0091hph+3PtKTf4fO5cICbdsUunt/g0
	 uNymmgE13zdY7V6j2P4JFKzhMwRw0oF3JDbEeptzl2CI5f9WihlkqFeAUpd1aOolse
	 j4Q/EwKrVg6pf03XXgc6DuwQ8ZilB3MrAECZyCCWUwGAJahvYPvCnO/eBzQE1umZi9
	 mwaqEpLolR6RioC3+TQ/q4cWkMAqqkgKuQip9/P0rK2DyUaAHVjNspT100+1a0OXoC
	 grutJjcFAu+sg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Chenguang Zhao <zhaochenguang@kylinos.cn>,
	Paul Moore <paul@paul-moore.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	davem@davemloft.net,
	edumazet@google.com,
	pabeni@redhat.com,
	netdev@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] netlabel: fix IPv6 unlabeled address add error handling
Date: Mon, 31 Aug 2026 09:27:40 -0400
Message-ID: <20260831133314.4125787-432-sashal@kernel.org>
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

From: Chenguang Zhao <zhaochenguang@kylinos.cn>

[ Upstream commit 56872b930feee7ae07b9720ca950dd9fa65596ee ]

netlbl_unlhsh_add_addr6() always returned zero after
netlbl_af6list_add(), masking failures such as duplicate
IPv6 static label entries.

Signed-off-by: Chenguang Zhao <zhaochenguang@kylinos.cn>
Acked-by: Paul Moore <paul@paul-moore.com>
Link: https://patch.msgid.link/20260522022910.398416-1-zhaochenguang@kylinos.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `netlabel: fix IPv6 unlabeled address add
error handling`

**Local tree:** `v6.18.44` (`stable/linux-6.18.y`, `VERSION = 6`,
`PATCHLEVEL = 18`, `SUBLEVEL = 44`)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject line
**Record:** `[netlabel]` `[fix]` — IPv6 unlabeled address add error
handling was broken; failures from `netlbl_af6list_add()` were masked.

### Step 1.2: Tags
**Record:**
- **Signed-off-by:** Chenguang Zhao `<zhaochenguang@kylinos.cn>`
  (author)
- **Acked-by:** Paul Moore `<paul@paul-moore.com>` (netlabel maintainer
  — strong quality signal)
- **Link:** https://patch.msgid.link/20260522022910.398416-1-
  zhaochenguang@kylinos.cn
- **Signed-off-by:** Jakub Kicinski `<kuba@kernel.org>` (committer)
- No `Fixes:` tag (expected for manual review)
- No `Reported-by:` / syzbot
- No `Cc: stable@vger.kernel.org` in submission
- Ignore pipeline `Signed-off-by: Sasha Levin`

### Step 1.3: Body analysis
**Record:**
- **Bug:** `netlbl_unlhsh_add_addr6()` always returned `0` after
  `netlbl_af6list_add()`, even when that call failed.
- **Symptom:** Duplicate IPv6 static unlabeled label adds appear
  successful to callers.
- **Root cause:** Copy/paste oversight — IPv4 sibling
  `netlbl_unlhsh_add_addr4()` correctly returns `ret_val`; IPv6 path
  hard-coded `return 0`.
- **Version info:** None in message.

### Step 1.4: Hidden bug fix?
**Record:** Not disguised — explicitly labeled a fix. Error-path
`kfree(entry)` was already present; the bug is return-value propagation
and downstream effects, not a leak.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
- **Files:** `net/netlabel/netlabel_unlabeled.c` (+1 / -1)
- **Function:** `netlbl_unlhsh_add_addr6()`
- **Scope:** Single-file, single-line surgical fix

### Step 2.2: Code flow change
**Record:**
- **Before:** On `netlbl_af6list_add()` failure (e.g. `-EEXIST`), entry
  is freed, but function returns `0`.
- **After:** Returns actual `ret_val` from `netlbl_af6list_add()`.
- **Path affected:** IPv6 static unlabeled address add error path
  (admin/LSM configuration).

### Step 2.3: Bug mechanism
**Record:**
- **Category:** Logic / correctness — incorrect error propagation.
- **Mechanism:** `netlbl_af6list_add()` returns `-EEXIST` for duplicate
  address/mask (`net/netlabel/netlabel_addrlist.c:193`). IPv6 wrapper
  discarded that and reported success. IPv4 path at lines 252–254
  already does the right thing.

### Step 2.4: Fix quality
**Record:**
- Obviously correct — mirrors IPv4 and function documentation (“On
  success zero is returned, otherwise a negative value”).
- Minimal risk; no locking/API changes.
- No regression risk identified.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:** Buggy `return 0;` at line 298 in current tree; blame points
to `e664048784506` (file introduction in this tree). IPv4 `return
ret_val;` at line 254 present alongside it from the same introduction.

### Step 3.2: Fixes: tag
**Record:** N/A — no `Fixes:` tag.

### Step 3.3: Related file history
**Record:**
- `0c4bb32ad7fdc` — same author, separate netlabel validation fix
  already in this tree.
- Upstream fix: `56872b930feee` (mainline, May 25 2026); stable backport
  exists as `642d90c85b137` on `autosel` branch.
- Fix is **not** in current `HEAD` (`v6.18.44`).

### Step 3.4: Author context
**Record:** Chenguang Zhao has multiple netlabel fixes; Paul Moore
(maintainer) Acked this patch.

### Step 3.5: Dependencies
**Record:** Standalone one-liner; no series prerequisites. Applies
cleanly (`return 0` → `return ret_val` at line 298; upstream diff
context matches aside from unrelated `kzalloc` vs `kzalloc_obj` naming
elsewhere).

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original discussion
**Record:**
- `b4 dig -c 56872b930feee`: https://patch.msgid.link/20260522022910.398
  416-1-zhaochenguang@kylinos.cn
- Single v1 submission; applied to netdev/net-next by Jakub Kicinski.
- Paul Moore replied with **Acked-by** in thread.

### Step 4.2: Reviewers
**Record:** `b4 dig -w`: CC'd Paul Moore, David Miller, netdev
maintainers, `linux-security-module@vger.kernel.org`.

### Step 4.3: Bug report
**Record:** No external bug report or syzbot link — author-found logic
bug.

### Step 4.4: Series context
**Record:** Standalone 1-patch series; no dependencies.

### Step 4.5: Stable list
**Record:** No `Cc: stable` discussion found in mbox thread.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** `netlbl_unlhsh_add_addr6()`, `netlbl_af6list_add()`,
`netlbl_unlhsh_add()`.

### Step 5.2: Callers
**Record:**
- `netlbl_unlhsh_add()` → `netlbl_unlhsh_add_addr6()` (line 423)
- `netlbl_unlhsh_add()` called from:
  - `netlbl_unlabel_staticadd()` / `netlbl_unlabel_staticadddef()`
    (Generic Netlink admin)
  - `netlbl_cfg_unlbl_static_add()` (kernel API, used e.g. from
    `security/smack/smackfs.c`)

### Step 5.3: Callees
**Record:** `kzalloc()`, `netlbl_af6list_add()` (can return `-EEXIST`),
`kfree()` on failure.

### Step 5.4: Reachability
**Record:** Reachable from userspace via Netlink (`CAP_NET_ADMIN`) and
from LSM code configuring static labels. IPv6 path requires
`CONFIG_IPV6`.

### Step 5.5: Similar patterns
**Record:** IPv4 `netlbl_unlhsh_add_addr4()` correctly returns `ret_val`
— confirms this is an IPv6-only regression/typo.

---

## PHASE 6: CROSS-REFERENCE AGAINST LOCAL TREE

### Step 6.1: Buggy code present?
**Record:** **YES** — line 298 in `/home/sasha/linux-
autosel-7.0/net/netlabel/netlabel_unlabeled.c` is `return 0;` while line
254 (IPv4) is `return ret_val;`.

### Step 6.2: Backport complications
**Record:** Clean one-line apply expected; no structural conflicts in
this file.

### Step 6.3: Related fixes already present?
**Record:** Related validation fix `0c4bb32ad7fdc` is present; this
error-handling fix is **not**.

---

## PHASE 7: SUBSYSTEM CONTEXT

### Step 7.1: Subsystem criticality
**Record:** `net/netlabel` — **IMPORTANT** (LSM integration: SELinux,
Smack; MAC labeling and audit).

### Step 7.2: Activity
**Record:** Recent activity in this tree (validation fix June 2026);
netlabel touched in 6.18.y.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who is affected
**Record:** Systems using NetLabel IPv6 static unlabeled labels with
SELinux/Smack (or other LSM consumers of
`netlbl_cfg_unlbl_static_add()`). Config-specific (`CONFIG_NETLABEL`,
`CONFIG_IPV6`).

### Step 8.2: Trigger conditions
**Record:** Adding a duplicate IPv6 static unlabeled label (same
address/mask). Requires admin capability. Duplicate-add is a realistic
admin/script mistake, not exotic.

### Step 8.3: Failure mode severity
**Record:**
1. Userspace receives success (`0`) instead of `-EEXIST`.
2. `netlbl_unlhsh_add()` incorrectly executes
   `atomic_inc(&netlabel_mgmt_protocount)` (lines 434–435).
3. Audit records `res=1` (success) on failure (line 444).
4. **Protocount skew:** duplicate “success” inflates count; after
   removing the real entry, `netlabel_mgmt_protocount` can remain `> 0`
   with zero entries, leaving `netlbl_enabled()` true
   (`net/netlabel/netlabel_kapi.c:960`). SELinux uses `netlbl_enabled()`
   in netfilter hooks (`security/selinux/hooks.c:6004, 6021`).

**Severity:** **MEDIUM-HIGH** for affected deployments — not a crash,
but incorrect security subsystem state and audit integrity.

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** Correct errno, accurate audit, correct
  protocount/`netlbl_enabled()` behavior.
- **Risk:** Very low (one line, maintainer-acked, mirrors working IPv4
  path).
- **Ratio:** Strong benefit, negligible risk.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence summary

**FOR backport:**
- Clear, real bug (IPv6-only; IPv4 correct)
- Maintainer Acked-by (Paul Moore)
- One-line, obviously correct fix
- Affects LSM/security admin path and audit logs
- Protocount inflation can leave NetLabel “enabled” after entries
  removed
- Bug confirmed present in `v6.18.44`
- Upstream already merged (`56872b930feee`)

**AGAINST backport:**
- No crash, UAF, or memory corruption
- Only failure mode from `netlbl_af6list_add()` is `-EEXIST`
  (duplicates)
- Niche subsystem (NetLabel + IPv6 static labels)
- No syzbot/user crash reports

**Unresolved:** None material to the decision.

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — mirrors IPv4; maintainer
   ack; trivial change.
2. Fixes a real bug affecting users? **PASS** — wrong errno, audit, and
   protocount on duplicate IPv6 adds.
3. Important issue? **PASS** — security subsystem correctness and audit
   integrity (MEDIUM-HIGH).
4. Small and contained? **PASS** — 1 line, 1 file.
5. No new features/APIs? **PASS**.
6. Can apply to local tree? **PASS** — buggy code present; clean apply.

### Step 9.3: Exception categories
**Record:** N/A (not device ID, quirk, DT, build, or docs fix).

### Step 9.4: Decision rationale
This is a straightforward error-handling bug in the NetLabel IPv6 admin
path. While it does not cause a kernel oops, it corrupts security-
relevant state: callers, audit subsystem, and
`netlabel_mgmt_protocount`/`netlbl_enabled()` all behave incorrectly on
a realistic duplicate-add scenario. The fix is trivial, maintainer-
reviewed, and the bug is present in this `6.18.44` tree.

---

## Verification

- [Phase 1] `git describe HEAD` → `v6.18.44`; parsed subject, tags, body
  from provided commit message
- [Phase 1] Read current `netlbl_unlhsh_add_addr6()` — confirmed `return
  0` bug at line 298
- [Phase 2] Read diff — single line `return 0` → `return ret_val`
- [Phase 2] Read `netlbl_af6list_add()` — returns `-EEXIST` on duplicate
  (line 193)
- [Phase 2] Compared IPv4 `netlbl_unlhsh_add_addr4()` — returns
  `ret_val` (line 254)
- [Phase 3] `git blame -L 290,305` — buggy line attributed to file
  introduction
- [Phase 3] `git show 56872b930feee` — upstream fix commit confirmed
- [Phase 3] `git merge-base --is-ancestor 56872b930feee HEAD` → fix NOT
  in HEAD
- [Phase 3] `git show 642d90c85b137` — stable backport commit exists on
  `autosel` branch
- [Phase 4] `b4 dig -c 56872b930feee -w` — lore URL and recipient list
  retrieved
- [Phase 4] `b4 dig -c 56872b930feee -a` — single v1 revision
- [Phase 4] `b4 dig -m /tmp/netlabel_ipv6_fix.mbox` — Paul Moore Acked-
  by confirmed; no stable Cc in thread
- [Phase 5] `grep netlbl_unlhsh_add` — traced callers to Netlink and
  `netlbl_cfg_unlbl_static_add()`
- [Phase 5] `grep netlbl_enabled` — SELinux hooks depend on protocount
- [Phase 6] Read lines 248–299 and 364–447 — buggy code and downstream
  `atomic_inc`/audit impact verified
- [Phase 6] `git log --oneline -20 -- net/netlabel/netlabel_unlabeled.c`
  — fix not yet in tree
- [Phase 8] Traced protocount inflation scenario through add/remove
  paths (lines 434–435, 664–666, 960)

**YES**

 net/netlabel/netlabel_unlabeled.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netlabel/netlabel_unlabeled.c b/net/netlabel/netlabel_unlabeled.c
index 2237a5261dd2a..0dfbb63d513ce 100644
--- a/net/netlabel/netlabel_unlabeled.c
+++ b/net/netlabel/netlabel_unlabeled.c
@@ -295,7 +295,7 @@ static int netlbl_unlhsh_add_addr6(struct netlbl_unlhsh_iface *iface,
 
 	if (ret_val != 0)
 		kfree(entry);
-	return 0;
+	return ret_val;
 }
 #endif /* IPv6 */
 
-- 
2.53.0

