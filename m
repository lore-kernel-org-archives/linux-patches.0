Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49E4331282A;
	Sat, 25 Oct 2025 16:22:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409371; cv=none; b=JvVbrYr2J18dRD4+GuZXKMmfORHdFiJu/8JepFfbH+xp+4YN/FAJUugjYVREojSIwG+aoGsxQK7lHDaJN6XQ4pf2hycaM6mtd3ZmXHs6Wl557cVjGM5hpeNvZ3cBGDTPFxJOTTdEujqUnE30mT50U9YuYkwEGnNoYtU+/Zk9G0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409371; c=relaxed/simple;
	bh=FyVNBJtoXIU+UCMoupIR3bW+8ILc9AsMBD2jKWbal20=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AX4aA7mtLiwdE/cqduh8P4qwiOjgQKzlAWFDoF9BdRMKh5rVki02OQ7JpdnrUDR9j48uvtl6zrOhXYrkOvm6IJZ3fvEdVZVScNlTc7yvT0B6hvcCS66zYH6dtUxgtG61ilARUfIIM0o+WbOooS8DIO66+kHJiZ6wkZXY6/9YfD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=s46ke+pA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="s46ke+pA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01BFAC4CEF5;
	Sat, 25 Oct 2025 16:22:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409371;
	bh=FyVNBJtoXIU+UCMoupIR3bW+8ILc9AsMBD2jKWbal20=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s46ke+pATOndPT///X9+JRsx6nDOzzinpMFjYnY6Ot+0dl09FEtEqnH8cCB2J0QEM
	 pUM//s9ByNil4u84v46ld7E7b62+XtTyr5ehZHsZR66Hb2K3xiEa7KusS6g0QfAkYW
	 apoaNbi+GV6k1BDBiqr2QVNAchotLABmd7X0ChfBe9SKStsdy1jHa2yyNGhXfA8YfY
	 hkkS5Nu4/udMqzDz1IsmJ8QeaRUK/IY/QZyOuOiEoNwbHEwrDWdQFTF4IqtArTcab4
	 nN6GdOkkBU4vEpWwXa/bPGM2/LVwlT7ju31EDIzlkd6w9mtHSVfJEVOUCTHrQvmKpq
	 gWcAySPNeXXbg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Vitaly Prosyak <vitaly.prosyak@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	mario.limonciello@amd.com,
	lijo.lazar@amd.com,
	kent.russell@amd.com,
	alexandre.f.demers@gmail.com,
	arnd@arndb.de
Subject: [PATCH AUTOSEL 6.17] drm/amdgpu: add to custom amdgpu_drm_release drm_dev_enter/exit
Date: Sat, 25 Oct 2025 11:58:45 -0400
Message-ID: <20251025160905.3857885-294-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Transfer-Encoding: 8bit

From: Vitaly Prosyak <vitaly.prosyak@amd.com>

[ Upstream commit c31f486bc8dd6f481adcb9cca4a6e1837b8cf127 ]

User queues are disabled before GEM objects are released
(protecting against user app crashes).
No races with PCI hot-unplug (because drm_dev_enter prevents cleanup
if iewdevice is being removed).

Cc: Christian König <christian.koenig@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Vitaly Prosyak <vitaly.prosyak@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

Rationale
- Fixes a real race: amdgpu file release can run concurrently with PCI
  hot-unplug. Wrapping per-file cleanup in `drm_dev_enter/exit` prevents
  touching device state after `drm_dev_unplug()`, avoiding UAFs or
  deadlocks.
- Small, contained change: adds `drm_dev_enter/exit` and local
  variables, no API/ABI changes, no architectural churn. Only touches
  one function.

What changes and why it helps
- Release path gating
  - Patch wraps per-file cleanup in `drm_dev_enter()`:
    - Before: `amdgpu_drm_release` unconditionally does per-fpriv
      cleanup: sets `fd_closing`, destroys eviction fence manager, and
      finalizes user queues, then calls `drm_release()`
      (drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c:2932–2944).
    - After: it first gets `dev = file_priv->minor->dev`, then runs
      those cleanup calls only if `drm_dev_enter(dev, &idx)` succeeds,
      followed by `drm_dev_exit(idx)`.
  - This prevents cleanup that touches device state when the DRM device
    is being unplugged, eliminating hot-unplug races.

