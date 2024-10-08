Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC8EF1C32EB;
	Tue,  8 Oct 2024 13:10:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728393005; cv=none; b=qMzEcDVhBiwVkUp4SQLTUh2T7wPKW5yclZE0oahAIzLVZdmWcOZXkl/94fwWvWUnkm5GRsC/DA4x7nrtk8p8Bwcu+aE6vUS46IO4Aa3Law0mwmRKGkngU7zHuwsfgEqnJPLjMgZrZzQbZbCPVx/wZqj8AD6bvdjkOedEufW09Cc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728393005; c=relaxed/simple;
	bh=lTXM3K8l3fRqCbKNtMC6hyCevmzx5yJBSeQNyQxBweg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tU8hJ4xR78coctnVDychPcAhGEebTd35loWZHz+ZQU6vZj8noFIadZckWSTcBZnkh7yDr/Xtd8wyRmrNnt7qYyOaVSmuhGHaVdQXTPfV/s0WuD5FpMDeSobuxVTXdMKj1h+xFgTrKe/vO1IlTM/VLbx1A66mAHf0YXz9HLSapoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1L9rpveW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1L9rpveW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 158EAC4CEC7;
	Tue,  8 Oct 2024 13:10:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728393005;
	bh=lTXM3K8l3fRqCbKNtMC6hyCevmzx5yJBSeQNyQxBweg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1L9rpveWRTg8Ner1KrgWTc5bZ647UnpAghBXzuk34U4stMnzaspo8+sNhSyXJGFXa
	 VY8JdFMxy7AI0NOvZSMS7vJ9xftXXdRJ+oBU3VferZ8J30UNLm4aWYac9nUTex2kUj
	 AxJazt0wy+q0xjZUPSbe3Bd9L8uN63KxVkHHNuSo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Asad Kamal <asad.kamal@amd.com>,
	Lijo Lazar <lijo.lazar@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 007/386] drm/amdgpu: Fix get each xcp macro
Date: Tue,  8 Oct 2024 14:04:12 +0200
Message-ID: <20241008115629.609070052@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 9a1036aeec2a0..9142238e7791a 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_xcp.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_xcp.h
@@ -179,6 +179,6 @@ amdgpu_get_next_xcp(struct amdgpu_xcp_mgr *xcp_mgr, int *from)
 
 #define for_each_xcp(xcp_mgr, xcp, i)                            \
 	for (i = 0, xcp = amdgpu_get_next_xcp(xcp_mgr, &i); xcp; \
-	     xcp = amdgpu_get_next_xcp(xcp_mgr, &i))
+	     ++i, xcp = amdgpu_get_next_xcp(xcp_mgr, &i))
 
 #endif
-- 
2.43.0



