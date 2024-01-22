Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2630512BF3D;
	Tue, 23 Jan 2024 00:16:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968966; cv=none; b=ttlMYFOqW6jKaEnJRnXsU5sEko/Etspttz5iqIqCDLkwFHUM1sEXvGC2cOIkpXc7M2sUNh2jU1KXCyCdOfiOZEZOVjt7+Bm+WYBw8rJ0MxaUcJL/Q6yOP8dXUYBIus7CvIAsqd0brUaIt0YN3VX9Mv0A978zy/6yjyvNImDAsWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968966; c=relaxed/simple;
	bh=y51k/7Yk9Q1bQrybJLMoLPCLH8UIZVrKIapMP481X5I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=K4KvevsX5gPW8w2R+eCB2EBW0vtwqiKa+XjfA5OJxOKYJArwO42fsoD2xtRor8qHQxcCgipyrrIRFcRzMR+BEhqEef/hoMeWNI55SJ6mdprSMpGb5OA6/EY6Xqh23yjg4rUBLvRDCreQMo5LYUu5oiD8rhT4vT9sXfnCV17Z8O4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XGi3zYUk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XGi3zYUk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD94AC433F1;
	Tue, 23 Jan 2024 00:16:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705968966;
	bh=y51k/7Yk9Q1bQrybJLMoLPCLH8UIZVrKIapMP481X5I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XGi3zYUkXkcoeIp4cjb259unhg+LO1VRu+0gr/TzD73yl1YyOYoyqUIxkfNbdcTw0
	 5by1K2cWT8RhsYfPIHn0uOFYK7dMNAqpxqkcOVnqunNvRPDmxXIyRplX+m+vwZ6fWI
	 qP2HmnqAQIuQOQtVocX34ATo1xsHtxzvPwQF5Iag=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 127/194] drm/amdgpu/debugfs: fix error code when smc register accessors are NULL
Date: Mon, 22 Jan 2024 15:57:37 -0800
Message-ID: <20240122235724.685243813@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235719.206965081@linuxfoundation.org>
References: <20240122235719.206965081@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index d81034023144..48b8b5600402 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c
@@ -393,7 +393,7 @@ static ssize_t amdgpu_debugfs_regs_smc_read(struct file *f, char __user *buf,
 	int r;
 
 	if (!adev->smc_rreg)
-		return -EPERM;
+		return -EOPNOTSUPP;
 
 	if (size & 0x3 || *pos & 0x3)
 		return -EINVAL;
@@ -435,7 +435,7 @@ static ssize_t amdgpu_debugfs_regs_smc_write(struct file *f, const char __user *
 	int r;
 
 	if (!adev->smc_wreg)
-		return -EPERM;
+		return -EOPNOTSUPP;
 
 	if (size & 0x3 || *pos & 0x3)
 		return -EINVAL;
-- 
2.43.0



