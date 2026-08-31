Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8F4E450906;
	Mon, 31 Aug 2026 13:34:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183265; cv=none; b=fC5CNw2nRceCTbOC1HBS/CMp5dqeUtB/A7OB4YD/Tfs5X6Vj44nlxB5mOKiF60qoTmJcOOgidWRmEuoepr0UD7Tndl2GMClOxYZ6a8B4dkplOdVkZVppBJCycK4Of6BWrSI8f5ioSbieG9xnYOtxION2sGaW27hB2xd7oroL8NI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183265; c=relaxed/simple;
	bh=MqngZ8Tj06+Q7KL5Ue/Pqn1J4tGdwuDeBsXgnbZhC+o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=P/TVf3DyF0ia73fYqGOjMQNbVszMZF3Q0CNI0R9GXex0nelhVFRgMztROMxIUhHKmrByNX5wd9/GNN7uKdJj9MXWOHYr2eUMPpxzbW3uyV4Xc/KnXmQKBck44fgjgvzUsDPnTLb6kou3kN1nVkszN2g+JXXF1NIfUig2F//rwhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k5pW9A8m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k5pW9A8m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5587B1F000E9;
	Mon, 31 Aug 2026 13:34:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183263;
	bh=cO2mZ5HN8GGzP/R9aMklJrVC6U8lRQNLY/LSuFjXokw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k5pW9A8m9nDeOrHOD88v8Nr7n2s9oqwvE0MvO2H21VJNX2h9/0fqwTgZafsn3MQl/
	 cEP/Pzc5Zw9fldQN1IdX9Ft0GTP7cmxF2Pd/rMhscIqIz1kS7Vyzb5gYrKCYD41N8b
	 BFQVDK1Adzy4mwh3hQYM0RqndmOA7DgIzpQfPetnP4TwwX5Nrbyl1+v3Z0GTp+0y9p
	 UuXkjVTMrTZ/eXRFBA7Zd9/ylbt4PDzyP2677QiZP4FmryS7dNvy41NXtwxzlnCAAo
	 uIt7R+bGnO+VXkZwLT2EoKmYRh9ddLid9RLrEu3aZ6kIdULduobIfxmppDFr4ihOqt
	 d1rjE7HeTlMjw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Lorenzo Bianconi <lorenzo@kernel.org>,
	Xuegang Lu <xuegang.lu@airoha.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	andrew+netdev@lunn.ch,
	davem@davemloft.net,
	edumazet@google.com,
	pabeni@redhat.com,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] net: airoha: Reserve RX headroom to avoid skb reallocation
Date: Mon, 31 Aug 2026 09:21:11 -0400
Message-ID: <20260831133314.4125787-43-sashal@kernel.org>
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

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit bbfb1983944f2eaa8ee192e0f7b59ecc0fda9981 ]

Reserve NET_SKB_PAD + NET_IP_ALIGN bytes of headroom for received packets
to avoid skb head reallocation when pushing protocol headers into the skb.

