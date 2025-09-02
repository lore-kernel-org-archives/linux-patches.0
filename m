Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F39DF32ED43;
	Tue,  2 Sep 2025 13:42:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756820527; cv=none; b=Z5mB/BXBTLrJeaKlEic7YM6KASu1EDPCDVNXwylZfPZq0lWGf2LFefUKx1N4zIP+/hhlFt4XjgUpM8io8Rj2UKYcdjDML6ZUMkrqQZf6+17jLX/RLF/C6QNp/cicvUW+dZtxZF9S43hkR4LfQ5xl1EkcjdYVlrpF6P8L9TQU4kM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756820527; c=relaxed/simple;
	bh=RfjKCZBIWxhRJEzFBY2qWvTe5ZjQzYn7HrWMsRoJT/U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WcrHC6jDK7loVG7SNLXM2DVzcjFwRvLimYbDaR1UsW0wiOX1p35182Vm9YHkJW4H9/ORhvwyhTKoKRgd6I8W7EETuGFNhlOgMGHJAFb9GriFzz10F7gfP3ubRW/aNY60TrxVuxzszKAcxFVQ9RNBcM0TySzaGtbjjiBEw2muSsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a9KoBA5V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a9KoBA5V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BFC6C4CEED;
	Tue,  2 Sep 2025 13:42:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756820526;
	bh=RfjKCZBIWxhRJEzFBY2qWvTe5ZjQzYn7HrWMsRoJT/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a9KoBA5V33ivBObg9pbfy+aDjl5dVfOq2pMQcUXq2i6Ez+f/fLB7n/GXtnTFXV6PK
	 5a5zzx868KMgyK7O57YRiRbS7RNx/0CkE+Tu/V4EUQULpLa9Q2J+ufjrirkYaJzy7L
	 Prhj2b8+MDHBRUb9C4aAOme9iuQlQMJLiYGssI14=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 40/50] Revert "drm/amdgpu: fix incorrect vm flags to map bo"
Date: Tue,  2 Sep 2025 15:21:31 +0200
Message-ID: <20250902131932.111802796@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131930.509077918@linuxfoundation.org>
References: <20250902131930.509077918@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


