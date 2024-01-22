Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E50235D91E;
	Tue, 23 Jan 2024 01:46:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974396; cv=none; b=mdOHa5e1qGxihmGOpjdeNuv/TPZZeogKcLQk1PwSDyr3f6u8UcBqX4xmjOecsxkcvuhybPIBJnHD6iYjuHJEx3wdMSyEtzCSl/WRMdF+1R+8lW22XD0rV3gYUtpPZINN2OGxQZLrE5+zzMuckl9Min0HzXQYWHOPXhGpm3jvyzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974396; c=relaxed/simple;
	bh=CwdlLSWJiYReus6B9PRV5np+PddEmp8suyIw/a+sj74=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tDmwYqROU/9a8mBKUOuTkujTe+Z1YwCCfFMX03EEDRSLUFCvSLhE8lBlQrIGdF6dIhKFYGCltT08mRloPuByc3TIdBohV392lV27oi1vdVoqe8gjBLFEk4qljgXi2RYGZPycIu3u1pw66DBbK8kUpa/4pNJBeP/60tOrOW6c3JQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SlT9swUB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SlT9swUB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA631C433F1;
	Tue, 23 Jan 2024 01:46:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974395;
	bh=CwdlLSWJiYReus6B9PRV5np+PddEmp8suyIw/a+sj74=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SlT9swUBWC+S+ZROO8fLwZ93k1ke1Eekg8RDKpsiy35LGjPSkJIdSaSL1a4+WoY3C
	 YZF4reT4iS/8VSttnXnVjxiP6GCJ/5btjNLpUC/s1I6/iHw9ZBb33uUqpD2UdiTEMl
	 HfZVsga7mLK02WCjZYZhnQIXM/y2is5gBlTJH2Ac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 208/374] drm/amdgpu/debugfs: fix error code when smc register accessors are NULL
Date: Mon, 22 Jan 2024 15:57:44 -0800
Message-ID: <20240122235751.862924709@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
User-Agent: quilt/0.67
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit afe58346d5d3887b3e49ff623d2f2e471f232a8d ]

Should be -EOPNOTSUPP.

Fixes: 5104fdf50d32 ("drm/amdgpu: Fix a null pointer access when the smc_rreg pointer is NULL")
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c
index 632d8df04ef4..aa057ceecf06 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c
@@ -465,7 +465,7 @@ static ssize_t amdgpu_debugfs_regs_smc_read(struct file *f, char __user *buf,
 	int r;
 
 	if (!adev->smc_rreg)
-		return -EPERM;
+		return -EOPNOTSUPP;
 
 	if (size & 0x3 || *pos & 0x3)
 		return -EINVAL;
@@ -527,7 +527,7 @@ static ssize_t amdgpu_debugfs_regs_smc_write(struct file *f, const char __user *
 	int r;
 
 	if (!adev->smc_wreg)
-		return -EPERM;
+		return -EOPNOTSUPP;
 
 	if (size & 0x3 || *pos & 0x3)
 		return -EINVAL;
-- 
2.43.0



