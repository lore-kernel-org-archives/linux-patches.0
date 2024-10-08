Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCB9C1779B1;
	Tue,  8 Oct 2024 12:40:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391202; cv=none; b=C0F0oUBMn9DX0fM/CBqzknz64i3PR1VZ6uZNhwVyJD+E/90GPOe602e1tWRi/uIjscTwhh31/9IedFB6SjA3fjXOc41xI126845ZkEPizr0rXMpundUJcrZWLXW3W6BIaiypX8xGVoyuJ8yRcH+0493Wj+DnT6u0pdtlseMchGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391202; c=relaxed/simple;
	bh=4TsvlOxZPA/CyqnmLoLRP81YcXvDseL6swv3m6UjNPU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IP8su3M6uRvVXp5Z2R4bbbYQ+/eGuZSyIMatzzTObnzzPJJ2PlWQvRE9W201MczmjGZNX/wZOj51X6m9J56hnVmEwZpPYmNjEqAeqHoRDHJJem/dwnB8/anhJNOjUxQVV+QgzGrxTD2UR5E26Sl9SgCg/VCONm5DTUtkGqpeV3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NiBm80gg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NiBm80gg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 515BBC4CEC7;
	Tue,  8 Oct 2024 12:40:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391201;
	bh=4TsvlOxZPA/CyqnmLoLRP81YcXvDseL6swv3m6UjNPU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NiBm80ggKQkzrk4TldBx+GOaEKAThc4uWf/XrpVkBKBgLoj4g3yobq6LC6JpLXwlP
	 vGPeO+B03NxARyE2+8jANM5ejpDbn/Fw+n5k28zatuD0hwwRjAvF7sRp4/8nuq7WYX
	 IrjOycfdq/rXvSdAi2QqDtrCaVtf8yd4xpY5yIIY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Asad Kamal <asad.kamal@amd.com>,
	Lijo Lazar <lijo.lazar@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 009/558] drm/amdgpu: Fix get each xcp macro
Date: Tue,  8 Oct 2024 14:00:39 +0200
Message-ID: <20241008115702.588337832@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Asad Kamal <asad.kamal@amd.com>

[ Upstream commit ef126c06a98bde1a41303970eb0fc0ac33c3cc02 ]

Fix get each xcp macro to loop over each partition correctly

Fixes: 4bdca2057933 ("drm/amdgpu: Add utility functions for xcp")
Signed-off-by: Asad Kamal <asad.kamal@amd.com>
Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_xcp.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_xcp.h b/drivers/gpu/drm/amd/amdgpu/amdgpu_xcp.h
index 90138bc5f03d1..32775260556f4 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_xcp.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_xcp.h
@@ -180,6 +180,6 @@ amdgpu_get_next_xcp(struct amdgpu_xcp_mgr *xcp_mgr, int *from)
 
 #define for_each_xcp(xcp_mgr, xcp, i)                            \
 	for (i = 0, xcp = amdgpu_get_next_xcp(xcp_mgr, &i); xcp; \
-	     xcp = amdgpu_get_next_xcp(xcp_mgr, &i))
+	     ++i, xcp = amdgpu_get_next_xcp(xcp_mgr, &i))
 
 #endif
-- 
2.43.0



