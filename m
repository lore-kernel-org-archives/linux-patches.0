Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2681412B9A;
	Sat,  3 Feb 2024 04:14:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933667; cv=none; b=cW7IIyM1SEmbLnXAtzWH71WVKu4qcdGBti4jPNOYk2+AAA1PXyteFVJWoCs4lrLLc40yek5DwGZMVvo/9jzIfethaapumKtKFz3hOzVJEeS5597mNatDQuZvqRLlDX7v3+qAZTJSjb5qv+nidqEVvqYj9uRWl0SbvByRp7vXWCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933667; c=relaxed/simple;
	bh=yPbbo8h4XWvtDuAqAmYpRWDcFwn61VmtQhWd4c4iCLU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pYJ6YJDUrlTgTD8cj41GCX158O/i9fDTzy+Ab2kT02mRwT3eRGje01ObY4wywi5egQV+iua5WQC8xSuFfZDle1RpHMZr3zE+6+C8hR2t/gFOgFbEDme/0k27WbhMYi7PH4A1GmIM0WYbfhBxDhNZlx/KwUcMK07mV2g2eKnsFMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UC0RuiMz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UC0RuiMz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E399EC43390;
	Sat,  3 Feb 2024 04:14:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933667;
	bh=yPbbo8h4XWvtDuAqAmYpRWDcFwn61VmtQhWd4c4iCLU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UC0RuiMzqiuuJMn1JIH8901aXeNR9Q8iT8wbr7qzTqMorqYCKtL+fGoy/hOEh7Duo
	 DSgOyQ55+4aZ+gGgBj6TvtGn8/0YyG2aoRrcarDC079y60yvfVN9bBjUq+BlIOmxI8
	 XriniWaBC+k2Xf/diYnCShYttpknaFJzyZOIpOl0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiaojian Du <Xiaojian.Du@amd.com>,
	Lijo Lazar <lijo.lazar@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 255/322] drm/amdgpu: Fix with right return code -EIO in amdgpu_gmc_vram_checking()
Date: Fri,  2 Feb 2024 20:05:52 -0800
Message-ID: <20240203035407.393194105@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035359.041730947@linuxfoundation.org>
References: <20240203035359.041730947@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>

[ Upstream commit fac4ebd79fed60e79cccafdad45a2bb8d3795044 ]

The amdgpu_gmc_vram_checking() function in emulation checks whether
all of the memory range of shared system memory could be accessed by
GPU, from this aspect, -EIO is returned for error scenarios.

Fixes the below:
drivers/gpu/drm/amd/amdgpu/gmc_v6_0.c:919 gmc_v6_0_hw_init() warn: missing error code? 'r'
drivers/gpu/drm/amd/amdgpu/gmc_v7_0.c:1103 gmc_v7_0_hw_init() warn: missing error code? 'r'
drivers/gpu/drm/amd/amdgpu/gmc_v8_0.c:1223 gmc_v8_0_hw_init() warn: missing error code? 'r'
drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c:2344 gmc_v9_0_hw_init() warn: missing error code? 'r'

Cc: Xiaojian Du <Xiaojian.Du@amd.com>
Cc: Lijo Lazar <lijo.lazar@amd.com>
Cc: Christian König <christian.koenig@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
Suggested-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c
index d78bd9732543..bc0eda1a729c 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c
@@ -876,21 +876,28 @@ int amdgpu_gmc_vram_checking(struct amdgpu_device *adev)
 	 * seconds, so here, we just pick up three parts for emulation.
 	 */
 	ret = memcmp(vram_ptr, cptr, 10);
-	if (ret)
-		return ret;
+	if (ret) {
+		ret = -EIO;
+		goto release_buffer;
+	}
 
 	ret = memcmp(vram_ptr + (size / 2), cptr, 10);
-	if (ret)
-		return ret;
+	if (ret) {
+		ret = -EIO;
+		goto release_buffer;
+	}
 
 	ret = memcmp(vram_ptr + size - 10, cptr, 10);
-	if (ret)
-		return ret;
+	if (ret) {
+		ret = -EIO;
+		goto release_buffer;
+	}
 
+release_buffer:
 	amdgpu_bo_free_kernel(&vram_bo, &vram_gpu,
 			&vram_ptr);
 
-	return 0;
+	return ret;
 }
 
 static ssize_t current_memory_partition_show(
-- 
2.43.0



