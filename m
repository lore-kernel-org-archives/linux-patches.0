Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A191C4A33EC
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:49:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772300983; cv=none; b=Zt7FFRsqxvMA0Xrw2aXZ0Z1GCLJNpECgsLXdgOMwemZ8i69wAKtI9e9o6vQ9ZZMKkM4YIVrWBsBcbHPymZLHgZ3BTQ7Ceo/oUsP5fwph4fUpyLL3d5EZ4F+ge22Ze0eomtVP6fB9XnBQtee+Aki35G+lV5DJJMAGfSRX7HOxYHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772300983; c=relaxed/simple;
	bh=l6QofvuS+CaSX3iM2RSm0oFxPH36SSCZb8kic2G8jVo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t9/5JY0UR0kKX0qEIomE0tip3150wvLBXKwCDtnaMyNCmfat7RU/XsuO4VmMgK2ugvrf/DzPYoG7YHow8o/pzDQ27RimYWIfe+Mz6+LHFELTMzraGpYGejd2iDHXMrvwDtkChHgGsPXQTB9+hs5AM79tTSK3zNi10lA9KwONiQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e9ZYR5kn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e9ZYR5kn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC271C116D0;
	Sat, 28 Feb 2026 17:49:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772300983;
	bh=l6QofvuS+CaSX3iM2RSm0oFxPH36SSCZb8kic2G8jVo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e9ZYR5knklbWxQKSAdQhzPEFmLDupMlTfhPGOBu4SRaQXcD6kISRr5e6FN0ELLPXt
	 UtmRgVxkoymjMmOHhdE2XmyyjCy8xbZItYOhZlts9n/+CSVego5yVYetKnmUG8n1VY
	 bS2lZcAfTOgHdID5h9mQppHivdkvJd63l1RgO4E2mXFk/ve8uJXs1WsPczd3mxceHf
	 7vpvnKGO8U0NMFYHb+4omjNY5z20j9qcsca830r7/XWOHP7Tua3dK1W3JTOhu5JMKv
	 JkpGLPf9ubTjWuhQJ/LjHT5pwvDFYkPf1sMiExq9MDKEzmATkIG90OQrAmmYN2sHJt
	 JpxkbGi1fEXNA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Likun Gao <Likun.Gao@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 113/752] drm/amdgpu: fix NULL pointer issue buffer funcs
Date: Sat, 28 Feb 2026 12:37:04 -0500
Message-ID: <20260228174750.1542406-113-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Likun Gao <Likun.Gao@amd.com>

[ Upstream commit 9877a865d62c9c3e0f4cc369dc9ca9f7f24f5ee9 ]

If SDMA block not enabled, buffer_funcs will not initialize,
fix the null pointer issue if buffer_funcs not initialized.

Signed-off-by: Likun Gao <Likun.Gao@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index 53b33a636971a..c052da36aa9c2 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -3280,7 +3280,8 @@ static int amdgpu_device_ip_init(struct amdgpu_device *adev)
 	if (r)
 		goto init_failed;
 
-	if (adev->mman.buffer_funcs_ring->sched.ready)
+	if (adev->mman.buffer_funcs_ring &&
+	    adev->mman.buffer_funcs_ring->sched.ready)
 		amdgpu_ttm_set_buffer_funcs_status(adev, true);
 
 	/* Don't init kfd if whole hive need to be reset during init */
-- 
2.51.0

