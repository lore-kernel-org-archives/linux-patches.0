Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 200D655A28A;
	Mon, 19 Oct 2026 13:57:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418232; cv=none; b=Ns7Wu7f2LGiV6JAGEpNFzvb4UbYtAD8am8VMys8peds0JnIVXeYYQN05McnBxNu3Aq2KJoP/ERMc8MjAmUXV8RQtvL8MRRCSscI//tw6HQNAPkyjYHqkkC8CRbjXtVbWZrnpO9qFRwL1nGUZE63fi1rRDcxYqaAvsH9XXj2qByk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418232; c=relaxed/simple;
	bh=AZXjxsCPS4rNmUCm7QddDv2NNVQGPMq77xilEpD8Zdc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KUEP8c2IoqJprOAIC7gPQXKJ7oozXoMPDjYmR/0eh9dRweZK1eDtPS9CQkgSLG7WP78ouQDeensNaqdV98Xx/jtkKB4qG8P4IOlOpwvLMNJcCh4KTjehtSUbn69Ifg7dmWZE2AZ3lhdrLodF6xgagFhIYgQEB5nozSJVlP/yu5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IFF4ou3J; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IFF4ou3J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E10BB1F000C4;
	Mon, 19 Oct 2026 13:57:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418229;
	bh=Uq1pZL5AqR1p29pZAp1Vr7oZbLYXhdL3FVLTMJ5eOP0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IFF4ou3JYsRg0lvbOa+7o0/TqQfbaWkQ+RId3k0xVkwQDQgoEfjGc1udkYxqvaOZi
	 HXRe+k/zIlGK4TDQQWnmk2mY08/4U5RLB/2XQiBK1hE+tx7RSEHIN20PjKOn+Mnyh4
	 DpJkHkiybfMLs6FrWn1uZeAnAVpGr1XnxvhDI4uTssMAA2hlcsj50FI04a6HK4pNCt
	 WwfOus6GBUZRumdvCr2113ekPmS8f8RbZyYgxsI5FomNLVrGEG1T2caXIcEy7V0Oxp
	 sDGM/NdcWL/5/8bLAtzKslElEltYP3gEnQtqbq2JW6qeZeP2alI3JupDJ3JVQMqMV5
	 ZeyKnCxJcZSkg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Hans Verkuil <hverkuil+cisco@kernel.org>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	mchehab@kernel.org,
	linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] media: em28xx: use vb2_video_unregister_device
Date: Mon, 19 Oct 2026 09:46:35 -0400
Message-ID: <20261019135441.1420968-104-sashal@kernel.org>
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

[ Upstream commit 7c8bf63b79371f5b57da1bd1401bd420180ac6e6 ]

Use vb2_video_unregister_device instead of video_unregister_device
to ensure any streaming is correctly stopped at unregister time.

Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Tested-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit message forensics

**Step 1.1: Subject line**
Record: `[media: em28xx] [use] switch unregister to
vb2_video_unregister_device so streaming is stopped at unbind`

**Step 1.2: Tags**
Record:
- `Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>` (author;
  V4L2/videobuf2 maintainer)
- `Tested-by: Hans Verkuil <hverkuil+cisco@kernel.org>` (author tested;
  not an independent tester)
- `Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>`
  (media maintainer)
- No `Fixes:`, `Reported-by:`, `Link:`, `Cc: stable`, `Reviewed-by:`, or
  `Acked-by:`
- Absence of `Fixes:` / `Cc: stable` is expected for this review and is
  not treated as a negative

**Step 1.3: Body**
Record:
- Bug: `video_unregister_device()` does not stop an active vb2 queue, so
  streaming can continue after the video node is unregistered.
- Symptom: capture still running across USB unbind / module unload /
  probe rollback.
- Root cause (from message + helper docs): drivers that use
  `_vb2_fop_release()` must use `vb2_video_unregister_device()` so the
  queue is released at unregister time.
- No stack trace, reproducer, or version range in the message.

**Step 1.4: Hidden bug fix?**
Record: Yes. “Use helper X” is a correctness fix, not a feature. The
cover letter for the series is titled “fix lifecycle issues” and says
this patch “ensures all streaming is stopped when the video device is
unregistered.”

## Phase 2: Diff analysis

**Step 2.1: Inventory**
Record:
- File: `drivers/media/usb/em28xx/em28xx-video.c` (+6 / -6)
- Functions: `em28xx_v4l2_fini()`, `em28xx_v4l2_init()` error path
  `unregister_dev`
