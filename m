Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CA713090CC;
	Sat, 25 Oct 2025 16:22:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409351; cv=none; b=Hos0ikU14wzKklmXmIObKjIon3XOWq1v3PRQjIr3AVQvNE6dKxkQaLY1pYniRwLlkK+fFGDfGSnrAQrr35BUgC8m5VttuPe0cCsr673h4nClG70brld8cPBVUfvpFMpKjZnsK1a7Jt0LKXqKW/QlXzKKjcMlgaHw7QahNHhUCYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409351; c=relaxed/simple;
	bh=vcA2wQcdhq8Q9Q1qi/kmkIkg9qpLIpkNLvtBU55QUFY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qeS9d7kSvLJpeXE6YxZGjTps0oU6jI8yidpMIedB9dIsSMaj9YOT0R0JAlK2Pl8jF13PYUk5yYhWP7c3eY04948gOWbozgPyOyo0q0PelN2VHJHkPkpqgyBqsMb7n9z2xqtywilTVrpjMB2daub9Fg3skk1/dpT3rBJclWvwkYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Kki2kS2Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Kki2kS2Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4DB8C4CEF5;
	Sat, 25 Oct 2025 16:22:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409350;
	bh=vcA2wQcdhq8Q9Q1qi/kmkIkg9qpLIpkNLvtBU55QUFY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Kki2kS2QLEA55SkF/oq/e8UAdjfJm8xyoF7J9kA1Njmh7+9rm8TSuPo8cqPT5y0Xl
	 0o4SLxfXcLKDmS2FeUFYDcSykNJQKfiu0eIBvPNrzzFmJuFZLklJ7Ad0zLbHHttmyJ
	 mIrqbOIC+hbEtFoDaHt7ELbx6mLOPuRwYwsvwKhjN6P4yBXfaT/ey5Ws5C5fYwdeqh
	 TJiB0grspH+v9LtR7+ZcBtusvqU4gCJOdNADVNfPM9Cojh30H7BVk7igNlb6ysOkKp
	 4nOLphv0pWCeDHUpIJglSgEOLwi8GvAfW24HbzJ6KVoGixfKKh0MSfgh7colIAh26U
	 5NVJRvkTO0f2A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Prike Liang <Prike.Liang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	christian.koenig@amd.com,
	sunil.khatri@amd.com,
	shashank.sharma@amd.com,
	Arunpravin.PaneerSelvam@amd.com,
	Arvind.Yadav@amd.com,
	Jesse.Zhang@amd.com
Subject: [PATCH AUTOSEL 6.17] drm/amdgpu: validate userq input args
Date: Sat, 25 Oct 2025 11:58:37 -0400
Message-ID: <20251025160905.3857885-286-sashal@kernel.org>
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

From: Prike Liang <Prike.Liang@amd.com>

[ Upstream commit 219be4711a1ba788bc2a9fafc117139d133e5fea ]

This will help on validating the userq input args, and
rejecting for the invalid userq request at the IOCTLs
first place.

Signed-off-by: Prike Liang <Prike.Liang@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

- Centralizes and hardens ioctl argument validation for AMDGPU user
  queues, preventing invalid user inputs from reaching deeper paths:
  - Adds `amdgpu_userq_input_args_validate()` with strict checks for
    `CREATE` and `FREE` ops, called up front in the ioctl path at
    `drivers/gpu/drm/amd/amdgpu/amdgpu_userq.c:662`.
  - Validation covers:
    - Allowed flags mask only (priority + secure) at
      `drivers/gpu/drm/amd/amdgpu/amdgpu_userq.c:611`.
    - Supported `ip_type` values (GFX, DMA, COMPUTE) at
      `drivers/gpu/drm/amd/amdgpu/amdgpu_userq.c:615`.
    - Secure queue constraints with TMZ check at
      `drivers/gpu/drm/amd/amdgpu/amdgpu_userq.c:623`.
    - Queue VA and size nonzero and not `AMDGPU_BO_INVALID_OFFSET` at
      `drivers/gpu/drm/amd/amdgpu/amdgpu_userq.c:631`.
    - RPTR/WPTR nonzero at
      `drivers/gpu/drm/amd/amdgpu/amdgpu_userq.c:637`.
    - For `FREE`, requires all other input fields to be zero (preserves
      prior semantics) at
      `drivers/gpu/drm/amd/amdgpu/amdgpu_userq.c:642`.

- Previously scattered checks are consolidated and performed before any
  runtime or power management work:
  - `amdgpu_userq_ioctl()` now rejects invalid input immediately,
    returning `-EINVAL` before dispatching the operation at
    `drivers/gpu/drm/amd/amdgpu/amdgpu_userq.c:668-689`.
  - The ip-type and secure checks moved out of `amdgpu_userq_create()`
    into the validator (logic preserved). `amdgpu_userq_create()` still
    verifies hardware support via `uq_funcs` at
    `drivers/gpu/drm/amd/amdgpu/amdgpu_userq.c:493-499`.

