Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE5B2188A09;
	Tue, 10 Sep 2024 10:15:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963310; cv=none; b=Ynmjp/ZJtVHuA3k5vk9nWVEauDkRny6khGagk70wSeXm/2hV8k4e/ZyAwFnZNDtnoONnE5giYKtgyzaS95rqZBJ+mfPX639Q+UshTJixmrXjUAJz3NkR+4RzfJADWMI9IEmvAlmmuHl4CIPCNH900spbbCnzlqnCKLxAaVx+Klo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963310; c=relaxed/simple;
	bh=K4TzeoQdY58wEde+cZnEYk4Z0tj4Ymtbkm+TBBCcTdU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=W4AQqYcEu7J6nWGcPGJYG0n2dD0sFncniyHt5zNJglvQhJ4NxrykW4KgBXjWWBenSIwhjL+hWplU19kt7EkCTNDyHZ9U3d8AKK9aUSwKdUtgzbQBYladCjD0lKbeH97Cx7PGNz8h/ikuGCzzTrjfkHSwl5xMjjxGmqQL/2gDJaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wXRxASH8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wXRxASH8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 175B8C4CEC3;
	Tue, 10 Sep 2024 10:15:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963309;
	bh=K4TzeoQdY58wEde+cZnEYk4Z0tj4Ymtbkm+TBBCcTdU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wXRxASH8oHn09KZSEjv6rxr1u8cYKlcMoa0+9UKFdZFZ3lPkFQZT8CeLiWgyo/E+O
	 BvL9c0FP0Cj59dBIO7OpF1fJ9OcZsl7VfFLvZV9RuWFYYlwmPU27+8Y3NnySJjhBWf
	 WZIKx0hMiVUhi+Fg7p4MApRMBHigWPHncKk9UXcM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Huang <Tim.Huang@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 014/214] drm/amdgpu: fix uninitialized scalar variable warning
Date: Tue, 10 Sep 2024 11:30:36 +0200
Message-ID: <20240910092559.316569524@linuxfoundation.org>
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

From: Tim Huang <Tim.Huang@amd.com>

[ Upstream commit 9a5f15d2a29d06ce5bd50919da7221cda92afb69 ]

Clear warning that uses uninitialized value fw_size.

Signed-off-by: Tim Huang <Tim.Huang@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c
index b508126a9738..8d9bdec2b700 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c
@@ -410,6 +410,8 @@ static void amdgpu_virt_add_bad_page(struct amdgpu_device *adev,
 	uint64_t retired_page;
 	uint32_t bp_idx, bp_cnt;
 
+	memset(&bp, 0, sizeof(bp));
+
 	if (bp_block_size) {
 		bp_cnt = bp_block_size / sizeof(uint64_t);
 		for (bp_idx = 0; bp_idx < bp_cnt; bp_idx++) {
-- 
2.43.0



