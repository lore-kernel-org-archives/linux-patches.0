Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C97354E56C3;
	Mon, 31 Aug 2026 13:40:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183605; cv=none; b=HB8GIHqYd2fqVUTy/IC2G+9dNyRTCdHKMiiaHuPgYkxup4GEn7P4E1nSZ88x5i6MDoCxd+tFOB9M12czIAWxuYRK0XJvgeseAhfXkDUpbVXb2FW3yMhymbS3okj02UMyyR6FelU307IAf6iyEG5nx8ETnsyqRLITMq5mH1oNKno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183605; c=relaxed/simple;
	bh=hq3LvVJbLSoVc9fDLeWev5a3+jV6a15QR+CehIr11S8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pnzACSbFk0XdzYGvC+WX5ZP5c9phKf/3iUyR2C8nUx3P9usqkAvbd4ylEPH4MKiHRN0bpN24/3IgRHrln9vI2LwphqZEskBLvIr6VYmEQXmMXDTQjJqQTAOTpLojwceuWEy8qbXWTCB8khmjQFTIkDaYpcYkTJGuqEbHUOHy69E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lSCQDRm7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lSCQDRm7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 769E91F00ACA;
	Mon, 31 Aug 2026 13:40:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183602;
	bh=FRdDbvDICh6LQur0eYHl3aCIVvxP1IckkMD0ZJdShjQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lSCQDRm7HtqaY68yuwyba87tbjcMjjvs0npUylx7FTDlV5tM4uenxk6bp854qyOUm
	 HcOuAgXs5opXpeC9b5QLRcj7o0JbS/G+meT2IkoHuX9lak7nwdw3NYLTicBBnsAiMA
	 LqUlBLNEeA3kAjTdqdvPG24Bc61c9NbPih4xETGYp42yL9Tw+QECmlZNMLSU449tGT
	 8c3KSnc74PkxKT+VOsh2+NoUt2Oql3qkLg6owmZO4XpcxGCaCqzJy3Dzw6HNEZkM9f
	 tmBmRKoMGSWxFnEdj5xIP6VQRgUI4Te2Cs80+EzPaeESf+b7tZsrZHaE/50KOC4ts9
	 BVZU2pBrd39DA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jijie Shao <shaojijie@huawei.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	shenjian15@huawei.com,
	andrew+netdev@lunn.ch,
	davem@davemloft.net,
	edumazet@google.com,
	pabeni@redhat.com,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] net: hns3: improve the unused_tuple parameter setting
Date: Mon, 31 Aug 2026 09:23:41 -0400
Message-ID: <20260831133314.4125787-193-sashal@kernel.org>
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

From: Jijie Shao <shaojijie@huawei.com>

[ Upstream commit 1ad6f1ff3e96c7ee888475740c8acdaf822e0813 ]

Currently, when the tc tool is used to set flow table rules, the IP address
and MAC address can be configured separately, for example, src_xx or dst_xx
can be configured separately.

Therefore, the driver needs to check whether the mask is all zero in
keys, such as FLOW_DISSECTOR_KEY_IPV4_ADDRS, FLOW_DISSECTOR_KEY_IPV6_ADDRS,
and FLOW_DISSECTOR_KEY_ETH_ADDRS.
If the mask is all zero, the tuple is not configured.
In this case, the driver adds the tuple to unused_tuple.

Signed-off-by: Jijie Shao <shaojijie@huawei.com>
Link: https://patch.msgid.link/20260610060618.834987-3-shaojijie@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

**Step 1.1 — Subject line**
Record: `[net: hns3]` `[improve]` — improve `unused_tuple` handling when
parsing tc flower match keys for MAC and IP addresses.

**Step 1.2 — Tags**
Record:
- **Signed-off-by:** Jijie Shao `<shaojijie@huawei.com>` (author)
- **Link:**
  https://patch.msgid.link/20260610060618.834987-3-shaojijie@huawei.com
- **Signed-off-by:** Jakub Kicinski `<kuba@kernel.org>` (netdev
  maintainer)
- No `Fixes:`, `Reported-by:`, `Tested-by:`, `Reviewed-by:`, `Acked-
  by:`, or `Cc: stable@vger.kernel.org`

Notable: maintainer merge (`kuba@kernel.org`), but no fuzzer or user bug
report tags.

**Step 1.3 — Body analysis**
Record:
- **Bug:** When `tc` installs flower rules with only `src_*` or only
  `dst_*` for IP/MAC, the dissector key (`FLOW_DISSECTOR_KEY_ETH_ADDRS`,
  `FLOW_DISSECTOR_KEY_IPV4_ADDRS`, `FLOW_DISSECTOR_KEY_IPV6_ADDRS`) can
  be present while one side’s mask is all-zero.
