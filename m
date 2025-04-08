Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0924C227BB6;
	Tue,  8 Apr 2025 11:33:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112024; cv=none; b=R2+VFf5GPDADxXhF0QZZK3DUukx9+YO1I3qZ16j0HqKKkjMys+iuqkau9zb1kaGWMrCdM825VQAdIeN8kFFl1d6+H3cY5XK+VJbRDIyLzLw1ME0UNX3J/O/r9JjLHSGaX0R2vI4rldKPd9baLQ7VZbLe98/62Wut7PZKa5ntxtQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112024; c=relaxed/simple;
	bh=PnAu2BZ/4D+pi5WzyF1EHjOKEqxw1b8/Lck4dTzWH3E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sgM11wX8C/cPARJrYq1sm87qDf/RU2B0D3y4crKq4rRfTX61EGX8/BY2dhiaTc7W8Gjf1pgJcBwImr+FQ3bYxmOK9+oBmD/sPE3Iwlz4rqL7UyKSUCY3IQCZ/BS72eDl7KCiJ8c2MkehwQm+6q0QAxUCBzHUQPNhp4fAPPzXcA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VRRkOD+C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VRRkOD+C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C61CC4CEE5;
	Tue,  8 Apr 2025 11:33:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112023;
	bh=PnAu2BZ/4D+pi5WzyF1EHjOKEqxw1b8/Lck4dTzWH3E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VRRkOD+CgZHvQS62zd6e/0eekYpqvIEBXxlzuR5cyGV2z/sNyTVrQWFWFiElqN9ZK
	 yRzIMbO4fHJjYvBVsObOPkdpzIkjVs1M34TMCoXODWHyOcnXqK2UQZIkCo0DsXYN9L
	 +rnWXIwO6ya/HIbwnh4eyKf+8lyZXdwZNRpJoED4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sunil Khatri <sunil.khatri@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 648/731] drm/amdgpu/gfx12: fix num_mec
Date: Tue,  8 Apr 2025 12:49:05 +0200
Message-ID: <20250408104929.338899274@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit dce8bd9137b88735dd0efc4e2693213d98c15913 ]

GC12 only has 1 mec.

Fixes: 52cb80c12e8a ("drm/amdgpu: Add gfx v12_0 ip block support (v6)")
Reviewed-by: Sunil Khatri <sunil.khatri@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v12_0.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v12_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v12_0.c
index 48ff00427882c..c21b168f75a75 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v12_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v12_0.c
@@ -1337,7 +1337,7 @@ static int gfx_v12_0_sw_init(struct amdgpu_ip_block *ip_block)
 		adev->gfx.me.num_me = 1;
 		adev->gfx.me.num_pipe_per_me = 1;
 		adev->gfx.me.num_queue_per_pipe = 1;
-		adev->gfx.mec.num_mec = 2;
+		adev->gfx.mec.num_mec = 1;
 		adev->gfx.mec.num_pipe_per_mec = 2;
 		adev->gfx.mec.num_queue_per_pipe = 4;
 		break;
-- 
2.39.5



