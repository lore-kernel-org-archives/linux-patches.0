Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5036330215A;
	Tue,  5 May 2026 09:52:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777974720; cv=none; b=ZQxVK/8Dof/GEJwPix/93CEA6O9+EGCILASBc+KOGFeOK2uErYyHgY0rNly2Zr579Y6r4qmRncbI6jgAKPjhZJMrTWTwRRSYXLvttykELkO+mTPPhRNEjD4dYALy76mJZixNugTKm7OPkQNmhdUrZRkYvQeGPU4WIpawGxpH4YM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777974720; c=relaxed/simple;
	bh=0qV4cOztwSvvWGGKaqSmfSyQWpKz4dYQwUC37FZ5STg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WY66AY+jjwiGZ9B8l89rdCppDdlHjY1R7E1hNY010Q/iIgkD4h65WzlvMmrDVvBuiQfmtNCYgbf+y+D79Jy1LQRYkSzIRe8kKf/fQFeD5efi4mrPlEsbcr+QCIG+enLT8rLAmFCRKDgpPR7W9dfc1hEcJE2LQ3qy3XG9pSOp1Dw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CiQl8tax; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CiQl8tax"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0517BC2BCB4;
	Tue,  5 May 2026 09:51:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777974720;
	bh=0qV4cOztwSvvWGGKaqSmfSyQWpKz4dYQwUC37FZ5STg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CiQl8taxKU0fmnrf3fQ9S1MwRNL2Fvty49yYhxu/HTr1jUZT7JulOnsQmuN55QBKU
	 Miv97ef42Vm5cnjcrrDlJGk1hExO3jObYqHhCiUnU9lzbi3ByaFto8DS19+UnggCFt
	 s/5uO6cbMhs9dopu9heMaKcF+5VtK2gidI+HvAss6qWXLOi3xNmczvJtZs5/V6jB36
	 ShB18KtplzwNd0IW/7DxfZhI5OMcZ2jenLX6Ov+gWDk3F4hyz0Eac0vrs4ztod1Jwu
	 BSM+pvrqA7JoZ0ICc/MqJvCcTuTtYzyfu7RXmM/9I5+iYjHsYdj7wkWz5JByXmZZWa
	 xIUhj1Fv2FhBQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Lijo Lazar <lijo.lazar@amd.com>,
	Asad Kamal <asad.kamal@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	kenneth.feng@amd.com,
	christian.koenig@amd.com,
	airlied@gmail.com,
	simona@ffwll.ch,
	amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0] drm/amd/pm: Update emit clock logic
Date: Tue,  5 May 2026 05:51:19 -0400
Message-ID: <20260505095149.512052-3-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260505095149.512052-1-sashal@kernel.org>
References: <20260505095149.512052-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0.3
Content-Transfer-Encoding: 8bit

From: Lijo Lazar <lijo.lazar@amd.com>

[ Upstream commit d6b99885b122528651d554a7bd907211a81579c2 ]

If only one level is enabled in clock table, there is no need to
follow the fine grained clock logic which expects a minimum of
two levels (min/max).

Signed-off-by: Lijo Lazar <lijo.lazar@amd.com>
Reviewed-by: Asad Kamal <asad.kamal@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 7f19097af1496dd908a044ca95862f32d05f02df)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics
Step 1.1 Record: subsystem `drm/amd/pm`; action verb `Update`; claimed
intent is to change AMD SMU clock-level sysfs emission when a DPM clock
table has only one enabled level.

Step 1.2 Record: tags present are `Signed-off-by: Lijo Lazar
<lijo.lazar@amd.com>`, `Reviewed-by: Asad Kamal <asad.kamal@amd.com>`,
`Signed-off-by: Alex Deucher <alexander.deucher@amd.com>`, and a cherry-
pick marker for `7f19097af149...`. No `Fixes:`, `Reported-by:`, `Tested-
by:`, `Link:`, or `Cc: stable@vger.kernel.org` tag was present in the
supplied commit message.

Step 1.3 Record: the body says fine-grained clock logic expects two
levels, min and max, so it should not be used when the table has only
one level. Symptom is incorrect sysfs clock-level emission for that one-
level case; no crash, stack trace, affected version, or reproducer is
described.

Step 1.4 Record: this is a hidden logic/correctness bug fix, not a
cleanup. The bug is that a one-level table can be treated as fine-
grained min/max output.

## Phase 2: Diff Analysis
Step 2.1 Record: one file changed,
`drivers/gpu/drm/amd/pm/swsmu/smu_cmn.c`; one-line condition change in
`smu_cmn_print_dpm_clk_levels()`. Scope is a single-file surgical driver
fix.

Step 2.2 Record: before, any table marked `SMU_DPM_TABLE_FINE_GRAINED`
used the fine-grained path, which forces `count = 2` and emits min/max-
style output. After, `count == 1` tables use the discrete-table path and
emit exactly the real table entries.

