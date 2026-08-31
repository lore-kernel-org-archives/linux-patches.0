Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1ACE474258;
	Mon, 31 Aug 2026 13:35:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183340; cv=none; b=kHI5TagiUuil8wxjcYME31MIIuUmPX6bChMpfMx2sU/fElCyMG61vaG13M3X9TOjCEFZv2+IHRjkSwEt+LV0ico9cHg1yqUJXB+Ylw02sSp1IKQWJGWNt5YEvAatBnXLfFTsjL/w5iHLFP5FWY5LayBk/vrCZUar8uiC36/G6lM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183340; c=relaxed/simple;
	bh=axz5vylE4FxBOgoV1DlQWb8KgAqUuL00a1VstUYsNKQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YYfZsEUMXYlKPThSo1FRxvO6IWiD4BgJz2s2bXukG4UrKfWl/N3lIeeZ4n9aBDHhS7KPiQC/mwtp82dQRUpzJ12V9TY+pBRm47rKear00wgQX4ujV5qbDSIGJQxDlzw5N9aLtdrAbi/YLtM995tOeo2FMGLdlICzQQcuzUIvE00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jOHGpe3n; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jOHGpe3n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09BA81F00A3D;
	Mon, 31 Aug 2026 13:35:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183337;
	bh=QpstxJnSY0vcdZyNSDutxF0fesjA6gCk/K78ALCzL4I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jOHGpe3nR2OxwcY4oja0MXj0lYsegH1QjBiYFc+z7mp2G3xrQrq33cslcM2mZh99E
	 nYXDXw31cXqJoj0+8b64QkEkRBSmnthr/7981/XamXKAMiSmQz6c4k26xCr+LdyNzX
	 qVF2xWxj6e/TvYRP4BgJeBTQ8kUVgB/DaFpEoilDDOq8awB4iRLYKXj946CrTPWlTl
	 sLEJOfUZj1zeA0txtg0IREkIRjxyXz08Fi1uSVtkdZvUSAWtzB+rhYsVLjSna/cJNp
	 NSCWm4NanUmlMKKQpXxK9WmTcKeOAo5TcTnI7zRmBAXbk7e3E8BSyWDGfmvPWjw6ch
	 OwwMd5Ed0gciA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Stefan Berger <stefanb@linux.ibm.com>,
	Kamlesh Kumar <kam@juniper.net>,
	Mimi Zohar <zohar@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>,
	roberto.sassu@huawei.com,
	dmitry.kasatkin@gmail.com,
	paul@paul-moore.com,
	jmorris@namei.org,
	serge@hallyn.com,
	linux-integrity@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.15] integrity: Check for NULL returned by asymmetric_key_public_key
Date: Mon, 31 Aug 2026 09:21:56 -0400
Message-ID: <20260831133314.4125787-88-sashal@kernel.org>
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

From: Stefan Berger <stefanb@linux.ibm.com>

[ Upstream commit c93a5f038ccc11ed8558ce642f62d5ede701a348 ]

Check for a NULL pointer returned by asymmetric_key_public_key and return
-ENOKEY in this case.

Signed-off-by: Stefan Berger <stefanb@linux.ibm.com>
Tested-by: Kamlesh Kumar <kam@juniper.net>
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

### Step 1.1: Subject line
**Record:** `[integrity]` `[Check]` — Add a NULL check on the return
value of `asymmetric_key_public_key()` in asymmetric signature
verification.

### Step 1.2: Tags
**Record:**
- **Signed-off-by:** Stefan Berger `<stefanb@linux.ibm.com>` (author)
- **Tested-by:** Kamlesh Kumar `<kam@juniper.net>`
- **Signed-off-by:** Mimi Zohar `<zohar@linux.ibm.com>` (integrity
  subsystem maintainer)
- **No** Fixes:, Reported-by:, Link:, Cc: stable@vger.kernel.org,
  Reviewed-by:, Acked-by:

Notable: maintainer sign-off plus Tested-by; no syzbot or user bug
report.

### Step 1.3: Body analysis
**Record:**
- **Bug:** `asymmetric_key_public_key()` can return NULL; the code
  dereferences `pk` without checking.
- **Symptom:** NULL pointer dereference → kernel oops in
  `asymmetric_verify()`.
