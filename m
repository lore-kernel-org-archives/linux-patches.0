Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F69B199231;
	Thu,  5 Sep 2024 09:46:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725529609; cv=none; b=eIFUqkzFSeqaoQiRMPhlIeYADtiFQzh+pivU1kcGM/W4+fs3BY9To1O07E5pz0rVbrpj7CiEz1753yhpTob+EC2v8PTcM88Zok8ocnv1pgTTZg3OG9sLrtNiY+80la9iRnHizzs0EfGgiHVPNbnOkxPYMi1MzfjRNKUUHiBw/S8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725529609; c=relaxed/simple;
	bh=3uAffZ+FThe+KLMMTphyw0t7XpjXkpEZ92MLJQGVXqE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DwsMbxZO+sAqKDz54p2FRJf8ygkolVEmrBiA1JM+jxm7IjvH44dFHKlmyk2ypbBLbhf+WAjdc+AVHLMWn7N46YXV6N2pTP/et37P/zN6ihfSWmlm+V66zrG7yF15e7DRzLq20Y5hMslNlneYujGnKL5iuhBuuk3BcoJDUGPQIko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BET05Prs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BET05Prs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8391C4CEC7;
	Thu,  5 Sep 2024 09:46:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725529609;
	bh=3uAffZ+FThe+KLMMTphyw0t7XpjXkpEZ92MLJQGVXqE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BET05PrsWB78Fl2IacaCCFUiKxS/zNCTyvpfUumE2u5owoArFZFZ196qulcb4IHn4
	 33eZKMuML3IZXfY/zGGcgDKxqkXGLqyH3888gsSNobHXRKY6SLk34B8Rvdbh58x8zx
	 71EzVhaMiHorQkFf526U82mZNvNRD1KRbMdqq6K0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Jun <Jun.Ma2@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Tim Huang <Tim.Huang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 086/184] drm/amdgpu: Fix out-of-bounds write warning
Date: Thu,  5 Sep 2024 11:39:59 +0200
Message-ID: <20240905093735.597112572@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093732.239411633@linuxfoundation.org>
References: <20240905093732.239411633@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index d20405d84e12..e6344a6b0a9f 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ring.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ring.c
@@ -354,7 +354,7 @@ int amdgpu_ring_init(struct amdgpu_device *adev, struct amdgpu_ring *ring,
 	ring->max_dw = max_dw;
 	ring->hw_prio = hw_prio;
 
-	if (!ring->no_scheduler) {
+	if (!ring->no_scheduler && ring->funcs->type < AMDGPU_HW_IP_NUM) {
 		hw_ip = ring->funcs->type;
 		num_sched = &adev->gpu_sched[hw_ip][hw_prio].num_scheds;
 		adev->gpu_sched[hw_ip][hw_prio].sched[(*num_sched)++] =
-- 
2.43.0



