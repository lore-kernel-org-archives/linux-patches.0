Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29FC01ED25
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 16:12:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 574E7C433C8;
	Fri, 21 Jul 2023 16:12:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689955945;
	bh=K5wY6MwYufgtvkC9EDJJ0D1S6y6XF1o/qZ2LxZNKqBs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kynfhJDjNVaewoG4Nsu/YxQA1imDekwxx00UmolOizggW9zGg9hRUZYBxOPzeW9ST
	 o09oAD53BHmiJybbfuKbe9RR5VrAZGTCxuelL7p04Xr7gsn5JFPIcSXTqg6/uMpLxC
	 D+laO7SCQ5YMUP4vcjL/a9NP8K5sjkLQX18bEGGc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
	Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>,
	Tejas Upadhyay <tejas.upadhyay@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 086/292] drm/i915: Fix one wrong caching mode enum usage
Date: Fri, 21 Jul 2023 18:03:15 +0200
Message-ID: <20230721160532.497764501@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160528.800311148@linuxfoundation.org>
References: <20230721160528.800311148@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Tvrtko Ursulin <tvrtko.ursulin@intel.com>

[ Upstream commit 113899c2669dff148b2a5bea4780123811aecc13 ]

Commit a4d86249c773 ("drm/i915/gt: Provide a utility to create a scratch
buffer") mistakenly passed in uapi I915_CACHING_CACHED as argument to
i915_gem_object_set_cache_coherency(), which actually takes internal
enum i915_cache_level.

No functional issue since the value matches I915_CACHE_LLC (1 == 1), which
is the intended caching mode, but lets clean it up nevertheless.

Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Fixes: a4d86249c773 ("drm/i915/gt: Provide a utility to create a scratch buffer")
Cc: Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
Reviewed-by: Tejas Upadhyay <tejas.upadhyay@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230707125503.3965817-1-tvrtko.ursulin@linux.intel.com
(cherry picked from commit 49c60b2f0867ac36fd54d513882a48431aeccae7)
Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/gt/intel_gtt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/gt/intel_gtt.c b/drivers/gpu/drm/i915/gt/intel_gtt.c
index 4f436ba7a3c83..123b82f29a1bf 100644
--- a/drivers/gpu/drm/i915/gt/intel_gtt.c
+++ b/drivers/gpu/drm/i915/gt/intel_gtt.c
@@ -625,7 +625,7 @@ __vm_create_scratch_for_read(struct i915_address_space *vm, unsigned long size)
 	if (IS_ERR(obj))
 		return ERR_CAST(obj);
 
-	i915_gem_object_set_cache_coherency(obj, I915_CACHING_CACHED);
+	i915_gem_object_set_cache_coherency(obj, I915_CACHE_LLC);
 
 	vma = i915_vma_instance(obj, vm, NULL);
 	if (IS_ERR(vma)) {
-- 
2.39.2



