Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5EE33C198D;
	Wed, 20 May 2026 11:19:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779275998; cv=none; b=lJVno780vGzb8DdcMVrYn1mZXe1et7oOwM9fHLrfx/KOupP/UpXTr5aYGiXT5Hg1Bkv+EK5iOrAmiW+unvN4OMU1DFGSxst7f8YqYZVyr5AmGGgkC9LB5pz+EHJ9TZCwt9+i88L6RnfLL9NnmqsoZK/t/fDUit1kibrSJPH7ak8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779275998; c=relaxed/simple;
	bh=IX/Repa1aySqfY4fx8TzeX6rhq3yO0kNzFJX8DguvF8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cOo4cl0daVx+gOYFLaNMByJ0ubUHu8h7JHTamef/06vKOKd73YR+1u64QM6JeL0y+LctrdmubJUdlBfywxHN/bup912y9ICd4P2embgK5PPzIr0da0woC0X8+DmA/NGWYxJLKjZlUqRYaniVSlbLffmqimrDECBRxr67XlGpVn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T1CKjdrB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T1CKjdrB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBF3F1F00893;
	Wed, 20 May 2026 11:19:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779275992;
	bh=nPgcOEOH3FWn/QWW6rJHvWeVUMHCsPNHcUfOAvcXkmc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T1CKjdrBfEctzDWIN2DCA1s5d78Nh3QouL68n7qOw8aZUPgHbikOF9elmBcnSB/vF
	 viJL6P2Pup4Jymbh39qaQtaNjHYk5UMUA6QqiKGn4HWSyrtvWpRbGHjZM8cCzlyCnq
	 dpyL3/ehJc8dGkErkZu+3k+cU1UhvVALnf2J5NXjMlEHOHv+OYJdFjfiuMDr3xXhI1
	 1HE9gZdxrRW2FVN9YLk9R/j0bIBdtA74cqx5PR0lW2evN3fXoPVRHKmnoeIuXte+ZN
	 TlGYS8WAigzDP5q9v5HQOWvk2ty7oY7fxaGKYaN3abGH761JqHGoARBmMmLkGhRIrF
	 fzG86/xAsXCBQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Christian Van <cvan20191@gmail.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>,
	jagan@amarulasolutions.com,
	maarten.lankhorst@linux.intel.com,
	mripard@kernel.org,
	tzimmermann@suse.de,
	airlied@gmail.com,
	simona@ffwll.ch,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-5.10] drm/panel: feiyang-fy07024di26a30d: return display-on error
Date: Wed, 20 May 2026 07:18:37 -0400
Message-ID: <20260520111944.3424570-5-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260520111944.3424570-1-sashal@kernel.org>
References: <20260520111944.3424570-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0.9
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Christian Van <cvan20191@gmail.com>

[ Upstream commit c67e8787f6743101c90c7a9c4bb7cf6f1f739f83 ]

mipi_dsi_dcs_set_display_on() returns an error code, but feiyang_enable()
currently ignores it and always reports success.

Return the DCS command result so callers can observe enable failures.

Signed-off-by: Christian Van <cvan20191@gmail.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patch.msgid.link/20260425053948.117714-1-cvan20191@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics
Step 1.1 Record: subsystem `drm/panel`, action verb `return`, summary:
`feiyang-fy07024di26a30d` should propagate the MIPI DSI display-on
command error instead of reporting success.

Step 1.2 Record: tags verified:
- `Signed-off-by: Christian Van <cvan20191@gmail.com>`
- `Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>`
- `Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>`
- `Link:
  https://patch.msgid.link/20260425053948.117714-1-cvan20191@gmail.com`
No `Fixes:`, `Reported-by:`, `Tested-by:`, `Cc: stable`, syzbot, or
sanitizer tags were present.

Step 1.3 Record: the body says `mipi_dsi_dcs_set_display_on()` returns
an error but `feiyang_enable()` ignores it and always returns success.
Verified in `drivers/gpu/drm/panel/panel-feiyang-fy07024di26a30d.c`.
Symptom: DRM panel core cannot observe a failed display-on command and
may continue the enable sequence as if the panel enabled successfully.
No user report, stack trace, or affected-version statement was found.

