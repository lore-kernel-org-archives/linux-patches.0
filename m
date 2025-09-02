Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96070305062;
	Tue,  2 Sep 2025 13:46:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756820800; cv=none; b=Ojk8myKMw5XO/IzjuitzHGlqxuyXdQhUYnQoXrB6vOBc+1+JeQsrojjBgpR+aOFZiLRd/mTfWjiO1EfIR4OBM39X73IxU+La2QEoFjXS6L1LULWfM38mg1Zc2r+M40RKCV3LY88CCnJ30UF6AgB3iW1S9O1AHM9/+jyFBrfKDdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756820800; c=relaxed/simple;
	bh=Oum/+//rsLSnKDLmNuNdTQ9PhPQzTSAIgOSQ65SH1CM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iZ0keyGte/RCAUOhY1+GLpjvk42uFWM8ZrdS+syLApAznsoKHU6N4OhPap1Pur2USxuAfGkODOvyVCZVsiqExPw2AAJeOzGOMC+fypeTg1DdwsbSFgcHCuCFKx+kKOCHRVCb6pbSifDx6J22PGvXvtHhvCqwYKdTNPSUEp0Wl0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lHDiy33l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lHDiy33l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C68A8C4CEED;
	Tue,  2 Sep 2025 13:46:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756820800;
	bh=Oum/+//rsLSnKDLmNuNdTQ9PhPQzTSAIgOSQ65SH1CM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lHDiy33lhb3l7DtczZUUmrFa/XAYLWAy6t+NfYb/8WBCnI79a3aynA3hsPlB2nKey
	 Q8dvzUY3QkTOhXQCQFWQ05uKQ9R98dnsAPVEGh800cWyLkV1D27dZ9Yh4k9dt+UNIM
	 wWwtKlct88RZUz1k6WqDvMgkBKraDjxCk4Tg1N1I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.4 21/23] Revert "drm/amdgpu: fix incorrect vm flags to map bo"
Date: Tue,  2 Sep 2025 15:22:07 +0200
Message-ID: <20250902131925.579244835@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131924.720400762@linuxfoundation.org>
References: <20250902131924.720400762@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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


