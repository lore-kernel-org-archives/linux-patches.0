Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5318A18D65C;
	Wed,  5 Mar 2025 18:10:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741198201; cv=none; b=WlhRPLVn4IQFoW0QqlgSIy58mxFD5VfDp4riW2I168emYUIJciFa2j+As1wtf391t3r79F0kI1RGxzqIgoES8u2cYiF96K7IDPi9l6i75sZCqL1BtUufYvUDWfPKLiV35zwVBEoNjj+6dENuS7P1pKkE13Z4Re8Um5Xv0DcdJQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741198201; c=relaxed/simple;
	bh=bQaIMLfY7IIws/vtVW6aM37t+xCgjIuiPLnoM7yihS0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LxDftGlRxu1j76M4C1UbUyKP3yAjTgU293KBHnnIQADMMtrYz3fv5gllEJj9xgn5HONC8c3y2KxbO17CRSYlcxAwWTeVSsNck+mSjlOYlxIjyMBqgPxtlxhc8CtvvJAp+aVhq7FtxbPRIn7mTOgVf8168jRSisH4sCt1bI5U3NA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tstwp2dJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tstwp2dJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F8E5C4CEE2;
	Wed,  5 Mar 2025 18:10:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741198200;
	bh=bQaIMLfY7IIws/vtVW6aM37t+xCgjIuiPLnoM7yihS0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tstwp2dJ60mLcq5Vf34Eoa1/WaqMVS8LfSebjtsu1NZWtFNxZdlPIJfWSPJbsnuIN
	 bheMsqV3UgvAZ2wEWRajkxgyHU8Krut/+AZx7SZxXNrTsmP7mLM3KQ1QolSZIGvzDy
	 YwTin97jXcHJ2qzdC2Zb20iHRJ4fPhEF90LXJnV8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre-Eric Pelloux-Prayer <pierre-eric.pelloux-prayer@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>
Subject: [PATCH 6.12 098/150] drm/amdgpu: init return value in amdgpu_ttm_clear_buffer
Date: Wed,  5 Mar 2025 18:48:47 +0100
Message-ID: <20250305174507.748621326@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174503.801402104@linuxfoundation.org>
References: <20250305174503.801402104@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