- **Fix:** Return `-ENOKEY` and jump to the existing `out:` cleanup
  path.
- **Series context:** Patch 1/4 of “Add support for ML-DSA signature for
  EVM and IMA”; v3 added patches 1/4 and 2/4 per Mimi Zohar’s review
  comments on v2.

### Step 1.4: Hidden bug fix?
**Record:** Yes — explicit NULL-dereference fix, not cosmetic cleanup.

---

## Phase 2: Diff Analysis

### Step 2.1: Inventory
**Record:**
- **File:** `security/integrity/digsig_asymmetric.c` (+4 / −0)
- **Function:** `asymmetric_verify()`
- **Scope:** Single-file, surgical (4 lines)

### Step 2.2: Code flow change
**Record:**
- **Before:** After `request_asymmetric_key()` succeeds, `pk =
  asymmetric_key_public_key(key)` is used immediately as
  `pk->pkey_algo`.
- **After:** If `pk` is NULL, set `ret = -ENOKEY`, `goto out` (which
  calls `key_put(key)`).
- **Path:** Error handling in IMA/EVM asymmetric signature verification
  (sig v2).

### Step 2.3: Bug mechanism
**Record:** **Category:** NULL pointer dereference.
**Mechanism:** `asymmetric_key_public_key()` is an inline accessor
returning `key->payload.data[asym_crypto]`, which can be NULL. The code
assumed it was always valid after a successful key lookup.

### Step 2.4: Fix quality
**Record:** Obviously correct; mirrors existing `!pkey` handling in
`restrict_link_by_digsig()` / `restrict_link_by_ca()`. Uses existing
`out:` label. Very low regression risk.

---

## Phase 3: Git History Investigation

### Step 3.1: Blame
**Record:** Lines 110–111 in the local tree were introduced in commit
`6bda50f4333fa` (2025-11-29) when `digsig_asymmetric.c` was added. The
missing NULL check has been present since that introduction in this
tree.

### Step 3.2: Fixes: tag
**Record:** N/A — no Fixes: tag.

### Step 3.3: Related file history
**Record:** On `stable/linux-6.18.y`, `digsig_asymmetric.c` appears from
`6bda50f4333fa`. The buggy pattern is present at merge-base
`7b923c78b50d`. Part of ML-DSA v3 series (4 patches); this commit is
standalone and does not require patches 2–4.

### Step 3.4: Author context
**Record:** Stefan Berger is a regular integrity contributor. Mimi Zohar
(maintainer) signed off. Series included in `integrity-v7.2` pull (June
2026).

### Step 3.5: Dependencies
**Record:** No prerequisites. Applies independently of ML-DSA support
(patches 3/4 and 4/4).

---

## Phase 4: Mailing List and External Research

