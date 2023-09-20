Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A4C118654
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 11:47:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94613C433CB;
	Wed, 20 Sep 2023 11:47:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695210428;
	bh=9CGDgVKsifeYqfZrwlkgSwDkYXSqDhGVABbvC8BGZ8E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mBjY1OuOfnlzjYYK/KJxc1P7w/VsAXczPox3rr01mWXSWDvJx0/no3XczN6FpECet
	 bC0602Hth57BBn/Xd8ahjr16A64tcyQh3SbMJbF5jb+vKeSGrFQUY3ILeYRcooFfg5
	 P39HSUumCUFXDBU2asN+dZ9GhP7nj8/O6+z7wb6w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	James Zhu <James.Zhu@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 074/211] drm/amdgpu: Update ring scheduler info as needed
Date: Wed, 20 Sep 2023 13:28:38 +0200
Message-ID: <20230920112848.091483524@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112845.859868994@linuxfoundation.org>
References: <20230920112845.859868994@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lijo Lazar <lijo.lazar@amd.com>

[ Upstream commit 6cb209ed68e45c8e4b71d97a037ac6b7dbce9b50 ]

Not all rings have scheduler associated. Only update scheduler data for
rings with scheduler. It could result in out of bound access as total
rings are more than those associated with particular IPs.

Signed-off-by: Lijo Lazar <lijo.lazar@amd.com>
Reviewed-by: James Zhu <James.Zhu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/aqua_vanjaram_reg_init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/aqua_vanjaram_reg_init.c b/drivers/gpu/drm/amd/amdgpu/aqua_vanjaram_reg_init.c
index 72b629a78c62c..d0fc62784e821 100644
--- a/drivers/gpu/drm/amd/amdgpu/aqua_vanjaram_reg_init.c
+++ b/drivers/gpu/drm/amd/amdgpu/aqua_vanjaram_reg_init.c
@@ -134,7 +134,7 @@ static int aqua_vanjaram_xcp_sched_list_update(
 
 	for (i = 0; i < AMDGPU_MAX_RINGS; i++) {
 		ring = adev->rings[i];
-		if (!ring || !ring->sched.ready)
+		if (!ring || !ring->sched.ready || ring->no_scheduler)
 			continue;
 
 		aqua_vanjaram_xcp_gpu_sched_update(adev, ring, ring->xcp_id);
-- 
2.40.1



