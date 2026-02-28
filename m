Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 793CC4A33F0
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:49:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772300984; cv=none; b=XEgFKv9aAbOoVzcGwEa2a/F6QK0LqcrxhvCxriwYhELw3dLFB14UtCkm9tVg94FDGhNxlRsCKEMd0SlyitJrCmL1QiqN/hUaBCdO7L5RcfmLryVDWrT1kvqhMJEFKPfQ50cWM4yrC2twlq6hwlatDcqkQgIjouwEYHiY16jA8vw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772300984; c=relaxed/simple;
	bh=VDQQtUXxbL8NRp1GgVvxGTudy3q36CIHRKAFiuh3qZI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZIqBcO4W1uiqkDh97zTpnZ+LwpmGbLRZsmKrDiXUgVdEJuNQSLMLTRQkjI2zWPogVta5mlIA1RmJu905nh5ayXzKW7Sq9W2CZZzAZ86bEKxZl2L3zsNZ9SzfgYXooPhgv516GT8w2GegIulguvtyQaEhBDAu+kWZCLR532GNINI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MmO/AEGA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MmO/AEGA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7050C116D0;
	Sat, 28 Feb 2026 17:49:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772300984;
	bh=VDQQtUXxbL8NRp1GgVvxGTudy3q36CIHRKAFiuh3qZI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MmO/AEGAgK6mX5vLiXuNSm8bwVeZ4TGrFwbFgZNaUTEjieztaf37kHBQ1VeQHKhiL
	 7jQEjt86//2+2Evv0rL3/K+TJJ7Wd3Ps9QkYuvlK10MmuqRQS4JzZCykUeN5gAzFiH
	 Hl1L98Xl7QZ1gW2IT8GoTMA+A8G/dxCPCVLIqOtef/uXE9yUvg6Db9cTa45f5L+n/b
	 FzW/eLO9htNTEtmBYczSIyYEQCRZNEkFsJ1yF4lPOkBcaoFbC7yKJ4fov/zroxcHV0
	 85bm1Pd5IeLdkbApbqj676EfFrMg77lT9td4W4y1c8+eqqQHVm8So6BmS+WPhnzFZG
	 OSOGCsgcVGq+w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Tao Zhou <tao.zhou1@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 114/752] drm/amdgpu: fix the calculation of RAS bad page number
Date: Sat, 28 Feb 2026 12:37:05 -0500
Message-ID: <20260228174750.1542406-114-sashal@kernel.org>
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

From: Tao Zhou <tao.zhou1@amd.com>

[ Upstream commit f752e79d38857011f1293fcb6c810409c3b669ee ]

__amdgpu_ras_restore_bad_pages is responsible for the maintenance of bad
page number, drop the unnecessary bad page number update in the error
handling path of add_bad_pages.

Signed-off-by: Tao Zhou <tao.zhou1@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
index 3fd19859055a5..ca5f99df1ac20 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
@@ -3056,8 +3056,6 @@ int amdgpu_ras_add_bad_pages(struct amdgpu_device *adev,
 						/* deal with retire_unit records a time */
 						ret = __amdgpu_ras_convert_rec_array_from_rom(adev,
 										&bps[i], &err_data, nps);
-						if (ret)
-							con->bad_page_num -= adev->umc.retire_unit;
 						i += (adev->umc.retire_unit - 1);
 					} else {
 						break;
@@ -3070,8 +3068,6 @@ int amdgpu_ras_add_bad_pages(struct amdgpu_device *adev,
 		for (; i < pages; i++) {
 			ret = __amdgpu_ras_convert_rec_from_rom(adev,
 				&bps[i], &err_data, nps);
-			if (ret)
-				con->bad_page_num -= adev->umc.retire_unit;
 		}
 
 		con->eh_data->count_saved = con->eh_data->count;
-- 
2.51.0

