Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAD20334721;
	Mon, 18 Aug 2025 14:10:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755526246; cv=none; b=dWwRDWE+JyVkwKjqcqZrcuK/8H6rtYjOaO4QGweyYawpS8GvvJx+qoMlu/O1wDDE8192mwFTlORysU7+1CICBdcnSO7WAlJClr/k7D0Oha6oEIZwhEKxxkMqJu+JJiUteP3UNhhymFEPF+Q4ffY28kDgqBtPRQucZAQb0MLGmo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755526246; c=relaxed/simple;
	bh=udOoNcx5xSZwkwjM4xqxR15Zzrs+5awSyU+BXF2f3Vo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mvpOoPtHVYfpi/TyGSgXgm4gdkYuCuYxU/B4HMchkAdG7AF5A+LVNl6DuRdi6YlWg3dM6RlibPfWR+4eCpq26pxx6/rA/t2wAgWndGUGTsUG8/gu3mfql76Heksj73FL91y4QGNh8s6/g0Q7uYRvqxNdW9VyckMq8kV05E0bH3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I4osgvX6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I4osgvX6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 669DDC4CEEB;
	Mon, 18 Aug 2025 14:10:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755526246;
	bh=udOoNcx5xSZwkwjM4xqxR15Zzrs+5awSyU+BXF2f3Vo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I4osgvX6cXKfvxk4Zq277D1d+KptVbOS6GhTIRP2BOVZSPqTGegnnYSdcJ/l0/1PJ
	 lxurt1rsyBXuKdd9aiFTjKKIUTNwaF01pGiFWcMNoOtQqXLqjUhBzguO19QEyJvECb
	 Kn5lcHNEpICy/E3zYGiYcE5YSAbCsFBBza7X4OGc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jack Xiao <Jack.Xiao@amd.com>,
	Likun Gao <Likun.Gao@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 482/570] drm/amdgpu: fix incorrect vm flags to map bo
Date: Mon, 18 Aug 2025 14:47:49 +0200
Message-ID: <20250818124524.452481295@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index 02138aa55793..dfb6cfd83760 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_csa.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_csa.c
@@ -88,8 +88,8 @@ int amdgpu_map_static_csa(struct amdgpu_device *adev, struct amdgpu_vm *vm,
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



