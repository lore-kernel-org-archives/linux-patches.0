Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CDB7543C3D;
	Mon, 19 Oct 2026 14:06:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418772; cv=none; b=HEa0Io+/zRN6UuW+fOBXvz3d5RJ8oWTr9Op98VX0EmaiSJpeiq15fdBHThAcyk+4KX8iaclH4Tpw4LedwAc7eTblrbAuqKn2MpPKssrPhbY7QUuKR9ADsQ1zh4wRSKJwFpYUEK/M4MkPfLyxEzwLiBrMcEEq7/u3DfxTRp7qulM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418772; c=relaxed/simple;
	bh=EoudlL7YwgDi7sJK8VzGj1yFIiwPZ1prbOJ2prvU8OY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hoIH/s8VzSKQItYuc98HiwchSnHsCLtSFB61JW3tbsyoC4HioqY7vptc90ir+JneSYu1nd/PwKfr5tu9CR1VxmmEOO2SNEIYU12qNZM6k1AQjYAlPnVFG5OKDpMoV3RjDtEJhipbXOHBvU6nH2L8IHdkkky5KYwV788lNOlzCbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TankBjgE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TankBjgE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28EFF1F000CD;
	Mon, 19 Oct 2026 14:06:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418769;
	bh=G9Y99oW6oDHR0wfYeVH1Lh3TE8TZx3h9bjl3n725Kc8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TankBjgE+rvs3Fdy8m+pFKQgCpHVycaQzXHTy6bsLTSAaVqzCLLU/yKbV5eZLOy1W
	 gXZVpSqKmTXIx5a+GmjdOnZRjPTdfHXu+EBkuQRWa/LqSCiKh69C3i6Hv2vlIvsQmA
	 vd4Hxvo+mLHfjngRBJHf9VbLo8knTDbaP3QKLUByXW+WlqT1kq7uwD+SX5Balyargi
	 Mty0IS8RpzEJD8pezKCGmlM+uXKJ6DZQ3u3oHZPnR/6FIxawGYElZ9IKpiO+EEa8//
	 Sp50WJAeYl50rIdjXRVwfWGcZR5R/t/hfX01g7zOT9lbqft7FQqllcHqjnEeeE8zK6
	 1QBRCL7m1MRpQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Hans Verkuil <hverkuil+cisco@kernel.org>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	mchehab@kernel.org,
	linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] media: em28xx: dev_info->pr_info since dev has been freed
Date: Mon, 19 Oct 2026 09:52:53 -0400
Message-ID: <20261019135441.1420968-482-sashal@kernel.org>
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

[ Upstream commit c132b07f7e5853c0df35a9b94b8e204cdc6afdef ]

In em28xx_free_device() dev_info passed &dev->intf->dev,
but that device can be freed already.

Just use pr_info instead.

Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Tested-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

This is a one-line use-after-free fix in a USB disconnect/teardown path.
The local tree is mainline **v7.3-rc4** (`7.3.0-rc4`); the driver and
the delayed-free path are present, and the change is independently
correct.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

**Step 1.1: PARSE THE SUBJECT LINE**
- Subsystem: `media: em28xx`
- Action verb: implicit fix (`dev_info->pr_info since dev has been
  freed`)
- Claimed intent: stop logging through a USB `struct device` that may
  already have been freed.

Record: **[media/em28xx] [replace logging helper] [do not use freed USB
device in em28xx_free_device()]**

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
- No `Fixes:` tag (expected for this review)
- No `Reported-by:` / syzbot
- `Tested-by: Hans Verkuil <hverkuil+cisco@kernel.org>` — author tested
  on real hardware
- No `Reviewed-by:` / `Acked-by:` on the committed message
- No `Link:`
- No `Cc: stable@vger.kernel.org` (expected)
- `Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>` (author;
  V4L2 maintainer)
- `Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>`
  (media maintainer)

Record: **Author+media maintainer SOBs; Tested-by from author; no
Fixes/Cc stable (not a negative).**

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Body: `em28xx_free_device()` passed `&dev->intf->dev` to `dev_info`, but
that USB interface device can already be gone. Replace with `pr_info`
using `dev->name`.

Record:
- Bug: use of `dev->intf->dev` after the USB interface may have been
  freed
- Symptom: kernel UAF / oops while printing “Freeing device”
- Version info: none in the message; history shows the log line since
  v4.10
- Root cause: delayed `kref_put` after USB disconnect tears down `intf`

**Step 1.4: DETECT HIDDEN BUG FIXES**
Not hidden. Cover letter for the series says explicitly: “The fifth
patch fixes a use-after-freed”.

Record: **[Explicit UAF fix, not cleanup]**

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

**Step 2.1: INVENTORY THE CHANGES**
- File: `drivers/media/usb/em28xx/em28xx-cards.c` (1 insertion, 1
  deletion)
