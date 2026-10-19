Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C85336301E7;
	Mon, 19 Oct 2026 14:05:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418729; cv=none; b=IlxDLVlPJqNZPnop2lQKQMSjj8s8FkfzdQgB6nuTfFzAeg6mnBCiAZML8ci6QPXaYLR+bf57PNJZc1LyIdCR1h/x7pN/JMaER59RvwG2YpjY5bfnBiB21zEvWiOhFkejAXnYCpfBWYfFNSc5oF/czafRHOJyHZCRpNYNfWASdTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418729; c=relaxed/simple;
	bh=1jnWH4VwF8YerAsB7d5GBxnznGwbwqpbjy5I7grac7w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=O7ZH3yXCkBdFTyEg7qkzvhgsfS484i0mTMeNxEVF10+BYF4N6YWj2NwPSTsdBtxge++YGijocT2jyGdmGanPL2+f9wWE1x7cJdaFlkc5evzHaFwiBGeB8FBoey1o9z/y1z15ACX+SXsIMFBA3/gfxmVpSio/fxNNWCkCCOV9ZVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M8P32T69; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M8P32T69"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD34E1F000CA;
	Mon, 19 Oct 2026 14:05:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418725;
	bh=20E9De6BR+S8VMH4NJX+3knCPN5YgOZQEqpYqKvUVww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M8P32T69oDdZsTGtioWELWnFL5tDcoALk2OUF07xosR+exBuTjGmm7L3x8lIauq7U
	 ySx1kfwhXABsosgtOphwHJ6gVYoKGfn2dsAi1MCyn0yTkjimnKk3nzkqQx0Dft3xkC
	 8Q74HkUEEnRVa5/YocAzuVcxt0goSHkyZHzDTK73IgKcZ9VvbImxmhhe+o+dRkc9kG
	 Y9xQe5QlqUsDqwKeiD1AFqLOOz4XpKhEPC1XzCUNY8XBSZU/ZySg4Ksc00M0vjY+ac
	 L9I241RUXElfOQgYGTO4wvEag7BHKlTM3Dc3oLKJjJ6L71Euhz5gN7a6qEUdxcp2Zu
	 NvhPLZFtWRt1w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Hans Verkuil <hverkuil+cisco@kernel.org>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	hverkuil@kernel.org,
	mchehab@kernel.org,
	linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] media: cec/core: drop cec_post_state_event call
Date: Mon, 19 Oct 2026 09:52:23 -0400
Message-ID: <20261019135441.1420968-452-sashal@kernel.org>
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

From: Hans Verkuil <hverkuil+cisco@kernel.org>

[ Upstream commit 2ff4b91e82bd76e1a6e1ff22bfc9aeda08e12a61 ]

No need to call cec_post_state_event() if the next call
is to cec_adap_unconfigure() since that will also call
cec_post_state_event().

This fixes the case when, when the physical address is
invalidated, you get two CEC_EVENT_STATE_CHANGE events:
one with a non-zero log_addr_mask and one with a zero
log_addr_mask.

You just want to see the event with phys_addr set to
f.f.f.f and log_addr_mask set to 0.

Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The local tree is **v7.3-rc4** (mainline 7.3). The extra
`cec_post_state_event()` lives in `__cec_s_phys_addr()` and is a real
UAPI-visible duplicate-event bug on HDMI unplug, not a cleanup-only
change.

## Phase 1: Commit message forensics

**Step 1.1: Subject line**
Record: **[media/cec/core] [drop] [remove redundant
`cec_post_state_event()` before `cec_adap_unconfigure()`]**

**Step 1.2: Tags**
Record:
- Signed-off-by: Hans Verkuil \<hverkuil+cisco@kernel.org\> (CEC
  maintainer / author)
- Signed-off-by: Mauro Carvalho Chehab \<mchehab+huawei@kernel.org\>
  (media maintainer)
- No Fixes:, Reported-by, Tested-by, Reviewed-by, Acked-by, Link:, or
  Cc: stable (absence of Fixes:/Cc: stable is expected for this review)

