Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585767;
	b=a4mopNVPZ2lnKBf3UT0dkBl5zdhqBpWJEnYSD1kBvJnFEdBS2UJ0COjTlwxwlBlh7cJJ
	 u+Y5XMZwMQU35XGcLH/SzSLR5nT3D1GlN2US75vSXAhvDdb0loCWEM2iNtR8Ow9yJne62
	 lgvvBFOe0nbo2mG6jQ2zd3CbNkTwztEGaXnGy0NAGHHMV6zc8nnLseTu+kTcBBV1Q8Khy
	 D2CZLaQwAltTnJeV/EslDvgyisprOMUkK9kdI5NOycX6rFmBW/7kytSFwGHRFUp68Xu7c
	 UrZ8Yy7McldOAZaVXRQ0IBrwp0UeiEByY8Vr/T3EKcYR++vUWh2VNB5Ixrw1hAR4pjg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585767;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/SryqEe6ar22Qhep3x6TwtEToBxLwq2AygowmBUmgQc=;
	b=4PEk3Pe32in9WcQPVG3Af4S1XTo81Kknov6bN9DsWEDVF4lsaPt6qbuPWag6JuNCEtsL
	 O66LW92c3jFOoNv9JNkIWFtnByxk9tGZBMWLs/n2MbhpiwKLVZOcs9ca1O+Xdv6l7oWoX
	 ExrSuTxrPvMI3ItdiydYydl8Wj0EKPCQk9kJdGn+AMe2GtbQQ8QL04RugcO037XpJzqqA
	 ylFVVM12aXTtHDYlVvG6PlXd85tDKemqs6i3XVwom22TazSTqR6mSNPX1D3Q4DSR2sDJU
	 gJOJyZNbHRSuJ4OezO1MSB+CbRvDLQ7fOA004KXeIxVtqF02d3hVJon9XqDj4iNeAWg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YLEHK8rl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2AF3606D445;
	Fri, 13 Nov 2026 16:02:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YLEHK8rl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E6FD1F000C4;
	Fri, 13 Nov 2026 16:02:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585767;
	bh=/SryqEe6ar22Qhep3x6TwtEToBxLwq2AygowmBUmgQc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YLEHK8rlqJOoFTHBsOR3fMC8BvPN6RvJIwFXs2+/ISeQbTzL9QNHRp/wtwR2q+kUP
	 q55m/6LoG+Z5Bbb6ryKWdOy5JNtnCxsd4hnmFJyIEwbjIuumvqHdCiVet5cNVZcKwd
	 CMZ10pJfkWsDgSQ3eNxeTfbF0p64ThDv3L60uTH8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prike Liang <Prike.Liang@amd.com>,
	Lijo Lazar <lijo.lazar@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 359/507] drm/amdgpu: stop the schedulers before preparing the GPU reset
Date: Fri, 13 Nov 2026 10:51:03 -0500
Message-ID: <20261113153808.078732774@linuxfoundation.org>
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

[ Upstream commit 5b40c07c7ae9f80ec5277bc44c63f354ff581077 ]

amdgpu_device_halt_activities() only stops the ring schedulers after
amdgpu_amdkfd_pre_reset() and amdgpu_userq_pre_reset(). With a hung MES
every REMOVE_QUEUE in amdgpu_userq_pre_reset() waits for its timeout, so
the schedulers keep pushing jobs to the hardware for seconds after the
reset has started:

  GPU reset begin!. Source:  6
  MES failed to respond to msg=REMOVE_QUEUE fence_wait_ret=528494 status=0x0
  WARNING: amdgpu_device.c:928 at amdgpu_device_skip_hw_access+0x73/0x90 [amdgpu]
  Workqueue: sdma0 drm_sched_run_job_work [gpu_sched]
  Call Trace:
   amdgpu_mm_wdoorbell64+0x20/0x70 [amdgpu]
   sdma_v6_0_ring_set_wptr+0xa6/0x180 [amdgpu]
   amdgpu_ring_commit+0x5b/0xa0 [amdgpu]
   amdgpu_ib_schedule+0x64a/0x8f0 [amdgpu]
   amdgpu_job_run+0xa2/0x220 [amdgpu]
   drm_sched_run_job_work+0x10c/0x300 [gpu_sched]

Stop the schedulers of all devices in the reset list first. None of the
preparation steps needs them, and jobs submitted meanwhile simply wait
until amdgpu_device_sched_resume().

Fixes: 290f46cf5726 ("drm/amdgpu: Implement user queue reset functionality")
Signed-off-by: Prike Liang <Prike.Liang@amd.com>
Acked-by: Lijo Lazar <lijo.lazar@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit ea55250ab5594032541c455e1b84e8a7c15a2ba4)
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 28 ++++++++++++----------
 1 file changed, 15 insertions(+), 13 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index 10fc1981fb640..948886fffb4ad 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -5515,7 +5515,21 @@ static void amdgpu_device_halt_activities(struct amdgpu_device *adev,
 	struct amdgpu_device *tmp_adev = NULL;
 	int i;
 
-	/* block all schedulers and reset given job's ring */
+	/* Stop job submission first, the preparation below can take seconds */
+	list_for_each_entry(tmp_adev, device_list, reset_list) {
+		for (i = 0; i < AMDGPU_MAX_RINGS; ++i) {
+			struct amdgpu_ring *ring = tmp_adev->rings[i];
+
+			if (!amdgpu_ring_sched_ready(ring))
+				continue;
+
+			drm_sched_wqueue_stop(&ring->sched);
+
+			if (need_emergency_restart)
+				amdgpu_job_stop_all_jobs_on_sched(&ring->sched);
+		}
+	}
+
 	list_for_each_entry(tmp_adev, device_list, reset_list) {
 		amdgpu_device_set_mp1_state(tmp_adev);
 
@@ -5551,18 +5565,6 @@ static void amdgpu_device_halt_activities(struct amdgpu_device *adev,
 			amdgpu_ras_suspend(tmp_adev);
 
 		amdgpu_userq_pre_reset(tmp_adev);
-
-		for (i = 0; i < AMDGPU_MAX_RINGS; ++i) {
-			struct amdgpu_ring *ring = tmp_adev->rings[i];
-
-			if (!amdgpu_ring_sched_ready(ring))
-				continue;
-
-			drm_sched_wqueue_stop(&ring->sched);
-
-			if (need_emergency_restart)
-				amdgpu_job_stop_all_jobs_on_sched(&ring->sched);
-		}
 		atomic_inc(&tmp_adev->gpu_reset_counter);
 	}
 }
-- 
2.53.0