- Function: `em28xx_free_device()`
- Scope: single-file surgical fix

Record: **[em28xx-cards.c ±1] [em28xx_free_device] [surgical]**

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Before:
```
dev_info(&dev->intf->dev, "Freeing device\n");
```
After:
```
pr_info("%s: Freeing device\n", dev->name);
```

This runs at the start of the kref release callback, **before**
`kfree(dev)`. `dev->name` is an embedded `unsigned char name[32]` in
`struct em28xx`, still valid. `&dev->intf->dev` is not, if USB core
already dropped the interface.

Record: **[dev_info on possibly-freed usb_interface -> pr_info on still-
live em28xx::name]**

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Category: **memory safety / use-after-free**.

Call path (verified in this tree):
1. `em28xx_usb_disconnect()` sets `dev->disconnected = 1`, calls
   `em28xx_close_extension()`, then `em28xx_release_resources()`
   (`usb_put_dev`), then `kref_put(&dev->ref, em28xx_free_device)`.
2. Extensions hold extra refs. Audio PCM close still does `kref_put`
   (`em28xx-audio.c`); v4l2 defers the last `kref_put` until
   `em28xx_free_v4l2()` after the last userspace close.
3. If a capture/audio handle is still open at unplug, the last
   `kref_put` happens **after** USB `disconnect()` returns. USB core
   then unregisters/frees `usb_interface`. `dev->intf` is dangling.
4. `dev_info(&dev->intf->dev, ...)` dereferences that freed `struct
   device`.

This delayed-free path is not new: even before the 2026 v4l2-release-
callback series, open/close took `kref_get`/`kref_put` on `dev->ref`, so
the last put could already run after unplug.

Record: **[UAF] [printk through freed usb_interface after delayed kref
release]**

**Step 2.4: ASSESS THE FIX QUALITY**
Obviously correct: stop touching `intf` once it may be gone; log via a
field inside `dev` that has not been freed yet. No API change.
Regression risk is negligible (log prefix loses the kernel device name;
`dev->name` is set in probe via `snprintf`).

Record: **[minimal, correct] [regression risk very low]**

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

**Step 3.1: BLAME THE CHANGED LINES**
Buggy `dev_info` line: `29b05e22f5c68c` (“[media] em28xx: use
usb_interface for dev_foo() calls”, Mauro, 2016-12-07). `git describe`
on that commit: `v4.9-rc6-495-g29b05e22f5c68`; `git describe
--contains`: `v4.10-rc1~71^2^2~4`. `em28xx_free_device()` itself is from
`47677e51e2a404` (2014).

Record: **[29b05e22f5c68c, first in v4.10] [long-standing]**

**Step 3.2: FOLLOW THE FIXES: TAG**
No `Fixes:` tag.

Record: **[N/A — no Fixes tag; introducing commit identified via
blame]**

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
This commit is **patch 5/6** of Hans Verkuil’s “media: em28xx: fix
lifecycle issues” series (v2, 2026-06-16), applied next to:
- `288254383674b` use v4l2_device release callback
- `de626073dfcbb` drop `users` field
- `7c8bf63b79371` use `vb2_video_unregister_device` (immediate parent)
- `67f87b104f4ef` requeue buffers if start_streaming fails

Those other patches are lifetime/refactor/WARN_ON work. **This hunk does
not use any of that new machinery**; it only edits a log line that has
existed since 2016.

Record: **[part of a series, but this patch is standalone]**

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Hans Verkuil is the V4L2 maintainer; Mauro is listed as em28xx
maintainer in `MAINTAINERS`. Cover letter: tested on Hans’s em28xx
device.

Record: **[subsystem maintainer-level author; related lifecycle series
exists but is not a hard dep]**

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
The replacement uses existing `pr_info` and `dev->name`. No new helpers.
Applies on the pre-series `em28xx_free_device()` as well.

Record: **[no prerequisites] [can apply standalone]**

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
`b4 dig -c c132b07f7e585` → https://patch.msgid.link/4f25383b64139feb0a6
4a07c20b1776d13301f9c.1781615432.git.hverkuil+cisco@kernel.org

`b4 dig -a`:
- v1: 3-patch series (2026-05-19), this change was not in v1
- v2: `[PATCHv2 0/6] media: em28xx: fix lifecycle issues` (2026-06-16) —
  this is 5/6

Cover letter (from saved mbox): “The fifth patch fixes a use-after-
freed”. No NAK on 5/6. Review discussion in the matched thread was about
1/6 (`v4l2-async`), not this patch.

Record: **[lore/msgid above] [v1 then v2/6] [no NAK on this patch]
[author described it as UAF]**

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
`b4 dig -w`: Hans Verkuil; `linux-media@vger.kernel.org`; Mauricio Faria
de Oliveira; Sakari Ailus. Sakari reviewed 1/6 only. Mauro applied it.

