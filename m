Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F12A6307AEB;
	Sat, 25 Oct 2025 16:25:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409505; cv=none; b=t0rd+thkJTZP0h/igOZ7vGZ2V1LxM1vbZA+mbaD/ZB3KfD1ReIX0SDYbdg6OxILyuHa6FQTnC4qbTcUcNw4hGL9wwamL/VM3M9ZXACwdlsWnWIpwQDJfcxFPSC1heoYXdO7uSEBhUbtKPWdhLLgl6euhRfDo7z5vHOkUZi9X/Ps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409505; c=relaxed/simple;
	bh=TwhuqC3KO8KtpUE5+tHAXuohxqOq/M8R6SCzSroordc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mh8grxg+LC8BrEi0J3VgS+c61lJ6L4+3iHY5udKiqUqZBJOcgRl99PWYuRBRb4Sezia9NsS0bsAvcab6lklrxDXIkz6tcbkb6QkIsJ5hrEFdfvCrb/2oVCyQxznKXFfgPnhxyl0+GTn6dOCRWJySUyschdqYcrZO6sDc6NtSyMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QgNMGq1d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QgNMGq1d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46A33C4CEF5;
	Sat, 25 Oct 2025 16:25:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409504;
	bh=TwhuqC3KO8KtpUE5+tHAXuohxqOq/M8R6SCzSroordc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QgNMGq1dY/0Eb9Byd5vuWy48/Gl7tjziAffnxTUNwajDLRYg7p+c0WgoIAlO3FsRj
	 bbMVFONo5ftLHciEutLfDjoq1RlzE1ETiSThMOcRYzkCd72yMFYACn2dsi40Yllb2I
	 uR0VHPFbE1xVpRplJ2rfnpN9cStCQRYUL4wXSBj/+q8bo35o5s2iLvwI76u1YfKnAY
	 dr2DkCX4a5xoYQmHrego0rg9QVhrJoJYzxZkKzfgZbYrvIsyWxddbclGNp/Zc6JAqL
	 GzS2aqxZ75bujvuD+jTbF3cNyePVXREpSPsmQWWV0XY/t1SCVjs/yIdAKYyDYUpzNm
	 zJiyigKqsmtZQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Ce Sun <cesun102@amd.com>,
	"Stanley.Yang" <Stanley.Yang@amd.com>,
	Tao Zhou <tao.zhou1@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	Hawking.Zhang@amd.com,
	ganglxie@amd.com,
	lijo.lazar@amd.com,
	candice.li@amd.com,
	YiPeng.Chai@amd.com,
	alexandre.f.demers@gmail.com,
	victor.skvortsov@amd.com,
	xiang.liu@amd.com
Subject: [PATCH AUTOSEL 6.17-6.12] drm/amdgpu: Avoid rma causes GPU duplicate reset
Date: Sat, 25 Oct 2025 11:59:43 -0400
Message-ID: <20251025160905.3857885-352-sashal@kernel.org>
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

From: Ce Sun <cesun102@amd.com>

[ Upstream commit 21c0ffa612c98bcc6dab5bd9d977a18d565ee28e ]

Try to ensure poison creation handle is completed in time
to set device rma value.

Signed-off-by: Ce Sun <cesun102@amd.com>
Signed-off-by: Stanley.Yang <Stanley.Yang@amd.com>
Reviewed-by: Tao Zhou <tao.zhou1@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

- What it fixes
  - Prevents duplicate GPU resets in RAS “RMA” scenarios by
    consolidating the reset trigger and enforcing ordering. Duplicate
    resets are user-visible disruptions and can exacerbate recovery
    problems.