Step 1.4 Record: yes, this is a hidden bug fix: it fixes ignored error
handling in a panel enable path. It is not cleanup or refactoring.

## Phase 2: Diff Analysis
Step 2.1 Record: one file changed, `drivers/gpu/drm/panel/panel-feiyang-
fy07024di26a30d.c`; 1 insertion, 3 deletions. Modified function:
`feiyang_enable()`. Scope: single-file surgical driver fix.

Step 2.2 Record: before, `feiyang_enable()` called
`mipi_dsi_dcs_set_display_on(ctx->dsi)` and always returned `0`. After,
it returns the DCS command result directly. Affected path: normal panel
enable path, after the 200 ms enable delay.

Step 2.3 Record: bug category is logic/error-propagation correctness.
The broken mechanism was an ignored negative return from
`mipi_dsi_dcs_set_display_on()`. Verified that
`mipi_dsi_dcs_set_display_on()` returns `0` on success or a negative
error code on failure.

Step 2.4 Record: fix quality is high: minimal, obviously correct, no new
API, no locking, no data structure change. Regression risk is very low;
the only behavior change is that a real display-on failure prevents
`drm_panel_enable()` from marking the panel enabled and enabling
backlight/followers.

## Phase 3: Git History Investigation
Step 3.1 Record: `git blame` shows the ignored return was introduced
with the original driver commit
`69dc678abc2b9d36ff005413ca6e9edabe4c369a` (`drm/panel: Add Feiyang
FY07024DI26A30-D MIPI-DSI LCD panel`), first contained in `v5.2-rc1`.

Step 3.2 Record: no `Fixes:` tag was present, so there was no tag to
follow. I inspected the original driver commit anyway; it added the
driver and already ignored this display-on return.

Step 3.3 Record: recent file history shows mostly unrelated panel API
conversions and cleanup. The candidate patch is standalone and only
needs the existing `feiyang_enable()` and
`mipi_dsi_dcs_set_display_on()` code.

Step 3.4 Record: no other `Christian Van` commits under
`drivers/gpu/drm/panel` were found in checked `master` or `graphics-
next`. Neil Armstrong is listed as DRM panel maintainer in `MAINTAINERS`
and reviewed/applied the patch.

Step 3.5 Record: no dependencies found. The patch applies directly to
`v5.10`, `v5.15`, `v6.1`, `v6.6`, `v6.12`, `v6.19`, and `v7.0`; `v5.4`
contains the buggy code but needs a trivial context backport.

## Phase 4: Mailing List And External Research
Step 4.1 Record: `b4 dig -c c67e8787f6743101c90c7a9c4bb7cf6f1f739f83`
found the original submission at
`https://patch.msgid.link/20260425053948.117714-1-cvan20191@gmail.com`.
`b4 dig -a` found only v1, so the committed version is the only revision
found.

Step 4.2 Record: `b4 dig -w` showed the original recipients included
Christian Van, Jagan Teki, Neil Armstrong, Jessica Zhang, Maarten
Lankhorst, Maxime Ripard, Thomas Zimmermann, David Airlie, Simona
Vetter, `dri-devel`, and `linux-kernel`. Neil Armstrong reviewed it and
later applied it to `drm-misc-fixes`.

Step 4.3 Record: no `Reported-by` or bug-report link exists. WebFetch
for lore URLs was blocked by Anubis, but `b4 mbox` fetched the thread
successfully. The thread contained Neil’s `Reviewed-by` reply and an
applied notice.

Step 4.4 Record: no multi-patch series found; this is a standalone
1-patch series.

Step 4.5 Record: WebFetch searches of `lore.kernel.org/stable` were
blocked by Anubis. Local pending/stable candidate branches searched did
not show this patch already present.

## Phase 5: Code Semantic Analysis
Step 5.1 Record: modified function: `feiyang_enable()`.

