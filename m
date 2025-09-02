Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85D1828AB1E;
	Tue,  2 Sep 2025 13:43:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756820589; cv=none; b=Gn4V+Z2Grn8z1BGADUgJZoFPmEz4TKJ4rWejGaijNtHmIO33sZEwNGfzgd51SA0fY+m3uQJjpqbiAuhsDUJxAQxcLRT15mZg3Olk9WQE1DkGIP4VuvDBO8IvlSF5Mxp+XiPpqmQDdQn5psnf3gb5qg7NbdsbVg/RhzjgzwdSIbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756820589; c=relaxed/simple;
	bh=PH5h8z37H0L2mK5/yDFWZJaHTzuxCELYrgmSYh0Nc9E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GkfViJPH9XChxcYFTOCn9n+AurNegdytMRQ0SWAfEGTTHX5Zz4AY1uWZij4LgrKGOVJmpc97jVlvkOZLZnQp81/V1MDiKKV9tj2SAu1KJxxPMb9o8yeeAB9W+3faEflYq/XJVLTL5v2IKp1GHSmGFwRnXeWzqTC/DMeU6rJXBjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VeGHYa4Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VeGHYa4Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A65E4C4CEED;
	Tue,  2 Sep 2025 13:43:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756820589;
	bh=PH5h8z37H0L2mK5/yDFWZJaHTzuxCELYrgmSYh0Nc9E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VeGHYa4QuumxLhficw193PGxGYIwhEOft1n4aYeCaEzF6ydEHNbcoTHhn///NzXOg
	 lSOU79kjNYT2//hWkYroYo2VnQjm5XUozmy8V6uK9OW6LJ/XD2MCyDa15zAzBMPjEN
	 Sd5VXg+rwOtjauDuhVNOt9KFYbWaUIghpf+qdJxM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.15 26/33] Revert "drm/amdgpu: fix incorrect vm flags to map bo"
Date: Tue,  2 Sep 2025 15:21:44 +0200
Message-ID: <20250902131928.085837725@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131927.045875971@linuxfoundation.org>
References: <20250902131927.045875971@linuxfoundation.org>
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
@@ -93,8 +93,8 @@ int amdgpu_map_static_csa(struct amdgpu_
 	}
 
 	r = amdgpu_vm_bo_map(adev, *bo_va, csa_addr, 0, size,
-			     AMDGPU_VM_PAGE_READABLE | AMDGPU_VM_PAGE_WRITEABLE |
-			     AMDGPU_VM_PAGE_EXECUTABLE);
+			     AMDGPU_PTE_READABLE | AMDGPU_PTE_WRITEABLE |
+			     AMDGPU_PTE_EXECUTABLE);
 
 	if (r) {
 		DRM_ERROR("failed to do bo_map on static CSA, err=%d\n", r);


