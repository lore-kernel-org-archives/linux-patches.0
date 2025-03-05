Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C6B8255E53;
	Wed,  5 Mar 2025 18:18:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741198725; cv=none; b=tjqCJFoSzls6geF1FVqgMDL76mMnO+LG/1b3AvoXPXAdcHIX16mfZvKMOKv1NCq3okU+i/eoH0qGruHECHLFRIZxwjePJdGSdu2CspZlDqAoyOz9OEe+ouEOv9+U4N5Csv+I7BYVc//5pEnR3nzRstz+3yUPz9qbkvA1aMkp1II=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741198725; c=relaxed/simple;
	bh=VH7UdYV3FBiD7Fp3Cwev5wThqgeOM5+zX3NUEIEbNe8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tFAdTziHpOwkylXRHLKL2fBTAgCiLTm/hF6vcLJoCByadE5Odgi9meNlM/2ojE55P44/v4rD5JMhFPOXImPU7cxcs7nbGzNMJ0OFuBtkBXeQYUuV5EL+geDunFsYmvJG05BE8bMVslyWJoaF3tPWbOrNLBGrI/q1+6Vu05cj1hU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i3JIpnrM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i3JIpnrM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1E24C4CEE0;
	Wed,  5 Mar 2025 18:18:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741198725;
	bh=VH7UdYV3FBiD7Fp3Cwev5wThqgeOM5+zX3NUEIEbNe8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i3JIpnrMTaeCe/4eCJ9BZhoOHbOEokO8Ro20F8g73F0NFKhL9pdWGMkinCPzM66l7
	 N/KaaBs7kmwfFdQPfzugiCCdMqIJAc/ZiBbhRJHGJidtkELk0MQucXB2TiIEMplNZg
	 YApZm5RGhIlIUt1YyNF5+O3JSQJWeii05OME5jeU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre-Eric Pelloux-Prayer <pierre-eric.pelloux-prayer@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>
Subject: [PATCH 6.13 095/157] drm/amdgpu: init return value in amdgpu_ttm_clear_buffer
Date: Wed,  5 Mar 2025 18:48:51 +0100
Message-ID: <20250305174509.132376597@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.268725418@linuxfoundation.org>
References: <20250305174505.268725418@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pierre-Eric Pelloux-Prayer <pierre-eric.pelloux-prayer@amd.com>

commit d3c7059b6a8600fc62cd863f1ea203b8675e63e1 upstream.

Otherwise an uninitialized value can be returned if
amdgpu_res_cleared returns true for all regions.

Possibly closes: https://gitlab.freedesktop.org/drm/amd/-/issues/3812

Fixes: a68c7eaa7a8f ("drm/amdgpu: Enable clear page functionality")
Signed-off-by: Pierre-Eric Pelloux-Prayer <pierre-eric.pelloux-prayer@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 7c62aacc3b452f73a1284198c81551035fac6d71)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
@@ -2280,7 +2280,7 @@ int amdgpu_ttm_clear_buffer(struct amdgp
 	struct amdgpu_ring *ring = adev->mman.buffer_funcs_ring;
 	struct amdgpu_res_cursor cursor;
 	u64 addr;
-	int r;
+	int r = 0;
 
 	if (!adev->mman.buffer_funcs_enabled)
 		return -EINVAL;