- Correct ordering vs GEM release
  - The custom release ensures user queues are torn down before GEM
    objects are released by core DRM via `drm_release()`
    (drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c:2943). This ordering avoids
    userspace-visible crashes if queues reference GEM BOs that core is
    about to free.

Evidence from this branch (linux-autosel-6.17)
- Custom release exists and currently runs device-touching cleanup
  unconditionally:
  - `amdgpu_drm_release` with `amdgpu_eviction_fence_destroy()` and
    `amdgpu_userq_mgr_fini()`
    (drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c:2932–2944).
  - fops uses this custom release
    (drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c:2993–3001).
- The per-fpriv cleanups do interact with device and schedule/cancel
  work:
  - `amdgpu_eviction_fence_destroy()` flushes delayed work on
    `evf_mgr->suspend_work`
    (drivers/gpu/drm/amd/amdgpu/amdgpu_eviction_fence.c:176–208).
  - `amdgpu_userq_mgr_fini()` locks `adev->userq_mutex`, walks per-
    device `userq_mgr_list`, unmaps queues and removes from the list
    (drivers/gpu/drm/amd/amdgpu/amdgpu_userq.c:840–875). This uses
    `userq_mgr->adev` and BO handling; unsafe if device teardown is
    racing.
- Hot-unplug path calls `drm_dev_unplug()` early, then device teardown:
  - `amdgpu_pci_remove()` calls `drm_dev_unplug(dev)` before
    `amdgpu_driver_unload_kms(dev)`
    (drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c:2568–2602 vicinity; see
    unplug and unload sequence).
  - Device suspend/teardown already globally suspends user queues (e.g.,
    `amdgpu_userq_suspend(adev)` in `amdgpu_device.c:3569` and
    `amdgpu_device.c:5160`), so skipping per-file queue finalize during
    unplug is safer than racing device shutdown.

Stable backport criteria
- Important bugfix: prevents hot-unplug races and potential UAFs in
  release path; also enforces correct queue/GEM teardown ordering.
- Minimal risk: surgical addition of `drm_dev_enter/exit` around
  existing cleanup; no new features, no ABI changes, confined to AMDGPU.
- Applies to branches that already have the custom `amdgpu_drm_release`
  and userq/evf infrastructure (present here: see
  `amdgpu_runtime_idle_check_userq` at
  drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c:2925 and userq files). For
  trees without these features, the change is not applicable, but for
  linux-autosel-6.17 it is directly relevant.

Security and regression considerations
- Security: reduces UAF risk during device removal by preventing device-
  affecting work from running after unplug detection.
- Regression risk: low. On unplug, global suspend paths handle userq
  state; skipping per-file finalize when `drm_dev_enter` fails avoids
  races. Normal close still performs full cleanup before
  `drm_release()`.

Conclusion
- This is a focused race fix in a hot path with clear user impact and
  low regression risk. It should be backported to stable trees that
  include the custom `amdgpu_drm_release` and userq/evf code, such as
  this 6.17-based branch.

 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
index c1792e9ab126d..5e81ff3ffdc3f 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
@@ -2937,11 +2937,14 @@ static int amdgpu_drm_release(struct inode *inode, struct file *filp)
 {
 	struct drm_file *file_priv = filp->private_data;
 	struct amdgpu_fpriv *fpriv = file_priv->driver_priv;
+	struct drm_device *dev = file_priv->minor->dev;
+	int idx;
 
-	if (fpriv) {
+	if (fpriv && drm_dev_enter(dev, &idx)) {
 		fpriv->evf_mgr.fd_closing = true;
 		amdgpu_eviction_fence_destroy(&fpriv->evf_mgr);
 		amdgpu_userq_mgr_fini(&fpriv->userq_mgr);
+		drm_dev_exit(idx);
 	}
 
 	return drm_release(inode, filp);
-- 
2.51.0

