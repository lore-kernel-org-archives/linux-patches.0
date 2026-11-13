Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585765;
	b=P56sfuOi2tNyMLnCfcXb9PGkCv0n89xL0iZ6tunZ9Ib0ACQ9Lx0CMOnKLbrVwQlfczGo
	 DRdRNBt6k2DkauSbUgbBmdC4NMfNZe96XE40CdN/HsJygwStTx+pL+/eM6aatgrkvr7UN
	 SjRi9SYpmv1gfZwh3kOrdI8h/wl0apCKAZd2GwgTGLivloPRMdtjQdVwFwS/7CcNNPXIc
	 rkKGzIfGRuk9naiumESwtLAwf0uWIuODdUJxhUpLCVjJdhvIFzGwboOIY+HwV5zB4HeTf
	 nrIhFTleOvXQAs/L/xeQBeEWSYLLtdaKljFes2dtJQsKv4VorUCtKf556UeRPY154qg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585765;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ut9FybAEdlgihk1YvvqLC9MWEPJT9XQVIQe/0MDoVio=;
	b=YnroFKqjixL44pHCiKs6E3QirzHmByM/BRO2iZG74PwIytbhivSjGd5QGHFgFc7sGR0C
	 upa50OP+A13KeNOBPyVYfhUkx4rEEhP9RpMH2eyIb7KUcWdz4/JrWPxX+AHaJZlmg+7Gd
	 7UF8viEHveSj8iPOq441BQyqsYqJIGqaHW70g3PsFue0e25WYPcJkNtWmMKBrWuDXwWsN
	 HdO3QeNM00FCeSU7Pc2CynXl7ITZU2hFEnX23jLzTqvns4ismWOu4kF9/wHYHZoFo8FR1
	 qGuYvTSHT5tabYm7Q6g+MvFnt8z/0uQR9rXVmgjVoX7MK+QXIrI1BcHh5f5Jeqagq5A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FKMqFoQc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D71E606D445;
	Fri, 13 Nov 2026 16:02:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FKMqFoQc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE2821F000C4;
	Fri, 13 Nov 2026 16:02:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585765;
	bh=ut9FybAEdlgihk1YvvqLC9MWEPJT9XQVIQe/0MDoVio=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FKMqFoQcrGW11bVPwi4itt11ZS2zbTFXJrfiFNXfZNGFl/lpy3jvlJiIqQf0uNUgy
	 IB6w9Vs/j6HfKyqRqH95VbIOtRzfCePq/PJMa59f2Ye8+E5T7q3h9AcRlijfePvQ7U
	 SFmGXfgkvt1AJbH5Na9dUhNPeQC1/CMZDMK3AigI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prike Liang <Prike.Liang@amd.com>,
	Lijo Lazar <lijo.lazar@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 357/507] drm/amdgpu: finish GPU recovery callbacks before restarting schedulers
Date: Fri, 13 Nov 2026 10:51:01 -0500
Message-ID: <20261113153807.907828956@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Prike Liang <Prike.Liang@amd.com>

[ Upstream commit 733389cb31e2c55e355410759fdc68afe74a4582 ]

Run GPU post-reset callbacks, including KFD and display-audio resume,
before restarting DRM scheduler workqueues. IP hardware initialization
already happens inside ASIC recovery; this change orders the remaining
callbacks before new scheduler submissions. Preserve the emergency-stop
and guity job completition path's callbacks without starting schedulers,

Signed-off-by: Prike Liang <Prike.Liang@amd.com>
Acked-by: Lijo Lazar <lijo.lazar@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 1f6433e2b264e75c56ae95f187788806201bdbc3)
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index 5b72e4afb650f..10fc1981fb640 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -5797,8 +5797,10 @@ int amdgpu_device_gpu_recover(struct amdgpu_device *adev,
 
 	amdgpu_device_halt_activities(adev, job, reset_context, &device_list,
 				      hive, need_emergency_restart);
-	if (need_emergency_restart)
-		goto skip_sched_resume;
+	if (need_emergency_restart) {
+		amdgpu_device_gpu_resume(adev, &device_list, need_emergency_restart);
+		goto reset_unlock;
+	}
 	/*
 	 * Must check guilty signal here since after this point all old
 	 * HW fences are force signaled.
@@ -5808,18 +5810,17 @@ int amdgpu_device_gpu_recover(struct amdgpu_device *adev,
 	if (job && (dma_fence_get_status(&job->hw_fence->base) > 0)) {
 		job_signaled = true;
 		dev_info(adev->dev, "Guilty job already signaled, skipping HW reset");
-		goto skip_hw_reset;
+		goto post_resume;
 	}
 
 	r = amdgpu_device_asic_reset(adev, &device_list, reset_context);
 	if (r)
 		goto reset_unlock;
-skip_hw_reset:
+post_resume:
+	amdgpu_device_gpu_resume(adev, &device_list, need_emergency_restart);
 	r = amdgpu_device_sched_resume(&device_list, reset_context, job_signaled);
 	if (r)
 		goto reset_unlock;
-skip_sched_resume:
-	amdgpu_device_gpu_resume(adev, &device_list, need_emergency_restart);
 reset_unlock:
 	amdgpu_device_recovery_put_reset_lock(adev, &device_list);
 	amdgpu_ras_post_reset(adev, &device_list);
-- 
2.53.0