- Key code changes and why they matter
  - drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c:
    amdgpu_ras_do_page_retirement()
    - Removes the unconditional RMA reset path:
      - Old: after handling bad pages, if any bad addresses were found
        and `amdgpu_ras_is_rma(adev)` is true, it called
        `amdgpu_ras_reset_gpu(adev)` (in your tree at
        drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c:2948).
      - New: this reset is removed.
    - Rationale: This reset source raced with/duplicated the reset
      initiated elsewhere (poison events), causing double resets.
  - drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c:
    amdgpu_ras_poison_creation_handler()
    - Adds the centralized RMA reset trigger with a one-time gate:
      - New code calls `amdgpu_ras_reset_gpu(adev)` only if
        `amdgpu_ras_is_rma(adev)` and
        `atomic_cmpxchg(&ras->rma_in_recovery, 0, 1) == 0`.
      - Effect: Ensures the RMA-driven reset is initiated exactly once
        per recovery episode, avoiding duplicate reset storms. This
        aligns behavior with the long-standing comment in consumption
        flow that “for RMA, amdgpu_ras_poison_creation_handler will
        trigger gpu reset.”
  - drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c:
    amdgpu_ras_poison_consumption_handler()
    - Adds `flush_delayed_work(&con->page_retirement_dwork)` before
      evaluating reset decisions.
      - Old: flush was done only within the “non-RMA reset” branch.
      - New: flush happens unconditionally before deciding whether to
        reset.
      - Effect: Ensures the retirement work (which updates the EEPROM
        and can set the device RMA state) completes before we decide
        whether consumption should reset. That way, if RMA was reached
        by retiring pages, `amdgpu_ras_is_rma(adev)` is correctly seen
        as true here, so the consumption path skips reset, avoiding a
        duplicate.
  - drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c: amdgpu_ras_recovery_init()
    - Initializes a new atomic gate: `atomic_set(&con->rma_in_recovery,
      0)`.
  - drivers/gpu/drm/amd/amdgpu/amdgpu_ras.h: struct amdgpu_ras
    - Adds `atomic_t rma_in_recovery`.
      - Effect: Provides per-device gating specifically for RMA-
        initiated resets, on top of the existing generic `in_recovery`
        gating, to prevent multiple RMA-triggered resets from different
        paths.

- Why this is suitable for stable
  - Clear, user-facing bug: duplicate GPU resets in RAS/RMA situations
    cause unnecessary downtime and potential instability.
  - Small and contained: All changes are within the AMDGPU RAS paths; no
    ABI/feature addition beyond an internal struct field and logic
    adjustments.
  - No architectural rewrite: This refactors where and when the reset
    occurs (creation handler) and adds synchronization (flush + atomic
    gate) to avoid races/duplication. Normal, non-RMA poison flows are
    unchanged.
  - Minimal regression risk:
    - Ordering: `flush_delayed_work()` ensures RMA flag is set before
      consumption decides to reset or not, which reduces race conditions
      rather than adding them.
    - Gating: The new `rma_in_recovery` is only checked when
      `amdgpu_ras_is_rma(adev)` is true; non-RMA cases, including
      existing reset decisions and `in_recovery` gate, are unaffected.
    - The removal of the reset from `amdgpu_ras_do_page_retirement()`
      eliminates a duplicated reset source. The reset now originates
      once from the poison creation flow, as intended by existing
      comments in the consumption handler.

- Historical context and dependencies in-tree
  - The earlier change “trigger mode1 reset for RAS RMA status”
    introduced the idea that RMA requires a specific reset mode and
    added an RMA-aware path that could trigger resets in several places
    (e.g., do_page_retirement, UMC handling). This created the potential
    for duplicate resets.
  - Subsequent work refined poison creation/consumption handling and
    centralized their processing in `amdgpu_ras.c` with FIFO and
    counters (e.g., commits that added `poison_creation_count`, merged
    consumption reset flags, and used delayed work for retirement).
  - This patch fits that evolution by:
    - Centralizing the RMA reset trigger in
      `amdgpu_ras_poison_creation_handler()`.
    - Ensuring consumption does not race into a second reset by flushing
      the retirement work first to read a correct RMA state.
  - Backporting note: This change assumes the RMA framework and poison
    creation/consumption infrastructure are present (e.g.,
    `amdgpu_ras_is_rma()`, `page_retirement_dwork`,
    `poison_creation_count`/FIFO, and the consumption-merge logic). For
    stable series that predate those, the patch will not apply cleanly
    or won’t make sense.

- Security/side effects
  - No security implications identified.
  - Does not change user-visible interfaces or add new features; it
    tightens error-handling sequencing.

