Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D86C1576285;
	Mon, 31 Aug 2026 13:49:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184145; cv=none; b=AZIR490NIzMNhxHc96FTR4/zqWnxFom3MxNcu7G4q0R8/wlSorFTocBxGyeC1eNvFqTVOovOsjt3V+yl4aQJBeKWRcl5t/A99Vo0H34QIofQS6Wx6sqItArudhnoVHYZUK0lwwMS3c4438znhPoYx33NwwhVsHmTyMrbONVj9OM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184145; c=relaxed/simple;
	bh=aE/dGKOE+/+JRZEPvSI4cLNBtQQ7v8uQ63nME7Bxi8o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rLN250IUrB/s78jGh/Cqw6SqtmIuivZi0qXRM0vo075GEO4/JsdnAGWGYoVYdV5nyZPofk8hoEuajw4JIDncu6mwXQLmftVPetcAMlCAQXGy0aqFMSYuZ2B5C6QruwDH9bXc6lvYezi1j5XFRvrd0sm+hBA/at0X8b7gWH/sKZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CMCkQUMR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CMCkQUMR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BDB81F00A3D;
	Mon, 31 Aug 2026 13:49:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184142;
	bh=TBQmycXGCNT51pvFUjCMPoRPUlZDmd6s3LxsIAnRwww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CMCkQUMRnOy6gqScHCTkaXG8UewFXTqfCTNc0aSqoFaBinNJkGvyFiJ9xiKyIp/1u
	 rhHBrqwtrEtBf+yrvUCsu72kM/G4pIJSEcPPPk92o1w7LMwLJt7nW3D0FPMSY/Swkr
	 GJ46XT3fF1werSI4fGIHst/y4iBTEdEMb5DP2/RbafiQkdUA4WE2LsKrs6XpXyS+nL
	 tSj15lsThfn2qFuCDULqv4/UOaXtf/lhmSAx9R0ieR28gJaAHhDbTnDsamKs9ntU+6
	 3htbO4sXzAoGLj/YWkdT36O2zZ3YPw3zU1bQZORvnuEabqvILbJDDVJglVWM8d8kFl
	 0jIcV6LRXhBQg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	mchehab@kernel.org,
	linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] media: em28xx-video: fix missing res_free() on init_usb_xfer failure
Date: Mon, 31 Aug 2026 09:29:05 -0400
Message-ID: <20260831133314.4125787-517-sashal@kernel.org>
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

From: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>

[ Upstream commit cc20e81da6d99926f94fad7af21f75c07e865769 ]

res_get() is called before em28xx_init_usb_xfer(), but the error
path of em28xx_init_usb_xfer() does not release the resource,
leading to a persistent busy state.

Signed-off-by: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

### Step 1.1: Subject line
**Record:** `[media: em28xx-video]` `[fix]` — missing `res_free()` on
`em28xx_init_usb_xfer()` failure in `em28xx_start_analog_streaming()`.

### Step 1.2: Commit message tags
**Record:**
- **Fixes:** — not present (expected for manual review)
- **Reported-by:** — none
- **Tested-by:** — none
- **Reviewed-by:** — none in message (Hans Verkuil appears only as
  Signed-off-by)
- **Link:** — none
- **Cc: stable:** — none
- **Signed-off-by:** Haoxiang Li (author), Hans Verkuil (V4L2/media
  maintainer)

No syzbot, no multi-reporter signals. Hans Verkuil's sign-off is a
quality indicator.

### Step 1.3: Commit body analysis
**Record:**
- **Bug:** `res_get()` is called before `em28xx_init_usb_xfer()`, but
  the error return path does not call `res_free()`.
- **Symptom:** Persistent busy state — `dev->resources` stays set for
  VIDEO or VBI.
- **Root cause (author):** Missing cleanup on the
  `em28xx_init_usb_xfer()` failure path.
- **Version info:** None in the message. Patch was submitted April 2026
  and merged for v7.2 media pull.

### Step 1.4: Hidden bug fix detection
**Record:** Not disguised — explicitly labeled a fix. This is an error-
path resource-leak fix (missing `res_free()`), a well-known stable
backport category.

---

