Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22F322DF126;
	Sat, 17 Oct 2026 17:30:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258239; cv=none; b=YJSkILitTmYwx/cOlgFZsuXuUNJ4I4xz4ZZjlKYe57NJgp5hiNaL9lkLS//xmVftqumXVo5beFiYGlv1l+boI5DiJWcRpvARAWd/ZfQi99eku23Pjg0AQZT75elas0DBLGYZY3Y49M5LLWF8CbLPqM2T5BOhSaC3j5v63F/lDf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258239; c=relaxed/simple;
	bh=n4u9f/JuwWizJ+kXTXGFGxZYz54SHPMfpz7wLThE3Hk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=B3CuPZkv36fr23t+gnwwXOOhafo3dIqpwBBG0xfnibmyGRKg6YcfjAeP1a8cUxy5fhjnB0DrPx6QTyhEBvO5OH0f8k5eP5EYPRJEh8SSFGv7zE7C6DH+6QFA9xzznWUduAqJT0ABC0Yajjoc+TTxee7Gd63TLkEo68oZqYj+cgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GceEUhID; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GceEUhID"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AEBD1F000C4;
	Sat, 17 Oct 2026 17:30:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258238;
	bh=UGZpPzrJhhntr6Ji+Db4ROjivs8pfufcFzJuk2fRsFI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GceEUhID3awXE5Z6OPGct+bFSlhaYu68T/tZoAfS/pISMmFsgSlH4idMC7o9EOLb3
	 nl6wuxfd9bqeABsI8TaeQ5oy7NRj3FJcDdj+t9IaZ4M7/hGCtgyodQDLSuKYhuqTn9
	 fsxzZelKEWs7VAXZzx9SXbehxaSQEY/c/x/zY6MA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0818/1674] drm/amdgpu: remove two invalid BUG_ON()s
Date: Sat, 17 Oct 2026 17:51:30 +0200
Message-ID: <20261017160452.120343363@linuxfoundation.org>
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

[ Upstream commit 5d55ed19d4190d2c210ac05ac7a53f800a8c6fe5 ]

Those can be triggered trivially by userspace.

Signed-off-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Acked-by: Timur Kristóf <timur.kristof@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
index 131be358f9207..c3b92ba3f8213 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
@@ -5284,8 +5284,6 @@ static void gfx_v11_0_ring_emit_ib_gfx(struct amdgpu_ring *ring,
 	unsigned vmid = AMDGPU_JOB_GET_VMID(job);
 	u32 header, control = 0;
 
-	BUG_ON(ib->flags & AMDGPU_IB_FLAG_CE);
-
 	header = PACKET3(PACKET3_INDIRECT_BUFFER, 2);
 
 	control |= ib->length_dw | (vmid << 24);
-- 
2.53.0



