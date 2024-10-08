Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39EBE1DE3A3;
	Tue,  8 Oct 2024 12:53:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391984; cv=none; b=L1jUmsNiayVyyTavLSzXut02dNl8IMKtrdSvVmwm4CeqxoR1ha3hb6CpGLB5jn83CSrL3jFzUXolqKtjRwGzYeY1oN+bxkgv3pOd0TsyFVunlZnpChkic4hr+Flo1bpmj65q/AkSdZ7COt1jxWNCRVg/CNvgyO+MsZ2BclcbX+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391984; c=relaxed/simple;
	bh=U0EA+t5ccVf6rSitBXb/KVEedLPN12rRZ6JJ9ngIous=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G3tAtOWYwVwFs/AlfVkeir3aDGPszwKSCHFn4Xc88u5vQj/zY6NXXQza2iir//YXgCDF52/2ZADsYEVzCUhaiEuZvAebtQhhVqXi+QRY6Oloj878HiK2tpLk1C8Dp4Ows9T5lf6fkUsav0IHjAqxUteBSLc6z4a0cIrRT+12dc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VZkP0DE5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VZkP0DE5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F908C4CEC7;
	Tue,  8 Oct 2024 12:53:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391984;
	bh=U0EA+t5ccVf6rSitBXb/KVEedLPN12rRZ6JJ9ngIous=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VZkP0DE5aMr3caaEn4X61zY1+Cxw9hnoYcFNbVgcIHLp/Br+SfqijD6YmADg4tcQ2
	 17yhloOK/W2dfolZCvrEIHRz3SB8Hvbo/gmWDfqBzAoi8KGMxK6wQs8fsAgnMiMsfZ
	 Bh5/5Yv/r94G68WZF7xQE6sn5YxOF04By6EyDUeI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Sunil Khatri <sunil.khatri@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 282/558] drm/amdgpu: fix ptr check warning in gfx10 ip_dump
Date: Tue,  8 Oct 2024 14:05:12 +0200
Message-ID: <20241008115713.423631740@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sunil Khatri <sunil.khatri@amd.com>

[ Upstream commit 98df5a7732e3b78bf8824d2938a8865a45cfc113 ]

Change condition, if (ptr == NULL) to if (!ptr)
for a better format and fix the warning.

Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sunil Khatri <sunil.khatri@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
index e444e621ddaa0..5b41c6a44068c 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
@@ -4649,7 +4649,7 @@ static void gfx_v10_0_alloc_ip_dump(struct amdgpu_device *adev)
 	uint32_t inst;
 
 	ptr = kcalloc(reg_count, sizeof(uint32_t), GFP_KERNEL);
-	if (ptr == NULL) {
+	if (!ptr) {
 		DRM_ERROR("Failed to allocate memory for GFX IP Dump\n");
 		adev->gfx.ip_dump_core = NULL;
 	} else {
@@ -4662,7 +4662,7 @@ static void gfx_v10_0_alloc_ip_dump(struct amdgpu_device *adev)
 		adev->gfx.mec.num_queue_per_pipe;
 
 	ptr = kcalloc(reg_count * inst, sizeof(uint32_t), GFP_KERNEL);
-	if (ptr == NULL) {
+	if (!ptr) {
 		DRM_ERROR("Failed to allocate memory for Compute Queues IP Dump\n");
 		adev->gfx.ip_dump_compute_queues = NULL;
 	} else {
@@ -4675,7 +4675,7 @@ static void gfx_v10_0_alloc_ip_dump(struct amdgpu_device *adev)
 		adev->gfx.me.num_queue_per_pipe;
 
 	ptr = kcalloc(reg_count * inst, sizeof(uint32_t), GFP_KERNEL);
-	if (ptr == NULL) {
+	if (!ptr) {
 		DRM_ERROR("Failed to allocate memory for GFX Queues IP Dump\n");
 		adev->gfx.ip_dump_gfx_queues = NULL;
 	} else {
-- 
2.43.0