**Step 1.3: Body**
Record:
- **Bug:** When the CEC physical address is invalidated, userspace gets
  two `CEC_EVENT_STATE_CHANGE` events: one with a non-zero
  `log_addr_mask`, then one with zero.
- **Symptom:** Extra/inconsistent state-change event. Desired event is
  `phys_addr = f.f.f.f` and `log_addr_mask = 0`.
- **Root cause:** `__cec_s_phys_addr()` posts a state event, then
  immediately calls `cec_adap_unconfigure()`, which posts another after
  clearing `log_addr_mask`.
- **Version info:** none in the message. The double-post has been in
  `__cec_s_phys_addr()` since the original CEC adapter (2016).

**Step 1.4: Hidden bug fix?**
Record: **Not hidden.** The first sentence sounds like cleanup, but the
body describes a real userspace-visible duplicate event. Confirmed by
the UAPI docs: `log_addr_mask` must be 0 if `phys_addr` is
`CEC_PHYS_ADDR_INVALID`. The first event violates that.

## Phase 2: Diff analysis

**Step 2.1: Inventory**
Record:
- File: `drivers/media/cec/core/cec-adap.c` (−1 line)
- Function: `__cec_s_phys_addr()`
- Scope: single-file, one-line surgical deletion

**Step 2.2: Code flow**
Record:
- **Before:** On PA change/invalidation (`becomes_invalid ||
  !is_invalid`): set `adap->phys_addr = CEC_PHYS_ADDR_INVALID`, **post
  STATE_CHANGE** (mask still old/non-zero), then
  `cec_adap_unconfigure()` which zeros `log_addr_mask` and posts again.
- **After:** Same path, but only `cec_adap_unconfigure()` posts.
  Userspace sees one event with invalid PA and mask 0.
- Path: HDMI unplug / HPD low / `CEC_ADAP_S_PHYS_ADDR` with
  `CEC_PHYS_ADDR_INVALID` / notifier invalidation. Not an error path.

**Step 2.3: Bug mechanism**
Record: **Logic / userspace-event correctness.** Redundant notification
posted before logical addresses were cleared. First event contradicts
the documented invariant. `cec_adap_unconfigure()` already posts the
correct event (verified at line 1426).

**Step 2.4: Fix quality**
Record: Obviously correct. `cec_adap_unconfigure()` still posts after
clearing the mask. No API/data-structure change. Regression risk is very
low: anyone depending on the intermediate non-zero mask with invalid PA
would be depending on a documented-impossible state.

## Phase 3: Git history

**Step 3.1: Blame**
Record: The extra `cec_post_state_event()` before
`cec_adap_unconfigure()` is from **9881fe0ca187c2** (“[media] cec: add
HDMI CEC framework (adapter)”, 2016-06-28). Present since CEC was
introduced.

**Step 3.2: Fixes: tag**
Record: None. The double-post is original 2016 code. It became much more
visible after **67d9598720159** (“handle core events like normal
events”, 2026-07-17), which raised the STATE_CHANGE queue from 1 to 3 so
the first event is no longer overwritten.

**Step 3.3: Related file history**
Record: Same-day series (Hans Verkuil, 2026-07-10, merged 2026-07-17):
1. `e6dcc43e5174d` max_retries → max_attempts (rename)
2. `0c138a5d5045f` drop ABORTED/TIMEOUT check
3. `67d9598720159` handle core events like normal events (**makes
   duplicate visible**)
4. `2ff4b91e82bd7` **this commit**
5. `350308a05f7dd` flush stale STATE_CHANGE events (related,
   independent)
6–8. new UAPI flag, pin toggle, debugfs (features)

This patch is 4/8. It is self-contained: it only deletes a call that has
existed since 2016.

**Step 3.4: Author**
Record: Hans Verkuil is the CEC subsystem maintainer and original author
of this function. High confidence in the diagnosis.

**Step 3.5: Prerequisites**
Record: Applies standalone (one-line delete). **67d9598720159 is in this
tree** (`git merge-base --is-ancestor` succeeded), so the duplicate is
actually delivered here. Follow-up `350308a05f7dd` is not required for
this fix.