- Duplicated parameter checks removed from the MQD creation path and
  replaced by consistent ioctl-level validation:
  - `mes_userq_mqd_create()` no longer performs basic null/size checks
    for `queue_va`, `rptr_va`, `wptr_va`, or `queue_size` (these were
    previously inlined there). The function now assumes validated inputs
    and proceeds with MQD setup (e.g., property assignment) at
    `drivers/gpu/drm/amd/amdgpu/mes_userqueue.c:268-284`.
  - This is compensated by the new front-end validation and the existing
    VM address-range validation still done in `amdgpu_userq_create()`
    using `amdgpu_userq_input_va_validate()` for `queue_va`, `rptr_va`,
    and `wptr_va` at
    `drivers/gpu/drm/amd/amdgpu/amdgpu_userq.c:508-515`.

- Behavior and surface area improvements:
  - New explicit rejection of `AMDGPU_BO_INVALID_OFFSET` for `queue_va`
    prevents misuse of a sentinel value that could otherwise percolate
    before failing later (more precise erroring at the ioctl boundary).
  - Early rejection saves work (e.g., avoids power runtime ops,
    allocations) and provides consistent error codes/messages to
    userspace.
  - No uAPI change: same ioctl and structures; only input validation
    strengthened. No architectural changes.

- Regression risk is low:
  - Logic enforcing allowed flags and `FREE`-op zeroing matches existing
    expectations documented in UAPI (`include/uapi/drm/amdgpu_drm.h:357`
    and `include/uapi/drm/amdgpu_drm.h:422`).
  - Hardware support and VM mapping checks remain intact
    (`drivers/gpu/drm/amd/amdgpu/amdgpu_userq.c:493-499` and
    `drivers/gpu/drm/amd/amdgpu/amdgpu_userq.c:508-515`).
  - The only stricter acceptance criterion is rejecting `queue_va ==
    AMDGPU_BO_INVALID_OFFSET`, which userspace should never rely upon
    for valid operation.

- Scope and impact:
  - Changes are confined to AMDGPU’s user-queue stack (`amdgpu_userq.c`,
    `mes_userqueue.c`) and the ioctl plumbing (`amdgpu_drv.c` references
    `amdgpu_userq_ioctl` at
    `drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c:3056`).
  - No changes outside DRM/AMDGPU; no cross-subsystem side effects.

Conclusion: This is a small, targeted, and beneficial hardening/bugfix
that reduces invalid input reaching deeper driver logic and produces
earlier, clearer failures. It fits stable rules (important
correctness/safety fix, minimal risk, no features or architecture
changes). Recommend backporting to all stable series that include the
AMDGPU userq uAPI.

 drivers/gpu/drm/amd/amdgpu/amdgpu_userq.c  | 81 +++++++++++++++-------
 drivers/gpu/drm/amd/amdgpu/mes_userqueue.c |  7 --
 2 files changed, 56 insertions(+), 32 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_userq.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_userq.c
index 8190c24a649a2..65c8a38890d48 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_userq.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_userq.c
@@ -404,27 +404,10 @@ amdgpu_userq_create(struct drm_file *filp, union drm_amdgpu_userq *args)
 		(args->in.flags & AMDGPU_USERQ_CREATE_FLAGS_QUEUE_PRIORITY_MASK) >>
 		AMDGPU_USERQ_CREATE_FLAGS_QUEUE_PRIORITY_SHIFT;
 
-	/* Usermode queues are only supported for GFX IP as of now */
-	if (args->in.ip_type != AMDGPU_HW_IP_GFX &&
-	    args->in.ip_type != AMDGPU_HW_IP_DMA &&
-	    args->in.ip_type != AMDGPU_HW_IP_COMPUTE) {
-		drm_file_err(uq_mgr->file, "Usermode queue doesn't support IP type %u\n",
-			     args->in.ip_type);
-		return -EINVAL;
-	}
-
 	r = amdgpu_userq_priority_permit(filp, priority);
 	if (r)
 		return r;
 
-	if ((args->in.flags & AMDGPU_USERQ_CREATE_FLAGS_QUEUE_SECURE) &&
-	    (args->in.ip_type != AMDGPU_HW_IP_GFX) &&
-	    (args->in.ip_type != AMDGPU_HW_IP_COMPUTE) &&
-	    !amdgpu_is_tmz(adev)) {
-		drm_file_err(uq_mgr->file, "Secure only supported on GFX/Compute queues\n");
-		return -EINVAL;
-	}
-
 	r = pm_runtime_get_sync(adev_to_drm(adev)->dev);
 	if (r < 0) {
 		drm_file_err(uq_mgr->file, "pm_runtime_get_sync() failed for userqueue create\n");
@@ -543,22 +526,45 @@ amdgpu_userq_create(struct drm_file *filp, union drm_amdgpu_userq *args)
 	return r;
 }
 
