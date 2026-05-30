Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A369341AC7;
	Sat, 30 May 2026 17:56:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163809; cv=none; b=bUsL9DCm40pHSj+0fzW/KwHZ/KHRtEsTISgybpKPY/381HoH61VMs0NjtL/6MFEw9zv/qj9a7u/r0DULiJNk7QczfQT4yR34x1ArvulxtRkboFXgkZTZfCGh8/wMrBbSv+mzJ9AckA8Um8bT9meQyoNPI5OLGmUt52qrjkAoDL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163809; c=relaxed/simple;
	bh=CIS3yYf2nHkK9Dv3/JYfPu13Pj0MTMBhIw/S0uQDizI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nGi86YT5uyqJ5UECXqIlA5aCavZffb50TNh72VT6WHW/7fWBVbWXVARWDWkXBJdxvxvWqklWj0Vraf79Y4AxBL02H4IyIZcj6fAQ16QZqVu4gKzEZ+ZF1s5JF+6I3T+S00SbZdJt1HS+8W0QOOnzU2jF5pAea3HHem41R4seF/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tuezgylv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tuezgylv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FB771F00893;
	Sat, 30 May 2026 17:56:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163808;
	bh=IXU3WuUAf5PxgyOKkaMixV5/YFtZwxNR9RcHqPgdJuI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tuezgylv13OmUM1SoqxaQq8nnZw1gglSV23cfUmo9lxVxsEpJw3tMR7HDyQ8W3k4K
	 Aq3sNe0MDg01qWjDjmoa9FdTkk8O6jtKu+4oVi1vDT1eGtmxIl4FjANi5bhV8Q1zbQ
	 wHl3fLs4I3YuMf1XqmbOVSCY4iv8n0ya3Ikl0iVc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	"John B. Moore" <jbmoore61@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.15 369/776] drm/amdgpu/gfx9: drop unnecessary 64-bit fence flag check in KIQ
Date: Sat, 30 May 2026 18:01:23 +0200
Message-ID: <20260530160250.085842942@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John B. Moore <jbmoore61@gmail.com>

commit 7bbfb2559bcec39d1a4e1182d931a2046112c352 upstream.

Remove the BUG_ON(flags & AMDGPU_FENCE_FLAG_64BIT) assertion from
gfx_v9_0_ring_emit_fence_kiq().  The KIQ hardware supports 64-bit
fence writes; the 32-bit writeback address constraint is an
upper-layer convention, not a hardware limitation.  The check serves
no purpose and should not be present.

Found by code inspection while investigating related BUG_ON
assertions in the GFX and compute ring emission paths.

Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: John B. Moore <jbmoore61@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 1b1101a46a426bb4328116bb5273c326a2780389)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
@@ -5533,9 +5533,6 @@ static void gfx_v9_0_ring_emit_fence_kiq
 {
 	struct amdgpu_device *adev = ring->adev;
 
-	/* we only allocate 32bit for each seq wb address */
-	BUG_ON(flags & AMDGPU_FENCE_FLAG_64BIT);
-
 	/* write fence seq to the "addr" */
 	amdgpu_ring_write(ring, PACKET3(PACKET3_WRITE_DATA, 3));
 	amdgpu_ring_write(ring, (WRITE_DATA_ENGINE_SEL(0) |


