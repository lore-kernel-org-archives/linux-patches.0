Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5745512B83;
	Sat,  3 Feb 2024 04:14:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933653; cv=none; b=BLE2+OB9H/JJd3zzSnT5ujPKu1kAyqlJJJi+MFb+3Teobf6HPMjjmCpFtrJJzWKm0PV3keqQ/ENemsJSmhSJj9Xl6aE+CO/DTGYJrbGLp1ULjF2RaqQTT/PVAztpCaxrJLNUDFDOjrW3XhY9ny7Vl9VbtsaXdFf7Jxuf6gzkIhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933653; c=relaxed/simple;
	bh=u6Lp8Y/omp8XvFDUl+2NaMOqheVNnVLUFj6xyraFB0s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Q4uwqskrPlB1EJxRiGMOJOo99TJgbr2F6Zgt26Vh2UFJwjs0W4nPZi45E7B+8CjRn+0RuzzUe5JZ9f9XCAjM8C3nEPhvCkzoNyIyf0wxXCMps2SdAczVOGtPqG7ZrpYvRqam2cMsdzdByxfZoWE9RXCknQQGQORg66o/kAJamSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mnN4gg1h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mnN4gg1h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E581C43390;
	Sat,  3 Feb 2024 04:14:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933653;
	bh=u6Lp8Y/omp8XvFDUl+2NaMOqheVNnVLUFj6xyraFB0s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mnN4gg1hwVZaaFVLUDXUr5oDOa0TNkaaMSM4LqR04RLbuUDIK4hmrsHn7u2OegPCo
	 FLjmZApkgKtisUK/7bNHY2Ip7Yh33fRKJOrrfvipu7F37ewxXPHbP0qRDpLFgvKgaw
	 VI478dX9qUgQR92mtguYODUtX28hcBBWL9hpO9tM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Kuehling <Felix.Kuehling@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>,
	Felix Kuehling <felix.kuehling@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 214/322] drm/amdgpu: Drop fence check in to_amdgpu_amdkfd_fence()
Date: Fri,  2 Feb 2024 20:05:11 -0800
Message-ID: <20240203035406.160618096@linuxfoundation.org>
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

[ Upstream commit bf2ad4fb8adca89374b54b225d494e0b1956dbea ]

Return value of container_of(...) can't be null, so null check is not
required for 'fence'. Hence drop its NULL check.

Fixes the below:
drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_fence.c:93 to_amdgpu_amdkfd_fence() warn: can 'fence' even be NULL?

Cc: Felix Kuehling <Felix.Kuehling@amd.com>
Cc: Christian König <christian.koenig@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
Reviewed-by: Felix Kuehling <felix.kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_fence.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_fence.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_fence.c
index 469785d33791..1ef758ac5076 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_fence.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_fence.c
@@ -90,7 +90,7 @@ struct amdgpu_amdkfd_fence *to_amdgpu_amdkfd_fence(struct dma_fence *f)
 		return NULL;
 
 	fence = container_of(f, struct amdgpu_amdkfd_fence, base);
-	if (fence && f->ops == &amdkfd_fence_ops)
+	if (f->ops == &amdkfd_fence_ops)
 		return fence;
 
 	return NULL;
-- 
2.43.0