Step 2.3 Record: bug category is logic/correctness in user-visible sysfs
output. The specific broken mechanism is the fine-grained display path
assuming two levels even when `dpm_table->count` is one.

Step 2.4 Record: fix quality is high: it preserves all existing behavior
except the verified `is_fine_grained && count == 1` case. Regression
risk is very low because non-fine-grained tables and fine-grained tables
with more than one level are unchanged.

## Phase 3: Git History Investigation
Step 3.1 Record: `git blame` shows `smu_cmn_print_dpm_clk_levels()` and
the original `if (!is_fine_grained)` condition came from
`a08ea4bc7711f8` (`drm/amd/pm: Add a helper to show dpm table`). Later
fine-grained formatting changes came from `d81e52fc61fb9` (`drm/amd/pm:
fix issue of missing '*' on pp_dpm_xxx nodes`). `a08ea4bc7711f8` is
contained in `v7.0`, `v7.0.1`, `v7.0.2`, and `v7.0.3`, but not `v6.19`.

Step 3.2 Record: no `Fixes:` tag is present, so there was no Fixes
target to follow. Related history identifies `a08ea4bc7711f8` as the
likely introducing commit.

Step 3.3 Record: recent file history shows a series of AMD PM
helper/refactor commits, including `a08ea4bc7711f8` and `d81e52fc61fb9`.
The target patch is standalone on top of code present in `v7.0.y`.

Step 3.4 Record: Lijo Lazar authored the helper introduction and has
multiple recent commits under `drivers/gpu/drm/amd/pm`, so the author is
an active AMD PM contributor.

Step 3.5 Record: dependency is the helper itself. The affected function
is absent in `v6.19`, so older stable trees do not need this patch. For
`v7.0.y`, the context exists and the backport should be trivial.

## Phase 4: Mailing List And External Research
Step 4.1 Record: `b4 dig -c 7f19097af149...`, `-a`, and `-w` all failed
because the local repository does not contain that commit object.
`WebFetch` to lore and git.kernel.org was blocked by Anubis. Web
searches by exact subject/hash/body did not find the original target
patch.

Step 4.2 Record: b4 recipient data could not be obtained. The only
verified review signal is the commit-message `Reviewed-by: Asad Kamal`.

Step 4.3 Record: no bug-report link or reporter tag exists. No syzbot,
Bugzilla, or user-report evidence was found.

Step 4.4 Record: related external context found the earlier AMD PM
`Remove print_clock_levels` series and a `Use one level table if dpm not
enabled` patch, but not this exact patch. These support the broader area
of clock table/sysfs work but are not direct evidence for this commit.

Step 4.5 Record: stable-list search via lore was blocked; web search
found no stable-specific discussion.

## Phase 5: Code Semantic Analysis
Step 5.1 Record: modified function is `smu_cmn_print_dpm_clk_levels()`.

Step 5.2 Record: callers found in AMD SMU ppt files include
`smu_v14_0_2_ppt.c`, `smu_v13_0_7_ppt.c`, `smu_v13_0_6_ppt.c`,
`smu_v13_0_0_ppt.c`, `aldebaran_ppt.c`, `sienna_cichlid_ppt.c`,
`navi10_ppt.c`, and `arcturus_ppt.c`.

Step 5.3 Record: key callees/macros are `sysfs_emit_at()`,
`smu_cmn_freqs_match()`, `SMU_DPM_TABLE_MIN()`, and
`SMU_DPM_TABLE_MAX()`.

Step 5.4 Record: verified call chain is sysfs read path
`amdgpu_get_pp_dpm_clock()` / `amdgpu_get_pp_od_clk_voltage()` ->
`amdgpu_dpm_emit_clock_levels()` -> `smu_emit_ppclk_levels()` -> ASIC-
specific `emit_clk_levels()` -> `smu_cmn_print_dpm_clk_levels()`. The
buggy path is reachable through AMDGPU PM sysfs clock-level reads.

Step 5.5 Record: similar one-level DPM table setup exists in multiple
AMD SMU ppt files, and fine-grained flags are set in several SMU
generations. This verifies that `count == 1` and fine-grained clock-
table handling are both real local patterns.

## Phase 6: Stable Tree Analysis
Step 6.1 Record: `git grep` confirmed `smu_cmn_print_dpm_clk_levels()`
is absent from `v6.19` and present in `v7.0`. Tags containing the helper
include `v7.0` through `v7.0.3`.

Step 6.2 Record: expected backport difficulty to `v7.0.y` is clean or
near-clean: the patch changes one existing condition in code verified
present in `v7.0`.

