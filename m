Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 638FB3BE63F;
	Sat, 17 Oct 2026 17:30:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258215; cv=none; b=L9JrZPWZPzKjEKaGHagNKBRZ79uOjeYLN8THIoDJ4kxsFAhQaZs/n3ZkB+1R4JQS+SBDqz50cArCX7KHClGiKT/t8dXagojPjDE4CJj3HoQfVnLO+wyEkBl8/Ym67eKgOBNmLAU3tIKsANLaVvbIaD7yViVHUfOz4/j+JhLJgwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258215; c=relaxed/simple;
	bh=+ADUJmb5Njd3ws0KHNFJKhaUPH7vG4+avaqRJpo+AN8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IVl+29t4GlJ6QtH+GS/h3wz3pGLXP3+JXmpDCNfhb/hBbTO3eg/8E4gBGWjVLyR3b39upfmT3cPA7+3IwVRcofuDwlSJwglQAZRmxvp84+5Q5S8/PDCON0zE7CMQELmXcmZkDQLfB4nWcYWccBRr0uOidh+DQHBtejjpxU332a0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x3s51+ou; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x3s51+ou"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B16591F000C4;
	Sat, 17 Oct 2026 17:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258214;
	bh=7tSj2QG6yYQb8BFgZponU6iR6zOXERWPl+bwlDiJo2U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x3s51+ouq/SpYUadegT7ZgzCDcIoUBa6I+MoaY0o4mjFkvXq1XG2OSSvS3QGhNZae
	 uq7WvCywgcPCkOeDfEgJ9CC16st+vg93u/YIs9oJolTYzMQKUhrQIz/IUEzExdgvOz
	 oTNl5TRvt9ydCFeQKiKA8sGzLyFTtalNIkEWqtNc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Mangesh Gadre <Mangesh.Gadre@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Arunpravin Paneer Selvam <Arunpravin.PaneerSelvam@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0811/1674] drm/amdgpu: hide VRAM sysfs attributes on GPUs without VRAM
Date: Sat, 17 Oct 2026 17:51:23 +0200
Message-ID: <20261017160451.939746001@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian König <christian.koenig@amd.com>

[ Upstream commit 33cc891b56b93cad1a83263eaf2e417436f70c82 ]

Otherwise accessing them can cause a crash.

Signed-off-by: Christian König <christian.koenig@amd.com>
Tested-by: Mangesh Gadre <Mangesh.Gadre@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Arunpravin Paneer Selvam <Arunpravin.PaneerSelvam@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c
index 403a7c976dfa2..a592f80e940ea 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c
@@ -223,6 +223,9 @@ static umode_t amdgpu_vram_attrs_is_visible(struct kobject *kobj,
 	    !adev->gmc.vram_vendor)
 		return 0;
 
+	if (!ttm_resource_manager_used(&adev->mman.vram_mgr.manager))
+		return 0;
+
 	return attr->mode;
 }
 
-- 
2.53.0



