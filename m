Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DB6B571871;
	Mon, 31 Aug 2026 13:48:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184126; cv=none; b=WZhcS1rEsa1LMunYf2ulhEOlUzfCxu4QSptpAJUyETpFH3DX3vPbBYeLxtYtU8aJYqRvq1g4VD3nOmHbol5flnJ1gpxNYjJ2IFs7DZFVrR45Jt5yvKM/sQ3TtTtIpetIAkJVvLXElK02o2lWMku4x977EIQS68WXY8A9Llkptmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184126; c=relaxed/simple;
	bh=d7wWHaoctBKlOIxQEjP4Cku5/0PeF47E/CBvtLe+bJk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=s/6FbOmpKzeZdwzNI1+Yaixb4PjIbR10a3dpdnb6zS22JDuZlWxg5BbhYPk/TF28OBt/JJkeS2U03pEbJ3V7sqOfh5P+aTJETX1OtYVTy3oRVNd0TMVqNv1bRysRIAiz2QMkQyB7khFL/uVQFeOerdU91ttc9mrzq7EB9XBOPtc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mbwgeHMh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mbwgeHMh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4A161F00A3E;
	Mon, 31 Aug 2026 13:48:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184124;
	bh=6eMiomWKtD3vjDPbIJlRzzhAoMgF9O/0YZGf5IRdkLo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mbwgeHMhtl81fCRkiU/4DMs3ev7MKwXhFC+BxQgk09kQFjH/ccEFeoHwr3+hLouHP
	 4Eb+Ap8JVxFrv941BhD048Kfgp/AQLSoCn131u26eBgkZB84i2oUvy94y0jRR8tmUS
	 1BAkb6T71sFtI0/wHpm0EF39MRAtVLiMeJn9vaUm2ggZu1Au3RMrl1881ftg0Potu2
	 8UyKJyRr9yvtWUWoGAh1puNeftcPDRu9oq40lbwakeE6BWfCxJC/ct+LeybTE2XMVE
	 6YvTqnoJp8fKiR/gfktGsufvVprNowjMXSc0rM4pdCWJN8Z9OtUN+rtmQBAWLEud70
	 KsH4n/t8q7TDw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jakub Kicinski <kuba@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Willem de Bruijn <willemb@google.com>,
	Sasha Levin <sashal@kernel.org>,
	daniel.zahka@gmail.com,
	willemdebruijn.kernel@gmail.com,
	davem@davemloft.net,
	pabeni@redhat.com,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] psp: validate IPv4 header fields in psp_dev_rcv()
Date: Mon, 31 Aug 2026 09:28:54 -0400
Message-ID: <20260831133314.4125787-506-sashal@kernel.org>
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

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit c2b22277ad897d21341f502f87fccd905ff4e207 ]

psp_dev_rcv() is called from the NIC driver's RX completion path
before the frame reaches ip_rcv_core(), so the IP header has not
been validated in SW, yet. We expect that the device has done
all this validation, but let's also add the SW checks, to avoid
surprises.

Reviewed-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/20260428205352.1247325-4-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

### Step 1.1: Subject line
**Record:** `[psp]` `[validate]` — Add software validation of IPv4 (and
IPv6) header fields in `psp_dev_rcv()` before decapsulation.

### Step 1.2: Tags
**Record:**
- **Reviewed-by:** Eric Dumazet \<edumazet@google.com\>
- **Reviewed-by:** Willem de Bruijn \<willemb@google.com\>
- **Link:**
  https://patch.msgid.link/20260428205352.1247325-4-kuba@kernel.org
  (patch 4/N of a series)
- **Signed-off-by:** Jakub Kicinski \<kuba@kernel.org\>
- No Fixes:, Reported-by:, Tested-by:, Cc: stable, or syzbot tags.

Notable: reviewed by two senior networking developers; no fuzzer or user
crash report.

### Step 1.3: Body analysis
**Record:**
- **Bug:** `psp_dev_rcv()` runs in the NIC RX completion path before
  `ip_rcv_core()`, so normal software IP header validation has not run
  yet.
- **Symptom:** Malformed IP headers (invalid `ihl`,
  `tot_len`/`payload_len` too small for decapsulation) could be
  accepted; code uses `iph->ihl` for `ip_fast_csum()` and subtracts
  `encap` from length fields without bounds checks.
- **Root cause:** Assumption that hardware always delivers valid L3
  headers; no defensive SW checks mirroring `ip_rcv_core()`.
- **Version info:** None in the message.

### Step 1.4: Hidden bug fix?
**Record:** Yes. Despite “avoid surprises” wording, this is a real
validation bug fix: invalid `ihl` can cause out-of-bounds access in
`ip_fast_csum()`, and unchecked subtraction can underflow
`tot_len`/`payload_len`, producing corrupt skbs passed up the stack.

