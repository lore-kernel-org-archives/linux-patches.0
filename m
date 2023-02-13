Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA9F48F57
	for <patches@lists.linux.dev>; Mon, 13 Feb 2023 15:00:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 616CAC4339B;
	Mon, 13 Feb 2023 15:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676300412;
	bh=SRYmsQtr7uoRmlvCMvnp3rTrwcGFeXSxqZ5WHB/ApaQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zadccWl2RbXGIOwllVq2tlgxmiuS+DfcZHbQKao6nSUszTqtfW9h2GnWbAiTeINwJ
	 /p7FCt2vpfr20ZNTnfBbKEPxvVYEgvCo2jTqPXOq6VvqnJ0wOFI4oIVoL4SeA05Byl
	 FJa0BZVfEYVjqLzS4wI+hqvCm5oiIcCxuXlX1714=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Auld <matthew.auld@intel.com>,
	Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
	Aravind Iddamsetty <aravind.iddamsetty@intel.com>,
	Andrzej Hajda <andrzej.hajda@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 5.15 65/67] drm/i915: Initialize the obj flags for shmem objects
Date: Mon, 13 Feb 2023 15:49:46 +0100
Message-Id: <20230213144735.501905723@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144732.336342050@linuxfoundation.org>
References: <20230213144732.336342050@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Aravind Iddamsetty <aravind.iddamsetty@intel.com>

commit 44e4c5684fcc82d8f099656c4ea39d9571e2a8ac upstream.

Obj flags for shmem objects is not being set correctly. Fixes in setting
BO_ALLOC_USER flag which applies to shmem objs as well.

v2: Add fixes tag (Tvrtko, Matt A)

Fixes: 13d29c823738 ("drm/i915/ehl: unconditionally flush the pages on acquire")
Cc: <stable@vger.kernel.org> # v5.15+
Cc: Matthew Auld <matthew.auld@intel.com>
Cc: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Reviewed-by: Matthew Auld <matthew.auld@intel.com>
Signed-off-by: Aravind Iddamsetty <aravind.iddamsetty@intel.com>
Reviewed-by: Andrzej Hajda <andrzej.hajda@intel.com>
Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
[tursulin: Grouped all tags together.]
Link: https://patchwork.freedesktop.org/patch/msgid/20230203135205.4051149-1-aravind.iddamsetty@intel.com
(cherry picked from commit bca0d1d3ceeb07be45a51c0fa4d57a0ce31b6aed)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/gem/i915_gem_shmem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/gem/i915_gem_shmem.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_shmem.c
@@ -533,7 +533,7 @@ static int shmem_object_init(struct inte
 	mapping_set_gfp_mask(mapping, mask);
 	GEM_BUG_ON(!(mapping_gfp_mask(mapping) & __GFP_RECLAIM));
 
-	i915_gem_object_init(obj, &i915_gem_shmem_ops, &lock_class, 0);
+	i915_gem_object_init(obj, &i915_gem_shmem_ops, &lock_class, flags);
 	obj->mem_flags |= I915_BO_FLAG_STRUCT_PAGE;
 	obj->write_domain = I915_GEM_DOMAIN_CPU;
 	obj->read_domains = I915_GEM_DOMAIN_CPU;


