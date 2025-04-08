Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A95C27C851;
	Tue,  8 Apr 2025 12:57:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744117043; cv=none; b=tcgFj0eY/2nx3/bTL0mNroSU4mFhieDZNh/zJFDqvfSxcUYA/GQo0SCQGRM1xe+w4hkyt7YB51yZKCCv+1isdIHlzVBGSk/kBJaqb1+b4+pCVBM5iVwDC7MvZD7RP8K+3S37O8WvV1s4x+x8F9UawgaRVwn1N8RCTFuzS/NdD9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744117043; c=relaxed/simple;
	bh=Uxd6mR3tNP+UrtOwwFqp/53TsP1dWpGoeXMbOYeqAB0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vA5yE6Z2DKU6750OtPaYO5ulXsBS09e4+9NdZ0owRzkQ8oQyqwNc1JkFOwvtA9MgMuYxflDGfRMDXLnInxs+ryEg93oHuNk7oxZ73Hl1csHPFI4YV7W+aeQlLtFGxE0akyIfv/wrKusutH11bpGCmfS5NcEGed3y1wJTcm3F9GU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TRlAOp7I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TRlAOp7I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26511C4CEE5;
	Tue,  8 Apr 2025 12:57:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744117042;
	bh=Uxd6mR3tNP+UrtOwwFqp/53TsP1dWpGoeXMbOYeqAB0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TRlAOp7IE/y4X98+hFd+rMOQEzHwJpY7wsR8R600vXWywscyebM36bnAJ7k1Rr8vh
	 mJv3EomLVXBPXvcNOFrKW3Ya6R/0OelxMCZSnA+Oe/zHDdL6JOefGM0bmKxiFG+s2M
	 OwvVmKPYhug1za9+EPz13yj65kYgWFA3LJ/X5WKw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sunil Khatri <sunil.khatri@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 346/423] drm/amdgpu/gfx11: fix num_mec
Date: Tue,  8 Apr 2025 12:51:12 +0200
Message-ID: <20250408104853.899493081@linuxfoundation.org>
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

[ Upstream commit 4161050d47e1b083a7e1b0b875c9907e1a6f1f1f ]

GC11 only has 1 mec.

Fixes: 3d879e81f0f9 ("drm/amdgpu: add init support for GFX11 (v2)")
Reviewed-by: Sunil Khatri <sunil.khatri@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
index d3e8be82a1727..84cf5fd297b7f 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
@@ -1549,7 +1549,7 @@ static int gfx_v11_0_sw_init(void *handle)
 		adev->gfx.me.num_me = 1;
 		adev->gfx.me.num_pipe_per_me = 1;
 		adev->gfx.me.num_queue_per_pipe = 1;
-		adev->gfx.mec.num_mec = 2;
+		adev->gfx.mec.num_mec = 1;
 		adev->gfx.mec.num_pipe_per_mec = 4;
 		adev->gfx.mec.num_queue_per_pipe = 4;
 		break;
-- 
2.39.5