---

## Phase 2: Diff Analysis

### Step 2.1: Inventory
**Record:**
- **File:** `net/psp/psp_main.c` (+9 lines, 0 removed)
- **Function:** `psp_dev_rcv()`
- **Scope:** Single-file, surgical validation additions.

### Step 2.2: Code flow per hunk
**Record:**
1. **IPv4 `ihl` check (after reading `iph`):** Before → used `iph->ihl`
   directly for `l3_hlen` and later `ip_fast_csum()`. After → reject if
   `ihl < 5`.
2. **IPv4 `tot_len` check (before modifying header):** Before →
   `iph->tot_len = htons(ntohs(iph->tot_len) - encap)` with no guard.
   After → reject if `tot_len < l3_hlen + encap`.
3. **IPv6 `payload_len` check:** Before → subtract `encap`
   unconditionally. After → reject if `payload_len < encap`.

### Step 2.3: Bug mechanism
**Record:** **Memory safety / logic correctness.**
- Invalid `ihl` (< 5): `l3_hlen = iph->ihl * 4` can be too small;
  `ip_fast_csum((u8 *)iph, iph->ihl)` may read fewer than 20 bytes or
  use invalid length (compare `ip_rcv_core()` at
  `net/ipv4/ip_input.c:500`).
- Length underflow: `ntohs(iph->tot_len) - encap` with `tot_len < encap`
  wraps to a large value when stored back into `tot_len`, corrupting the
  skb for downstream IP processing.

### Step 2.4: Fix quality
**Record:** Obviously correct; mirrors existing IP stack validation
patterns. Minimal risk; only rejects packets that would have been
mishandled. No API changes. In this tree, checks must be placed after
`encap` is computed with `psp_hlen` (post-`ac4bf66686bbb`), not the
fixed `PSP_ENCAP_HLEN` shown in the candidate diff.

---

## Phase 3: Git History Investigation

### Step 3.1: Blame
**Record:** Core `psp_dev_rcv()` logic from `19eef1d98eeda` (Nov 2025).
Variable-length PSP header handling added in `ac4bf66686bbb` (May 2026,
already in this tree). The validation gap dates to initial
`psp_dev_rcv()` introduction.

### Step 3.2: Fixes: tag
**Record:** N/A — no Fixes: tag.

### Step 3.3: Related file history
**Record:** Recent `net/psp/psp_main.c` commits:
- `ac4bf66686bbb` — variable-length PSP header strip (Cc: stable,
  backported)
- `b640188b61e63` — `psp_write_headers()` hash fix
- `aa1a08a4632af`, `d90df5ce6deb2` — permission/unregister checks

The candidate commit is **not** in this tree. It is standalone
validation logic, but must be adapted for post-`ac4bf66686bbb` `encap`
calculation.

### Step 3.4: Author context
**Record:** Jakub Kicinski is the networking tree maintainer who merged
PSP work. Related PSP fixes in-tree were reviewed by Willem de Bruijn
(same reviewer on this patch).

### Step 3.5: Dependencies
**Record:** No series dependency for the validation logic itself.
Applies standalone to any tree with `psp_dev_rcv()`. In this tree,
`encap = sizeof(struct udphdr) + psp_hlen + optional ICV`, so the
`tot_len`/`payload_len` checks use the updated `encap` value.

---

## Phase 4: Mailing List and External Research

### Step 4.1–4.5
**Record:** Lore/patch.msgid.link fetch returned 403 (bot protection).
`b4 dig` requires a commit hash; the candidate is not in this checkout,
so `b4 dig -c` could not match it. **UNVERIFIED:** full mailing-list
thread, stable nominations in review, series context for patches 1–3.

From the Link subject (`1247325-4`), this is patch 4 of a series; the
validation changes themselves appear self-contained.

---

## Phase 5: Code Semantic Analysis

### Step 5.1: Key functions
**Record:** `psp_dev_rcv()` — only function modified.

### Step 5.2: Callers
**Record:**
- `drivers/net/ethernet/mellanox/mlx5/core/en_accel/psp_rxtx.c:135` —
  `mlx5e_psp_offload_handle_rx_skb()`, production RX path after HW
  decryption syndrome check.
- `drivers/net/netdevsim/psp.c:64` — test/simulation path.

### Step 5.3: Callees
**Record:** `__vlan_get_protocol()`, `pskb_may_pull()`, `skb_ext_add()`,
`ip_fast_csum()`, `memmove()`, `skb_pull()`, `pskb_trim()`.

### Step 5.4: Reachability
**Record:** Reachable from NIC RX completion on PSP-offloaded mlx5
devices (`CONFIG_INET_PSP` + `CONFIG_MLX5_EN_PSP`). Hardware is expected
to validate frames first; netdevsim allows software testing without HW.
Not a general syscall path, but network-reachable on configured systems.

