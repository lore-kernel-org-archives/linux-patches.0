Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C7C91F4275;
	Tue, 21 Jan 2025 18:05:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482736; cv=none; b=fJL5oxXNfueamnb9vmQjyV3zlLsl6qJY7Ci3UBzTA2QtNCzmKVhtcPbivkdi0C5rKq9d3A7K2QrX765OtY8Ro6wBT6ieo5GBnKg4aFh6MgG9m4rmqqMxY3Zd73qmjK5y6ocT6Thp3G6BdJJpWdlZvRj766xK1uN5R6QJp/U1zjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482736; c=relaxed/simple;
	bh=w1RrjY3cNoK25Y1Jvyey4gh+tnZ8tHjgcixsr+Nm+eM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XMTAUoUTvUYIGxPnogvoMpnJFUxCQSnk5Bt5lK9K/AQ9TZqkzne8Ma+ZVKbJCo6Mzssh1+AFBJq8C9yVZ1Y+3BVqn+pESYmG5BLSFS6/hCZVkreYI4hIcrJCELTKcFOQqGWSGoqgL/NqzFpIIHiD+0rPXC7lpS1jd9Xm6vdj8Qs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iTI5rMST; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iTI5rMST"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 749D8C4CEDF;
	Tue, 21 Jan 2025 18:05:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482735;
	bh=w1RrjY3cNoK25Y1Jvyey4gh+tnZ8tHjgcixsr+Nm+eM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iTI5rMSTsUpZsACsONQnF6bumL1L67+wErJFmcEUmRqp1PIpvB7t4GLtLEqXJCkwZ
	 3egSLT3c0G6d8IdQ5X830e3SMyOpcjjc6jSmNiSpIoeb5OB3qxJXyrqG8XfJ9or2jf
	 hstQirmtEydoaULCY5BsI00+WZtGNgjx94f2uZLo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Salvatore Bonaccorso <carnil@debian.org>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 55/64] Revert "drm/amdgpu: rework resume handling for display (v2)"
Date: Tue, 21 Jan 2025 18:52:54 +0100
Message-ID: <20250121174523.659629130@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174521.568417761@linuxfoundation.org>
References: <20250121174521.568417761@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit c807ab3a861f656bc39471a20a16b36632ac6b04 which is
commit 73dae652dcac776296890da215ee7dec357a1032 upstream.

The original patch 73dae652dcac (drm/amdgpu: rework resume handling for
display (v2)), was only targeted at kernels 6.11 and newer.  It did not
apply cleanly to 6.12 so I backported it and it backport landed as
99a02eab8251 ("drm/amdgpu: rework resume handling for display (v2)"),
however there was a bug in the backport that was subsequently fixed in
063d380ca28e ("drm/amdgpu: fix backport of commit 73dae652dcac").  None
of this was intended for kernels older than 6.11, however the original
backport eventually landed in 6.6, 6.1, and 5.15.

Please revert the change from kernels 6.6, 6.1, and 5.15.

Link: https://lore.kernel.org/r/BL1PR12MB5144D5363FCE6F2FD3502534F7E72@BL1PR12MB5144.namprd12.prod.outlook.com
Link: https://lore.kernel.org/r/BL1PR12MB51449ADCFBF2314431F8BCFDF7132@BL1PR12MB5144.namprd12.prod.outlook.com
Reported-by: Salvatore Bonaccorso <carnil@debian.org>
Reported-by: Christian König <christian.koenig@amd.com>
Reported-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c |   45 +----------------------------
 1 file changed, 2 insertions(+), 43 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -3242,7 +3242,7 @@ static int amdgpu_device_ip_resume_phase
  *
  * @adev: amdgpu_device pointer
  *
- * Second resume function for hardware IPs.  The list of all the hardware
+ * First resume function for hardware IPs.  The list of all the hardware
  * IPs that make up the asic is walked and the resume callbacks are run for
  * all blocks except COMMON, GMC, and IH.  resume puts the hardware into a
  * functional state after a suspend and updates the software state as
@@ -3260,7 +3260,6 @@ static int amdgpu_device_ip_resume_phase
 		if (adev->ip_blocks[i].version->type == AMD_IP_BLOCK_TYPE_COMMON ||
 		    adev->ip_blocks[i].version->type == AMD_IP_BLOCK_TYPE_GMC ||
 		    adev->ip_blocks[i].version->type == AMD_IP_BLOCK_TYPE_IH ||
-		    adev->ip_blocks[i].version->type == AMD_IP_BLOCK_TYPE_DCE ||
 		    adev->ip_blocks[i].version->type == AMD_IP_BLOCK_TYPE_PSP)
 			continue;
 		r = adev->ip_blocks[i].version->funcs->resume(adev);
@@ -3285,36 +3284,6 @@ static int amdgpu_device_ip_resume_phase
 }
 
 /**
- * amdgpu_device_ip_resume_phase3 - run resume for hardware IPs
- *
- * @adev: amdgpu_device pointer
- *
- * Third resume function for hardware IPs.  The list of all the hardware
- * IPs that make up the asic is walked and the resume callbacks are run for
- * all DCE.  resume puts the hardware into a functional state after a suspend
- * and updates the software state as necessary.  This function is also used
- * for restoring the GPU after a GPU reset.
- *
- * Returns 0 on success, negative error code on failure.
- */
-static int amdgpu_device_ip_resume_phase3(struct amdgpu_device *adev)
-{
-	int i, r;
-
-	for (i = 0; i < adev->num_ip_blocks; i++) {
-		if (!adev->ip_blocks[i].status.valid || adev->ip_blocks[i].status.hw)
-			continue;
-		if (adev->ip_blocks[i].version->type == AMD_IP_BLOCK_TYPE_DCE) {
-			r = adev->ip_blocks[i].version->funcs->resume(adev);
-			if (r)
-				return r;
-		}
-	}
-
-	return 0;
-}
-
-/**
  * amdgpu_device_ip_resume - run resume for hardware IPs
  *
  * @adev: amdgpu_device pointer
@@ -3344,13 +3313,6 @@ static int amdgpu_device_ip_resume(struc
 
 	r = amdgpu_device_ip_resume_phase2(adev);
 
-	if (r)
-		return r;
-
-	amdgpu_fence_driver_hw_init(adev);
-
-	r = amdgpu_device_ip_resume_phase3(adev);
-
 	return r;
 }
 
@@ -4349,6 +4311,7 @@ int amdgpu_device_resume(struct drm_devi
 		dev_err(adev->dev, "amdgpu_device_ip_resume failed (%d).\n", r);
 		return r;
 	}
+	amdgpu_fence_driver_hw_init(adev);
 
 	r = amdgpu_device_ip_late_init(adev);
 	if (r)
@@ -5102,10 +5065,6 @@ int amdgpu_do_asic_reset(struct list_hea
 				if (r)
 					goto out;
 
-				r = amdgpu_device_ip_resume_phase3(tmp_adev);
-				if (r)
-					goto out;
-
 				if (vram_lost)
 					amdgpu_device_fill_reset_magic(tmp_adev);
 


