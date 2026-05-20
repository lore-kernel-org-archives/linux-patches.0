Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91A9261FFE;
	Wed, 20 May 2026 16:39:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295153; cv=none; b=Mt2YpzGB0LhA5c0hSIeNuoh7Zeg9nIp/62S+3q3d1DXeTI3+VqThOcz0C6XOuF2iGe4jJrenjAGANMgmwPPuTbpqxXzZ8B7ntHL1SrkcW2SD+/IuNkWijoWiEWf6y9tI8mKH8O1Vv05YoIS8zk4gUrn/PhPE2A+nfClN0x8cM8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295153; c=relaxed/simple;
	bh=ThrXr0NshvLHXQaaX6t2W6aO7BkEBu5fgoNYy/xXw0U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dsvZBy9OIfvMH4Lb2QFqA70+umeKgq3xA1v0H+c/yBMMJ3gG2cKqUzQtOZxLo+U5ryeDDg1c/LtANl9ks1WTTkoyINnLj8q5d9jmOzYXs2Krt7UKRgo2Szi6ZyHnPNxt6jYn296bHuCxiO7Aion0neTCbP0MhDQE+KdSDV1lxNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J/lLPwBq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J/lLPwBq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35F2D1F000E9;
	Wed, 20 May 2026 16:39:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295150;
	bh=xuN7fQRMW4YJzQwaexgcJOkuR755bKxHIuXVsoBwjYE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J/lLPwBq8jtW1ekWHuzYCr0PNlNYau6WpbDob/Sb2c1Mb04c01Nyq7HVGbbILoeZY
	 l1W5NadzUCISUWmejfAG5XyR3n2bFdjDARZE5vdoi80x8Gh6FoVZ4Gua/c6SfRNs2E
	 uB5Ks9gav5ZeFtJcdRQKKvYc21PPuUuk9Ye4u9sI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0311/1146] drm/amdgpu/gfx10: look at the right prop for gfx queue priority
Date: Wed, 20 May 2026 18:09:21 +0200
Message-ID: <20260520162155.240617440@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit 355d96cdec5c61fd83f7eb54f1a28e38809645d6 ]

Look at hqd_queue_priority rather than hqd_pipe_priority.
In practice, it didn't matter as both were always set for
kernel queues, but that will change in the future.

Fixes: b07d1d73b09e ("drm/amd/amdgpu: Enable high priority gfx queue")
Reviewed-by：Jesse Zhang <jesse.zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
index 1893ceeeb26c8..8b60299b73ef7 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
@@ -6752,7 +6752,7 @@ static void gfx_v10_0_gfx_mqd_set_priority(struct amdgpu_device *adev,
 	/* set up default queue priority level
 	 * 0x0 = low priority, 0x1 = high priority
 	 */
-	if (prop->hqd_pipe_priority == AMDGPU_GFX_PIPE_PRIO_HIGH)
+	if (prop->hqd_queue_priority == AMDGPU_GFX_QUEUE_PRIORITY_MAXIMUM)
 		priority = 1;
 
 	tmp = RREG32_SOC15(GC, 0, mmCP_GFX_HQD_QUEUE_PRIORITY);
-- 
2.53.0



