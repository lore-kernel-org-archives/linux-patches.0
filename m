Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831176;
	b=v0ERWbQ3rddzf9/f+ly4hQjkDCzWB5p+aqRhGFxmUthVxwXMdq9cCkjaculA3qbTqhH1
	 sxe0h5ZWuSOKwy01HWws41wihJhtAGk+P2xBmwWdbBo4PT1zD83+JJy1sZi0Mmgr5bl3I
	 SiaRPyTcp/naejeAbWBzKxTb8ktgQ0OgBHBaU7F0lGWdNZzVcq9gwndTKRZl8ZemkNDiH
	 0jIxEq4x+HZWFIr90Yudnw+q4SS1u1y09SJ07usJQvn7GkL1VKAatpfVYha1f7bbKNop8
	 +3/8wfM3kHIOUvoiAXfkyV3i4KGB2mcpHJvJTHnC0YtfcYFCILAvmJb2SXJGrles9tA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831176;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=rWp8rcrN8lyzoP2KCyVqOMrQpb3CcsWKJUQiuj1b5fw=;
	b=VUDf7AVlc5ski++FBs5M9HNQ+mkAxw4tOdk+qlWXaCdo59XhqOpB3VzjBFcnZMNLZDq2
	 k6CPKLPX77PIAvgvVgSYBuKudU8FcJa4KB32n8PqokkhV3gNDWJGcU3bhMHtQh50MYR1F
	 sBfrhcwrOTBr3y/JTD4vfVh/3Qvrttq+3Cz1YhmDIV/1eEYIUpX+narbi8aLxWIP3BIs9
	 HTkqHFSjTObYYUpVIf1D+SJXw2EAojBDjwITVe4OPCTEJihGQ/UD/He/RV7i56B6qbBc7
	 y9Ys3fjcOWB+CAQaFzN3RlSk8m6/o9W5F9HOPjaqlA7r7FtQA+EGONb37ZTXeKBF27Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ACwwwiM4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A819606A33C;
	Wed,  4 Nov 2026 22:26:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ACwwwiM4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDEF01F00A17;
	Wed,  4 Nov 2026 22:26:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831176;
	bh=rWp8rcrN8lyzoP2KCyVqOMrQpb3CcsWKJUQiuj1b5fw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ACwwwiM4pCXp6wsmrwrbHOpdq2Szbn4fymX3hR2WPzD3ZxQIgqD5jDwBwJh/ry5kD
	 sMkcwJIcspkV5YuOx1Awh8BnV9t7HnGCaUUE3A+KE5DJLllEe1YAsTmg3NqiSe/exh
	 GX4fXVQdGLZCRDHHiOf8eI0syxRIrBGQSEXj66pg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Auld <matthew.auld@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Maarten Lankhorst <dev@lankhorst.se>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0543/1005] drm/xe/display: skip FORCE_WC and vm_bound check for external dma-bufs
Date: Wed,  4 Nov 2026 16:04:36 -0500
Message-ID: <20261104211059.100492117@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Auld <matthew.auld@intel.com>

[ Upstream commit 3e493f88c84088ccd7b53cdd23ac5c875c9a60dd ]

Currently, xe_display_bo_framebuffer_init() unconditionally attempts to
apply XE_BO_FLAG_FORCE_WC to the buffer and rejects the FB creation with
-EINVAL if the BO is already VM_BINDed.

However, for imported dma-bufs (ttm_bo_type_sg), this check doesn't seem
to make much sense since CPU caching policy is entirely controlled by
the exporter. Plus there is no place to set this flag, in the first
place. Also this is not rejected if not yet vm_binded, but that seems
arbitrary since setting or not setting FORCE_WC should a noop either
way, at this stage, and whether it is currently VM_BINDed makes no
difference.

Currently if we run an app and offload rendering to an external dGPU,
like NV or another xe device, the dma-buf passed back to the compositor
(igpu) will be an actual external import from xe pov, and it will be
missing FORCE_WC, and if the compositor side did a VM_BIND before
turning into it into an fb the whole thing gets rejected.

So it looks like we either need to reject outright, no matter what, or
this usecase is valid and we need to loosen the restriction for sg
buffers.  Proposing here to loosen the restriction.

Assisted-by: Gemini:gemini-3.1-pro-preview
Link: https://gitlab.freedesktop.org/drm/xe/kernel/-/work_items/7919
Fixes: 44e694958b95 ("drm/xe/display: Implement display support")
Signed-off-by: Matthew Auld <matthew.auld@intel.com>
Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Maarten Lankhorst <dev@lankhorst.se>
Cc: <stable@vger.kernel.org> # v6.12+
Reviewed-by: Maarten Lankhorst <dev@lankhorst.se>
Link: https://patch.msgid.link/20260612170501.550816-2-matthew.auld@intel.com
[ sashal: Used SCANOUT in place of FORCE_WC and adapted the hunks to the older intel_fb_bo.c and xe_fb_pin.c code, adding the ttm_bo_type_sg exemption to both the flag check and the pin-time drm_WARN_ON. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/display/intel_fb_bo.c | 3 ++-
 drivers/gpu/drm/xe/display/xe_fb_pin.c   | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/xe/display/intel_fb_bo.c b/drivers/gpu/drm/xe/display/intel_fb_bo.c
index ebdb22c9499d7..b98afefdc4c84 100644
--- a/drivers/gpu/drm/xe/display/intel_fb_bo.c
+++ b/drivers/gpu/drm/xe/display/intel_fb_bo.c
@@ -46,7 +46,8 @@ int intel_fb_bo_framebuffer_init(struct drm_framebuffer *fb,
 	if (ret)
 		goto err;
 
-	if (!(bo->flags & XE_BO_FLAG_SCANOUT)) {
+	if (!(bo->flags & XE_BO_FLAG_SCANOUT) &&
+	    bo->ttm.type != ttm_bo_type_sg) {
 		/*
 		 * XE_BO_FLAG_SCANOUT should ideally be set at creation, or is
 		 * automatically set when creating FB. We cannot change caching
diff --git a/drivers/gpu/drm/xe/display/xe_fb_pin.c b/drivers/gpu/drm/xe/display/xe_fb_pin.c
index fa5c70478713a..c3e4645a94673 100644
--- a/drivers/gpu/drm/xe/display/xe_fb_pin.c
+++ b/drivers/gpu/drm/xe/display/xe_fb_pin.c
@@ -420,7 +420,8 @@ int intel_plane_pin_fb(struct intel_plane_state *new_plane_state,
 		return 0;
 
 	/* We reject creating !SCANOUT fb's, so this is weird.. */
-	drm_WARN_ON(bo->ttm.base.dev, !(bo->flags & XE_BO_FLAG_SCANOUT));
+	drm_WARN_ON(bo->ttm.base.dev, !(bo->flags & XE_BO_FLAG_SCANOUT) &&
+		    bo->ttm.type != ttm_bo_type_sg);
 
 	vma = __xe_pin_fb_vma(intel_fb, &new_plane_state->view.gtt, alignment);
 
-- 
2.53.0



