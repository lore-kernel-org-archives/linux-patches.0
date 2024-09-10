Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62846190676;
	Tue, 10 Sep 2024 10:39:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964762; cv=none; b=gs34B1LMy91qiImc3LssMU6B9XM4M1Z0Y6MaXIWZ4LEUP2q+DsAMJwxYWERrhJmmAaw8/8jM9tn6O/MIsTuyHfIPFf+WVXw+7z9pghWB01dfSn9+HFrcnUyenLIpAGyHCBedwpuM1s04pclP7NHE2sDbu/eXzN7LEuchAkg84oI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964762; c=relaxed/simple;
	bh=Q1AXB7T5vLyaS6aDxBmIaeD+UfJJlqSsPSQYXBjcyqI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=vDjoRRJi/JvThsq0I8aLlGXhj6Wr0YLcKb4QL55XrB+cycb6zqM8UEx5ZCCFiHnBARZIUfSCdXzClq8a6fKuikrDyUC2okX2hOCClUhw320QuC86aNl1K5sYJhY4jkKITiEyKTdOTD+MIkeSXq+1qlTOSu+/abcAMfA4jkcLIFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fpOC1L62; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fpOC1L62"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBF12C4CEC3;
	Tue, 10 Sep 2024 10:39:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964762;
	bh=Q1AXB7T5vLyaS6aDxBmIaeD+UfJJlqSsPSQYXBjcyqI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fpOC1L62A4Ia1tqtackY5lgui+FAfJ6bT93YwMmgkpxL5jUkBXYyqZgND471aFLc1
	 efpMmJeg4TVBHucHQ6NJVN5A4BYLAsP0P54hzXB3NzWMwFbxziH1hEkJPQDKX2wNgl
	 vwtW6fBX4XikD8ztUWC61SZ+EaQgk9InFyuGq6Go=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Jun <Jun.Ma2@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Tim Huang <Tim.Huang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 022/186] drm/amdgpu: Fix out-of-bounds write warning
Date: Tue, 10 Sep 2024 11:31:57 +0200
Message-ID: <20240910092555.538681354@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092554.645718780@linuxfoundation.org>
References: <20240910092554.645718780@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ma Jun <Jun.Ma2@amd.com>

[ Upstream commit be1684930f5262a622d40ce7a6f1423530d87f89 ]

Check the ring type value to fix the out-of-bounds
write warning

Signed-off-by: Ma Jun <Jun.Ma2@amd.com>
Suggested-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Tim Huang <Tim.Huang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ring.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ring.c
index 6976f61be734..b78feb8ba01e 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ring.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ring.c
@@ -260,7 +260,7 @@ int amdgpu_ring_init(struct amdgpu_device *adev, struct amdgpu_ring *ring,
 	ring->priority = DRM_SCHED_PRIORITY_NORMAL;
 	mutex_init(&ring->priority_mutex);
 
-	if (!ring->no_scheduler) {
+	if (!ring->no_scheduler && ring->funcs->type < AMDGPU_HW_IP_NUM) {
 		hw_ip = ring->funcs->type;
 		num_sched = &adev->gpu_sched[hw_ip][hw_prio].num_scheds;
 		adev->gpu_sched[hw_ip][hw_prio].sched[(*num_sched)++] =
-- 
2.43.0



