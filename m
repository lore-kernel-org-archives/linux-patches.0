Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054332;
	b=DS8+MojuDsNeJy8Xq7qB1AnFrar0EeVWSjDcAAdUrK5IMJf6kYDbqosF4++3UZ6IQn+o
	 RAjlmhnva/MQ15ifcPuaA9f8bfBcSDvDH9y16JuuIct7SKAAAGoG1KwY1ZcN5478746Ri
	 adQbTa6gRid1LA7vmpMVOPI06NlVOANuboy5z/q4EW0DwFUcvmIO54UI6xPHqvWea4O1Z
	 xLVL87J9N2aSGUFODGJhv0c+BfkVm4KjBtKe9TDDl6PKCjRcLDrdwaqZHLJc3ZrQJRksS
	 W1WHW2vskUvU3/QQtkbvEE2GqUuX3zPvUec6p72a72k/Z7SRjjrCDafGIkPfC79QBtQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054332;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QdLdq5Ow9lDYR/lVLR7mqaIj2kRt5lBXTE9sY3Vzzmc=;
	b=tT79psWnQu+l2ScCPN0UIjKXyMwpLC6PWh1ZFW+PoKaN/VVxwgv+K6IYTn9rOSYDn0Il
	 nTumf9pAXkS7rsL1RpqfYMhA1WE6yrCazsTDxXIjzLI1wIfrH2h2KSwT7+4UPn6EjGy/k
	 hMVCT26NmdLv0wdo7hb+wHLuAs6ufking3ei2UKmvUx4OQClPy3KgghFqc9vFKP6+vxNS
	 ydEXdDfS6B2/EqpZhwoHiRn8q1sJ2KergHiYcX+Ps5GsLY3gcS4htAksLLcXFrywMn9r2
	 QfFGojDc6bSWKVoi3gD5NAdXpiQUp9nZXzuPa3ECpaJ55Cb5EQ/+Oc1h2p8bHlBIxww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="O/6zQ569";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EF7D606A320;
	Thu, 19 Nov 2026 02:12:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O/6zQ569
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF2B21F000C4;
	Thu, 19 Nov 2026 02:12:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054332;
	bh=QdLdq5Ow9lDYR/lVLR7mqaIj2kRt5lBXTE9sY3Vzzmc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O/6zQ569AgUBJoXxFHl37Ahy3XibW4SVLbkB/xZSKaJtH8jTDHZbMSrjecUCjg7hp
	 ylfgUYRNwEUGep2yfEzpLDrnwaCFSB2aNAAHeJtngFzpuTF392SnOT21kX3p7sfa2A
	 FckLYJrKAhDjDpZJX3yeQDjbcSAO/sDsWjlhlndg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prike Liang <Prike.Liang@amd.com>,
	Lijo Lazar <lijo.lazar@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1236/2214] drm/amdgpu: finish GPU recovery callbacks before restarting schedulers
Date: Wed, 18 Nov 2026 15:48:32 +0100
Message-ID: <20261118150101.183727284@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Adapted resume-helper reordering to inline code in amdgpu_device_gpu_recover() because the separate helpers are absent. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 38 ++++++++++++++--------
 1 file changed, 24 insertions(+), 14 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index 5f9fa4a7caa69..9c98084ac1234 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -5296,7 +5296,7 @@ int amdgpu_device_gpu_recover(struct amdgpu_device *adev,
 	}
 
 	if (need_emergency_restart)
-		goto skip_sched_resume;
+		goto post_resume;
 
 	/*
 	 * Must check guilty signal here since after this point all old
@@ -5337,7 +5337,6 @@ int amdgpu_device_gpu_recover(struct amdgpu_device *adev,
 
 skip_hw_reset:
 
-	/* Post ASIC reset for all devs .*/
 	list_for_each_entry(tmp_adev, device_list_handle, reset_list) {
 
 		/*
@@ -5351,6 +5350,29 @@ int amdgpu_device_gpu_recover(struct amdgpu_device *adev,
 			!(tmp_vram_lost_counter < atomic_read(&adev->vram_lost_counter)))
 			amdgpu_device_recheck_guilty_jobs(
 				tmp_adev, device_list_handle, &reset_context);
+	}
+
+post_resume:
+	list_for_each_entry(tmp_adev, device_list_handle, reset_list) {
+		/* unlock kfd: SRIOV would do it separately */
+		if (!need_emergency_restart && !amdgpu_sriov_vf(tmp_adev))
+			amdgpu_amdkfd_post_reset(tmp_adev);
+
+		/* kfd_post_reset will do nothing if kfd device is not initialized,
+		 * need to bring up kfd here if it's not be initialized before
+		 */
+		if (!adev->kfd.init_complete)
+			amdgpu_amdkfd_device_init(adev);
+
+		if (audio_suspended)
+			amdgpu_device_resume_display_audio(tmp_adev);
+	}
+
+	if (need_emergency_restart)
+		goto skip_sched_resume;
+
+	/* Post ASIC reset for all devs .*/
+	list_for_each_entry(tmp_adev, device_list_handle, reset_list) {
 
 		for (i = 0; i < AMDGPU_MAX_RINGS; ++i) {
 			struct amdgpu_ring *ring = tmp_adev->rings[i];
@@ -5384,18 +5406,6 @@ int amdgpu_device_gpu_recover(struct amdgpu_device *adev,
 
 skip_sched_resume:
 	list_for_each_entry(tmp_adev, device_list_handle, reset_list) {
-		/* unlock kfd: SRIOV would do it separately */
-		if (!need_emergency_restart && !amdgpu_sriov_vf(tmp_adev))
-	                amdgpu_amdkfd_post_reset(tmp_adev);
-
-		/* kfd_post_reset will do nothing if kfd device is not initialized,
-		 * need to bring up kfd here if it's not be initialized before
-		 */
-		if (!adev->kfd.init_complete)
-			amdgpu_amdkfd_device_init(adev);
-
-		if (audio_suspended)
-			amdgpu_device_resume_display_audio(tmp_adev);
 		amdgpu_device_unlock_adev(tmp_adev);
 	}
 
-- 
2.53.0