## Phase 2: Diff Analysis

### Step 2.1: Change inventory
**Record:**
- **File:** `drivers/media/usb/em28xx/em28xx-video.c` (+3 / -1 lines)
- **Function:** `em28xx_start_analog_streaming()`
- **Scope:** Single-file, surgical fix in one error path

### Step 2.2: Code flow change
**Record:**
- **Before:** On `em28xx_init_usb_xfer()` failure → `return rc` with
  resource still held.
- **After:** On failure → `res_free(dev, vq->type)` then `return rc`.
- **Path affected:** First streaming user (`streaming_users == 0`), USB
  xfer initialization error path only.

### Step 2.3: Bug mechanism
**Record:** **Category:** Error-path resource leak / reference-style
lock not released.

Mechanism verified in tree:
1. Line 1085: `res_get(dev, vq->type)` sets `dev->resources` bit.
2. Lines 1102–1107: `em28xx_init_usb_xfer()` may fail (URB alloc,
   `usb_clear_halt`, `usb_submit_urb`).
3. Lines 1108–1109 (current tree): early `return rc` without
   `res_free()`.
4. `streaming_users++` at line 1132 is never reached on this path.
5. videobuf2 does **not** call `stop_streaming` when `start_streaming`
   fails (`start_streaming_called` cleared at line 1794 of
   `videobuf2-core.c` without invoking `stop_streaming`).

### Step 2.4: Fix quality
**Record:** Obviously correct — mirrors `res_free()` already called
unconditionally in `em28xx_stop_streaming()` (line 1146) and
`em28xx_stop_vbi_streaming()` (line 1181). Minimal, no API changes.
Regression risk: very low.

---

## Phase 3: Git History Investigation

### Step 3.1: Blame
**Record:** Buggy lines (1085–1109) blame to `5d324e5159d9e` (Merge tag
'usb-6.18-rc8', Nov 2025). `res_get`/`res_free` helpers and the
`res_get()` before `em28xx_init_usb_xfer()` pattern are part of the
driver as present in this 6.18.y tree. Shallow history here (file added
in that merge); the resource-lock pattern is longstanding em28xx design,
not a recent regression.

### Step 3.2: Fixes: tag
**Record:** N/A — no `Fixes:` tag.

### Step 3.3: Related file history
**Record:** Recent commits on `drivers/media/usb/em28xx/` in this tree:
- `871b8ea8ef39a` — em28xx UAF fix in `em28xx_v4l2_open()` (already
  backported to 6.18.y)
- `5d324e5159d9e` — merge bringing em28xx driver into this tree

Standalone fix; not part of a multi-patch series.

### Step 3.4: Author context
**Record:** Haoxiang Li — contributor (also has other stable-nominated
resource-leak fixes in wider kernel). Hans Verkuil signed off —
V4L2/media subsystem maintainer.

### Step 3.5: Dependencies
**Record:** None. Patch applies cleanly (`git apply --check` exit 0). No
prerequisite commits required.

---

## Phase 4: Mailing List and External Research

### Step 4.1: Original patch discussion
**Record:** Found at
https://www.spinics.net/lists/kernel/msg6153558.html (Apr 14, 2026).
Single-patch submission to Mauro Chehab. Follow-up from Markus Elfring
listed but content not retrieved (fetch timeout). No NAK visible in
available thread content. `b4 dig -c` could not run — commit hash not in
this checkout.

### Step 4.2: Reviewers
**Record:** CC'd: `linux-media@`, `linux-kernel@`, Mauro Chehab. Hans
Verkuil sign-off indicates maintainer acceptance.

### Step 4.3: Bug report
**Record:** No external bug report, syzbot, or user Reported-by. Bug
identified by code-path analysis.

### Step 4.4: Related patches
**Record:** Included in v7.2 media pull (lists.openwall.net).
Standalone; no series dependencies.

### Step 4.5: Stable list history
**Record:** No stable-specific discussion found. Patch does not include
`Cc: stable@vger.kernel.org`.

---

## Phase 5: Code Semantic Analysis

### Step 5.1: Key functions
**Record:** `em28xx_start_analog_streaming()`, `res_get()`,
`res_free()`, `em28xx_init_usb_xfer()`.