Step 5.2 Record: `feiyang_enable()` is installed as `.enable` in
`feiyang_funcs`. `drm_panel_enable()` calls
`panel->funcs->enable(panel)` and checks negative returns. Multiple DRM
bridge/host drivers call `drm_panel_enable()`.

Step 5.3 Record: key callees are `msleep(200)` and
`mipi_dsi_dcs_set_display_on(ctx->dsi)`. The latter calls
`mipi_dsi_dcs_write()` and returns a negative error on write failure.

Step 5.4 Record: reachable through DRM panel enable paths during display
modeset/enable for systems using this panel. This is driver/hardware-
specific, not universal. No in-tree DTS user of
`feiyang,fy07024di26a30d` was found beyond the binding example and
driver match table.

Step 5.5 Record: many other panel drivers already check and return or
handle `mipi_dsi_dcs_set_display_on()` errors, confirming this driver
was an outlier.

## Phase 6: Cross-Referencing And Stable Tree Analysis
Step 6.1 Record: buggy code exists in `v5.4`, `v5.10`, `v5.15`, `v6.1`,
`v6.6`, `v6.12`, `v6.19`, and `v7.0`. The driver was introduced for
`v5.2-rc1`, so all active stable trees at or after that point likely
contain it.

Step 6.2 Record: expected backport difficulty is clean for `v5.10+`
based on apply checks. `v5.4` failed direct apply due to context drift
but contains the same ignored call and should need only a trivial one-
function backport.

Step 6.3 Record: no related stable-side fix for this same issue was
found in the checked stable/pending branches.

## Phase 7: Subsystem And Maintainer Context
Step 7.1 Record: subsystem is DRM panel driver, criticality
`PERIPHERAL`/driver-specific. It affects users of Feiyang
FY07024DI26A30-D MIPI-DSI panels.

Step 7.2 Record: DRM panel is maintained and active. The file has had
several API-conversion commits since introduction, but this fix is not
dependent on those conversions for `v5.10+`.

## Phase 8: Impact And Risk Assessment
Step 8.1 Record: affected population is driver-specific/config-specific:
kernels with `CONFIG_DRM_PANEL_FEIYANG_FY07024DI26A30D` and hardware
described with `feiyang,fy07024di26a30d`.

Step 8.2 Record: trigger is a failure of the DSI `SET_DISPLAY_ON`
command during panel enable. I did not verify a specific real-world
reporter, so frequency is unverified. It is not shown to be
unprivileged-user-triggerable.

Step 8.3 Record: failure mode is user-visible display enable
misreporting: before the patch, the panel core could treat the panel as
enabled despite the failed display-on command. Severity: `MEDIUM` for
affected hardware, because it can leave display/backlight state wrong,
but no crash, memory corruption, deadlock, or security issue was
verified.

Step 8.4 Record: benefit is moderate for affected hardware; risk is very
low because the patch only returns an existing error code from a
function that already has an `int` return type.

## Phase 9: Final Synthesis
Step 9.1 Record:
Evidence for backporting: real ignored-error bug; affects display enable
correctness; original buggy code dates to `v5.2-rc1`; one-line surgical
fix; maintainer reviewed/applied to `drm-misc-fixes`; clean apply to
`v5.10+`; no new API or feature.
Evidence against backporting: no user report, crash, security issue,
data corruption, syzbot report, or `Fixes:` tag; affected population is
limited to one panel driver; `v5.4` needs a trivial manual backport.
Unresolved: actual field frequency of DSI display-on failures was not
verified.

Step 9.2 Record:
1. Obviously correct and tested? Correct by inspection; reviewed by DRM
   panel maintainer. No explicit `Tested-by`.
2. Fixes a real bug? Yes, ignored negative return from a hardware
   command.
3. Important issue? Moderate: display enable state correctness for
   affected hardware, not a critical kernel-wide failure.
4. Small and contained? Yes, one function, one file, 1 insertion/3
   deletions.
5. No new features/APIs? Yes.
6. Can apply to stable? Yes for `v5.10+`; trivial backport needed for
   `v5.4`.