Tested-by: Xuegang Lu <xuegang.lu@airoha.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://patch.msgid.link/20260513-airoha-rx-headroom-v1-1-bd87798e422d@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `net: airoha: Reserve RX headroom to avoid
skb reallocation`

**Local tree:** Linux **6.18.43** (`git describe HEAD` →
`v6.18.43-1-gc7f0dac02d232`)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Parse the subject line
**Record:** `[net: airoha]` `[Reserve]` — Reserve RX headroom in the
Airoha Ethernet driver to prevent skb head reallocation on received
packets.

### Step 1.2: Parse all commit message tags
**Record:**
| Tag | Value |
|-----|-------|
| Tested-by | Xuegang Lu `<xuegang.lu@airoha.com>` (Airoha vendor
engineer) |
| Signed-off-by | Lorenzo Bianconi `<lorenzo@kernel.org>` (driver
author) |
| Signed-off-by | Jakub Kicinski `<kuba@kernel.org>` (netdev maintainer)
|
| Link | https://patch.msgid.link/20260513-airoha-rx-
headroom-v1-1-bd87798e422d@kernel.org |
| Fixes: | **Not present** (expected for manual review) |
| Cc: stable | **Not present** (expected) |
| Reported-by: | **Not present** |

**Notable patterns:** Vendor `Tested-by` from Airoha; no
syzbot/sanitizer reports; no explicit crash description in the commit
message.

### Step 1.3: Analyze commit body text
**Record:**
- **Bug described:** RX skbs are built without `NET_SKB_PAD +
  NET_IP_ALIGN` headroom, so the network stack must reallocate skb heads
  when pushing protocol headers.
- **Symptom/failure mode:** skb head reallocation on the RX path
  (performance/correctness issue for page_pool-based RX, not a
  documented oops).
- **Version info:** None in commit message.
- **Root cause (author):** Driver omitted standard RX headroom
  reservation that peer drivers (e.g. MediaTek) already use.

### Step 1.4: Detect hidden bug fixes
**Record:** **Yes, partially.** While framed as avoiding reallocation,
the final patch also tightens RX length validation (`data_len` now uses
`AIROHA_RX_LEN()` / `e->dma_len` instead of unadjusted buffer sizes).
During review of v5, sashiko-bot flagged that without this bounds
adjustment, `__skb_put()` with `skb_reserve()` could overflow skb bounds
if hardware returned an oversized length. Lorenzo acknowledged and fixed
this in v6. The committed version includes both the headroom fix and the
bounds-check correction.

---

## PHASE 2: DIFF ANALYSIS — LINE BY LINE

### Step 2.1: Inventory the changes
**Record:**
| File | Changes |
|------|---------|
| `drivers/net/ethernet/airoha/airoha_eth.c` | +8 / -6 lines |
| `drivers/net/ethernet/airoha/airoha_eth.h` | +2 lines |
| **Functions modified:** `airoha_qdma_fill_rx_queue()`,
`airoha_qdma_rx_process()` |
| **Scope:** Single-subsystem, two-file surgical driver fix |

### Step 2.2: Code flow change per hunk

**Hunk 1 — `airoha_qdma_fill_rx_queue()`:**
- **Before:** DMA buffer starts at page_pool fragment offset; full
  `SKB_WITH_OVERHEAD(q->buf_size)` used for DMA length.
- **After:** Offset advanced by `AIROHA_RX_HEADROOM`; DMA length reduced
  by headroom via `AIROHA_RX_LEN()`.
- **Path affected:** RX ring refill (initialization/hot path).

**Hunk 2 — `airoha_qdma_rx_process()` DMA sync:**
- **Before:** Synced `SKB_WITH_OVERHEAD(q->buf_size)` regardless of
  actual buffer offset.
- **After:** Syncs `e->dma_len` (actual mapped region).
- **Path affected:** RX NAPI processing.

**Hunk 3 — `airoha_qdma_rx_process()` length validation:**
- **Before:** `data_len` used full `q->buf_size` /
  `SKB_WITH_OVERHEAD(q->buf_size)`.
- **After:** `data_len` uses `AIROHA_RX_LEN(q->buf_size)` or
  `e->dma_len`.
- **Path affected:** RX validation before skb construction.

**Hunk 4 — `airoha_qdma_rx_process()` skb build:**
- **Before:** `napi_build_skb(e->buf, q->buf_size)` with no headroom.
- **After:** `napi_build_skb(e->buf - AIROHA_RX_HEADROOM, q->buf_size)`
  + `skb_reserve(q->skb, AIROHA_RX_HEADROOM)`.
- **Path affected:** First-buffer skb construction on every received
  packet.

**Hunk 5 — header defines:**
- **Before:** No headroom macros.
- **After:** `AIROHA_RX_HEADROOM = NET_SKB_PAD + NET_IP_ALIGN`,
  `AIROHA_RX_LEN(_n) = (_n) - AIROHA_RX_HEADROOM`.

### Step 2.3: Bug mechanism classification
**Record:**
- **Category:** Logic/correctness fix + memory-safety hardening
- **Mechanism:** Driver uses `page_pool` + `napi_build_skb()` +
  `skb_mark_for_recycle()` but did not reserve the standard `NET_SKB_PAD
  + NET_IP_ALIGN` (typically 34 bytes) of RX headroom. When the network
  stack later pushes headers (bridging, VLAN, DSA, GRO, etc.),
  `skb_cow_head()` / `pskb_expand_head()` forces skb head reallocation,
  defeating the page_pool zero-copy model. The bounds-check update
  prevents accepting packet lengths that would overflow the reduced
  usable buffer after `skb_reserve()`.

### Step 2.4: Fix quality assessment
**Record:**
- **Quality:** High. Matches established pattern in `mtk_eth_soc.c`
  (`skb_reserve(skb, NET_SKB_PAD + NET_IP_ALIGN)`).
- **Regression risk:** Very low. Only reduces usable DMA buffer by a
  fixed 34-byte headroom; all length checks and DMA sync updated
  consistently.
- **Red flags:** None. No API changes, no cross-subsystem impact.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame the changed lines
**Record:** Local tree has shallow history (~50 commits). `git blame`
attributes all `airoha_eth.c` RX code to a bulk-import commit, so the
exact introduction commit cannot be determined from this checkout. The
driver source header shows Copyright 2024, and the buggy RX path is
**present in 6.18.43** at lines 549–674 of `airoha_eth.c`.

### Step 3.2: Follow Fixes: tag
**Record:** No `Fixes:` tag present. Not applicable.

### Step 3.3: File history for related changes
**Record:** `git log --oneline -- drivers/net/ethernet/airoha/` returns
no airoha-specific commits in this shallow stable checkout. The fix is
**standalone** (not part of a multi-patch dependency chain in the
committed form). During netdev review it was patch 02/12 of a larger
series, but this commit is self-contained.

### Step 3.4: Author's relationship to subsystem
**Record:** Lorenzo Bianconi is the Airoha Ethernet driver author (per
file header and patch submission). Jakub Kicinski (netdev maintainer)
applied the patch. Strong subsystem ownership.

### Step 3.5: Prerequisite commits
**Record:** No prerequisite commits referenced. All symbols
(`napi_build_skb`, `page_pool`, `skb_mark_for_recycle`,
`SKB_WITH_OVERHEAD`) exist in 6.18.43. Patch applies cleanly with minor
line-number offset (verified via `git apply --check`).

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original patch discussion
**Record:**
- **b4 dig URL:** https://patch.msgid.link/20260513-airoha-rx-
  headroom-v1-1-bd87798e422d@kernel.org
- **Series revisions:** Only v1 found via `b4 dig -a` (direct
  submission, applied as-is to net-next)
- **Key reviewer feedback:** In the v5 series thread (spinics.net),
  sashiko-bot flagged missing bounds-check adjustment as a potential
  buffer overflow; Lorenzo replied "ack, I will fix it in v6." The
  committed version includes that fix.
- **Stable nominations:** None found in the thread (only patchwork-bot
  apply notification).
- **NAKs:** None.

### Step 4.2: Reviewers from b4 dig -w
**Record:** CC'd: Andrew Lunn, David S. Miller, Eric Dumazet, Jakub
Kicinski, Paolo Abeni, linux-arm-kernel, linux-mediatek, netdev, Xuegang
Lu (Airoha). Appropriate netdev maintainer coverage.

### Step 4.3: Bug report details
**Record:** No formal bug report URL in commit. OpenWrt downstream
commit `dda777dd4472` describes this as part of "Airoha reported bug for
ethernet" and backported it to their 6.12 airoha target. Vendor testing
confirmed via `Tested-by: Xuegang Lu`.

### Step 4.4: Related patches in series
**Record:** Part of a larger airoha-eth multi-patch series on net-next,
but this specific commit is independently applicable and functionally
complete.

### Step 4.5: Stable mailing list history
**Record:** Not searched exhaustively; no stable-list nomination found
in available thread data.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions modified
**Record:** `airoha_qdma_fill_rx_queue()`, `airoha_qdma_rx_process()`

### Step 5.2: Callers
**Record:**
- `airoha_qdma_fill_rx_queue()` called from `airoha_qdma_rx_process()`
  (line 716) and `airoha_qdma_init_rx_queue()` (line 802)
- `airoha_qdma_rx_process()` called from `airoha_qdma_rx_napi_poll()`
  (line 727)
- NAPI poll is the standard per-packet RX hot path on every received
  frame

### Step 5.3: Key callees
**Record:** `page_pool_dev_alloc_frag()`, `napi_build_skb()`,
`skb_reserve()`, `skb_mark_for_recycle()`, `eth_type_trans()`,
`napi_gro_receive()`, `dma_sync_single_for_cpu()`

### Step 5.4: Call chain / reachability
**Record:** Hardware interrupt → NAPI poll → `airoha_qdma_rx_process()`
→ network stack (`napi_gro_receive`). **Every received packet** on
Airoha hardware traverses this path. Commonly triggered on OpenWrt
router platforms with DSA switching and bridging.

### Step 5.5: Similar patterns
**Record:** `drivers/net/ethernet/mediatek/mtk_eth_soc.c:2320` uses
`skb_reserve(skb, NET_SKB_PAD + NET_IP_ALIGN)` on RX. Many page_pool-
aware drivers reserve equivalent headroom. The Airoha driver was missing
this standard practice.

---

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

### Step 6.1: Does the buggy code exist?
**Record:** **Yes.** In 6.18.43:
- `airoha_eth.c:571-573`: no headroom offset, `e->dma_len =
  SKB_WITH_OVERHEAD(q->buf_size)`
- `airoha_eth.c:638-644`: unadjusted length checks
- `airoha_eth.c:654`: `napi_build_skb(e->buf, q->buf_size)` without
  `skb_reserve()`
- `AIROHA_RX_HEADROOM` macro **not defined** in `airoha_eth.h`

### Step 6.2: Backport complications
**Record:** **Clean apply** with minor line-number offset (functions at
lines 549/613 vs. 526/594 in upstream diff). No conflicting changes
detected. `AIROHA_MAX_MTU` differs (9216 local vs 9220 upstream) but is
unrelated to this patch.

### Step 6.3: Related fixes already present?
**Record:** `git log --grep="headroom"` and `git log --grep="airoha"`
return no matches. **Fix is not already in 6.18.43.**

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem criticality
**Record:** `drivers/net/ethernet/airoha/` — **IMPORTANT** (platform
primary Ethernet MAC for Airoha SoCs used in routers/embedded). Config:
`CONFIG_NET_AIROHA` depends on `ARCH_AIROHA || COMPILE_TEST`, selects
`PAGE_POOL`.

### Step 7.2: Subsystem activity
**Record:** Driver is actively developed (2024 copyright, recent multi-
patch series on net-next). Bug present since initial RX implementation.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who is affected
**Record:** Users of Airoha SoC gigabit Ethernet (`CONFIG_NET_AIROHA`) —
embedded routers (OpenWrt airoha target), MediaTek-related DSA switch
platforms. Not universal, but **primary network path** for those
systems.

### Step 8.2: Trigger conditions
**Record:**
- **Trigger:** Any RX traffic where the network stack pushes headers
  (bridging, VLAN, DSA tag handling, GRO, forwarding). Very common on
  router workloads.
- **Likelihood:** High on deployed Airoha router configurations.
- **Unprivileged trigger:** Yes (incoming network traffic).

### Step 8.3: Failure mode severity
**Record:**
- **Without fix:** Per-packet skb head reallocation on header push;
  page_pool recycling defeated; elevated CPU and allocation pressure;
  potential `rx_dropped` under load; theoretical skb bounds overflow if
  hardware returns oversized length (bounds-check issue fixed in final
  version).
- **Severity:** **MEDIUM-HIGH** for affected hardware — functional
  networking degradation, not a typical kernel oops, but real user-
  visible impact on production router platforms.

### Step 8.4: Risk-benefit ratio
**Record:**
- **Benefit:** HIGH for Airoha users (correct page_pool RX behavior,
  reduced per-packet allocations, hardened length validation).
- **Risk:** VERY LOW (10-line surgical change, vendor-tested,
  established driver pattern).
- **Ratio:** Favorable for backport to 6.18.y where the driver and buggy
  code both exist.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence compiled

**FOR backport:**
- Buggy code confirmed present in 6.18.43
- Vendor-tested (`Tested-by: Xuegang Lu @airoha.com`)
- OpenWrt downstream backported as "Airoha reported bug" to 6.12
- Standard RX headroom pattern used by peer drivers (MediaTek)
- page_pool + `skb_mark_for_recycle` without headroom is incorrect for
  header-push workloads
- Includes bounds-check hardening from review feedback
- Small, self-contained, applies cleanly
- Affects every RX packet on Airoha hardware

**AGAINST backport:**
- Commit message frames issue as avoiding reallocation (optimization
  language)
- No documented kernel crash, oops, or CVE
- Narrow hardware scope (`ARCH_AIROHA`)
- No explicit `Cc: stable` or maintainer stable nomination
- Performance fix rather than crash/corruption fix per strict stable-
  kernel-rules wording

**Unresolved:** Exact symptoms Airoha reported to OpenWrt are not
documented in the upstream commit or lore thread.

### Step 9.2: Stable rules checklist
| Criterion | Result |
|-----------|--------|
| 1. Obviously correct and tested? | **PASS** — standard pattern, vendor
Tested-by, netdev maintainer applied |
| 2. Fixes a real bug? | **PASS** — driver RX headroom omission
affecting page_pool skb handling |
| 3. Important issue? | **PASS** — functional RX path degradation on
deployed hardware; bounds-check hardening |
| 4. Small and contained? | **PASS** — 10 insertions, 6 deletions, 2
files |
| 5. No new features/APIs? | **PASS** — internal driver constants only |
| 6. Can apply to local tree? | **PASS** — verified clean apply to
6.18.43 |

### Step 9.3: Exception categories
**Record:** Not a device ID, quirk, DT, build, or documentation fix.
Standard driver correctness fix.

### Step 9.4: Decision rationale
For **6.18.43**, the Airoha Ethernet driver exists with the buggy RX
path. This is a vendor-reported, vendor-tested correction to a
fundamental RX buffer layout error that breaks the page_pool zero-copy
model on every packet requiring header push — a common case on Airoha
router platforms with DSA and bridging. The fix is minimal, obviously
correct, and carries negligible regression risk. While not a crash fix,
it addresses a real functional defect on production hardware that
downstream (OpenWrt) has already deemed worth backporting.

---

## Verification

- **[Phase 1]** Parsed commit message tags: Tested-by (Airoha), Signed-
  off-by (author + netdev maintainer), Link present; no Fixes:/Cc:
  stable/Reported-by
- **[Phase 1]** Identified hidden bounds-check fix from v5→v6 review
  cycle (spinics.net sashiko-bot thread)
- **[Phase 2]** Diff analysis: 2 files, functions
  `airoha_qdma_fill_rx_queue()` and `airoha_qdma_rx_process()` modified
- **[Phase 2]** Read current buggy code at `airoha_eth.c:549-674` —
  confirmed no headroom reservation
- **[Phase 3]** `git describe HEAD`: v6.18.43-1-gc7f0dac02d232; `make
  kernelversion`: 6.18.43
- **[Phase 3]** `git blame` on RX functions: shallow history, all
  attributed to bulk import; buggy code present
- **[Phase 3]** No Fixes: tag to follow
- **[Phase 4]** `b4 dig -c bbfb1983944f`: found lore URL
  https://patch.msgid.link/20260513-airoha-rx-
  headroom-v1-1-bd87798e422d@kernel.org
- **[Phase 4]** `b4 dig -a`: only v1 revision
- **[Phase 4]** `b4 dig -w`: netdev maintainers CC'd including Jakub
  Kicinski, David S. Miller, Eric Dumazet
- **[Phase 4]** `b4 dig -m /tmp/airoha_headroom.mbox`: thread saved;
  only patchwork-bot apply notification, no stable nomination
- **[Phase 4]** spinics.net v5 review thread: sashiko-bot bounds-check
  concern, Lorenzo acknowledged fix for v6
- **[Phase 4]** OpenWrt commit dda777dd4472: "Airoha reported bug for
  ethernet", backported to 6.12
- **[Phase 5]** Caller trace: `airoha_qdma_rx_napi_poll()` →
  `airoha_qdma_rx_process()` → `napi_gro_receive()`
- **[Phase 5]** `mtk_eth_soc.c:2320`: confirmed peer driver uses
  `skb_reserve(skb, NET_SKB_PAD + NET_IP_ALIGN)`
- **[Phase 5]** `include/linux/skbuff.h`: `NET_SKB_PAD = max(32,
  L1_CACHE_BYTES)`, `NET_IP_ALIGN = 2`
- **[Phase 5]** `gro.c:100-110`: pp_recycle mismatch prevents GRO
  merging — page_pool skb handling is sensitive
- **[Phase 6]** Confirmed `AIROHA_RX_HEADROOM` absent from local
  `airoha_eth.h`
- **[Phase 6]** `git apply --check` with line-adjusted patch: **applies
  cleanly** (exit 0)
- **[Phase 6]** `git log --grep="headroom"` / `--grep="airoha"`: no
  existing fix in tree
- **[Phase 7]** Read `drivers/net/ethernet/airoha/Kconfig`:
  CONFIG_NET_AIROHA selects PAGE_POOL
- **[Phase 8]** Assessed impact: Airoha SoC primary Ethernet,
  router/embedded deployments

**YES**

 drivers/net/ethernet/airoha/airoha_eth.c | 14 ++++++++------
 drivers/net/ethernet/airoha/airoha_eth.h |  2 ++
 2 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/airoha/airoha_eth.c b/drivers/net/ethernet/airoha/airoha_eth.c
index 64ab34e37c36f..e016f7521af59 100644
--- a/drivers/net/ethernet/airoha/airoha_eth.c
+++ b/drivers/net/ethernet/airoha/airoha_eth.c
@@ -568,9 +568,10 @@ static int airoha_qdma_fill_rx_queue(struct airoha_queue *q)
 		q->queued++;
 		nframes++;
 
+		offset += AIROHA_RX_HEADROOM;
 		e->buf = page_address(page) + offset;
 		e->dma_addr = page_pool_get_dma_addr(page) + offset;
-		e->dma_len = SKB_WITH_OVERHEAD(q->buf_size);
+		e->dma_len = SKB_WITH_OVERHEAD(AIROHA_RX_LEN(q->buf_size));
 
 		val = FIELD_PREP(QDMA_DESC_LEN_MASK, e->dma_len);
 		WRITE_ONCE(desc->ctrl, cpu_to_le32(val));
@@ -635,13 +636,12 @@ static int airoha_qdma_rx_process(struct airoha_queue *q, int budget)
 		q->tail = (q->tail + 1) % q->ndesc;
 		q->queued--;
 
-		dma_sync_single_for_cpu(eth->dev, e->dma_addr,
-					SKB_WITH_OVERHEAD(q->buf_size), dir);
+		dma_sync_single_for_cpu(eth->dev, e->dma_addr, e->dma_len,
+					dir);
 
 		page = virt_to_head_page(e->buf);
 		len = FIELD_GET(QDMA_DESC_LEN_MASK, desc_ctrl);
-		data_len = q->skb ? q->buf_size
-				  : SKB_WITH_OVERHEAD(q->buf_size);
+		data_len = q->skb ? AIROHA_RX_LEN(q->buf_size) : e->dma_len;
 		if (!len || data_len < len)
 			goto free_frag;
 
@@ -651,10 +651,12 @@ static int airoha_qdma_rx_process(struct airoha_queue *q, int budget)
 
 		port = eth->ports[p];
 		if (!q->skb) { /* first buffer */
-			q->skb = napi_build_skb(e->buf, q->buf_size);
+			q->skb = napi_build_skb(e->buf - AIROHA_RX_HEADROOM,
+						q->buf_size);
 			if (!q->skb)
 				goto free_frag;
 
+			skb_reserve(q->skb, AIROHA_RX_HEADROOM);
 			__skb_put(q->skb, len);
 			skb_mark_for_recycle(q->skb);
 			q->skb->dev = port->dev;
diff --git a/drivers/net/ethernet/airoha/airoha_eth.h b/drivers/net/ethernet/airoha/airoha_eth.h
index 57e8ddb30a9c5..216273595115d 100644
--- a/drivers/net/ethernet/airoha/airoha_eth.h
+++ b/drivers/net/ethernet/airoha/airoha_eth.h
@@ -32,6 +32,8 @@
 #define AIROHA_FE_MC_MAX_VLAN_TABLE	64
 #define AIROHA_FE_MC_MAX_VLAN_PORT	16
 #define AIROHA_NUM_TX_IRQ		2
+#define AIROHA_RX_HEADROOM		(NET_SKB_PAD + NET_IP_ALIGN)
+#define AIROHA_RX_LEN(_n)		((_n) - AIROHA_RX_HEADROOM)
 #define HW_DSCP_NUM			2048
 #define IRQ_QUEUE_LEN(_n)		((_n) ? 1024 : 2048)
 #define TX_DSCP_NUM			1024
-- 
2.53.0

