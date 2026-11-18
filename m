Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060002;
	b=XCTTqexYUg6E9rdHelwRPFzKoVJkwOmN9OdIAgtO67DUoQDS76gId15bD9nIZbiBSzKp
	 ZulU4fzQbiVuQUGK8rcHYfV+VOar5b32wRW6FeW6Pz1b85Iud01gqcR4b3ahMiBaPctcr
	 2W1w8bNKK8dSzZH0KGSdh+IJNAzaRmY8MSNRqbGnIQnc+iKPJEuheHNdzoDq5yHS0+Ggy
	 VmBINAIPEGPwXfCO6UjWliuDiIs5WPqMCG3scWoG36SpGVfJLvDi0/+wwipRComE5+zrm
	 Mr/D4wEk+X/zNQneqOimzyxo8/2XtAHP9sfRStuGWzyXWjDe0TLb3EKoUVD7ulKIpSw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060002;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Y7MKUmrqjvrhCyp0fDqRbN1uhZ2AJxlSQJGZTXfidhg=;
	b=Gw/CnpMfe02ptlL6gDEpcQbRPsPj8v/lXQQZGTN5JT6+D+MSpZlq73ApzkBA5IjwuZ71
	 v4i+2KHzJaep2+ENQpJbfHv8tPwE+tQxh4syXJ23msNLQDjQauig30Sxit6oFQHJqT/7r
	 r+IVM2weca4q5YFam8U6ZnMi2AhVHla6Ifcs8lZRWKSMF6Jsypa3tdkeIuIYv/a6Fv3RV
	 5+Bi1lPa7mEt6ZKmJp0Pq2XHWFhHEezsPo34zHl/ZsqRV/sc4mnw6Pudk691uDlDc0PmO
	 65KU3SSgcpKCA0MvlkYtiOLkcNTHLT4m2WjE18MiGNKTEc1ytQ1+JCS66gm8Xaz1/Cg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1Hl4abRU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 685AC606A320;
	Thu, 19 Nov 2026 03:46:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1Hl4abRU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE5AE1F000C4;
	Thu, 19 Nov 2026 03:46:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060002;
	bh=Y7MKUmrqjvrhCyp0fDqRbN1uhZ2AJxlSQJGZTXfidhg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1Hl4abRUVmzAXN+s9zHDkNunUKIfncqnDNSjezn0wkCzAB12s261Ck5faoEbLq3lr
	 Hqjh6vVOFVv7lVK24UjlOoNAkh76Myx+ZcJBvHdPqdJthQg/4kRmP86PZrLGyT2rTm
	 jElhWWisjBE8AO7jdfgtr4tfyuICtTpaMQ6dsJgk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prike Liang <Prike.Liang@amd.com>,
	Lijo Lazar <lijo.lazar@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1043/1848] drm/amdgpu: finish GPU recovery callbacks before restarting schedulers
Date: Wed, 18 Nov 2026 15:51:21 +0100
Message-ID: <20261118150000.996567505@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: adapted recovery helper reordering to inline callback code in amdgpu_device_gpu_recover() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index 873346c377787..ea0fd088c97f5 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -4646,7 +4646,7 @@ int amdgpu_device_gpu_recover(struct amdgpu_device *adev,
 	}
 
 	if (need_emergency_restart)
-		goto skip_sched_resume;
+		goto post_resume;
 
 	/*
 	 * Must check guilty signal here since after this point all old
@@ -4658,7 +4658,7 @@ int amdgpu_device_gpu_recover(struct amdgpu_device *adev,
 	    dma_fence_is_signaled(job->base.s_fence->parent)) {
 		job_signaled = true;
 		dev_info(adev->dev, "Guilty job already signaled, skipping HW reset");
-		goto skip_hw_reset;
+		goto post_resume;
 	}
 
 retry:	/* Rest of adevs pre asic reset from XGMI hive. */
@@ -4686,7 +4686,17 @@ int amdgpu_device_gpu_recover(struct amdgpu_device *adev,
 			goto retry;
 	}
 
-skip_hw_reset:
+post_resume:
+	list_for_each_entry(tmp_adev, device_list_handle, gmc.xgmi.head) {
+		/* unlock kfd: SRIOV would do it separately */
+		if (!need_emergency_restart && !amdgpu_sriov_vf(tmp_adev))
+			amdgpu_amdkfd_post_reset(tmp_adev);
+		if (audio_suspended)
+			amdgpu_device_resume_display_audio(tmp_adev);
+	}
+
+	if (need_emergency_restart)
+		goto skip_sched_resume;
 
 	/* Post ASIC reset for all devs .*/
 	list_for_each_entry(tmp_adev, device_list_handle, gmc.xgmi.head) {
@@ -4721,11 +4731,6 @@ int amdgpu_device_gpu_recover(struct amdgpu_device *adev,
 
 skip_sched_resume:
 	list_for_each_entry(tmp_adev, device_list_handle, gmc.xgmi.head) {
-		/*unlock kfd: SRIOV would do it separately */
-		if (!need_emergency_restart && !amdgpu_sriov_vf(tmp_adev))
-	                amdgpu_amdkfd_post_reset(tmp_adev);
-		if (audio_suspended)
-			amdgpu_device_resume_display_audio(tmp_adev);
 		amdgpu_device_unlock_adev(tmp_adev);
 	}
 
-- 
2.53.0