Record: **[media list + Sakari on a different patch; Mauro merged]**

**Step 4.3: SEARCH FOR THE BUG REPORT**
No syzbot/bugzilla for this specific log-line UAF. Author found it while
fixing em28xx lifecycle and tested on hardware.

Record: **[no public crash report; maintainer-found UAF]**

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Series mates are separate bugs (v4l2-async crash, lifetime refactor, vb2
unregister, start_streaming WARN_ON). Not required for this one-liner.

Record: **[standalone among the 6]**

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
lore.kernel.org/stable search was blocked (Anubis bot challenge). No
stable discussion in the saved media thread.

Record: **[UNVERIFIED: no stable@ thread retrieved]**

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

**Step 5.1: IDENTIFY KEY FUNCTIONS**
`em28xx_free_device()` (exported `EXPORT_SYMBOL_GPL`).

**Step 5.2: TRACE CALLERS**
`kref_put(&dev->ref, em28xx_free_device)` from:
- `em28xx_usb_disconnect()` (`em28xx-cards.c`)
- `em28xx_free_v4l2()` (`em28xx-video.c`) — after last v4l2 user
- `em28xx_audio_fini()` and PCM close (`em28xx-audio.c`)
- `em28xx_dvb` fini (`em28xx-dvb.c`)
- `em28xx-input.c` fini

The dangerous caller is a **late** `kref_put` after USB disconnect has
returned.

**Step 5.3: TRACE CALLEES**
`kref_to_dev`, `pr_info`, optional `em28xx_release_resources()` only if
`!dev->disconnected` (that path still has a live interface), `kfree`.

**Step 5.4: FOLLOW THE CALL CHAIN**
Userspace-reachable: unplug an em28xx USB capture stick while v4l2/ALSA
still has it open, then close the app. Common physical-unplug path, not
an obscure config.

Record: **[reachable from USB unplug + close] [yes, from
userspace/device removal]**

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Many other `dev_info(&dev->intf->dev, ...)` calls exist, but they run
while the interface is still bound (probe, streaming, disconnect
itself). The unique one in the post-disconnect free callback was this
“Freeing device” line.

Record: **[only this log site in the free callback]**

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Local tree: `v7.3-rc4-27-gf0100363d8c37`, `VERSION=7 PATCHLEVEL=3
SUBLEVEL=0 EXTRAVERSION=-rc4`.

`git merge-base --is-ancestor c132b07f7e585 HEAD` → yes. Current source
already has `pr_info("%s: Freeing device\n", dev->name);`.

The **bug** existed here before that commit; the **buggy pattern**
(`em28xx_free_device` + `dev->intf` + delayed kref) is still the
lifetime model. For any stable tree that branched with the 2016
`dev_info` line and without this commit, the bug is present.

Record: **[driver present; fix already in this mainline checkout; bug
introduced v4.10]**

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Hunk is one line in a function whose shape has been stable since 2014.
Would apply cleanly to trees still using `dev_info`.

Record: **[clean apply on pre-fix trees / already applied here]**

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
This is the fix. No earlier alternate fix of this log site.

Record: **[no other fix of this UAF]**

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

**Step 7.1: SUBSYSTEM AND CRITICALITY**
`drivers/media/usb/em28xx/` — USB analog/DVB capture (Hauppauge,
Terratec, etc.).

Record: **[media USB driver] [IMPORTANT / driver-specific, not
staging]**

**Step 7.2: SUBSYSTEM ACTIVITY**
Actively maintained (IDs, lifecycle, syzbot list-corruption fixes in the
same files). Mature driver, bug is old.

Record: **[mature, still active]**

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

**Step 8.1: WHO IS AFFECTED**
Users of em28xx USB sticks (`CONFIG_VIDEO_EM28XX`). Not universal, but
real consumer hardware.

**Step 8.2: TRIGGER CONDITIONS**
Unplug (or USB reset) while a v4l2/ALSA/DVB client still holds the
device, then close. Timing-dependent on refcount, but the window is the
entire time the app stays open after unplug — not a one-instruction
race.

Unprivileged users can trigger it by unplugging hardware.

**Step 8.3: FAILURE MODE SEVERITY**
`dev_info()` → `dev_printk()` walks a freed `struct device`. UAF: oops /
KASAN report, possible panic. Not data corruption, but a real crash on a
common unplug path.

Record: **[UAF oops] [HIGH]**

**Step 8.4: RISK-BENEFIT RATIO**
- Benefit: prevent oops on device removal for em28xx users
- Risk: 1-line log change, no locking/API/lifetime change

Record: **[high benefit for those devices] [very low risk] [favorable]**

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

**Step 9.1: COMPILE THE EVIDENCE**