### Step 5.5: Similar patterns
**Record:** `ip_rcv_core()` validates `iph->ihl < 5` and `len <
iph->ihl*4` (`net/ipv4/ip_input.c:500–524`). `route.c`, `icmp.c`,
`nf_reject_ipv4.c` use the same `ihl < 5` guard. `psp_dev_rcv()` is an
intentional bypass of that path and lacks equivalent checks today.

---

## Phase 6: Cross-Reference Against Local Tree (6.18.43)

### Step 6.1: Buggy code present?
**Record:** **Yes.** Current `net/psp/psp_main.c` (lines 294–358) lacks
all three checks. Uses `iph->ihl` without `ihl < 5` guard; subtracts
`encap` from `tot_len`/`payload_len` without underflow protection.

### Step 6.2: Backport complications
**Record:** **Minor adaptation needed.** This tree already has
`ac4bf66686bbb` (variable `psp_hlen`, dynamic `encap`). The candidate
diff targets pre-`ac4bf66686bbb` code with fixed `PSP_ENCAP_HLEN`.
Validation logic maps cleanly: `ihl` check at the same spot; length
checks after `encap` is computed with `sizeof(struct udphdr) +
psp_hlen`.

### Step 6.3: Related fixes already present?
**Record:** `ac4bf66686bbb` fixes variable-length PSP header stripping
but explicitly does not add IP header field validation. No duplicate fix
found.

---

## Phase 7: Subsystem Context

### Step 7.1: Subsystem / criticality
**Record:** `net/psp` — INET PSP security protocol. **IMPORTANT**
(networking RX path), but config-specific (`CONFIG_INET_PSP`).

### Step 7.2: Activity
**Record:** Actively developed subsystem in 6.18 (multiple PSP commits
in 2025–2026). New enough that bugs are still being found and hardened.

---

## Phase 8: Impact and Risk Assessment

### Step 8.1: Who is affected
**Record:** Systems with PSP offload enabled (primarily mlx5 ConnectX
with `MLX5_EN_PSP`). Not universal; datacenter/cloud deployments using
Google PSP.

### Step 8.2: Trigger conditions
**Record:** Malformed inner IP/IPv6 header in a PSP-decapsulated frame
reaching `psp_dev_rcv()`. Expected rare (HW validation), but possible
via HW/firmware bugs or test injection (netdevsim). Network-origin on
PSP-enabled hosts.

### Step 8.3: Failure mode severity
**Record:**
- `ihl < 5` → invalid `ip_fast_csum()` / wrong offsets → **HIGH** (OOB
  read potential)
- Length underflow → corrupt `tot_len`/`payload_len` on skb entering
  normal IP receive → **HIGH** (downstream parsing errors, possible
  crash)

Overall: **HIGH** if triggered; trigger likelihood is **LOW-MEDIUM**
(HW-gated but not impossible).

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** MEDIUM-HIGH — prevents corrupt skbs and OOB access in a
  network RX helper that bypasses standard IP validation.
- **Risk:** VERY LOW — 3 small rejection checks on error paths; no
  behavior change for valid packets.
- **Ratio:** Favorable for backport.

---

## Phase 9: Final Synthesis

### Step 9.1: Evidence compile

**FOR backport:**
- Real validation gap with concrete failure modes (OOB read, integer
  underflow)
- Network RX path on PSP-enabled hardware
- Small, obviously correct, matches `ip_input.c` patterns
- Reviewed by Eric Dumazet and Willem de Bruijn
- Buggy code confirmed present in 6.18.43
- Prior related PSP fix (`ac4bf66686bbb`) was nominated and backported
  to stable

**AGAINST backport:**
- No crash report, syzbot, or CVE cited
- Author frames as defense-in-depth (“device has done validation”)
- Narrow deployment (optional PSP on mlx5)
- Patch needs minor rework for current `psp_main.c` layout
- Mailing-list discussion unverified

**Unresolved:** Full review thread and whether patches 1–3 of the series
are prerequisites (validation patch appears independent).

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — mirrors established IP
   validation; reviewed by net experts (no runtime test cited).
2. Fixes a real bug? **PASS** — missing validation with demonstrable
   underflow/OOB mechanisms.
3. Important issue? **PASS** — potential crash/corruption in network RX
   path (HIGH severity if triggered).
4. Small and contained? **PASS** — ~9 lines, one function.
5. No new features/APIs? **PASS** — error-path validation only.
6. Can apply to local tree? **PASS** — with minor adjustment for
   `psp_hlen`-based `encap`.

### Step 9.3: Exception category
**Record:** None (not device ID, quirk, DT, build, or docs). Standard
bug-fix/hardening.