- Six call sites: radio / VBI / video, in both fini and probe-error
  teardown
- Scope: single-file surgical substitution

**Step 2.2: Code flow**
Record:
- Before: `video_unregister_device()` only removes the node; the vb2
  queue can remain in STREAMING.
- After: `vb2_video_unregister_device()` unregisters, then
  `vb2_queue_release()` (under the queue lock) which runs
  `stop_streaming` and returns buffers.
- Paths: USB disconnect / module unload (`em28xx_v4l2_fini`) and init
  failure (`unregister_dev`).

**Step 2.3: Bug mechanism**
Record: `[logic / lifecycle] [use-after-unbind]`
Verified disconnect order in this tree:

1. `em28xx_usb_disconnect()` sets `disconnected`, then
   `em28xx_close_extension()` → `em28xx_v4l2_fini()`.
2. fini already calls `em28xx_uninit_usb_xfer()`, then unregisters
   nodes.
3. Then `em28xx_release_resources()` unregisters I2C and
   `usb_put_dev()`.
4. Userspace may still hold the fd. Close calls `em28xx_v4l2_close()` →
   `_vb2_fop_release()` → `vb2_queue_release()` →
   `em28xx_stop_streaming()`.
5. `em28xx_stop_streaming()` does `v4l2_device_call_all(..., video,
   s_stream, 0)` and `em28xx_uninit_usb_xfer()`. That runs **after**
   I2C/USB teardown if the queue was not stopped in fini.

Stopping the queue in fini keeps `stop_streaming` on the unbind side of
I2C/USB teardown.

**Step 2.4: Fix quality**
Record:
- For video and VBI this is the documented vb2 pattern
  (`include/media/videobuf2-v4l2.h`: drivers using `_vb2_fop_release()`
  should use this helper). `em28xx_v4l2_close()` does call
  `_vb2_fop_release()`.
- Video/VBI set `vdev->queue` (`vb_vidq` / `vb_vbiq`).
- Radio never sets `vdev->queue`. The helper does
  `WARN_ON(!vdev->queue)` then still calls `video_unregister_device()`.
  Two boards have radio (`EM2820_BOARD_LEADTEK_WINFAST_USBII_DELUXE`,
  `EM2860_BOARD_KAIOMY_TVNPC_U2`).
- Probe error path: `vdev->queue` is assigned **before**
  `em28xx_vb2_setup()` / `vb2_queue_init()`. `unregister_dev` after a
  later `video_register_device()` or media-graph failure can call
  `vb2_queue_release()` on a zeroed queue (`mutex_lock(&q->mmap_lock)`
  in `vb2_core_queue_release()`). That is a real, but rare, teardown
  hazard.
- No API/feature additions. Regression risk is low on the disconnect
  path (queue is initialized); radio WARN_ON and probe-error queue
  release are the main nits.

## Phase 3: Git history

**Step 3.1: Blame**
Record:
- `video_unregister_device()` on these nodes comes from the
  embedded-`video_device` era (`d4352f3639d780`, 2015) and older Mauro
  unregister paths (2008/2013).
- Bug is long-standing, not new in 7.3.

**Step 3.2: Fixes: tag**
Record: None. Helper introduced in `f729ef5796d82` (2020, around v5.10).
`git merge-base --is-ancestor f729ef5796d82 HEAD` succeeds.

**Step 3.3: File history**
Record: Same-day series on this file:
1. `288254383674b` media: em28xx: use v4l2_device release callback
2. `de626073dfcbb` media: em28xx: drop 'users' field
3. `7c8bf63b79371` **this commit**
4. Later: `c132b07f7e585` (use-after-free of `dev->intf` in free),
   `67f87b104f4ef` (requeue on start_streaming failure)

This is standalone at the diff level (only a symbol change). Series
context: patch 1 deferred `v4l2_device_unregister()` until last close,
which makes a late `stop_streaming()` after I2C teardown more likely.
This tree already contains patches 1 and 2.

**Step 3.4: Author**
Record: Hans Verkuil is the V4L2/videobuf2 maintainer. He added the
helper in 2020 and converted au0828/usbtv/cxusb then (`24b5836dbd45b`).
em28xx was not in that conversion.

**Step 3.5: Prerequisites**
Record: Needs `vb2_video_unregister_device()` (present). Needs em28xx
vb2 video/VBI (present). `em28xx.h` already includes `videobuf2-v4l2.h`.
Can apply standalone. This tree already has the helper and the driver.

## Phase 4: Mailing list / external