## Phase 4: Mailing list / external research

**Step 4.1: Original discussion**
Record:
- `b4 dig -c 2ff4b91e82bd7` → https://patch.msgid.link/cc357768324be21b0
  133799326e8230face817ad.1783681656.git.hverkuil+cisco@kernel.org
- Cover: `[PATCH 0/8] media: cec/core: fixes and improvements`
- `b4 dig -a`: **v1 only**, no later revisions
- Thread (mbox) contains only Hans’s 8 patches. **No replies, no NAKs,
  no reviewer Cc: stable.**
- Cover letter: mixed “fixes and improvements”; this patch’s body is a
  concrete event bug, not a feature.

**Step 4.2: Recipients**
Record: `b4 dig -w`: Hans Verkuil + linux-media@vger.kernel.org. Merged
by Mauro Chehab. No external reviewer tags.

**Step 4.3: Bug report**
Record: No Reported-by / Link / bugzilla / syzbot. Author-found while
changing event queuing.

**Step 4.4: Series**
Record: 8-patch series. Patches 6–8 add a UAPI flag and debugfs (not
needed here). Patch 3 is in this tree and is why two STATE_CHANGE events
are queued. Patch 5 flushes older queued events on invalid PA;
complementary, not a prerequisite.

**Step 4.5: Stable list**
Record: lore.kernel.org returned HTTP 403 via WebFetch/curl.
**UNVERIFIED** whether this was discussed on stable@. No Cc: stable in
the commit or mbox.

## Phase 5: Code semantic analysis

**Step 5.1: Functions**
Record: `__cec_s_phys_addr()` (modified). Helpers involved:
`cec_post_state_event()`, `cec_adap_unconfigure()`, `cec_s_phys_addr()`.

**Step 5.2: Callers**
Record:
- `cec_s_phys_addr()` — exported; HDMI drivers/notifiers (DRM HDMI
  helper, DP CEC, Pulse8, Extron, adv76xx, tc358743, sun4i, omap,
  ch7322, vivid, …)
- `__cec_s_phys_addr()` also from `cec-api.c` (`CEC_ADAP_S_PHYS_ADDR`)
  and `cec-core.c` (unregister)
- `cec-notifier.c` on HDMI HPD/EDID PA updates

Reachable from ioctl and from HDMI hotplug.

**Step 5.3: Callees**
Record: Sets `adap->phys_addr`, `cec_adap_unconfigure()` (clears mask,
flush, **posts event**), `cec_adap_enable()`, `cec_claim_log_addrs()`.
Called with `adap->lock` held.

**Step 5.4: Call chain / reachability**
Record: Userspace-reachable. Common trigger: HDMI unplug →
notifier/driver sets PA invalid → `__cec_s_phys_addr()`. Also
`CEC_ADAP_S_PHYS_ADDR`. `cec_dqevent()` takes only `fh->lock`, not
`adap->lock`, so a waiter can dequeue the first (bad) event before
unconfigure posts the second.

**Step 5.5: Similar patterns**
Record: Other `cec_post_state_event()` sites (unconfigure, config-
complete, `cec_s_conn_info`) post once after state is consistent. Only
this site posted before clearing the mask. Follow-up `350308a05f7dd`
flushes stale STATE_CHANGE events when PA becomes invalid.

## Phase 6: This tree

**Step 6.1: Does the buggy code exist?**
Record: **Yes.** Tree is **v7.3-rc4** (`7.3.0-rc4`).
`__cec_s_phys_addr()` and the extra post exist in this lineage since
2016. Parent **67d9598720159 is an ancestor of HEAD**, so the
STATE_CHANGE queue depth is 3 and both events are delivered. Bug
introduced in 2016; user-visible duplicate made systematic in 7.3.

**Step 6.2: Backport difficulty**
Record: Clean apply. Surrounding function matches the pre-image. One-
line deletion, no conflicts expected.

**Step 6.3: Related fixes already here**
Record: `350308a05f7dd` (flush stale events) is already in this tree as
the next series patch. It does not replace this deletion; it handles
previously queued events. No alternate fix for the double-post.