- **Symptom:** Driver fails to mark that tuple as unused; hardware flow-
  director rules are programmed incorrectly instead of treating the
  field as a wildcard.
- **Root cause:** `hclge_get_cls_key_mac()` / `hclge_get_cls_key_ip()`
  only set `unused_tuple` when the entire key is absent, not when an
  individual mask is zero.

**Step 1.4 — Hidden bug fix?**
Record: **Yes.** Subject says “improve,” but this is a correctness fix
for tc flower hardware offload, not a cosmetic cleanup.

---

## Phase 2: Diff Analysis

**Step 2.1 — Inventory**
Record:
- **Files:** `drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c`
  (+12 lines)
- **Functions:** `hclge_get_cls_key_mac()`, `hclge_get_cls_key_ip()`
- **Scope:** Single-file, surgical driver fix

**Step 2.2 — Code flow change**
Record:
- **MAC hunk:** After copying eth addr keys/masks, if `match.mask->dst`
  or `match.mask->src` is all-zero, set `INNER_DST_MAC` /
  `INNER_SRC_MAC` in `unused_tuple`.
- **IPv4 hunk:** If `match.mask->src` or `match.mask->dst` is zero, set
  corresponding `INNER_SRC_IP` / `INNER_DST_IP`.
- **IPv6 hunk:** If `ipv6_addr_any(&match.mask->src/dst)`, set
  corresponding IP unused bits.
- **Before:** Only the `else` branch (key fully absent) marked tuples
  unused.
- **After:** Per-field zero masks are also treated as unused, matching
  ethtool-path behavior elsewhere in the same file.

**Step 2.3 — Bug mechanism**
Record: **Logic / correctness fix.** Category: incorrect hardware tuple
programming.

When `unused_tuple` is **not** set, `hclge_fd_convert_tuple()` programs
hardware using:

```862:863:drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
#define calc_x(x, k, v) ((x) = ~(k) & (v))
#define calc_y(y, k, v) ((y) = (k) & (v))
```

With mask `k = 0`, this yields `X = key`, `Y = 0` — not wildcard
behavior. When `unused_tuple` **is** set, `hclge_fd_convert_tuple()`
skips programming that tuple (wildcard). The ethtool path already does
zero-mask checks (e.g. `hclge_fd_check_ether_tuple()`); the tc flower
path did not.

**Step 2.4 — Fix quality**
Record: Obviously correct, minimal, mirrors existing driver logic. Low
regression risk. Does not fix the same gap in `hclge_get_cls_key_port()`
(ports), but that is a separate pre-existing issue.

---

## Phase 3: Git History Investigation

**Step 3.1 — Blame**
Record: `hclge_get_cls_key_mac()` introduced in `0205ec041ec61` (“net:
hns3: add support for hw tc offload of tc flower”, Dec 2020).
`hclge_get_cls_key_ip()` mostly from same commit; signature extended in
`e199a5b29f199` (2024).

**Step 3.2 — Fixes: tag**
Record: N/A — no `Fixes:` tag.

**Step 3.3 — Related file history**
Record: Commit `1ad6f1ff3e96c` is patch 2/6 of “enhance tc flow offload
support” on master. Other series commits add actions, dissectors,
debugfs, and file split — not required for this 12-line fix. Standalone.

**Step 3.4 — Author context**
Record: Jijie Shao is an active hns3 contributor (FD/TC-related commits
in this tree).

**Step 3.5 — Dependencies**
Record: None. Functions and structures exist unchanged in 6.18.y.
Cherry-pick to current HEAD applies cleanly (auto-merge, exit 0).

---

## Phase 4: Mailing List and External Research

**Step 4.1 — Original discussion**
Record: `b4 dig -c 1ad6f1ff3e96c` →
https://patch.msgid.link/20260610060618.834987-3-shaojijie@huawei.com
Series: V4 net-next 2/6. Revisions v1–v4 found via `b4 dig -a`. Lore
direct fetch blocked by bot protection; thread retrieved via `b4 dig
-m`.

**Step 4.2 — Reviewers**
Record: `b4 dig -w` CC’d `davem@davemloft.net`, `kuba@kernel.org`,
`pabeni@redhat.com`, `netdev@vger.kernel.org`, Huawei maintainers. No
explicit stable nomination found in mbox grep.

**Step 4.3 — Bug report**
Record: No external bug report, syzbot, or user `Reported-by:`.

**Step 4.4 — Series context**
Record: Part of 6-patch enhancement series, but this patch only fixes
existing cls-flower parsing; does not depend on new actions/dissectors
from patches 3–6.

**Step 4.5 — Stable list**
Record: Not searched on lore stable (no stable nomination found in
retrieved mbox). UNVERIFIED whether stable@ discussed this separately.

---

## Phase 5: Code Semantic Analysis