**Step 4.1: Original discussion**
Record: `b4 dig -c 7c8bf63b79371` → https://patch.msgid.link/ad61b2c30cd
477599312e9d5c12045dcd05c8ecd.1779191683.git.hverkuil+cisco@kernel.org
Saved thread: `/tmp/em28xx-thread.mbox` (cover + 3 patches, **no
replies**).
`b4 dig -a`: **v1 only**. Cover: `[PATCH 0/3] media: em28xx: fix
lifecycle issues`. Quote: “the last patch switches
video_unregister_device to vb2_video_unregister_device: this ensures all
streaming is stopped when the video device is unregistered.” Also: “All
this still needs to be tested on real hardware” at send time; the merged
commit later has `Tested-by: Hans Verkuil`. No NAK, no `Cc: stable` in
review (there was no review mail).

WebFetch of lore returned 403. Thread content was recovered via `b4 dig
-m`.

**Step 4.2: Recipients (`b4 dig -w`)**
Record: Hans Verkuil, `linux-media@vger.kernel.org`, Mauricio Faria de
Oliveira `<mfo@igalia.com>`. No review mail in the mbox. Mauro applied
it.

**Step 4.3: Bug report**
Record: No `Reported-by` / syzbot / bugzilla. No independent user report
found in the thread.

**Step 4.4: Series**
Record: Explicit 3/3 of a lifecycle series. This hunk does not need
patches 1–2 to compile. Those two are already in this tree.

**Step 4.5: Stable list**
Record: UNVERIFIED. lore.kernel.org/stable was blocked (Anubis bot-
check). No stable discussion in the captured media thread.

## Phase 5: Semantic / call graph

**Step 5.1: Functions**
Record: `em28xx_v4l2_fini`, `em28xx_v4l2_init` (`unregister_dev`).
Callee: `vb2_video_unregister_device` → `video_unregister_device` +
`vb2_queue_release` → `em28xx_stop_streaming` /
`em28xx_stop_vbi_streaming`.

**Step 5.2: Callers**
Record:
- `em28xx_v4l2_fini` ← `em28xx_close_extension()` (`em28xx-core.c`) ←
  `em28xx_usb_disconnect()` (unplug) and `em28xx_unregister_extension()`
  (module unload).
- `unregister_dev` ← probe/init failures after a node is registered.

**Step 5.3: Callees**
Record: queue release, `stop_streaming`, `em28xx_uninit_usb_xfer`,
`v4l2_device_call_all(..., s_stream, 0)`.

**Step 5.4: Reachability**
Record: Yes. Unplug or `rmmod` while an analog capture app is streaming
is a normal USB-TV / webcam path. Unprivileged userspace can hold the
device open; unplug is a physical event.

**Step 5.5: Similar patterns**
Record: Same helper is used across USB/PCI/platform V4L2 drivers (uvc,
au0828, usbtv, saa7134, vivid, …). em28xx was a leftover vs the 2020 USB
conversion.

semcode MCP tools: not available; used `git grep` / file reads.

## Phase 6: This tree

**Step 6.1: Local tree and buggy code**
Record:
- `git describe HEAD` → `v7.3-rc4-27-gf0100363d8c37`
- `make kernelversion` / Makefile → **7.3.0-rc4** (mainline, not an LTS
  branch)
- `git merge-base --is-ancestor 7c8bf63b79371 HEAD` → yes (already in
  this checkout)
- Driver, helper, and `_vb2_fop_release()` close path all exist here
- Bug class (unregister without stopping vb2) has been in em28xx since
  ~2015; it was not introduced after this tree

**Step 6.2: Backport difficulty**
Record: Clean apply on this codebase (already applied). Helper and
includes are present. No conflicting refactor of these call sites beyond
the same series.

**Step 6.3: Related fixes already here**
Record: Lifetime callback + drop-`users` are already here. No alternate
fix of these six call sites. Follow-up `67f87b104f4ef` is a different
start_streaming WARN, not a replacement for this change.

## Phase 7: Subsystem

**Step 7.1**
Record: `[drivers/media/usb/em28xx] [IMPORTANT]` — USB analog capture,
not core mm/net, but a long-lived in-tree driver with real hardware
users (`CONFIG_VIDEO_EM28XX` / `VIDEO_EM28XX_V4L2`).

**Step 7.2**
Record: Mature driver; recent work is lifecycle/vb2 correctness from the
V4L2 maintainer, not a new subsystem.

## Phase 8: Impact and risk

