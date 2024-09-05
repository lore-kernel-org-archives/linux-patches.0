Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B94851494DB;
	Thu,  5 Sep 2024 10:02:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725530535; cv=none; b=aY7PilBFRoN3YIlvCIZxKwdcD4AmptP7ERaVhQIhWl6khEwbNTLYA83ZjqZqV+bJoaH9eAB0HoQoslhxfbBYTGdtqpFtrnegRRMsCLAPTCPQegytAQVtmTeEWXxb163kQPzTVpwXVc1TmNz0F7VNO260rUY6nNLV8vLYQq8Egog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725530535; c=relaxed/simple;
	bh=Kb9AETA76ppfvHcXOmQ+4aUxPOBuZ66ZqnKxrgU4Ta0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mk3b8nN2wTD2dDcO6q/xrDMsrCi4K1EqclxuDANi94USdUddMRKKxdnXJ49f8drnQ8rrUPIWLh7eqgPaMgqJoAXELoHw3gPOjbiZwe5h1gi5uSAWJyREcBBBmA5r4yswb1OslpgSjNb6dB4arAmr/nRKnjZEhFMfWF9LU47IC08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aN4suwA5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aN4suwA5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E7ACC4CEC3;
	Thu,  5 Sep 2024 10:02:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725530535;
	bh=Kb9AETA76ppfvHcXOmQ+4aUxPOBuZ66ZqnKxrgU4Ta0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aN4suwA5r1wtVV57xxYyzcUTngbyBYNr/K84H4vFQkKUm0j73zt6pyA6vVafL3lGN
	 Lfa38/GdS0duyZK5fquXHm/UysQPcWcbPMleGEBetAmSsOTSXTKWW3mEVuLYPmaRi2
	 l01hmMQilUwnDBk4R7kPnpuLvM2mvjvW49vORTlE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Jun <Jun.Ma2@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Tim Huang <Tim.Huang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 053/101] drm/amdgpu: Fix out-of-bounds write warning
Date: Thu,  5 Sep 2024 11:41:25 +0200
Message-ID: <20240905093718.210944973@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093716.075835938@linuxfoundation.org>
References: <20240905093716.075835938@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 2001c7d27a53..cb73d06e1d38 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ring.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ring.c
@@ -324,7 +324,7 @@ int amdgpu_ring_init(struct amdgpu_device *adev, struct amdgpu_ring *ring,
 	ring->max_dw = max_dw;
 	ring->hw_prio = hw_prio;
 
-	if (!ring->no_scheduler) {
+	if (!ring->no_scheduler && ring->funcs->type < AMDGPU_HW_IP_NUM) {
 		hw_ip = ring->funcs->type;
 		num_sched = &adev->gpu_sched[hw_ip][hw_prio].num_scheds;
 		adev->gpu_sched[hw_ip][hw_prio].sched[(*num_sched)++] =
-- 
2.43.0