Step 9.3 Record: no automatic exception category applies; this is not a
device ID, quirk, DT, build, or documentation patch.

Step 9.4 Record: I recommend backporting. Although the impact is driver-
specific and not a crash-class bug, the fix is a genuine hardware enable
error propagation fix, very small, maintainer-reviewed, and low risk.
Stable users with this panel should not have the panel core mark the
panel enabled after the display-on command failed.

## Verification
- Phase 1: Parsed commit `c67e8787f6743101c90c7a9c4bb7cf6f1f739f83` with
  `git show`; confirmed subject, body, trailers, and diff.
- Phase 2: Read `panel-feiyang-fy07024di26a30d.c`; confirmed old
  `feiyang_enable()` ignored `mipi_dsi_dcs_set_display_on()` and
  returned `0`.
- Phase 2: Read `drm_mipi_dsi.c`; confirmed
  `mipi_dsi_dcs_set_display_on()` returns a negative error on failure.
- Phase 3: Ran `git blame -L 94,104`; confirmed buggy lines came from
  `69dc678abc2b9d`.
- Phase 3: Ran `git describe --contains 69dc678abc2b9d`; confirmed first
  containing version `v5.2-rc1`.
- Phase 3: Inspected original commit `69dc678abc2b9d`; confirmed the
  ignored return existed from driver introduction.
- Phase 4: Ran `b4 dig -c`, `b4 dig -a`, and `b4 dig -w`; confirmed one
  v1 patch, original lore URL, and recipient list.
- Phase 4: Ran `b4 mbox`; confirmed Neil Armstrong reviewed and applied
  it to `drm-misc-fixes`.
- Phase 4: WebFetch lore and stable searches were blocked by Anubis;
  this limitation did not drive the final decision.
- Phase 5: Read `drm_panel.c`; confirmed `drm_panel_enable()` checks
  negative `.enable` return and skips enabled/backlight/follower path on
  failure.
- Phase 5: Searched for `feiyang_enable`; confirmed it is used via
  `.enable = feiyang_enable`.
- Phase 5: Searched panel drivers for `mipi_dsi_dcs_set_display_on()`;
  confirmed many peers handle its return.
- Phase 6: Used `git grep` against stable tags; confirmed the ignored
  call exists in `v5.4`, `v5.10`, `v5.15`, `v6.1`, `v6.6`, `v6.19`, and
  `v7.0`.
- Phase 6: Apply-checked the patch in detached worktrees; clean for
  `v5.10`, `v5.15`, `v6.1`, `v6.6`, `v6.12`, `v6.19`, and `v7.0`; failed
  direct apply on `v5.4` due to context only.
- Phase 7: Checked `MAINTAINERS`; confirmed Neil Armstrong maintains DRM
  panel drivers.
- Phase 8: Checked Kconfig and compatible strings; confirmed impact is
  limited to the Feiyang panel driver/config and no in-tree board DTS
  use was found.
- UNVERIFIED: no actual user report or frequency of display-on command
  failures was found.

**YES**

 drivers/gpu/drm/panel/panel-feiyang-fy07024di26a30d.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/panel/panel-feiyang-fy07024di26a30d.c b/drivers/gpu/drm/panel/panel-feiyang-fy07024di26a30d.c
index 4f8d6d8c07e4d..dbdb7e3cb7b62 100644
--- a/drivers/gpu/drm/panel/panel-feiyang-fy07024di26a30d.c
+++ b/drivers/gpu/drm/panel/panel-feiyang-fy07024di26a30d.c
@@ -98,9 +98,7 @@ static int feiyang_enable(struct drm_panel *panel)
 	/* T12 (video & logic signal rise + backlight rise) T12 >= 200ms */
 	msleep(200);
 
-	mipi_dsi_dcs_set_display_on(ctx->dsi);
-
-	return 0;
+	return mipi_dsi_dcs_set_display_on(ctx->dsi);
 }
 
 static int feiyang_disable(struct drm_panel *panel)
-- 
2.53.0

