Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0051C302747;
	Sat, 25 Oct 2025 16:15:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761408911; cv=none; b=tFzwAna+bzPEbynTZ5QQn8TRn6h0hkglF7SP6hQrQHgLa5C9Fz5xvSENfpkHVReYxRvtNNwbc0JJLeTptqjxbG5wJ0MYZJiRvl+lyVMvoXXiGE61UOWXStsbAIWjjM+RQOlFYsW9zQquH/b2tmFrn6o8FLcrac4ScWvuJR/HGy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761408911; c=relaxed/simple;
	bh=j8yD5cqajyt8oHsVEUEfkhY+VtYIKmDymUlcKZ/9bbU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WmKc2mSf6U8WkY+Z6Qzsa8seZLe6oNLlWjvjO0ft2+uIpgkXYrRAxkawA9YaxhV095p2TreOmteTFa0FHcuXiXA2oKeG+cLqFToYUO9fw8+ICSkCAz9tVE8hkZ9V0ySRPLm2Zs3Sm9G9H06hC5a0U2VqdSaUKU7BqRDfX+NF6Rg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=p8XXAM6h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="p8XXAM6h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 503F2C4CEF5;
	Sat, 25 Oct 2025 16:15:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761408909;
	bh=j8yD5cqajyt8oHsVEUEfkhY+VtYIKmDymUlcKZ/9bbU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p8XXAM6hQ3hyQDByu7JgA4tX3JixhjA5IJAyf9nfs3ZHDEGcOQ96pqPoYRdwoDPSM
	 5nfb1sDlSQQf1mVJvpKpfrPG/03MbzPTbAhjfxq1PhueBtARHGdohqC3Jf1paKF95N
	 TToGZscEdZ0S8FJyht6qHrLbjghfmeErCwgE8v286ATG8qECQTRaNDjfGV3QvakxaV
	 //wj9xV/vNsm32xFTJem8Eqmc1pyPUUa1Qy54VWzATdKC8mYwHoYPqnZikxftvbQEd
	 q8h0i0SuT9O84+eV6w8b0vzd3WZAvjA9BUviH+BrPnNUrQDyc4yy6ETx8KxAvlbGmL
	 6k8g6b4hfsXCg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Ausef Yousof <Ausef.Yousof@amd.com>,
	Alvin Lee <alvin.lee2@amd.com>,
	Wayne Lin <wayne.lin@amd.com>,
	Dan Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	Wayne.Lin@amd.com,
	roman.li@amd.com,
	alex.hung@amd.com,
	ray.wu@amd.com,
	PeiChen.Huang@amd.com,
	Dillon.Varone@amd.com,
	Charlene.Liu@amd.com,
	Sung.Lee@amd.com,
	alexandre.f.demers@gmail.com,
	Richard.Chiang@amd.com,
	ryanseto@amd.com,
	linux@treblig.org,
	mario.limonciello@amd.com
Subject: [PATCH AUTOSEL 6.17] drm/amd/display: dont wait for pipe update during medupdate/highirq
Date: Sat, 25 Oct 2025 11:55:55 -0400
Message-ID: <20251025160905.3857885-124-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ausef Yousof <Ausef.Yousof@amd.com>

[ Upstream commit 895b61395eefd28376250778a741f11e12715a39 ]

[why&how]
control flag for the wait during pipe update wait for vupdate should
be set if update type is not fast or med to prevent an invalid sleep
operation

Reviewed-by: Alvin Lee <alvin.lee2@amd.com>
Signed-off-by: Ausef Yousof <Ausef.Yousof@amd.com>
Signed-off-by: Wayne Lin <wayne.lin@amd.com>
Tested-by: Dan Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

- What it fixes: Prevents sleeping in interrupt/atomic context during
  medium (MED) updates by avoiding a vupdate wait when the update is not
  FULL. This addresses “invalid sleep” risks during medupdate/highirq
  paths.

- Change summary: The wait decision flag passed to the hardware
  sequencer changes from only FAST to FAST or MED:
  - `drivers/gpu/drm/amd/display/dc/core/dc.c:4173` now passes
    `update_type < UPDATE_TYPE_FULL` instead of `update_type ==
    UPDATE_TYPE_FAST`.

- Why this matters: The wait routine will sleep via `fsleep()` when it
  decides to wait. Sleeping is not allowed at high IRQ levels or atomic
  contexts. MED updates are documented as ISR‑safe (i.e., they can occur
  in interrupt context), so they must not trigger sleeps.
  - Update type semantics: `drivers/gpu/drm/amd/display/dc/dc.h:453`
    (FAST “safe to execute in isr”),
    `drivers/gpu/drm/amd/display/dc/dc.h:454` (MED “ISR safe”),
    `drivers/gpu/drm/amd/display/dc/dc.h:455` (FULL “cannot be done at
    ISR level”).

- Actual wait behavior: The wait function only sleeps when it’s safe;
  the third argument tells it to skip the sleep for ISR‑safe paths:
  - Function definition:
    `drivers/gpu/drm/amd/display/dc/hwss/dcn10/dcn10_hwseq.c:101`
  - Core logic: If `is_surface_update_only` is true and the computed
    wait is long, it returns early without sleeping, deferring the wait:
    - Early return guard:
      `drivers/gpu/drm/amd/display/dc/hwss/dcn10/dcn10_hwseq.c:157`
    - Sleep call (which we avoid in ISR context):
      `drivers/gpu/drm/amd/display/dc/hwss/dcn10/dcn10_hwseq.c:163`

- Correctness and safety: For FULL updates, the code still treats the
  path as non‑ISR and uses the wait normally. Example full‑update path
  calls the wait with “false”:
  - `drivers/gpu/drm/amd/display/dc/core/dc.c:2146`
  - FULL updates explicitly set up the “wait required” state later when
    appropriate:
  - `drivers/gpu/drm/amd/display/dc/core/dc.c:4326`

- Side‑effects and risk: Minimal. This is a one‑line, scoped change
  that:
  - Avoids an invalid sleep during MED updates while preserving FULL
    update behavior.
  - Defers waiting by keeping `pipe_ctx->wait_is_required` set when
    skipping, so the wait happens later in a safe context (per
    `drivers/gpu/drm/amd/display/dc/hwss/dcn10/dcn10_hwseq.c:159`).

- Scope: Confined to AMD display DC commit path; no architectural/API
  changes.

- Stable backport criteria: Satisfies important bugfix (avoids sleeping
  in IRQ), small and contained change, low regression risk, no new
  features, and limited to a driver subsystem.

Given the above, this is a solid candidate for stable backport.

 drivers/gpu/drm/amd/display/dc/core/dc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc.c b/drivers/gpu/drm/amd/display/dc/core/dc.c
index 2d2f4c4bdc97e..74efd50b7c23a 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -4163,7 +4163,7 @@ static void commit_planes_for_stream(struct dc *dc,
 	}
 
 	if (dc->hwseq->funcs.wait_for_pipe_update_if_needed)
-		dc->hwseq->funcs.wait_for_pipe_update_if_needed(dc, top_pipe_to_program, update_type == UPDATE_TYPE_FAST);
+		dc->hwseq->funcs.wait_for_pipe_update_if_needed(dc, top_pipe_to_program, update_type < UPDATE_TYPE_FULL);
 
 	if (should_lock_all_pipes && dc->hwss.interdependent_update_lock) {
 		if (dc->hwss.subvp_pipe_control_lock)
-- 
2.51.0