### Step 4.1: Original discussion
**Record:** Found via spinics/openwall at [PATCH v3
1/4](https://www.spinics.net/lists/kernel/msg6157574.html). Cover
letter: [PATCH v3
0/4](https://www.spinics.net/lists/kernel/msg6157584.html). v3 added
patches 1/4 and 2/4 addressing Mimi’s v2 comments. `b4 dig -c` could not
be run (commit not in local tree); `b4 shazam` did not find message-id.
lore.kernel.org blocked by bot protection.

### Step 4.2: Reviewers
**Record:** CC’d: linux-integrity, linux-security-module, Mimi Zohar,
Roberto Sassu, Eric Biggers.

### Step 4.3: Bug report
**Record:** No external bug report, syzbot, or sanitizer report. Found
during ML-DSA series review (Mimi’s v2 feedback).

### Step 4.4: Series context
**Record:** 4-patch ML-DSA series. This patch is independently valuable;
later patches refactor and add ML-DSA sigv3 support.

### Step 4.5: Stable list
**Record:** No stable-list discussion found. Included in maintainer’s
`integrity-v7.2` pull for mainline.

---

## Phase 5: Code Semantic Analysis

### Step 5.1: Key functions
**Record:** `asymmetric_verify()` modified.

### Step 5.2: Callers
**Record:**
- `integrity_digsig_verify()` in `security/integrity/digsig.c` (sig
  types 2 and 3)
- Callers of `integrity_digsig_verify()`:
  - `security/integrity/ima/ima_appraise.c` — IMA signature appraisal
  - `security/integrity/evm/evm_main.c` — EVM signature verification

### Step 5.3: Callees
**Record:** `request_asymmetric_key()`, `asymmetric_key_public_key()`,
`verify_signature()`, `key_put()`.

### Step 5.4: Reachability
**Record:** Reachable from file access when
`CONFIG_INTEGRITY_ASYMMETRIC_KEYS` and IMA/EVM appraisal are enabled. On
this tree, IMA rejects sig version ≥ 3 before verification; sig v2
asymmetric verification is the affected path.

### Step 5.5: Similar patterns
**Record:** `crypto/asymmetric_keys/restrict.c` checks `if (!pkey)
return -ENOPKG`. `verify_signature()` checks `!key->payload.data[0]`
(same slot as `asym_crypto`) — but only after `asymmetric_verify()`
would have already crashed on NULL `pk`.

---

## Phase 6: Cross-Reference Against Local Tree

### Step 6.1: Buggy code present?
**Record:** **Yes.** Local tree is **v6.18.43** (`stable/linux-6.18.y`,
`HEAD` detached). `security/integrity/digsig_asymmetric.c` lines 110–111
lack the NULL check:

```110:111:security/integrity/digsig_asymmetric.c
        pk = asymmetric_key_public_key(key);
        pks.pkey_algo = pk->pkey_algo;
```

### Step 6.2: Backport complications
**Record:** Clean apply expected — 4 lines at a stable location. Minor
field-name difference (`pks.digest` vs `pks.m` in the submitted diff)
does not affect patch placement.

### Step 6.3: Related fixes already present?
**Record:** No — grep shows no existing NULL check at this site.

---

## Phase 7: Subsystem Context

### Step 7.1: Subsystem criticality
**Record:** **security/integrity** (IMA/EVM) — **IMPORTANT** (security-
sensitive, affects systems with integrity appraisal enabled).

### Step 7.2: Activity
**Record:** Actively maintained; recent IMA/EVM commits on this branch.

---

## Phase 8: Impact and Risk Assessment

### Step 8.1: Who is affected
**Record:** Systems with `CONFIG_INTEGRITY_ASYMMETRIC_KEYS` and IMA/EVM
digital-signature appraisal. Not universal, but important for
secured/enterprise deployments.

### Step 8.2: Trigger conditions
**Record:** A signature references a key ID that resolves to an
asymmetric key whose `asym_crypto` payload is NULL. With standard
X.509-loaded RSA/ECDSA keys this is unlikely; the subsystem already
treats `!pkey` as a valid error state elsewhere. More relevant once non-
standard key types (e.g. ML-DSA) are introduced. Trigger does not
require ML-DSA patch 4/4 on this tree, but practical likelihood on
6.18.y without ML-DSA is low.

### Step 8.3: Failure mode severity
**Record:** **Kernel oops** (NULL dereference at `pk->pkey_algo`) —
**CRITICAL** if triggered.

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** Prevents crash in security verification path; returns
  proper error instead.
- **Risk:** Very low — 4 lines, uses existing cleanup, no API change.
- **Ratio:** Favorable for stable despite rare trigger on current 6.18.y
  key types.

---

## Phase 9: Final Synthesis

### Step 9.1: Evidence summary

**FOR backport:**
- Real NULL-deref bug in security code
- Small, surgical, maintainer-signed fix with Tested-by
- Buggy code exists in v6.18.43
- Applies cleanly and standalone
- IMA/EVM verification path is security-critical
- Consistent with existing `!pkey` handling in asymmetric key code

**AGAINST backport:**
- No user report or fuzzer finding
- Added during ML-DSA series review; practical trigger on 6.18.y without
  ML-DSA may be very rare
- Standard X.509 keys normally always populate `asym_crypto`
- IMA already rejects sig v3 on this tree, limiting some future trigger
  scenarios

**Unresolved:** No confirmed production crash on 6.18.y with current key
types only.

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** (simple NULL check; Tested-by;
   maintainer SOB)
2. Fixes a real bug? **PASS** (NULL deref is a real defect, even if
   trigger is edge-case)
3. Important issue? **PASS** (kernel oops in integrity verification —
   HIGH/CRITICAL)
4. Small and contained? **PASS** (4 lines, one function)
5. No new features/APIs? **PASS**
6. Can apply to local tree? **PASS**

### Step 9.3: Exception categories
**Record:** None (not a quirk, device ID, or build fix).

### Step 9.4: Decision rationale

For **linux-6.18.y** specifically: the vulnerable code is present, the
fix is minimal and obviously correct, and a NULL dereference in the
IMA/EVM signature path is exactly the kind of security-subsystem defect
stable trees should fix. While the trigger may be uncommon with today’s
RSA/ECDSA-only keyrings, the kernel already acknowledges that asymmetric
keys can lack a public-key payload (`restrict.c`), and this path lacked
the corresponding guard. The patch is independent of the ML-DSA feature
commits and safe to backport alone.

---

## Verification

- **[Phase 1]** Parsed commit message and tags from user query and
  spinics/openwall
- **[Phase 2]** Read `security/integrity/digsig_asymmetric.c`; confirmed
  4-line NULL check at `asymmetric_key_public_key()` call site
- **[Phase 2]** Read `include/keys/asymmetric-type.h`; confirmed
  `asymmetric_key_public_key()` returns `key->payload.data[asym_crypto]`
  with no NULL guarantee
- **[Phase 3]** `git describe HEAD` → `v6.18.43`; Makefile VERSION
  6.18.43
- **[Phase 3]** `git blame -L 108,115
  security/integrity/digsig_asymmetric.c` → `6bda50f4333fa`
- **[Phase 3]** `git show 7b923c78b50d:...` → buggy code at merge-base
- **[Phase 3]** `git branch` → detached from `stable/linux-6.18.y`
- **[Phase 4]** spinics/openwall: found v3 1/4 and 0/4; v3 added patches
  per Mimi’s comments
- **[Phase 4]** `b4 shazam` — message-id not found; `b4 dig -c` not run
  (commit absent locally)
- **[Phase 4]** lore.kernel.org — blocked (bot protection)
- **[Phase 4]** Web search — commit `c93a5f0`, integrity-v7.2 pull
  confirmed
- **[Phase 5]** `grep asymmetric_verify` — callers in `digsig.c`,
  `ima_appraise.c`, `evm_main.c`
- **[Phase 5]** Read `crypto/asymmetric_keys/restrict.c` — `!pkey`
  checks at lines 141 and 183
- **[Phase 5]** Read `crypto/asymmetric_keys/signature.c` —
  `verify_signature()` checks `!key->payload.data[0]` but only after
  `asymmetric_verify()` would crash
- **[Phase 6]** Confirmed NULL check absent in current tree at lines
  110–111
- **[Phase 6]** Read `ima_appraise.c` lines 335–338 — sig v3 rejected
  before `integrity_digsig_verify()`
- **[Phase 8]** `grep mldsa` in `crypto/asymmetric_keys` — no ML-DSA
  support in this tree
- **UNVERIFIED:** Exact Mimi Zohar review text (follow-up to v2 on
  spinics not fetched); no production crash report

**YES**The background history search finished. In this
`stable/linux-6.18.y` checkout, `digsig_asymmetric.c` and the
`asymmetric_verify()` path without the NULL check both trace back to
commit `6bda50f4333fa` (Nov 29, 2025), when that file was added. The
vulnerable code is present in the current v6.18.43 tree, so the backport
analysis stands: **YES**.

 security/integrity/digsig_asymmetric.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/security/integrity/digsig_asymmetric.c b/security/integrity/digsig_asymmetric.c
index 457c0a396caf3..17219424a34dd 100644
--- a/security/integrity/digsig_asymmetric.c
+++ b/security/integrity/digsig_asymmetric.c
@@ -108,6 +108,10 @@ int asymmetric_verify(struct key *keyring, const char *sig,
 	pks.hash_algo = hash_algo_name[hdr->hash_algo];
 
 	pk = asymmetric_key_public_key(key);
+	if (!pk) {
+		ret = -ENOKEY;
+		goto out;
+	}
 	pks.pkey_algo = pk->pkey_algo;
 	if (!strcmp(pk->pkey_algo, "rsa")) {
 		pks.encoding = "pkcs1";
-- 
2.53.0

