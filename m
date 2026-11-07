Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061143;
	b=eDdKP1bLh57RVIFsjgOd6RqTPbniSsaLq6jLEluVz9fPfgt1R+vbybPxftGcn3l6cO+b
	 Ykb9px0Wcmpzv9sk4oL7ijk924/UyNTdTBNNqFyvQjfEqD5EqrQ+BBBDgpznasbIc2NY9
	 7HmGDzIR32WuQIPeXXwcM9CdMs0D+2c/bM0cVEsOuSqD620d1k+22aMu6PUdTVEbH+i/Q
	 KXp2TZTrxorelVrCHqSX1XPDwQiBOjlMg8W6de4UzqYcC3XEuwSmlg9HC0UWza+F6SRUq
	 zWoL623M2LkvLUt+4qQUNJ9ZPhXQHHzDN59srnKbSE1d85ZSkD5f/J69J1DPlo9oPGA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061143;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=rcW9NyuXr3/qSoPsPQ9n8ARHIg6lo0fcaNs+BF49HQI=;
	b=4CuBrnWrCDtvTl2jlKTirfKW6waitZKlkawChq/13YO98YZ4ZRK8szFOGzg1Nr01fWBV
	 K67duAL6K1At2mGUUgSV+UU0YjNQPL96UNKpTdII+8JAx3PgCTixLQg09RbCxByaAIitn
	 sflzegKc+ooXx6FfmvUGVCQfXZwsTmjHR3Syfso7iBE7W7Oq/QLC55A5+6+7FZx3x45r+
	 Bx6IQlWIFLl2DdC6HOpFzrrIBFmOPziftpVqNgz+cDPteYMfGjneyjDkNAYm6tY1O+jBG
	 OzTxLbnWw7GjYZQ2rk0vzOlrgYuAQKeDUmtvz1kg8mmhirZPxzTszsAj7j7hIAWTiAg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=v4exDqH7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF28F606D82D;
	Sat,  7 Nov 2026 14:19:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=v4exDqH7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C0121F0089F;
	Sat,  7 Nov 2026 14:19:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061142;
	bh=rcW9NyuXr3/qSoPsPQ9n8ARHIg6lo0fcaNs+BF49HQI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v4exDqH7av+I8R54mZiSiuSYh9XSSfCj9sPI4neeyXFhJ97+IUaYTE12hl1BMVmXG
	 QRZ6u3flARC/6pwkUBQXGF4GFhRYGnEFE8DBtUoK3hVWs/oyJbWBSztuRK6KpBT4JP
	 jpIhXl4Iumdi3A/u4N29HbO35tlibmMhwEbwO8Ww=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Auld <matthew.auld@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Maarten Lankhorst <dev@lankhorst.se>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0450/1536] drm/xe/display: skip FORCE_WC and vm_bound check for external dma-bufs
Date: Sat,  7 Nov 2026 08:41:06 -0500
Message-ID: <20261107135010.172650203@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Applied the sg-BO check to intel_fb_bo.c and intel_plane_pin_fb() instead of the refactored display file, and used the older XE_BO_FLAG_SCANOUT name in place of XE_BO_FLAG_FORCE_WC. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/display/intel_fb_bo.c | 3 ++-
 drivers/gpu/drm/xe/display/xe_fb_pin.c   | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/xe/display/intel_fb_bo.c b/drivers/gpu/drm/xe/display/intel_fb_bo.c
index 63ce97cc4cfef..7a3afa9af5c9f 100644
--- a/drivers/gpu/drm/xe/display/intel_fb_bo.c
+++ b/drivers/gpu/drm/xe/display/intel_fb_bo.c
@@ -43,7 +43,8 @@ int intel_fb_bo_framebuffer_init(struct intel_framebuffer *intel_fb,
 	if (ret)
 		goto err;
 
-	if (!(bo->flags & XE_BO_FLAG_SCANOUT)) {
+	if (!(bo->flags & XE_BO_FLAG_SCANOUT) &&
+	    bo->ttm.type != ttm_bo_type_sg) {
 		/*
 		 * XE_BO_FLAG_SCANOUT should ideally be set at creation, or is
 		 * automatically set when creating FB. We cannot change caching
diff --git a/drivers/gpu/drm/xe/display/xe_fb_pin.c b/drivers/gpu/drm/xe/display/xe_fb_pin.c
index 75756cc0255c0..33fdfb9e612ec 100644
--- a/drivers/gpu/drm/xe/display/xe_fb_pin.c
+++ b/drivers/gpu/drm/xe/display/xe_fb_pin.c
@@ -361,7 +361,8 @@ int intel_plane_pin_fb(struct intel_plane_state *plane_state)
 	struct i915_vma *vma;
 
 	/* We reject creating !SCANOUT fb's, so this is weird.. */
-	drm_WARN_ON(bo->ttm.base.dev, !(bo->flags & XE_BO_FLAG_SCANOUT));
+	drm_WARN_ON(bo->ttm.base.dev, !(bo->flags & XE_BO_FLAG_SCANOUT) &&
+		    bo->ttm.type != ttm_bo_type_sg);
 
 	vma = __xe_pin_fb_vma(to_intel_framebuffer(fb), &plane_state->view.gtt);
 	if (IS_ERR(vma))
-- 
2.53.0