- Conclusion
  - This is a focused bugfix that prevents duplicate GPU resets in RAS
    RMA scenarios by improving ordering and gating. It’s low risk,
    confined to AMDGPU RAS code, and should be backported to stable
    trees that already contain the related RMA/poison infrastructure.

 drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c | 17 ++++++++++-------
 drivers/gpu/drm/amd/amdgpu/amdgpu_ras.h |  1 +
 2 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
index c88123302a071..54909bcf181f3 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
@@ -3285,7 +3285,6 @@ static void amdgpu_ras_do_page_retirement(struct work_struct *work)
 					      page_retirement_dwork.work);
 	struct amdgpu_device *adev = con->adev;
 	struct ras_err_data err_data;
-	unsigned long err_cnt;
 
 	/* If gpu reset is ongoing, delay retiring the bad pages */
 	if (amdgpu_in_reset(adev) || amdgpu_ras_in_recovery(adev)) {
@@ -3297,13 +3296,9 @@ static void amdgpu_ras_do_page_retirement(struct work_struct *work)
 	amdgpu_ras_error_data_init(&err_data);
 
 	amdgpu_umc_handle_bad_pages(adev, &err_data);
-	err_cnt = err_data.err_addr_cnt;
 
 	amdgpu_ras_error_data_fini(&err_data);
 
-	if (err_cnt && amdgpu_ras_is_rma(adev))
-		amdgpu_ras_reset_gpu(adev);
-
 	amdgpu_ras_schedule_retirement_dwork(con,
 			AMDGPU_RAS_RETIRE_PAGE_INTERVAL);
 }
@@ -3357,6 +3352,9 @@ static int amdgpu_ras_poison_creation_handler(struct amdgpu_device *adev,
 	if (total_detect_count)
 		schedule_delayed_work(&ras->page_retirement_dwork, 0);
 
+	if (amdgpu_ras_is_rma(adev) && atomic_cmpxchg(&ras->rma_in_recovery, 0, 1) == 0)
+		amdgpu_ras_reset_gpu(adev);
+
 	return 0;
 }
 
@@ -3392,6 +3390,12 @@ static int amdgpu_ras_poison_consumption_handler(struct amdgpu_device *adev,
 		reset_flags |= msg.reset;
 	}
 
+	/*
+	 * Try to ensure poison creation handler is completed first
+	 * to set rma if bad page exceed threshold.
+	 */
+	flush_delayed_work(&con->page_retirement_dwork);
+
 	/* for RMA, amdgpu_ras_poison_creation_handler will trigger gpu reset */
 	if (reset_flags && !amdgpu_ras_is_rma(adev)) {
 		if (reset_flags & AMDGPU_RAS_GPU_RESET_MODE1_RESET)
@@ -3401,8 +3405,6 @@ static int amdgpu_ras_poison_consumption_handler(struct amdgpu_device *adev,
 		else
 			reset = reset_flags;
 
-		flush_delayed_work(&con->page_retirement_dwork);
-
 		con->gpu_reset_flags |= reset;
 		amdgpu_ras_reset_gpu(adev);
 
@@ -3570,6 +3572,7 @@ int amdgpu_ras_recovery_init(struct amdgpu_device *adev, bool init_bp_info)
 	mutex_init(&con->recovery_lock);
 	INIT_WORK(&con->recovery_work, amdgpu_ras_do_recovery);
 	atomic_set(&con->in_recovery, 0);
+	atomic_set(&con->rma_in_recovery, 0);
 	con->eeprom_control.bad_channel_bitmap = 0;
 
 	max_eeprom_records_count = amdgpu_ras_eeprom_max_record_count(&con->eeprom_control);
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.h b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.h
index 927d6bff734ae..699953c02649f 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.h
@@ -515,6 +515,7 @@ struct amdgpu_ras {
 	/* gpu recovery */
 	struct work_struct recovery_work;
 	atomic_t in_recovery;
+	atomic_t rma_in_recovery;
 	struct amdgpu_device *adev;
 	/* error handler data */
 	struct ras_err_handler_data *eh_data;
-- 
2.51.0

