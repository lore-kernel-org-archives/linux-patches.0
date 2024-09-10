Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1B80192D94;
	Tue, 10 Sep 2024 10:17:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963427; cv=none; b=VFkopg/IhQv+hJBrAZpsgqW5OzeVzPZGsZ/goBJhRlacLjcjFwSOjCSEdU5uzifgyl0s17qMJ882HOq/2VfRaYhvcYTdHbGJZzPlgGY++NiRjhSr64vVmsJvhmUMjPHxCl9xq4wYOVxhF5yXcN2PAZ22Eg2PgWFjc4KJEadJWbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963427; c=relaxed/simple;
	bh=rBIlFtjs4EuCB4Yv5e0nBn5JvNr4nfZAe4UYXJupI/Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RSu9/ikXaef8U8TMzFkKblMUrvt0mC2dYSz5IPhT/E4flnPLNXGtrD5r0GfoB9uzcloK3EbGD3fDh5sZdmsf7nLeI91KzCoRAQJMHXpVoNDjQy5oKQnv6M3I1cdyYFyp7FnxShuBLBNpskcpGTIFFFOUbYyXVsDUmD0zFL5sthM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dJtWQ1/R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dJtWQ1/R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BA2AC4CEDA;
	Tue, 10 Sep 2024 10:17:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963426;
	bh=rBIlFtjs4EuCB4Yv5e0nBn5JvNr4nfZAe4UYXJupI/Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dJtWQ1/RPcUgQ5tJWlGVf5lr3fqLXptKM3adI9K3L2XG2AHYopGZtbF1eUiq0jDNk
	 L7466cEyP+dIDSfslDvEfupFNvUEvK23uALOfZTH8Gje6m8uydH99pbxSqsnfdAmP2
	 OYVxKEkOlvJR48TIyl3dqk6E9fl3KT0D8OxNYfFs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Jun <Jun.Ma2@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Tim Huang <Tim.Huang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 026/214] drm/amdgpu: Fix out-of-bounds write warning
Date: Tue, 10 Sep 2024 11:30:48 +0200
Message-ID: <20240910092559.845020885@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092558.714365667@linuxfoundation.org>
References: <20240910092558.714365667@linuxfoundation.org>
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
index 294ad2929485..de05b7f864f2 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ring.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ring.c
@@ -263,7 +263,7 @@ int amdgpu_ring_init(struct amdgpu_device *adev, struct amdgpu_ring *ring,
 	ring->max_dw = max_dw;
 	ring->hw_prio = hw_prio;
 
-	if (!ring->no_scheduler) {
+	if (!ring->no_scheduler && ring->funcs->type < AMDGPU_HW_IP_NUM) {
 		hw_ip = ring->funcs->type;
 		num_sched = &adev->gpu_sched[hw_ip][hw_prio].num_scheds;
 		adev->gpu_sched[hw_ip][hw_prio].sched[(*num_sched)++] =
-- 
2.43.0