FOR:
- Confirmed UAF: delayed `em28xx_free_device()` after USB interface
  teardown
- Cover letter calls it a use-after-free
- One-line, obviously correct
- Tested by V4L2 maintainer on real em28xx hardware; merged by Mauro
- Bug in code since v4.10; delayed kref existed long before the 2026
  series
- No new API/feature
- Standalone; other series patches not required

AGAINST:
- No `Fixes:` / `Cc: stable` / syzbot (not a reason to reject)
- Driver-specific, not core mm/net
- This mainline checkout already contains the commit (expected for a
  mainline candidate)
- UNVERIFIED: stable@ mailing list history (lore bot-blocked)

**Step 9.2: STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — one-line; Tested-by Hans;
   cover letter explains UAF
2. Fixes a real bug that affects users? **PASS** — UAF on unplug-while-
   open
3. Important issue? **PASS** — UAF oops, HIGH (not theoretical)
4. Small and contained? **PASS** — 1 line, one function
5. No new features or APIs? **PASS**
6. Can apply to the local tree? **PASS** — surrounding
   `em28xx_free_device()` matches; trees that still have `dev_info` get
   a clean apply. This checkout already has the after-state because it
   *is* mainline including the fix.

**Step 9.3: EXCEPTION CATEGORIES**
Not a device-ID/quirk/DT/build/doc exception. It is a normal memory-
safety fix.

**Step 9.4: DECISION**
This should be backported. It is a small, tested UAF fix in a teardown
path users hit when they unplug a capture device. It does not depend on
the rest of the lifecycle series.

What it solves for stable users: kernel oops from
`dev_info(&dev->intf->dev)` after USB core has freed the interface, when
the last em28xx kref is dropped from v4l2/audio close. Risk is
essentially zero.

Verification:
- [Phase 1] Parsed tags: Tested-by Hans Verkuil; SOBs Hans + Mauro; no
  Fixes/Cc stable/Reported-by
- [Phase 1] Cover letter (mbox): “The fifth patch fixes a use-after-
  freed”
- [Phase 2] Diff: 1 line in `em28xx_free_device()`;
  `dev_info(&dev->intf->dev)` → `pr_info("%s: ...", dev->name)`
- [Phase 2] Call path: `em28xx_usb_disconnect` → `kref_put`; extra puts
  from `em28xx_free_v4l2`, audio PCM close (`kref_put` at em28xx-
  audio.c:312)
- [Phase 3] git blame parent: `29b05e22f5c68c` (v4.10) introduced
  `dev_info`; `git merge-base --is-ancestor 29b05e22f5c68c HEAD` true
- [Phase 3] No Fixes tag; standalone vs series confirmed by reading
  `288254383674b` (does not change this log line)
- [Phase 3] `git merge-base --is-ancestor c132b07f7e585 HEAD` true
  (original commit is in this mainline tree)
- [Phase 4] `b4 dig -c c132b07f7e585`: msgid 4f25383b64139feb… ; v2 5/6
  of lifecycle series
- [Phase 4] `b4 dig -a`: v1 (3 patches) then v2 (6 patches); this UAF
  patch added in v2
- [Phase 4] `b4 dig -w`: linux-media, Sakari Ailus, Mauricio Faria de
  Oliveira
- [Phase 4] mbox: no NAK on 5/6; Sakari comments only on 1/6
- [Phase 4] lore WebFetch 403; stable search Anubis-blocked — UNVERIFIED
  stable@ discussion
- [Phase 5] Callers of `em28xx_free_device` enumerated via grep of
  `kref_put`
- [Phase 5] `dev->name` is `unsigned char name[32]` in `struct em28xx`;
  set in probe (`snprintf(dev->name, 28, "em28xx")`)
- [Phase 6] `git describe HEAD` = `v7.3-rc4-27-gf0100363d8c37`; `make
  kernelversion` = `7.3.0-rc4`
- [Phase 6] Current file already has `pr_info` (fix present in this
  checkout)
- [Phase 7] MAINTAINERS: EM28XX VIDEO4LINUX DRIVER, Mauro Chehab
- [Phase 8] Failure mode: UAF in `dev_printk` on freed `usb_interface` →
  oops; trigger = unplug while open
- UNVERIFIED: whether a dedicated stable@ thread exists (lore bot)

**YES**

 drivers/media/usb/em28xx/em28xx-cards.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index b8e207443770e..af2c06a05084d 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -3556,7 +3556,7 @@ void em28xx_free_device(struct kref *ref)
 {
 	struct em28xx *dev = kref_to_dev(ref);
 
-	dev_info(&dev->intf->dev, "Freeing device\n");
+	pr_info("%s: Freeing device\n", dev->name);
 
 	if (!dev->disconnected)
 		em28xx_release_resources(dev);
-- 
2.53.0

