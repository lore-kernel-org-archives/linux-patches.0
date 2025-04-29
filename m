Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2155D1C6B4;
	Tue, 29 Apr 2025 17:22:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947323; cv=none; b=EhllipcqPhhDdzcCkpQ01FPKiNlxLI3fKuXat9lwCobRcdHmLNSusv5zhLvErhetqEgN2DlYMVoTqqK1FCRDr9TN1bG/wwXX0GSS4btESkEpCf+GZAXMz8vFEURq0suOxmMeEY96u6ci4KC/qnCPglErC7grbwesPd+FbouFa9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947323; c=relaxed/simple;
	bh=vcdzTl+QczwVR83WV54k0qNtVOZx4LuD8n8JziW8GsY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tgqQtRWmrj4SSO26pEiXEPTFBiLRqYq64u7K+MTuyJL8R7VHiF/zWjAMZdyVzRd6xjNJ1eSvKMGFDOxljymSz9ljxIKiRJGuDSAPyv/07ClfuVO3lUMFy/J247Q1WkQNkKGfgrujOKPPKcuGpGw3KApzHJ4KlYYHm9tmYSCsP/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oMBS43ce; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oMBS43ce"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A8DFC4CEE3;
	Tue, 29 Apr 2025 17:22:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947323;
	bh=vcdzTl+QczwVR83WV54k0qNtVOZx4LuD8n8JziW8GsY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oMBS43cebPdsA9AaDARHvViKbM833eLHOj8QaPUkndniHUuv8csqMk25cwQsYt1uZ
	 5w/hQREwxxkEw1uiUhj/E2hC7IscME777vvy0QlQFiBNqFLCwNLlZ0vtomBjFjlLSN
	 8hNSGSBdB4jK9WAfsIHFeVvMdI1U2Ub0QUgIJg+4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	David Airlie <airlied@linux.ie>,
	Daniel Vetter <daniel@ffwll.ch>,
	amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	Lee Jones <lee.jones@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 227/286] drm/amd/amdgpu/amdgpu_vram_mgr: Add missing descriptions for dev and dir
Date: Tue, 29 Apr 2025 18:42:11 +0200
Message-ID: <20250429161117.276432663@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161107.848008295@linuxfoundation.org>
References: <20250429161107.848008295@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Lee Jones <lee.jones@linaro.org>

[ Upstream commit 2c8645b7a6974b33744b677e9ddc89650776af46 ]

Fixes the following W=1 kernel build warning(s):

 drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c:648: warning: Function parameter or member 'dev' not described in 'amdgpu_vram_mgr_free_sgt'
 drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c:648: warning: Function parameter or member 'dir' not described in 'amdgpu_vram_mgr_free_sgt'

Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: "Christian König" <christian.koenig@amd.com>
Cc: David Airlie <airlied@linux.ie>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: amd-gfx@lists.freedesktop.org
Cc: dri-devel@lists.freedesktop.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: c0dd8a9253fa ("drm/amdgpu/dma_buf: fix page_link check")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c
index 0c6b7c5ecfec8..2c3a94e939bab 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c
@@ -531,6 +531,8 @@ int amdgpu_vram_mgr_alloc_sgt(struct amdgpu_device *adev,
  * amdgpu_vram_mgr_alloc_sgt - allocate and fill a sg table
  *
  * @adev: amdgpu device pointer
+ * @dev: device pointer
+ * @dir: data direction of resource to unmap
  * @sgt: sg table to free
  *
  * Free a previously allocate sg table.
-- 
2.39.5