### Step 9.4: Decision rationale

For **linux-6.18.y** (this checkout at 6.18.43): the PSP subsystem and
the vulnerable `psp_dev_rcv()` code are present. The function
deliberately skips `ip_rcv_core()` validation yet performs header
arithmetic (`tot_len - encap`, `ip_fast_csum` with `ihl`) that assumes
valid headers. That is a real bug; the fix is minimal, conservative, and
aligned with how the rest of the IPv4 stack validates headers. While
triggers are likely rare due to hardware offload gating, the failure
modes are serious enough for stable, and the same subsystem recently
received a similar stable backport (`ac4bf66686bbb`). The patch needs a
small adjustment for the variable-length PSP header changes already in
this tree, but the logic is straightforward.

---

## Verification

- **[Phase 1]** Parsed subject, tags, body from user-provided commit
  message.
- **[Phase 2]** Analyzed diff: 3 validation checks in `psp_dev_rcv()`.
- **[Phase 3]** `git describe HEAD` → `v6.18.43-1-gc7f0dac02d232`;
  Makefile → 6.18.43.
- **[Phase 3]** `git blame -L 294,360 net/psp/psp_main.c` → code from
  `19eef1d98eeda`, modified by `ac4bf66686bbb`.
- **[Phase 3]** `git log --oneline -20 -- net/psp/psp_main.c` → recent
  PSP history confirmed.
- **[Phase 3]** `git show ac4bf66686bbb` → variable-length header fix
  already in tree; notes HW gating, Cc: stable.
- **[Phase 3]** `git log --grep="validate IPv4"` → commit not in tree.
- **[Phase 4]** WebFetch patch.msgid.link → 403 blocked. **UNVERIFIED:**
  lore discussion, stable nominations.
- **[Phase 4]** `b4 dig -c HEAD` → no match (different commit).
  **UNVERIFIED:** original thread for this patch.
- **[Phase 5]** `grep psp_dev_rcv` → callers in mlx5 and netdevsim
  confirmed.
- **[Phase 5]** Read `mlx5e_psp_offload_handle_rx_skb()` → RX path with
  HW syndrome gate.
- **[Phase 5]** `grep "ihl < 5"` in `net/ipv4/` → standard validation in
  `ip_input.c:500` and elsewhere.
- **[Phase 6]** Read current `net/psp/psp_main.c:272-369` → all three
  checks absent.
- **[Phase 6]** `grep "ihl < 5|tot_len.*encap"` in `net/psp/` → no
  matches.
- **[Phase 7]** Read `net/psp/Kconfig` → `CONFIG_INET_PSP` optional,
  depends on INET.
- **[Phase 8]** Traced failure modes from code: underflow at lines
  351/358, `ip_fast_csum` at line 353 without `ihl` guard.

**YES**

 net/psp/psp_main.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/net/psp/psp_main.c b/net/psp/psp_main.c
index e35c31977479c..afda9cb660275 100644
--- a/net/psp/psp_main.c
+++ b/net/psp/psp_main.c
@@ -294,6 +294,9 @@ int psp_dev_rcv(struct sk_buff *skb, u16 dev_id, u8 generation, bool strip_icv)
 	if (proto == htons(ETH_P_IP)) {
 		struct iphdr *iph = (struct iphdr *)(skb->data + l2_hlen);
 
+		if (unlikely(iph->ihl < 5))
+			return -EINVAL;
+
 		is_udp = iph->protocol == IPPROTO_UDP;
 		l3_hlen = iph->ihl * 4;
 		if (l3_hlen != sizeof(struct iphdr) &&
@@ -347,6 +350,9 @@ int psp_dev_rcv(struct sk_buff *skb, u16 dev_id, u8 generation, bool strip_icv)
 	if (proto == htons(ETH_P_IP)) {
 		struct iphdr *iph = (struct iphdr *)(skb->data + l2_hlen);
 
+		if (unlikely(ntohs(iph->tot_len) < l3_hlen + encap))
+			return -EINVAL;
+
 		iph->protocol = psph->nexthdr;
 		iph->tot_len = htons(ntohs(iph->tot_len) - encap);
 		iph->check = 0;
@@ -354,6 +360,9 @@ int psp_dev_rcv(struct sk_buff *skb, u16 dev_id, u8 generation, bool strip_icv)
 	} else {
 		struct ipv6hdr *ipv6h = (struct ipv6hdr *)(skb->data + l2_hlen);
 
+		if (unlikely(ntohs(ipv6h->payload_len) < encap))
+			return -EINVAL;
+
 		ipv6h->nexthdr = psph->nexthdr;
 		ipv6h->payload_len = htons(ntohs(ipv6h->payload_len) - encap);
 	}
-- 
2.53.0