**Step 5.1 — Key functions**
Record: `hclge_get_cls_key_mac()`, `hclge_get_cls_key_ip()`, called from
`hclge_parse_cls_flower()`.

**Step 5.2 — Callers**
Record: `hclge_parse_cls_flower()` ← `hclge_add_cls_flower()` ←
`add_cls_flower` in `hnae3` ops ← `hns3_nic_setup_tc()`
(`ndo_setup_tc`). Reachable from userspace via `tc` flower rules on HNS3
NICs.

**Step 5.3 — Callees**
Record: `flow_rule_match_*`, `ether_addr_copy`, `ipv6_addr_be32_to_cpu`,
`unused_tuple |= BIT(...)`.

**Step 5.4 — Reachability**
Record: Userspace-triggered via `tc filter add ... flower ...` on
HiSilicon HNS3 hardware with flow-director/tc-flower offload enabled
(`CONFIG_HNS3`).

**Step 5.5 — Similar patterns**
Record: Ethtool FD path in same file already checks zero masks
(`hclge_fd_check_tcpip4_tuple()`, `hclge_fd_check_ether_tuple()`, etc.).
tc flower path was inconsistent.

---

## Phase 6: Cross-Reference Against Local Tree (6.18.y)

**Step 6.1 — Buggy code present?**
Record: **Yes.** Local tree is **v6.18.44** (`git describe HEAD`).
`hclge_get_cls_key_mac()` and `hclge_get_cls_key_ip()` lack zero-mask
checks. Commit `1ad6f1ff3e96c` is **not** an ancestor of HEAD (`NOT IN
TREE`). Bug present since tc flower support landed (2020).

**Step 6.2 — Backport complications**
Record: Clean cherry-pick (auto-merge, no conflicts). Expected apply:
**clean**.

**Step 6.3 — Related fixes already present?**
Record: No equivalent fix found in 6.18.y history for this specific
issue.

---

## Phase 7: Subsystem Context

**Step 7.1 — Subsystem / criticality**
Record: `drivers/net/ethernet/hisilicon/hns3` — **IMPORTANT**
(server/cloud NIC driver, tc offload data path).

**Step 7.2 — Activity**
Record: Actively maintained; recent TC/FD fixes in this file (e.g.
`d7beeb64be5ca`, `6b36e5c4741f1`).

---

## Phase 8: Impact and Risk Assessment

**Step 8.1 — Who is affected**
Record: Users of HiSilicon HNS3 NICs with hardware tc flower offload,
configuring rules with partial src/dst IP or MAC matching.

**Step 8.2 — Trigger conditions**
Record: Common — `tc flower` rules matching only source or only
destination IP/MAC. Unprivileged users can install tc rules (with
appropriate capabilities/namespace policy).

**Step 8.3 — Failure mode / severity**
Record: Incorrect hardware packet classification / queue steering; rules
may not match intended traffic or may match too narrowly. **Severity:
MEDIUM** — functional data-path bug, not kernel crash, deadlock, or
memory corruption.

**Step 8.4 — Risk vs benefit**
Record:
- **Benefit:** MEDIUM — fixes real mis-steering for standard tc usage on
  production NICs
- **Risk:** LOW — 12 lines, mirrors proven ethtool logic
- **Ratio:** Favorable for stable

---

## Phase 9: Final Synthesis

**Evidence FOR backport:**
- Real, verifiable logic bug in tc flower offload path
- Bug present in 6.18.y since 2020
- Small, self-contained, applies cleanly
- Aligns tc path with existing ethtool FD logic in same driver
- Userspace-reachable via `tc` on widely deployed server NICs
- Maintainer-reviewed and merged

**Evidence AGAINST backport:**
- No crash, security, or corruption angle
- No user/fuzzer bug report
- Part of larger net-next enhancement series (though patch itself is
  independent)
- Port matching has same class of bug but is not addressed here

**Stable rules checklist:**
1. Obviously correct and tested? **PASS** — logic mirrors existing
   driver patterns; no `Tested-by:` but change is straightforward
2. Fixes a real bug affecting users? **PASS** — incorrect HW filtering
   for partial tc flower matches
3. Important issue? **PASS (borderline)** — incorrect packet steering on
   production networking path; not crash-level but user-visible and
   operationally significant
4. Small and contained? **PASS** — 12 lines, 1 file
5. No new features/APIs? **PASS**
6. Can apply to local tree? **PASS** — verified clean cherry-pick

**Exception category:** None (not quirk/ID/DT/docs/build).

---

## Problem Summary

This commit fixes a long-standing inconsistency in the HNS3 driver’s tc
flower offload path. When users install `tc flower` rules specifying
only source or only destination IP/MAC addresses, the flow dissector
includes the address key with a zero mask for the unspecified side. The
driver must mark those tuples as unused so hardware treats them as
wildcards. Without this fix, `unused_tuple` is not set, hardware is
programmed with zero-mask tuple values, and flow-director rules behave
incorrectly.

