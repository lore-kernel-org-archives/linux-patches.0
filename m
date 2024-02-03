Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 910CD171C1;
	Sat,  3 Feb 2024 04:18:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933907; cv=none; b=i2FzZ0aSL+npDGM2GrDWuAVP5ko7Ep23VHINmfeWqBd20kaZD5pCV3mQB5aL4y1hj7uUl5Z0U5Ry9O0p52AGrLWWrRcb9be6dtt4eORHgP7XphY1sQ3O2+DFUCJ1z3yH/ZLE7E/HJdGmhGuQ/+wufSGYvUGpcYkAzXB1V13E0OU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933907; c=relaxed/simple;
	bh=fik22QSLbyxYAw4gg0wR4VV/o860SJkHQnseL27+ZuQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=q/Oep0x0OZ+Nar+dxY0HvrL/RLhnllaKRo9+uXdzEUvEyEipcedZNIIyAXRvXumXY9ltzm7gi6QO1+K5XHq8n25ht48bzA6RFMDwSuxSbrbi1Um/gN2Rqzi9cwGwg36dCtoAOanW/WbhYKfy9j7r1uEJtGr6QHxzvvgDuJB1b9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PMdtYaIg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PMdtYaIg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58CB5C433C7;
	Sat,  3 Feb 2024 04:18:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933907;
	bh=fik22QSLbyxYAw4gg0wR4VV/o860SJkHQnseL27+ZuQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PMdtYaIgf8Zy9+mqwA35v0fIzlgZcpF7TEYstC2akoke8E9vxhJR43zbLe5z6aXLc
	 t3qLiwHp1z9lp5/oLkA7pXY8GYHDW034kx/4jtZGqBsRxUjsrxiQ8BO+sMWmY5y2uE
	 IAmJGnc9danhmYrL9PpZoTmrLLcjauTo8O1OXJ1A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Tao Zhou <tao.zhou1@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 230/353] drm/amdgpu: Fix possible NULL dereference in amdgpu_ras_query_error_status_helper()
Date: Fri,  2 Feb 2024 20:05:48 -0800
Message-ID: <20240203035410.945481770@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>

[ Upstream commit b8d55a90fd55b767c25687747e2b24abd1ef8680 ]

Return invalid error code -EINVAL for invalid block id.

Fixes the below:

drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c:1183 amdgpu_ras_query_error_status_helper() error: we previously assumed 'info' could be null (see line 1176)

Suggested-by: Hawking Zhang <Hawking.Zhang@amd.com>
Cc: Tao Zhou <tao.zhou1@amd.com>
Cc: Hawking Zhang <Hawking.Zhang@amd.com>
Cc: Christian König <christian.koenig@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
index 63fb4cd85e53..4a3726bb6da1 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
@@ -1174,6 +1174,9 @@ static int amdgpu_ras_query_error_status_helper(struct amdgpu_device *adev,
 	enum amdgpu_ras_block blk = info ? info->head.block : AMDGPU_RAS_BLOCK_COUNT;
 	struct amdgpu_ras_block_object *block_obj = NULL;
 
+	if (blk == AMDGPU_RAS_BLOCK_COUNT)
+		return -EINVAL;
+
 	if (error_query_mode == AMDGPU_RAS_INVALID_ERROR_QUERY)
 		return -EINVAL;
 
-- 
2.43.0