## Phase 7: Subsystem context

**Step 7.1:**
Record: **media/CEC core**. Criticality: **IMPORTANT** for HDMI-CEC
users (TVs, Android TV, STBs, desktops with HDMI CEC). Not mm/fs/net
core, but the CEC device node is the userspace ABI for that class of
hardware.

**Step 7.2:**
Record: Active. Multiple CEC core commits in 7.3 from the maintainer.
This file is mature (2016) with ongoing event/config fixes.

## Phase 8: Impact and risk

**Step 8.1: Who is affected**
Record: Driver/config-specific: `CONFIG_CEC_CORE` and a CEC adapter (DRM
HDMI, USB CEC dongles, SoC CEC). Userspace that dequeues
`CEC_EVENT_STATE_CHANGE` (libcec, v4l-utils, Android CEC HAL).

**Step 8.2: Trigger**
Record: HDMI unplug / HPD low / invalidating the physical address.
Common for CEC users. Unprivileged userspace with a CEC fd can also set
PA via ioctl if `CEC_CAP_PHYS_ADDR` is set. Timing: the two posts are
consecutive in one lock section, but `cec_dqevent()` does not take
`adap->lock`, so a blocked waiter can observe the first event.

**Step 8.3: Failure mode**
Record: Userspace sees a STATE_CHANGE with `phys_addr = f.f.f.f` and
**non-zero** `log_addr_mask`, which the UAPI docs forbid, then a second
correct event. Can confuse adapters as still configured after
disconnect. **Severity: MEDIUM** (incorrect userspace event / UAPI
invariant break; not a kernel oops, leak, or corruption).

**Step 8.4: Risk-benefit**
Record:
- **Benefit:** Medium. Stops a documented-impossible event on a common
  HDMI path in this 7.3 tree, where queue depth is 3.
- **Risk:** Very low. One-line delete; unconfigure still posts the
  correct event.
- **Ratio:** Favorable.

## Phase 9: Synthesis

**Step 9.1: Evidence**

FOR:
- Real userspace bug: two STATE_CHANGE events, first with invalid PA and
  non-zero mask
- Violates documented UAPI (`log_addr_mask` must be 0 if PA is invalid)
- HDMI unplug / PA invalidation is a common path
- This tree has 67d9598720159, so both events are queued (not coalesced)
- 1-line deletion, obviously correct
- `cec_adap_unconfigure()` already posts the right event
- Author is the CEC maintainer; media maintainer merged it
- Applies cleanly here; no new API

AGAINST:
- Not a kernel crash, UAF, deadlock, or security issue
- No Reported-by / syzbot / user bug report
- Patch 4/8 in a mixed “fixes and improvements” series
- No mailing-list review comments beyond submission
- Severity is MEDIUM (wrong event), not CRITICAL

UNRESOLVED:
- lore.kernel.org HTTP 403; stable@ discussion not independently
  confirmed (no Cc: stable in the mbox)

**Step 9.2: Stable rules checklist**
1. Obviously correct and tested? **PASS** — one redundant call removed;
   unconfigure still notifies. Maintainer-authored, merged to media
   tree.
2. Real bug affecting users? **PASS** — duplicate/inconsistent CEC event
   on PA invalidation; userspace that trusts the UAPI invariant can mis-
   handle HDMI disconnect.
3. Important issue? **PASS** (medium) — not oops/corruption, but a
   userspace ABI invariant break on a common hotplug path. In this tree
   it is systematic because STATE_CHANGE is no longer a single-slot core
   event.
4. Small and contained? **PASS** — −1 line, one function.
5. No new features/APIs? **PASS**
6. Can apply to this tree? **PASS** — code and prerequisite
   67d9598720159 are present; hunk matches.

**Step 9.3: Exception category**
Record: None (not a device ID, quirk, DT, build, or docs fix). Qualifies
as a normal small bugfix.

**Step 9.4: Decision**
This tree is 7.3-rc4. The buggy double-post is in this lineage, and
67d9598720159 is here, so userspace actually receives the illegal first
event. The fix is a one-line deletion with essentially no regression
risk. That is appropriate to carry on this tree.