For **Linux 6.18.y**, the buggy code is present, the fix is absent, the
patch applies cleanly, and it is standalone. This is appropriate stable
material: a small, low-risk driver correctness fix for a userspace-
visible data-path bug.

---

## Verification

- [Phase 1] Parsed commit message and tags from provided diff and `git
  show 1ad6f1ff3e96c`
- [Phase 2] Analyzed diff: +12 lines in `hclge_get_cls_key_mac()` and
  `hclge_get_cls_key_ip()`
- [Phase 2] Verified `calc_x`/`calc_y` macros and
  `hclge_fd_convert_tuple()` skip logic
- [Phase 2] Verified ethtool path already has zero-mask checks
  (`hclge_fd_check_ether_tuple()` etc.)
- [Phase 3] `git blame`: buggy code from `0205ec041ec61` (2020)
- [Phase 3] `git merge-base --is-ancestor 1ad6f1ff3e96c HEAD` → NOT IN
  TREE
- [Phase 3] Cherry-pick test: `git cherry-pick --no-commit
  1ad6f1ff3e96c` → exit 0, auto-merge
- [Phase 4] `b4 dig -c 1ad6f1ff3e96c` → lore URL found
- [Phase 4] `b4 dig -a` → v1–v4 series revisions
- [Phase 4] `b4 dig -w` → netdev maintainers CC’d
- [Phase 4] `b4 dig -m` → cover letter retrieved; patch 2/6 context
  confirmed
- [Phase 5] Traced call chain: `hns3_nic_setup_tc` →
  `hclge_add_cls_flower` → `hclge_parse_cls_flower`
- [Phase 6] `git describe HEAD` → v6.18.44; Makefile 6.18.44
- [Phase 6] Read current `hclge_main.c` — buggy code confirmed present
  (no zero-mask checks in MAC/IP cls helpers)
- [Phase 8] Assessed severity as MEDIUM functional data-path bug
- UNVERIFIED: No direct lore stable-list discussion
- UNVERIFIED: No runtime test evidence beyond maintainer merge

**YES****Task result:** The branch search found commit `1ad6f1ff3e96c`
on `master` — it matches the patch under review and is not in the local
6.18.44 tree.

**Verdict (unchanged):** Backport **YES**. Small, standalone fix for
incorrect tc flower hardware filtering when only src or dst IP/MAC is
specified; applies cleanly to 6.18.y.

 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c  | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 7f174453928c1..08f7bda4ef4c4 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -7261,6 +7261,10 @@ static void hclge_get_cls_key_mac(const struct flow_rule *flow,
 		ether_addr_copy(rule->tuples_mask.dst_mac, match.mask->dst);
 		ether_addr_copy(rule->tuples.src_mac, match.key->src);
 		ether_addr_copy(rule->tuples_mask.src_mac, match.mask->src);
+		if (is_zero_ether_addr(match.mask->dst))
+			rule->unused_tuple |= BIT(INNER_DST_MAC);
+		if (is_zero_ether_addr(match.mask->src))
+			rule->unused_tuple |= BIT(INNER_SRC_MAC);
 	} else {
 		rule->unused_tuple |= BIT(INNER_DST_MAC);
 		rule->unused_tuple |= BIT(INNER_SRC_MAC);
@@ -7309,6 +7313,10 @@ static int hclge_get_cls_key_ip(const struct flow_rule *flow,
 		rule->tuples.dst_ip[IPV4_INDEX] = be32_to_cpu(match.key->dst);
 		rule->tuples_mask.dst_ip[IPV4_INDEX] =
 						be32_to_cpu(match.mask->dst);
+		if (!match.mask->src)
+			rule->unused_tuple |= BIT(INNER_SRC_IP);
+		if (!match.mask->dst)
+			rule->unused_tuple |= BIT(INNER_DST_IP);
 	} else if (addr_type == FLOW_DISSECTOR_KEY_IPV6_ADDRS) {
 		struct flow_match_ipv6_addrs match;
 
@@ -7321,6 +7329,10 @@ static int hclge_get_cls_key_ip(const struct flow_rule *flow,
 				      match.key->dst.s6_addr32);
 		ipv6_addr_be32_to_cpu(rule->tuples_mask.dst_ip,
 				      match.mask->dst.s6_addr32);
+		if (ipv6_addr_any(&match.mask->src))
+			rule->unused_tuple |= BIT(INNER_SRC_IP);
+		if (ipv6_addr_any(&match.mask->dst))
+			rule->unused_tuple |= BIT(INNER_DST_IP);
 	} else {
 		rule->unused_tuple |= BIT(INNER_SRC_IP);
 		rule->unused_tuple |= BIT(INNER_DST_IP);
-- 
2.53.0

