Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C62822AE7F;
	Tue, 26 Aug 2025 14:20:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218041; cv=none; b=S8lzs6Yic1Y8n7ZLShaHUX8dVi7IWBuEKBegKo4CGVGUNpMTVcj+Gt49uNMyCfIr9FMtHNgf3D7tBrlvfV4xN38TQitMMfv1p+OV/GMwQUGQtE6kDXZYZ1e/IYwym4vm/tLSgl3lYPznAC6Wt1/6sItP0p+z99tJo7Wk1Ju383E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218041; c=relaxed/simple;
	bh=5EKgokEl8AD1YbrdvLFFcnrKvUGDJU7q8gq2pQ2rBrI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DkP2rlh5vxxlyKdSwm9Aly4P5ug6dG9ZeoIJztmsbKtLGCBDI+UB0zuwZYJIWiL8qde+cC9kyGBrAHGvxA7vZv5pW0MtHmWDvtvQaX/yFy36Snq6sZBAOZ3j5Ub6UIz7b+U1iXGn6Ib5EQom86XRuT600V5z9CJ7ciqyP9yCh50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rlExmqcw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rlExmqcw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57804C4CEF1;
	Tue, 26 Aug 2025 14:20:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218041;
	bh=5EKgokEl8AD1YbrdvLFFcnrKvUGDJU7q8gq2pQ2rBrI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rlExmqcwKLRcxZEUxR88kyXkzcwDcqiZsFB1LimVsqNmoFcKLcSlxrj8cDwLw1SM8
	 YmPtNRxH4Jig0nZyQyau4EehcDiSzbkXKAr9Eh+XXVRa2GExcyr3jdhy1evqBWKpI6
	 6dnYIJ9L1H73N+XTxkWdOwpidNlkcq0Lm3q8fOsA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jack Xiao <Jack.Xiao@amd.com>,
	Likun Gao <Likun.Gao@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 340/523] drm/amdgpu: fix incorrect vm flags to map bo
Date: Tue, 26 Aug 2025 13:09:10 +0200
Message-ID: <20250826110932.857992367@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 08047bc4d588..2df9e81e2b49 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_csa.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_csa.c
@@ -94,8 +94,8 @@ int amdgpu_map_static_csa(struct amdgpu_device *adev, struct amdgpu_vm *vm,
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