**Step 8.1: Who is affected**
Record: Users of em28xx USB capture sticks (Hauppauge, Empia, etc.),
analog video/VBI. Radio-only extra is two board entries.

**Step 8.2: Trigger**
Record: Unplug or unload while `/dev/video*` or VBI is streaming (or
open with a live queue). Common for USB TV/webcam. Unprivileged process
can keep the fd; disconnect is the trigger.

**Step 8.3: Failure mode**
Record: `stop_streaming` after I2C unregister / `usb_put_dev` → use of
torn-down USB/I2C, hung DQBUF, possible UAF. Severity **HIGH**. Not a
guaranteed panic on every unplug (URBs are already killed in fini), but
the decoder `s_stream(0)` and second uninit run too late.

**Step 8.4: Risk/benefit**
Record:
- Benefit: high for em28xx users who unplug while capturing; matches the
  documented vb2 unbind contract.
- Risk: low on the disconnect path (6 substitutions, helper used since
  2020). Medium-low on probe-error (uninitialized queue) and radio
  (`WARN_ON`).
- Ratio: benefit of stopping the queue at unbind outweighs those edge
  nits.

## Phase 9: Synthesis

**Step 9.1: Evidence**

FOR:
- Real unbind/lifecycle bug: vb2 stays STREAMING after node unregister;
  `stop_streaming` can run after I2C/USB teardown.
- Driver already uses `_vb2_fop_release()`; helper is the required API.
- Small (6 lines), no new API, helper present in this tree since 2020.
- V4L2 maintainer authored and tested; media maintainer applied.
- USB unplug while capturing is a realistic user path.
- Same conversion already done for sibling USB drivers.

AGAINST:
- No user crash log / syzbot.
- Patch 3/3 of a lifecycle series (self-contained, but series-scoped).
- Radio `WARN_ON(!queue)` on two boards.
- Probe `unregister_dev` can `vb2_queue_release()` before
  `vb2_queue_init()`.
- Cover letter originally said hardware testing was still pending (later
  `Tested-by` is the author).

UNRESOLVED:
- lore.kernel.org HTTP 403 / stable list Anubis block; no independent
  stable-thread confirmation beyond the mbox (which had no replies).

**Step 9.2: Stable rules**
1. Obviously correct and tested? **PASS** for video/VBI disconnect; nits
   on radio/probe-error do not make the core change wrong. Tested-by
   author.
2. Real bug affecting users? **PASS** — verified disconnect vs close
   ordering.
3. Important (crash/UAF/unbind)? **PASS** — HIGH, use-after-unbind /
   late `s_stream` on torn-down I2C/USB.
4. Small and contained? **PASS** — 6 lines, one file.
5. No new features/APIs? **PASS**.
6. Applies to this tree? **PASS** — helper, includes, and call sites
   exist here.

**Step 9.3: Exception category**
Record: None (not an ID/quirk/DT/build/docs exception). It is a normal
small bugfix.

**Step 9.4: Decision**
This tree is 7.3-rc4 and already contains the helper and em28xx vb2
video. The change is a small, maintainer-tested fix for a real USB-
unbind lifecycle hole: without it, analog streaming is not stopped when
the node is unregistered, so `stop_streaming` can run after I2C/USB
teardown. That is in scope for this codebase and meets the stable bar.
Radio WARN_ON and a rare probe-error queue release are residual nits,
not reasons to keep the disconnect bug.

### What the commit solves for this tree
On em28xx analog capture, `em28xx_v4l2_fini()` (USB disconnect / module
unload) unregisters video/VBI with `video_unregister_device()` while the
vb2 queue can still be STREAMING. Close later stops the queue via
`_vb2_fop_release()`, but by then `em28xx_release_resources()` has
already dropped I2C and the USB device. Switching to
`vb2_video_unregister_device()` stops streaming during fini, while those
objects are still valid.

### Risk vs benefit
Benefit is a real unbind UAF/use-after-teardown hole on a commonly
unplugged USB capture driver. Risk is six call-site substitutions
through a helper that has been in this tree for years. Residual radio
WARN_ON and probe-error queue release are limited.

### Verification
- [Phase 1] Tags: author SOB + Tested-by Hans Verkuil, Mauro SOB; no
  Fixes/Reported-by/Link/Cc:stable
- [Phase 2] Diff: 6 `video_unregister_device` →
  `vb2_video_unregister_device` in `em28xx_v4l2_fini` and
  `unregister_dev`
