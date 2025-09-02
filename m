Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AF2A2EFDB1;
	Tue,  2 Sep 2025 13:38:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756820315; cv=none; b=LvFwsuBKbRlrTMabpgPxl6XXZOFrcFSDr1JlBClhexjghi0XAUuWWE0I3msDh48/02q9vWKsEiyrqxcWBUmgh3jGBk1OWL7d5/PVmjBVJYU/f4QTLnsPPbelsJWpoSdZDCgZx6lOnzGfmm4rDWcZtIh0EHVYz4v/y8OODk+7i0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756820315; c=relaxed/simple;
	bh=3iV+DB2uJV3M99dzmhMDolSnZ08GjhaE8z8KQCicPnU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HZDkplnK3xsp31Rrz6Xg5jdfIGbSW6ZVW3c38KkcOhh+79txj6mAb1eLaxxOGO9Wg7arCFnmC2FwRzIeSyJb99y+zXnzya0Oi7S6/P+Y/7uEC6xtBslFu9J3b2Y+Z+Xw3/aumeODCr+jjQxXSb2B2ZhzaAAjNmcI+bhAe7u98cc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lfL/vCdk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lfL/vCdk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E334C4CEED;
	Tue,  2 Sep 2025 13:38:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756820315;
	bh=3iV+DB2uJV3M99dzmhMDolSnZ08GjhaE8z8KQCicPnU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lfL/vCdkgzmkvGiubAXPBPzCBLZSDag/Mc6CGuVjhmclIRH68cJ8bBHr/3g+Lkt+1
	 uIO6vZ+wLUwyd073LPH7ifYVYj3yva59fIAJG3MpG0ZxYBs1zkLoJJrnz9bL7Wqny4
	 OcAyELTHPEMxfLEyhHXZVSzBcJU81zcIddpc+NVk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 64/75] Revert "drm/amdgpu: fix incorrect vm flags to map bo"
Date: Tue,  2 Sep 2025 15:21:16 +0200
Message-ID: <20250902131937.627454352@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131935.107897242@linuxfoundation.org>
References: <20250902131935.107897242@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -89,8 +89,8 @@ int amdgpu_map_static_csa(struct amdgpu_
 	}
 
 	r = amdgpu_vm_bo_map(adev, *bo_va, csa_addr, 0, size,
-			     AMDGPU_VM_PAGE_READABLE | AMDGPU_VM_PAGE_WRITEABLE |
-			     AMDGPU_VM_PAGE_EXECUTABLE);
+			     AMDGPU_PTE_READABLE | AMDGPU_PTE_WRITEABLE |
+			     AMDGPU_PTE_EXECUTABLE);
 
 	if (r) {
 		DRM_ERROR("failed to do bo_map on static CSA, err=%d\n", r);


