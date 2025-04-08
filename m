Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D93326F478;
	Tue,  8 Apr 2025 12:57:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744117072; cv=none; b=CkH2a+GT+u7KCQmDoTBQJlJ44UTBRQuazouZ0BsE4rXoKUiq/gXTkQ1T0S+lv7H+yx9TCvYy+W5g4gjRRxnDCPeRi/DOfOKQvICMBhnZ0BP6HwV4mw7V2K3mlNFYSaj4e7nscydD5Gy0iRoNDNG4evUfudOnTTvBoZqMDljpq5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744117072; c=relaxed/simple;
	bh=7ddwo3dFTtNTt7G9cgdlLZrdFiX8P5yIL9kOL0VQziE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rUwzkxbOOY6lBuQHG3c2fNuie71i7xizcGg+YcNjbqswELTfRIqOP77PremtYO1dGcqOtv8g+G2n7h8zY14z+mKKbKAQWNh0sdmIBDENoTY5zSvwGuOxzOeIktkUx0b2aenaG7nEp++HR87gmn5odbfrsbiltiL8HChYxI4g4ag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pZXJwfFK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pZXJwfFK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2B59C4CEE5;
	Tue,  8 Apr 2025 12:57:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744117072;
	bh=7ddwo3dFTtNTt7G9cgdlLZrdFiX8P5yIL9kOL0VQziE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pZXJwfFK4tfQ69j3VNvB3YWzxQuZPTqgMm+eh4mbWSBVjBvohFKAWhGo3Uwn9UKkv
	 sSsH2xujTF4mh/ZK7mNMbBVozOm9oi+YphzYfyw3QJGI0sA2A0NglY0urdGOwoIxI+
	 ckM4HIb3cxL0LgV9YzEykdlFPjq8GbQjKdIG6/IQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sunil Khatri <sunil.khatri@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 347/423] drm/amdgpu/gfx12: fix num_mec
Date: Tue,  8 Apr 2025 12:51:13 +0200
Message-ID: <20250408104853.923513026@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit dce8bd9137b88735dd0efc4e2693213d98c15913 ]

GC12 only has 1 mec.

Fixes: 52cb80c12e8a ("drm/amdgpu: Add gfx v12_0 ip block support (v6)")
Reviewed-by: Sunil Khatri <sunil.khatri@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v12_0.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v12_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v12_0.c
index d3798a333d1f8..b259e217930c7 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v12_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v12_0.c
@@ -1332,7 +1332,7 @@ static int gfx_v12_0_sw_init(void *handle)
 		adev->gfx.me.num_me = 1;
 		adev->gfx.me.num_pipe_per_me = 1;
 		adev->gfx.me.num_queue_per_pipe = 1;
-		adev->gfx.mec.num_mec = 2;
+		adev->gfx.mec.num_mec = 1;
 		adev->gfx.mec.num_pipe_per_mec = 2;
 		adev->gfx.mec.num_queue_per_pipe = 4;
 		break;
-- 
2.39.5