- [Phase 2] Helper: `vb2_video_unregister_device()` unregisters then
  `vb2_queue_release()`; `WARN_ON(!vdev->queue)` confirmed
- [Phase 2] `radio_dev` never assigns `.queue`; video/VBI do (`em28xx-
  video.c` init)
- [Phase 2] `em28xx_v4l2_close()` calls `_vb2_fop_release(filp, NULL)`
- [Phase 2] `em28xx_stop_streaming()` calls `s_stream(0)` and
  `em28xx_uninit_usb_xfer()`
- [Phase 3] `git describe HEAD` = v7.3-rc4-27-gf0100363d8c37;
  kernelversion 7.3.0-rc4
- [Phase 3] Commit `7c8bf63b79371` is ancestor of HEAD; helper
  `f729ef5796d82` is ancestor
- [Phase 3] Series: `288254383674b`, `de626073dfcbb`, this commit; 2020
  USB conversion `24b5836dbd45b` skipped em28xx
- [Phase 4] `b4 dig -c 7c8bf63b79371`: lore msgid
  ad61b2c30cd477599312e9d5c12045dcd05c8ecd…; v1-only 3-patch “fix
  lifecycle issues”
- [Phase 4] mbox: cover + 3 patches, zero replies; `b4 dig -w`: linux-
  media + Mauricio Faria de Oliveira
- [Phase 4] WebFetch lore 403; stable lore Anubis-blocked — UNVERIFIED
  beyond mbox
- [Phase 5] fini callers: `em28xx_close_extension` ←
  `em28xx_usb_disconnect` / `em28xx_unregister_extension`
- [Phase 6] `em28xx.h` includes `videobuf2-v4l2.h`; radio boards Leadtek
  Winfast USB II Deluxe, Kaiomy TVnPC U2
- [Phase 8] Disconnect then `em28xx_release_resources()` does
  `em28xx_i2c_unregister` + `usb_put_dev` before last close
- UNVERIFIED: independent hardware test besides author’s Tested-by; any
  stable@ thread

**YES**

 drivers/media/usb/em28xx/em28xx-video.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index e0a69309687b0..e2907b56220b7 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -2243,17 +2243,17 @@ static int em28xx_v4l2_fini(struct em28xx *dev)
 	if (video_is_registered(&v4l2->radio_dev)) {
 		dev_info(&dev->intf->dev, "V4L2 device %s deregistered\n",
 			 video_device_node_name(&v4l2->radio_dev));
-		video_unregister_device(&v4l2->radio_dev);
+		vb2_video_unregister_device(&v4l2->radio_dev);
 	}
 	if (video_is_registered(&v4l2->vbi_dev)) {
 		dev_info(&dev->intf->dev, "V4L2 device %s deregistered\n",
 			 video_device_node_name(&v4l2->vbi_dev));
-		video_unregister_device(&v4l2->vbi_dev);
+		vb2_video_unregister_device(&v4l2->vbi_dev);
 	}
 	if (video_is_registered(&v4l2->vdev)) {
 		dev_info(&dev->intf->dev, "V4L2 device %s deregistered\n",
 			 video_device_node_name(&v4l2->vdev));
-		video_unregister_device(&v4l2->vdev);
+		vb2_video_unregister_device(&v4l2->vdev);
 	}
 
 	v4l2_ctrl_handler_free(&v4l2->ctrl_handler);
@@ -2901,19 +2901,19 @@ static int em28xx_v4l2_init(struct em28xx *dev)
 		dev_info(&dev->intf->dev,
 			 "V4L2 device %s deregistered\n",
 			 video_device_node_name(&v4l2->radio_dev));
-		video_unregister_device(&v4l2->radio_dev);
+		vb2_video_unregister_device(&v4l2->radio_dev);
 	}
 	if (video_is_registered(&v4l2->vbi_dev)) {
 		dev_info(&dev->intf->dev,
 			 "V4L2 device %s deregistered\n",
 			 video_device_node_name(&v4l2->vbi_dev));
-		video_unregister_device(&v4l2->vbi_dev);
+		vb2_video_unregister_device(&v4l2->vbi_dev);
 	}
 	if (video_is_registered(&v4l2->vdev)) {
 		dev_info(&dev->intf->dev,
 			 "V4L2 device %s deregistered\n",
 			 video_device_node_name(&v4l2->vdev));
-		video_unregister_device(&v4l2->vdev);
+		vb2_video_unregister_device(&v4l2->vdev);
 	}
 
 	v4l2_ctrl_handler_free(&v4l2->ctrl_handler);
-- 
2.53.0

