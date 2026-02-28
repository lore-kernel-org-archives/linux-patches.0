Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC11D340A47
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:50:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301005; cv=none; b=kDpZQICRUcgKgUz75y+zi23GdNPugw6HC8EzSjNNcR4I7zI1OR6cyDi5ACl+RrMLxfqksac6OQkpY7jkEjrQ7OrDpQeVaQ8IhmRd1i06YwPi6yB3jSyUg4b6hwUTaIOhUTl9w6Kr6jC4LHmmyVim2fsxKfLplV7ZPdSFqAwGZsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301005; c=relaxed/simple;
	bh=Zz0ScmBJNiRPw+Y6OLxktjW5Vs27ArwbB0uY9BiOJ4c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qLdSC+Qfgc21v29+6qWvAyrt7SjRHG4JM7C98juloWT0IsV0+k/72GYlQxT37u4yofzdGMfpl3QT2cLX3JsNSFNysZ3vHTVMo3QAyIRhGaLLD+NscxBn9aGcF9trDEl3yvJyGIpAQ6fS5wPfYcWg1pNOaIL9Ebh0jhgQQqeSRRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UYItuX2i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UYItuX2i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CB99C19423;
	Sat, 28 Feb 2026 17:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301005;
	bh=Zz0ScmBJNiRPw+Y6OLxktjW5Vs27ArwbB0uY9BiOJ4c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UYItuX2i38KHadAi5FGPLqbs8KuHT0xTii9udZvIz4CQ6Yt3nSZBx72HKhvsb8cLu
	 gZyB9I9GBjYOFNiYD17hEdrYFdt0FCVYP0MdyzpXQH+TG8VVjogm/AyJs86A4czaj6
	 AixWNsWogTHLwbmB7bwxU4/nT3WmpPj+ZN9S4gBv6waS2qinHYbtVudF309dGN0YzP
	 9XNBJG6Z0c/t4VGd/HSDBaA0XcsdP8ruFiaKfikI9QxwykhMihnhAVyOYD/pcTZFXs
	 G/ZUioFEJyTGhlf7qxE7s5y9AMOom1tZKKADLO/AtZ+Rr+7lrd9iNUpZavtMVmKNbW
	 4M9y16/IHKeGA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Alex Deucher <alexander.deucher@amd.com>,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 139/752] drm/amdgpu: avoid a warning in timedout job handler
Date: Sat, 28 Feb 2026 12:37:30 -0500
Message-ID: <20260228174750.1542406-139-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit c8cf9ddc549fb93cb5a35f3fe23487b1e6707e74 ]

Only set an error on the fence if the fence is not
signalled.  We can end up with a warning if the
per queue reset path signals the fence and sets an error
as part of the reset, but fails to recover.

Reviewed-by: Timur Kristóf <timur.kristof@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_job.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_job.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_job.c
index 630af847f29ff..ffc720d189007 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_job.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_job.c
@@ -147,7 +147,8 @@ static enum drm_gpu_sched_stat amdgpu_job_timedout(struct drm_sched_job *s_job)
 		dev_err(adev->dev, "Ring %s reset failed\n", ring->sched.name);
 	}
 
-	dma_fence_set_error(&s_job->s_fence->finished, -ETIME);
+	if (dma_fence_get_status(&s_job->s_fence->finished) == 0)
+		dma_fence_set_error(&s_job->s_fence->finished, -ETIME);
 
 	if (amdgpu_device_should_recover_gpu(ring->adev)) {
 		struct amdgpu_reset_context reset_context;
-- 
2.51.0

