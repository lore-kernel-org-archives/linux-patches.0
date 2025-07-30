Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3D28442C;
	Wed, 30 Jul 2025 09:54:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753869279; cv=none; b=ohHCp1zkHdmlAisBS2A40WH7aeJISSoAR796ydTPgy8/NpaTMfndX8XEsAM3cNye/YYCGuBfmPkyVt/GBnpRaN3yNC0NxYBbhAns9BhHUq1/884pyYFWLFZX35PG/t55FkWsJTk23mZbnMGWhRDj4k0WmLvdbEoGN5f4lFLA2ow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753869279; c=relaxed/simple;
	bh=WRU/cv2aK8OltQ38teLt+tH5bSYX+YfidVHu6KNxcBQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EGftDjmp2rnWxHzjcVHxdPOHQpiZxvh1MNVSOLcXFrRI5ZjspHKwn3mUg+AW9cbllH8H0dYS3acCAySyD5nnEGQpX90Y2bymNkHd2Q/KnqoQ7NwNZoVEfDzO/xUHA95zrGaI7WUdjtnKdTPL+RzVr3KJJjMgrxirpgzZfwlHlmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0SEkxbp3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0SEkxbp3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F5E1C4CEF5;
	Wed, 30 Jul 2025 09:54:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753869279;
	bh=WRU/cv2aK8OltQ38teLt+tH5bSYX+YfidVHu6KNxcBQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0SEkxbp3F3Jz+2zmeBaaAYsY8sXYwZvLsKMy7CkAuTpEDjIb2CDIQ+tyN/kzT7iDf
	 Gua9qs5GdVN2O241la8+UC+9pd0nQsAxNChTFmN05cZMJT60aHbILcmsYm1e9p2FYi
	 6vV62CJOuQEbvgeQztdDMbO7tQdcuK4b04uOZUu8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Jesse Zhang <Jesse.Zhang@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 82/92] drm/amdgpu: Add the new sdma function pointers for amdgpu_sdma.h
Date: Wed, 30 Jul 2025 11:36:30 +0200
Message-ID: <20250730093233.922756298@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730093230.629234025@linuxfoundation.org>
References: <20250730093230.629234025@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jesse.zhang@amd.com <Jesse.zhang@amd.com>

commit 29891842154d7ebca97a94b0d5aaae94e560f61c upstream.

This patch introduces new function pointers in the amdgpu_sdma structure
to handle queue stop, start and soft reset operations. These will replace
the older callback mechanism.

The new functions are:
- stop_kernel_queue: Stops a specific SDMA queue
- start_kernel_queue: Starts/Restores a specific SDMA queue
- soft_reset_kernel_queue: Performs soft reset on a specific SDMA queue

v2: Update stop_queue/start_queue function paramters to use ring pointer instead of device/instance(Chritian)
v3: move stop_queue/start_queue to struct amdgpu_sdma_instance and rename them. (Alex)
v4: rework the ordering a bit (Alex)

Suggested-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Jesse Zhang <Jesse.Zhang@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: 09b585592fa4 ("drm/amdgpu: Fix SDMA engine reset with logical instance ID")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_sdma.h |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_sdma.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_sdma.h
@@ -50,6 +50,12 @@ enum amdgpu_sdma_irq {
 
 #define NUM_SDMA(x) hweight32(x)
 
+struct amdgpu_sdma_funcs {
+	int (*stop_kernel_queue)(struct amdgpu_ring *ring);
+	int (*start_kernel_queue)(struct amdgpu_ring *ring);
+	int (*soft_reset_kernel_queue)(struct amdgpu_device *adev, u32 instance_id);
+};
+
 struct amdgpu_sdma_instance {
 	/* SDMA firmware */
 	const struct firmware	*fw;
@@ -68,7 +74,7 @@ struct amdgpu_sdma_instance {
 	/* track guilty state of GFX and PAGE queues */
 	bool			gfx_guilty;
 	bool			page_guilty;
-
+	const struct amdgpu_sdma_funcs   *funcs;
 };
 
 enum amdgpu_sdma_ras_memory_id {


