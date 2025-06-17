Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34B8C2F234A;
	Tue, 17 Jun 2025 15:54:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175688; cv=none; b=QmDZxbzASZv8C6oGxGA3icESn82D55C2AdrsmDdaRsjRCwVRstKh3AR0lgfWA2SF/N5W2djz123ifrVTPVlfHWzBKxHhfrr0r8PrJYJDJq8rpiSUYHogNaTpeX8RxrAWm2SqUWNUIKLeMLBHj4wIAzDsivLlT7JHtJf+D19FjHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175688; c=relaxed/simple;
	bh=V9bjLif/hHFKNL3NuAIwW9oL8ROKO/D6AKEJpOe58sw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gJBk9qSRIIDXs6jJ9r5M6wccbophFLhxGtFEAhtAhd4ERPPHaHc3O2SsI6e82PbHQlJFJIkOk8prEYkU65+gu1mcZRP58fAF7LJculhmpf/0GRwVMjoN/ynffl2T6U4KeJYCnF0HFvjGqT6IJiKhruMu5lqQGZF/lR4s7/mxFSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fDwAr0Qc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fDwAr0Qc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 983D5C4CEE3;
	Tue, 17 Jun 2025 15:54:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175688;
	bh=V9bjLif/hHFKNL3NuAIwW9oL8ROKO/D6AKEJpOe58sw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fDwAr0QcSq7hmu2kzeQXTkNDd+pK9m82xxAEC1br82evAz+pCaeFm8+qj9/Vdc7UX
	 bjpIUOdTIyU+h4iwhXjZYUUsMSTh7ydn2w6vcArB4a5cOoDSTI9smHg4HMiPyVQ3jS
	 FekLVk9wo/ReddOkVw4FkhVpO5FoALDj/w6NENm8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 113/780] drm/amdgpu: Refine Cleaner Shader MEC firmware version for GFX10.1.x GPUs
Date: Tue, 17 Jun 2025 17:17:01 +0200
Message-ID: <20250617152456.108686342@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>

[ Upstream commit d30f61076268fd7ce01e4ec9e4d84bfaf90365f7 ]

Update the minimum firmware version for the Cleaner Shader in the
gfx_v10_0_sw_init function.

This change adjusts the minimum required firmware version for the MEC
firmware from 152 to 151, allowing for broader compatibility with
GFX10.1 GPUs.

Fixes: 25961bad9212 ("drm/amdgpu/gfx10: Add cleaner shader for GFX10.1.10")
Cc: Christian König <christian.koenig@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
index 23e6a05359c24..c68c2e2f4d61a 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
@@ -4800,7 +4800,7 @@ static int gfx_v10_0_sw_init(struct amdgpu_ip_block *ip_block)
 		adev->gfx.cleaner_shader_size = sizeof(gfx_10_1_10_cleaner_shader_hex);
 		if (adev->gfx.me_fw_version >= 101 &&
 		    adev->gfx.pfp_fw_version  >= 158 &&
-		    adev->gfx.mec_fw_version >= 152) {
+		    adev->gfx.mec_fw_version >= 151) {
 			adev->gfx.enable_cleaner_shader = true;
 			r = amdgpu_gfx_cleaner_shader_sw_init(adev, adev->gfx.cleaner_shader_size);
 			if (r) {
-- 
2.39.5