### Step 5.2: Callers
**Record:** `em28xx_start_analog_streaming` is the vb2
`.start_streaming` callback for:
- Video capture queue (`em28xx_video_qops`, line 1230)
- VBI capture queue (`em28xx-vbi.c`, line 85)

Triggered via VIDIOC_STREAMON → vb2 → driver start path. Common
userspace capture path.

### Step 5.3: Callees
**Record:** `res_get()` → checks/sets `dev->resources`;
`em28xx_init_usb_xfer()` → URB alloc/submit, USB I/O; `res_free()` →
clears resource bit.

### Step 5.4: Reachability
**Record:** Reachable from userspace via V4L2 streaming ioctl on em28xx
devices (`CONFIG_VIDEO_EM28XX`). Unprivileged users with device access
can trigger streaming start. Failure conditions (USB errors, ENOMEM,
bandwidth) are realistic though not every-boot common.

### Step 5.5: Similar patterns
**Record:** Normal success path relies on `em28xx_stop_streaming()` /
`em28xx_stop_vbi_streaming()` for `res_free()`. The missing cleanup is
unique to the early-error path before `streaming_users++` — consistent
with vb2 semantics (no `stop_streaming` on failed `start_streaming`).

---

## Phase 6: Cross-Reference Against Local Tree

### Step 6.1: Buggy code in this tree?
**Record:** **YES.** Tree is `v6.18.43` (`stable/linux-6.18.y`, `make
kernelversion` = 6.18.43). Current code at lines 1108–1109 lacks
`res_free()` on error. Fix is **not** yet applied.

### Step 6.2: Backport complications
**Record:** **Clean apply** — verified with `git apply --check`. No
conflicts expected.

### Step 6.3: Related fixes already present?
**Record:** Related em28xx fix `871b8ea8ef39a` (UAF in open) is present;
this `res_free` fix is **not** present.

---

## Phase 7: Subsystem Context

### Step 7.1: Subsystem criticality
**Record:** `drivers/media/usb/em28xx` — **PERIPHERAL** driver (USB
analog TV/capture dongles). Important for users of that hardware, not
universal.

### Step 7.2: Subsystem activity
**Record:** Low churn in this 6.18.y tree (3 commits on em28xx path).
Driver is mature; recent activity includes stable-worthy bug fixes.

---

## Phase 8: Impact and Risk Assessment

### Step 8.1: Who is affected
**Record:** Users of Empia EM28xx USB capture devices with
`CONFIG_VIDEO_EM28XX` enabled.

### Step 8.2: Trigger conditions
**Record:** VIDIOC_STREAMON when `em28xx_init_usb_xfer()` fails (URB
allocation, USB halt clear, URB submit). Realistic on USB errors or
resource pressure. Userspace-triggerable by device node holders.

### Step 8.3: Failure mode severity
**Record:** Resource bit stuck → subsequent streaming attempts get
`-EBUSY` from `res_get()` (line 861). Device remains unusable for that
buffer type until unplug/reprobe. **Severity: MEDIUM** — functional
breakage, not kernel crash, data corruption, or security issue.

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** Restores recoverability after transient USB init
  failures; prevents permanent device busy state.
- **Risk:** Very low — 3-line symmetric cleanup on documented error
  path.
- **Ratio:** Favorable for stable; conservative fix aligned with vb2
  driver contract.

---

## Phase 9: Final Synthesis

### Step 9.1: Evidence summary

**FOR backport:**
- Real, verifiable resource leak on error path
- User-visible persistent `-EBUSY` until device reset
- vb2 contract requires driver self-cleanup on failed `start_streaming`
  — fix does exactly that
- Minimal (3 lines), applies cleanly to 6.18.43
- Signed off by media maintainer Hans Verkuil
- Buggy code confirmed present in this tree

**AGAINST backport:**
- No crash, security issue, or data corruption
- Driver-specific; limited user base
- No fuzzer/user reports documenting field impact
- Failure path may be uncommon

**Unresolved:** Exact mainline commit SHA not in this checkout; Markus
Elfring review reply not read; no explicit stable nomination on list.

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — logic mirrors existing
   `stop_streaming` cleanup; maintainer sign-off
