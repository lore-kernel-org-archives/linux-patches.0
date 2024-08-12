Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A879183CC4;
	Mon, 12 Aug 2024 16:18:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479513; cv=none; b=EcPJhwirlZN7tmZi30tPq+OgCr1Bso8gWyh8Km9JaUpHpAJakZ4nneYFhbes8kX02DRap2Ekoo2VNeyZSppIxeX5hwUSvUffwsT5KK/aShn8G4TRTTDlRz7iTc59uHKYIqJT+0cTRXrZbCsMEjNVmzrQGblb/hoLq2u2j8Ph/tU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479513; c=relaxed/simple;
	bh=iuM2L/ZSWQlaPWJz/i8ot/uRxNKti77mtZ14Ah+wb3Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bk+0ESjdcyKj5OqKC/5Z6qqBrtOHLps9OtHYf05CMnTh3eUNF+ALJ9L9utk+i6h6cpxBHmQoN0j6yjwANGJ6NIWgLqYJkcan82oFKUmrawDMts8lVSnYB+3ksTZFh9YEsd9wVjdJIBIz6P+uB87/oC+pfJjLP7p2F4Gkb4G3a3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MAIuqrHm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MAIuqrHm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B450AC32782;
	Mon, 12 Aug 2024 16:18:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479513;
	bh=iuM2L/ZSWQlaPWJz/i8ot/uRxNKti77mtZ14Ah+wb3Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MAIuqrHmerXKuQIuWNwxt+JAFjZr6d9bymCL7WnhoUUX/76FRLVhzqORuJWnxZCyq
	 TK0uOkDA6blFTzWus7ZUTupI55d66Ci25KKXr/x4orugpzLVGxYcKz8DRzeBKROme1
	 3V80FYSzFqxk5+xZHC6ZsLPut0r5S8RzWhkYgyy4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Wilson <chris.p.wilson@linux.intel.com>,
	Andi Shyti <andi.shyti@linux.intel.com>,
	Jonathan Cavitt <jonathan.cavitt@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Subject: [PATCH 6.6 111/189] drm/i915/gem: Adjust vma offset for framebuffer mmap offset
Date: Mon, 12 Aug 2024 18:02:47 +0200
Message-ID: <20240812160136.414248564@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160132.135168257@linuxfoundation.org>
References: <20240812160132.135168257@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andi Shyti <andi.shyti@linux.intel.com>

commit 1ac5167b3a90c9820daa64cc65e319b2d958d686 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/gem/i915_gem_mman.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/gpu/drm/i915/gem/i915_gem_mman.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_mman.c
@@ -1129,6 +1129,8 @@ int i915_gem_fb_mmap(struct drm_i915_gem
 		mmo = mmap_offset_attach(obj, mmap_type, NULL);
 		if (IS_ERR(mmo))
 			return PTR_ERR(mmo);
+
+		vma->vm_pgoff += drm_vma_node_start(&mmo->vma_node);
 	}
 
 	/*


