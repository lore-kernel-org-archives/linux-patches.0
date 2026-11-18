Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028538;
	b=icz/eC34FiRXGcs0TBfU6h+SlZXHk6PN8DiOzkWilgHRSx3p6caR1+Hane4KGzViC/EU
	 aVsxw0lSndl3ieKGZFUDcuRW0Ud/pY9JYjDBlBxKLDRec/2puAoFA8ZwgTlpEgs5gr+xw
	 IeVptuUFKto60ihq2DD1V+y3W5kUHY2NRr/pixzfhXsC+6ZxmhCePF2BH6CAEdjfFhBOB
	 +gE8o81L5VT6GZuGm6K1S8jMh5W2S6EG1TBCq6jyYAye5Or8YfonilIg5UQMm8FvfcANs
	 bKIuFo59fX4P+W4ijHFeG0ioNv5SGDDlluGi8i5nBCHvnUOWUnw7VYbHekf1t5s7FYA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028538;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/fY3rO8o3AJ/jkzAZq+2AbFLO43WQzjCi8WgYV4hXsg=;
	b=huQV7FhWAWVAD1HsGG6s5VdnQy7KNpvHyyFPQ6fgt5G+DZha9tUNULLSV5ILzpfNPm8A
	 vqvT0xyrik15QHSgQ/hq9QzWcCgMwMcDxr4xeYnRwDtQ39992jD21RiqgTxojpfOTzclr
	 tvAsZePvugjHZ+wutFlm91/qKyApGRqVgjifKvyfvWjS0tIl+KIUvd96kQrPGRkdx/3D6
	 h/NvREZbgDBOUce+JEr2mfiD8cSwwpltJkWsm+auH63Xv8DyNzSNUNYg/UOKR2yDvLDf9
	 9HPIjmtvnKm4ROSZAmgibUu4AcmGPBdV7Ym3zkeQjrNAvmay8QkwNekmuZmuIyNPzeA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BPZ+RQzf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DB37606A31C;
	Wed, 18 Nov 2026 19:02:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BPZ+RQzf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C73351F000C4;
	Wed, 18 Nov 2026 19:02:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028538;
	bh=/fY3rO8o3AJ/jkzAZq+2AbFLO43WQzjCi8WgYV4hXsg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BPZ+RQzftS3TaIhG8to4P0T3QrJ//qD9+f6BSd3RUy+RfPZfrD1qsRgKRhjx4ZYof
	 BN+9l5O8433ZpEHH2MY9L07FTmSYfdioZFg/yPwWP/uL4AY1ceKg3u8sZuL8Lq6LGH
	 1HeltZMwY9/AqAO2Mb4nOLC+A49og1fidCOIDf9g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prike Liang <Prike.Liang@amd.com>,
	Lijo Lazar <lijo.lazar@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0032/1756] drm/amdgpu: finish GPU recovery callbacks before restarting schedulers
Date: Wed, 18 Nov 2026 15:35:59 +0100
Message-ID: <20261118150009.142238260@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: adapted resume helper reordering to existing inline code in amdgpu_device_gpu_recover() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 48 +++++++++++-----------
 1 file changed, 25 insertions(+), 23 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index 037cb9ce69e42..798e82769e789 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -6030,7 +6030,7 @@ int amdgpu_device_gpu_recover(struct amdgpu_device *adev,
 	}
 
 	if (need_emergency_restart)
-		goto skip_sched_resume;
+		goto post_resume;
 
 	/*
 	 * Must check guilty signal here since after this point all old
@@ -6041,7 +6041,7 @@ int amdgpu_device_gpu_recover(struct amdgpu_device *adev,
 	if (job && dma_fence_is_signaled(&job->hw_fence.base)) {
 		job_signaled = true;
 		dev_info(adev->dev, "Guilty job already signaled, skipping HW reset");
-		goto skip_hw_reset;
+		goto post_resume;
 	}
 
 retry:	/* Rest of adevs pre asic reset from XGMI hive. */
@@ -6087,7 +6087,28 @@ int amdgpu_device_gpu_recover(struct amdgpu_device *adev,
 		amdgpu_device_stop_pending_resets(tmp_adev);
 	}
 
-skip_hw_reset:
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
+
+		amdgpu_device_unset_mp1_state(tmp_adev);
+
+		amdgpu_ras_set_error_query_ready(tmp_adev, true);
+	}
+
+	if (need_emergency_restart)
+		goto reset_unlock;
 
 	/* Post ASIC reset for all devs .*/
 	list_for_each_entry(tmp_adev, device_list_handle, reset_list) {
@@ -6126,26 +6147,7 @@ int amdgpu_device_gpu_recover(struct amdgpu_device *adev,
 		}
 	}
 
-skip_sched_resume:
-	list_for_each_entry(tmp_adev, device_list_handle, reset_list) {
-		/* unlock kfd: SRIOV would do it separately */
-		if (!need_emergency_restart && !amdgpu_sriov_vf(tmp_adev))
-			amdgpu_amdkfd_post_reset(tmp_adev);
-
-		/* kfd_post_reset will do nothing if kfd device is not initialized,
-		 * need to bring up kfd here if it's not be initialized before
-		 */
-		if (!adev->kfd.init_complete)
-			amdgpu_amdkfd_device_init(adev);
-
-		if (audio_suspended)
-			amdgpu_device_resume_display_audio(tmp_adev);
-
-		amdgpu_device_unset_mp1_state(tmp_adev);
-
-		amdgpu_ras_set_error_query_ready(tmp_adev, true);
-	}
-
+reset_unlock:
 	tmp_adev = list_first_entry(device_list_handle, struct amdgpu_device,
 					    reset_list);
 	amdgpu_device_unlock_reset_domain(tmp_adev->reset_domain);
-- 
2.53.0