-int amdgpu_userq_ioctl(struct drm_device *dev, void *data,
-		       struct drm_file *filp)
+static int amdgpu_userq_input_args_validate(struct drm_device *dev,
+					union drm_amdgpu_userq *args,
+					struct drm_file *filp)
 {
-	union drm_amdgpu_userq *args = data;
-	int r;
+	struct amdgpu_device *adev = drm_to_adev(dev);
 
 	switch (args->in.op) {
 	case AMDGPU_USERQ_OP_CREATE:
 		if (args->in.flags & ~(AMDGPU_USERQ_CREATE_FLAGS_QUEUE_PRIORITY_MASK |
 				       AMDGPU_USERQ_CREATE_FLAGS_QUEUE_SECURE))
 			return -EINVAL;
-		r = amdgpu_userq_create(filp, args);
-		if (r)
-			drm_file_err(filp, "Failed to create usermode queue\n");
-		break;
+		/* Usermode queues are only supported for GFX IP as of now */
+		if (args->in.ip_type != AMDGPU_HW_IP_GFX &&
+		    args->in.ip_type != AMDGPU_HW_IP_DMA &&
+		    args->in.ip_type != AMDGPU_HW_IP_COMPUTE) {
+			drm_file_err(filp, "Usermode queue doesn't support IP type %u\n",
+				     args->in.ip_type);
+			return -EINVAL;
+		}
+
+		if ((args->in.flags & AMDGPU_USERQ_CREATE_FLAGS_QUEUE_SECURE) &&
+		    (args->in.ip_type != AMDGPU_HW_IP_GFX) &&
+		    (args->in.ip_type != AMDGPU_HW_IP_COMPUTE) &&
+		    !amdgpu_is_tmz(adev)) {
+			drm_file_err(filp, "Secure only supported on GFX/Compute queues\n");
+			return -EINVAL;
+		}
 
+		if (args->in.queue_va == AMDGPU_BO_INVALID_OFFSET ||
+		    args->in.queue_va == 0 ||
+		    args->in.queue_size == 0) {
+			drm_file_err(filp, "invalidate userq queue va or size\n");
+			return -EINVAL;
+		}
+		if (!args->in.wptr_va || !args->in.rptr_va) {
+			drm_file_err(filp, "invalidate userq queue rptr or wptr\n");
+			return -EINVAL;
+		}
+		break;
 	case AMDGPU_USERQ_OP_FREE:
 		if (args->in.ip_type ||
 		    args->in.doorbell_handle ||
@@ -572,6 +578,31 @@ int amdgpu_userq_ioctl(struct drm_device *dev, void *data,
 		    args->in.mqd ||
 		    args->in.mqd_size)
 			return -EINVAL;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+int amdgpu_userq_ioctl(struct drm_device *dev, void *data,
+		       struct drm_file *filp)
+{
+	union drm_amdgpu_userq *args = data;
+	int r;
+
+	if (amdgpu_userq_input_args_validate(dev, args, filp) < 0)
+		return -EINVAL;
+
+	switch (args->in.op) {
+	case AMDGPU_USERQ_OP_CREATE:
+		r = amdgpu_userq_create(filp, args);
+		if (r)
+			drm_file_err(filp, "Failed to create usermode queue\n");
+		break;
+
+	case AMDGPU_USERQ_OP_FREE:
 		r = amdgpu_userq_destroy(filp, args->in.queue_id);
 		if (r)
 			drm_file_err(filp, "Failed to destroy usermode queue\n");
diff --git a/drivers/gpu/drm/amd/amdgpu/mes_userqueue.c b/drivers/gpu/drm/amd/amdgpu/mes_userqueue.c
index d6f50b13e2ba0..1457fb49a794f 100644
--- a/drivers/gpu/drm/amd/amdgpu/mes_userqueue.c
+++ b/drivers/gpu/drm/amd/amdgpu/mes_userqueue.c
@@ -215,13 +215,6 @@ static int mes_userq_mqd_create(struct amdgpu_userq_mgr *uq_mgr,
 		return -ENOMEM;
 	}
 
-	if (!mqd_user->wptr_va || !mqd_user->rptr_va ||
-	    !mqd_user->queue_va || mqd_user->queue_size == 0) {
-		DRM_ERROR("Invalid MQD parameters for userqueue\n");
-		r = -EINVAL;
-		goto free_props;
-	}
-
 	r = amdgpu_userq_create_object(uq_mgr, &queue->mqd, mqd_hw_default->mqd_size);
 	if (r) {
 		DRM_ERROR("Failed to create MQD object for userqueue\n");
-- 
2.51.0