## What the commit solves for this tree

`__cec_s_phys_addr()` used to notify userspace **before** logical
addresses were cleared, then `cec_adap_unconfigure()` notified again.
After 67d9598720159 (in this tree), both events are queued. On HDMI
unplug, apps can see `phys_addr = f.f.f.f` with a non-zero
`log_addr_mask`, which the CEC UAPI says cannot happen. Dropping the
first post leaves a single correct event.

## Risk vs benefit

Benefit is correct CEC state on disconnect for every CEC userspace
client in 7.3. Risk is a one-line delete of a notification that is
immediately superseded. No locking, allocation, or ABI change.

## Concerns

- Importance is medium, not a kernel crash. Still a real ABI bug on a
  common path, with a trivial fix.
- Series patches 6–8 are unrelated features and must not be pulled with
  this.
- Patch 5 (flush stale events) is complementary, not required for this
  deletion to be correct.

## Verification
- [Phase 1] Parsed tags: author Hans Verkuil, SOB Mauro Chehab; no
  Fixes:/Reported-by/Cc: stable
- [Phase 1] UAPI docs in `cec-ioc-dqevent.rst`: `log_addr_mask` is 0 if
  `phys_addr` is `CEC_PHYS_ADDR_INVALID`
- [Phase 2] Diff: −1 line in `__cec_s_phys_addr()`;
  `cec_adap_unconfigure()` still calls `cec_post_state_event()` at line
  1426
- [Phase 3] `git describe HEAD` / Makefile: v7.3-rc4, VERSION=7
  PATCHLEVEL=3 SUBLEVEL=0 EXTRAVERSION=-rc4
- [Phase 3] `git blame` on pre-fix file: extra call from 9881fe0ca187c2
  (2016 CEC adapter)
- [Phase 3] `git show 9881fe0ca187c2`: original `__cec_s_phys_addr`
  already had post-then-unconfigure
- [Phase 3] `git merge-base --is-ancestor 2ff4b91e82bd7 HEAD` and
  `67d9598720159 HEAD`: both ancestors
- [Phase 3] `git show 67d9598720159`: STATE_CHANGE `max_events` 1→3;
  core-event overwrite removed
- [Phase 3] Series around the commit: 8 patches; this is 4/8; 5/8 is
  flush-stale, independent
- [Phase 4] `b4 dig -c 2ff4b91e82bd7`: lore URL found; v1 only; linux-
  media only; no replies in mbox
- [Phase 4] Cover letter: “fixes and improvements”; this patch body is
  the duplicate-event fix
- [Phase 4] lore.kernel.org WebFetch/curl: 403 — stable@ discussion
  UNVERIFIED
- [Phase 5] Callers: `cec_s_phys_addr`, ioctl, notifier, HDMI
  DRM/USB/platform drivers
- [Phase 5] `cec_dqevent()` uses only `fh->lock`; can dequeue between
  the two posts
- [Phase 6] Current `__cec_s_phys_addr` in this checkout already lacks
  the extra call (fix present in 7.3-rc4 lineage); pre-image still
  matches for a clean apply
- [Phase 8] Failure mode: inconsistent CEC_EVENT_STATE_CHANGE, severity
  MEDIUM, trigger HDMI PA invalidation

**YES**

 drivers/media/cec/core/cec-adap.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/cec/core/cec-adap.c b/drivers/media/cec/core/cec-adap.c
index 84eaf9780db25..4d2262530c94a 100644
--- a/drivers/media/cec/core/cec-adap.c
+++ b/drivers/media/cec/core/cec-adap.c
@@ -1708,7 +1708,6 @@ void __cec_s_phys_addr(struct cec_adapter *adap, u16 phys_addr, bool block)
 		cec_phys_addr_exp(phys_addr));
 	if (becomes_invalid || !is_invalid) {
 		adap->phys_addr = CEC_PHYS_ADDR_INVALID;
-		cec_post_state_event(adap);
 		cec_adap_unconfigure(adap);
 		if (becomes_invalid) {
 			cec_adap_enable(adap);
-- 
2.53.0