Step 6.3 Record: local `git log --grep` searches did not find this exact
target commit in current, `stable/linux-7.0.y`, `master`, or `graphics-
next`. Related fix `d81e52fc61fb9` is already in `v7.0`.

## Phase 7: Subsystem Context
Step 7.1 Record: subsystem is DRM AMDGPU power management. Criticality
is driver-specific but important for affected AMD GPU users because it
affects exported PM sysfs clock-level state.

Step 7.2 Record: `drivers/gpu/drm/amd/pm/swsmu` is actively developed;
recent history shows many AMD PM and SMU changes.

## Phase 8: Impact And Risk
Step 8.1 Record: affected users are AMDGPU users on SMU generations
using `smu_cmn_print_dpm_clk_levels()` with a fine-grained DPM table
whose count is one.

Step 8.2 Record: trigger is reading relevant AMDGPU PM sysfs files such
as `pp_dpm_*` / OD clock output. Whether unprivileged users can read
every affected node was not verified.

Step 8.3 Record: verified failure mode is incorrect sysfs clock-level
reporting: the old code can emit min/max-style two-level output for a
one-level table. I verified the paired write path parses numeric levels
and some fine-grained force-clock paths clamp to level 0/1 without
checking `count`, but I did not verify a concrete hardware failure from
writing the falsely advertised level.

Step 8.4 Record: benefit is moderate for affected AMD GPU users because
it fixes misleading PM sysfs state. Risk is very low because the patch
is one conditional change and leaves all other cases unchanged.

## Phase 9: Final Synthesis
Evidence for backporting: real user-visible logic bug, one-line fix,
reviewed by an AMD PM developer, authored by the contributor who
introduced the helper, code exists in `v7.0.y`, and regression risk is
very low.

Evidence against backporting: no verified crash, security issue, data
corruption, deadlock, reporter, reproducer, `Fixes:` tag, `Cc: stable`,
or accessible lore discussion. It is not relevant to stable trees older
than `v7.0`.

Stable rules checklist: obviously correct: yes by local code inspection.
Tested: no `Tested-by`, but reviewed. Real bug: yes, wrong sysfs clock-
level output. Important: borderline, but it affects a stable user-
visible PM interface and can advertise a non-real level.
Small/contained: yes, one line in one driver helper. No new
features/APIs: yes. Applies to stable: yes for `v7.0.y`; no need for
older stable trees lacking the helper.

Exception category: none.

## Verification
- Phase 1: parsed supplied subject/body/tags; confirmed no reporter,
  link, Fixes, Tested, or stable tag in the supplied message.
- Phase 2: inspected the supplied diff and current
  `smu_cmn_print_dpm_clk_levels()` implementation.
- Phase 3: ran `git blame` on the affected lines; identified
  `a08ea4bc7711f8` and `d81e52fc61fb9`.
- Phase 3: ran `git show a08ea4bc7711f8` and `git show d81e52fc61fb9`;
  confirmed helper introduction and related missing-star fix.
- Phase 3/6: ran tag/ancestor checks; confirmed helper is in `v7.0*`
  tags and not in `v6.19`.
- Phase 4: ran `b4 dig` variants; all failed because the commit object
  was not locally resolvable.
- Phase 4: attempted lore/git.kernel.org fetches; blocked by Anubis.
- Phase 4: searched web by exact subject/hash/body; did not find the
  target discussion.
- Phase 5: searched callers with `rg`; confirmed multiple AMD SMU ppt
  callers.
- Phase 5: read sysfs call chain in `amdgpu_pm.c`, `amdgpu_dpm.c`, and
  `amdgpu_smu.c`.
- Phase 5/8: inspected write-path parsing and force-clock logic;
  verified possible level 0/1 handling, but not a concrete hardware
  failure.
- Phase 7: ran recent `git log` for `drivers/gpu/drm/amd/pm/swsmu`;
  confirmed active subsystem churn.
- UNVERIFIED: exact upstream lore discussion, all review comments, exact
  commit date of `7f19097af149...`, and concrete hardware impact beyond
  incorrect sysfs output.

This should be backported to stable trees that contain the helper,
especially `v7.0.y`; it should not be applied to older stable trees
where the helper does not exist.

**YES**

 drivers/gpu/drm/amd/pm/swsmu/smu_cmn.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu_cmn.c b/drivers/gpu/drm/amd/pm/swsmu/smu_cmn.c
index 6fd50c2fd20e0..37de6022581ed 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu_cmn.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu_cmn.c
@@ -1310,7 +1310,7 @@ int smu_cmn_print_dpm_clk_levels(struct smu_context *smu,
 		level_index = 1;
 	}
 
-	if (!is_fine_grained) {
+	if (!is_fine_grained || count == 1) {
 		for (i = 0; i < count; i++) {
 			freq_match = !is_deep_sleep &&
 				     smu_cmn_freqs_match(
-- 
2.53.0

