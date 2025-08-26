Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE74E2B9A7;
	Tue, 26 Aug 2025 13:56:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216595; cv=none; b=njUmV/klUzxOkUKSWLSOmnSbvA1rKT9ErUTXqanfXjCSNOeX64n0nCs/gOwzoZwA7q+1Hw1R2AhfkP8AY61oiJw0v5W7dGXIsUjl3/1h2vZSLPKf4eXhyZ28puL6yV9ox2q22ybCYAE8+XFhVRpOPoR4B3xFLLynQ/vs5vhC0NU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216595; c=relaxed/simple;
	bh=jUudxoz0cOL05gLIcky5SHb0eI8NYTQzoyPLXC9rieY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dJl5MH8atZpgd1oMhZnpXzAbGacYJtFlk3bbApn+Gr9s/OFb5gaSv6Jxw51K+O0snmlB3PmL33C9mx5ruvGgtoiUjeDD5J2SsoD0TZ2wIT8GJmF/8youixExrUM7VSOHmf2gnPZY2710TDYcIivbYKh+hiDh4caADZSqtbsljyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yrSvenJl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yrSvenJl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FEE7C4CEF1;
	Tue, 26 Aug 2025 13:56:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216595;
	bh=jUudxoz0cOL05gLIcky5SHb0eI8NYTQzoyPLXC9rieY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yrSvenJlPGfbtDGifTxPPTJ5aewHW1NaD7yBSmzomD2STwN6Q5KxZ5aCgQ3SxTutR
	 wdiApzsqx+kOLE/a/BKhVlKgIIPQLX0LARmMXm5eoKzrCQGSI/asJIhmgU0veIDoay
	 QnQ+4opWgw2z2mHk7QFfhY+IhFf42uWHW5YxhXnM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jack Xiao <Jack.Xiao@amd.com>,
	Likun Gao <Likun.Gao@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 439/644] drm/amdgpu: fix incorrect vm flags to map bo
Date: Tue, 26 Aug 2025 13:08:50 +0200
Message-ID: <20250826110957.344011797@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jack Xiao <Jack.Xiao@amd.com>

[ Upstream commit 040bc6d0e0e9c814c9c663f6f1544ebaff6824a8 ]

It should use vm flags instead of pte flags
to specify bo vm attributes.

Fixes: 7946340fa389 ("drm/amdgpu: Move csa related code to separate file")
Signed-off-by: Jack Xiao <Jack.Xiao@amd.com>
Reviewed-by: Likun Gao <Likun.Gao@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit b08425fa77ad2f305fe57a33dceb456be03b653f)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_csa.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_csa.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_csa.c
index da21e60bb827..f5441ce15373 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_csa.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_csa.c
@@ -93,8 +93,8 @@ int amdgpu_map_static_csa(struct amdgpu_device *adev, struct amdgpu_vm *vm,
 	}
 
 	r = amdgpu_vm_bo_map(adev, *bo_va, csa_addr, 0, size,
-			     AMDGPU_PTE_READABLE | AMDGPU_PTE_WRITEABLE |
-			     AMDGPU_PTE_EXECUTABLE);
+			     AMDGPU_VM_PAGE_READABLE | AMDGPU_VM_PAGE_WRITEABLE |
+			     AMDGPU_VM_PAGE_EXECUTABLE);
 
 	if (r) {
 		DRM_ERROR("failed to do bo_map on static CSA, err=%d\n", r);
-- 
2.50.1



