Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBF0D19F473;
	Thu, 15 Aug 2024 14:06:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730800; cv=none; b=KyVOcHoMV25759fQIWsn7+NSshX52bAQiolOEY0ATDTcyaSKvIbeRys1uScpSq3YNVLS7j/chcXEawYAgKAGBfeyC6qaHv3DLU6Og+ckq/6ORj9bREYM+F3GU9l/y9UJqEatIfpwsznWT3+ob4UzITdi3FBzWvk+rRKmTErnuac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730800; c=relaxed/simple;
	bh=IJy+5fuvu9hJ9IvkgQefMtM9rlKNJpRZT4DaAEa7U9Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VmskQAbgh8pEwzDzjNnbP5pd9v9TwZIhZEheuJy3b2H8+yQ7TsigjIUYaNLMpgiMrbAx4HU00zQdo+dKorwVqfiAbH4gyDkfUbtycY/iNuZWi4e8O6Z1C9gwBSpra9TjWH7IGn+FliVzqzokVnJGLIN2Zr5ZK4IPKedgjRqEUPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BcV9coWy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BcV9coWy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FBBCC32786;
	Thu, 15 Aug 2024 14:06:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730800;
	bh=IJy+5fuvu9hJ9IvkgQefMtM9rlKNJpRZT4DaAEa7U9Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BcV9coWyBW4I9J5kSoQwjyurmAHt6bYV7k8NsBysdfJRVk5F1LGijSr/sY0WK8tc5
	 7IoN7ASN9dCj7SbSFTOTBXQ3+Hdy+cTBBEhrYp7R27+U8ZlTdy5BytqR1aGGbJch+x
	 klZl60+mA8haOLcsE15XyGuc+pHKixkdfftov4Cs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Wilson <chris.p.wilson@linux.intel.com>,
	Andi Shyti <andi.shyti@linux.intel.com>,
	Jonathan Cavitt <jonathan.cavitt@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 34/38] drm/i915/gem: Adjust vma offset for framebuffer mmap offset
Date: Thu, 15 Aug 2024 15:26:08 +0200
Message-ID: <20240815131834.267200726@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131832.944273699@linuxfoundation.org>
References: <20240815131832.944273699@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andi Shyti <andi.shyti@linux.intel.com>

[ Upstream commit 1ac5167b3a90c9820daa64cc65e319b2d958d686 ]

When mapping a framebuffer object, the virtual memory area (VMA)
offset ('vm_pgoff') should be adjusted by the start of the
'vma_node' associated with the object. This ensures that the VMA
offset is correctly aligned with the corresponding offset within
the GGTT aperture.

Increment vm_pgoff by the start of the vma_node with the offset=
provided by the user.

Suggested-by: Chris Wilson <chris.p.wilson@linux.intel.com>
Signed-off-by: Andi Shyti <andi.shyti@linux.intel.com>
Reviewed-by: Jonathan Cavitt <jonathan.cavitt@intel.com>
Reviewed-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: <stable@vger.kernel.org> # v4.9+
[Joonas: Add Cc: stable]
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240802083850.103694-2-andi.shyti@linux.intel.com
(cherry picked from commit 60a2066c50058086510c91f404eb582029650970)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/gem/i915_gem_mman.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/i915/gem/i915_gem_mman.c b/drivers/gpu/drm/i915/gem/i915_gem_mman.c
index 4a291d29c5af5..7e9310d01dfdd 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_mman.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_mman.c
@@ -1120,6 +1120,8 @@ int i915_gem_fb_mmap(struct drm_i915_gem_object *obj, struct vm_area_struct *vma
 		mmo = mmap_offset_attach(obj, mmap_type, NULL);
 		if (IS_ERR(mmo))
 			return PTR_ERR(mmo);
+
+		vma->vm_pgoff += drm_vma_node_start(&mmo->vma_node);
 	}
 
 	/*
-- 
2.43.0