2. Fixes real bug affecting users? **PASS** — persistent busy state on
   em28xx hardware
3. Important issue? **PASS** — MEDIUM severity functional breakage
   requiring device reset
4. Small and contained? **PASS** — 3 lines, one function
5. No new features/APIs? **PASS**
6. Can apply to local tree? **PASS** — clean apply verified

### Step 9.3: Exception categories
**Record:** None (not device ID, quirk, DT, build, or docs). Standard
error-path bug fix.

### Step 9.4: Decision rationale

For **linux-6.18.y (v6.18.43)**, this commit should be backported. The
buggy pattern exists in the checked-out tree, the fix is minimal and
obviously correct, and it addresses a real driver bug where a failed
stream start leaves the device permanently busy because videobuf2 does
not invoke `stop_streaming` on `start_streaming` failure. While impact
is limited to em28xx users and severity is functional rather than
catastrophic, stable trees routinely accept such error-path resource
leaks that brick device operation until physical reset.

---

## Verification

- **[Phase 1]** `git describe HEAD` → `v6.18.43-1-gc7f0dac02d232`; `make
  kernelversion` → `6.18.43`
- **[Phase 1]** Parsed commit message from user query and spinics mirror
- **[Phase 2]** Read `em28xx_start_analog_streaming()` lines 1069–1135;
  confirmed missing `res_free` on error
- **[Phase 2]** Read `res_get()`/`res_free()` at lines 854–876
- **[Phase 2]** Read `em28xx_init_usb_xfer()` failure paths in `em28xx-
  core.c` lines 1021–1052
- **[Phase 3]** `git blame -L 1085,1110` → all lines from
  `5d324e5159d9e`
- **[Phase 3]** `git log --oneline -20 -- drivers/media/usb/em28xx/` → 3
  commits including UAF fix
- **[Phase 4]** WebFetch spinics msg6153558 — patch content and
  submission date confirmed
- **[Phase 4]** Web search — patch in v7.2 media pull; `b4 dig -c`
  failed (commit not in tree)
- **[Phase 5]** Grep callers — video and VBI queues use
  `em28xx_start_analog_streaming`
- **[Phase 5]** Read `vb2_start_streaming()` lines 1775–1828 — no
  `stop_streaming` on failure
- **[Phase 5]** Read `__vb2_queue_cancel()` lines 2210–2211 —
  `stop_streaming` only if `start_streaming_called`
- **[Phase 6]** Confirmed buggy lines 1108–1109 in working tree
- **[Phase 6]** `git apply --check` with patch → exit 0 (clean apply)
- **[Phase 6]** `git diff HEAD -- em28xx-video.c` — fix not already
  applied
- **[Phase 8]** Verified `res_get()` returns `-EBUSY` when resource held
  (line 861)
- **UNVERIFIED:** Markus Elfring review reply content; exact mainline
  commit SHA; how long `res_get` before `init_usb_xfer` has existed in
  mainline pre-6.18

**YES**The background `git log -S "res_get(dev, vq->type)" --all` search
was stopped — `--all` scans too many branches and had been running for
90+ seconds. The same question was already answered with a targeted
search: in this 6.18.43 tree, that pattern dates to `5d324e5159d9e`, and
the buggy error path is still present at lines 1108–1109.

**Verdict unchanged: YES** — backport the missing `res_free()` on
`em28xx_init_usb_xfer()` failure; it’s a small, clean fix for a real
resource leak that leaves em28xx devices stuck busy until unplug.

 drivers/media/usb/em28xx/em28xx-video.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index 14c35995cd952..c8514682bccda 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -1105,8 +1105,10 @@ int em28xx_start_analog_streaming(struct vb2_queue *vq, unsigned int count)
 					  dev->max_pkt_size,
 					  dev->packet_multiplier,
 					  em28xx_urb_data_copy);
-		if (rc < 0)
+		if (rc < 0) {
+			res_free(dev, vq->type);
 			return rc;
+		}
 
 		/*
 		 * djh: it's not clear whether this code is still needed.  I'm
-- 
2.53.0

