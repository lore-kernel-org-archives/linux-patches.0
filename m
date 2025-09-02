Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2421731E0FD;
	Tue,  2 Sep 2025 13:45:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756820742; cv=none; b=QzFpma5Eep/xUdy74hh39lamuJW1M90OkLA4eliDSlqoiyUOo/D46015sRItAMNCIpXr+YatGWc+8mDDJXxEiicv1071AsxiP/mn0VNo8V8UJWi6ujxt9/1p4daCoTQGq9qt8/l88ZFZBjcBRjYRC/CtbY1RWOouB9EjcbzYMVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756820742; c=relaxed/simple;
	bh=shBAnC5QA8D7/Ukszc5oDJLC7tteV2UTEZYHT32HLLY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=paaSKEjLumVZRM90ajGQFhy4Qi5Qse8E/e/kK17+Hg5Z98C9jPmJlHchmbyYfUFxml8m0n7Lcxf5h0MX5v8teGIse2OqrjX4gzSo7bUq7NzPBVq85bXxa0ABDtiz3GZi9XY6cuoNykQl6AMbFGg6wvlGB6gm3eX3+1QmKOKZQi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Yev+Huiy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Yev+Huiy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89860C4CEED;
	Tue,  2 Sep 2025 13:45:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756820742;
	bh=shBAnC5QA8D7/Ukszc5oDJLC7tteV2UTEZYHT32HLLY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Yev+Huiyq5U5RQhJiQLvrQeIulVeIOwZ/+eosANu8GgHneb6Sb8yADwM/YT/uG4Bz
	 POzHyEaQ7bTn2Dr9dPMV8HK9V++/T7YocPyf7IZxNCaZ5K9mY8CZmQqA96HWXXg/ub
	 lAWtuaLvf/RUDWcZ7YwNKH8DWKcrarDZqqZoOKt0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.10 23/34] Revert "drm/amdgpu: fix incorrect vm flags to map bo"
Date: Tue,  2 Sep 2025 15:21:49 +0200
Message-ID: <20250902131927.542121805@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131926.607219059@linuxfoundation.org>
References: <20250902131926.607219059@linuxfoundation.org>
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

From: Alex Deucher <alexander.deucher@amd.com>

commit ac4ed2da4c1305a1a002415058aa7deaf49ffe3e upstream.

This reverts commit b08425fa77ad2f305fe57a33dceb456be03b653f.

Revert this to align with 6.17 because the fixes tag
was wrong on this commit.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit be33e8a239aac204d7e9e673c4220ef244eb1ba3)
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_csa.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_csa.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_csa.c
@@ -94,8 +94,8 @@ int amdgpu_map_static_csa(struct amdgpu_
 	}
 
 	r = amdgpu_vm_bo_map(adev, *bo_va, csa_addr, 0, size,
-			     AMDGPU_VM_PAGE_READABLE | AMDGPU_VM_PAGE_WRITEABLE |
-			     AMDGPU_VM_PAGE_EXECUTABLE);
+			     AMDGPU_PTE_READABLE | AMDGPU_PTE_WRITEABLE |
+			     AMDGPU_PTE_EXECUTABLE);
 
 	if (r) {
 		DRM_ERROR("failed to do bo_map on static CSA, err=%d\n", r);


