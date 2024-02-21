Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4608D3FB21;
	Wed, 21 Feb 2024 13:40:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708522809; cv=none; b=UkTp1DrLjXZdffvFVZusJpXdJcrv9ps5PL42/rVjaTKMVEketwjKmYRtE9VMtrNB1yo+xtTF01aAb1bwReCnUUH3n0kwevp/ww4fnM1mB4zB4cslZrIRzI1uqZyNOSgESVR/DBENFD8eNp1/XbaHiEp84EvbyftP0KOZGd1Yfu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708522809; c=relaxed/simple;
	bh=mmZHISCwI6qSJBLc+tA+3VucZZjXExbcY+c90chxvWc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RgtHj/fB1ep+/i0ASQH+o0M8QVDru16z3av+/kxmqA46Vz8vW+B7YH3cHHKdmhzmRaQJNdPolBCNXJ5tHa7ZKeZ+gOXzQ5tMR77fjN+mOL9h1kiTBFNuCkAHKhzWaSbdPc4zWAfnmKqLmqtFo3Sbm2NvN1xHGJwkd5VuSsSbLAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=06D2BLW1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="06D2BLW1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C63D3C433F1;
	Wed, 21 Feb 2024 13:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708522809;
	bh=mmZHISCwI6qSJBLc+tA+3VucZZjXExbcY+c90chxvWc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=06D2BLW1JqrqTxFXbjz8+GovjcTvDmU1YOxRcgogu8dx6WuMTXsD3IlbE9cOO8gpj
	 gj4tviLHVPoCAh7JH6qH0vJofYjUskIw9afhrtkdWxw1l5oYWlnJ88Sa+X5LZglNmR
	 ii3Z+lfWX7NTcnuR2pjUPrVCdKNgU8kw6w0zoghM=
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
Subject: [PATCH 5.15 238/476] drm/amdgpu: Drop fence check in to_amdgpu_amdkfd_fence()
Date: Wed, 21 Feb 2024 14:04:49 +0100
Message-ID: <20240221130016.687901450@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 1d0dbff87d3f..fb66e888ab3f 100644
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



