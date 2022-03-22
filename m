Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B5326453
	for <patches@lists.linux.dev>; Tue, 22 Mar 2022 21:43:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 675CAC340EC;
	Tue, 22 Mar 2022 21:43:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1647985380;
	bh=wZjjPIHrZl/Gm3NIx0w7E2TeqahXjahiA5sz15thP9w=;
	h=Date:To:From:In-Reply-To:Subject:From;
	b=nn9+6RD0jLm8REiUbTs3y9OUYUdrQyDOq7HKBvuhazT4ZcD0lTefti243YG2gxrxn
	 nRaYi/5AZtlnI+03ggHCA+dEuBN0IWBOCEwnFvRgNz/HOHx78b80IXDAFCo393MUEf
	 /DSrtAd8EEMZmidEWlTPRSF8ZNkQ6UkWEVxrT2p0=
Date: Tue, 22 Mar 2022 14:42:59 -0700
To: abaci@linux.alibaba.com,jiapeng.chong@linux.alibaba.com,akpm@linux-foundation.org,patches@lists.linux.dev,linux-mm@kvack.org,mm-commits@vger.kernel.org,torvalds@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 088/227] mm/vmalloc.c: fix "unused function" warning
Message-Id: <20220322214300.675CAC340EC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

From: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Subject: mm/vmalloc.c: fix "unused function" warning

compute_subtree_max_size() is unused, when building with
DEBUG_AUGMENT_PROPAGATE_CHECK=y.

mm/vmalloc.c:785:1: warning: unused function 'compute_subtree_max_size'
[-Wunused-function].

Link: https://lkml.kernel.org/r/20220129034652.75359-1-jiapeng.chong@linux.alibaba.com
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

--- a/mm/vmalloc.c~mm-vmallocc-fix-unused-function-warning
+++ a/mm/vmalloc.c
@@ -775,17 +775,6 @@ get_subtree_max_size(struct rb_node *nod
 	return va ? va->subtree_max_size : 0;
 }
 
-/*
- * Gets called when remove the node and rotate.
- */
-static __always_inline unsigned long
-compute_subtree_max_size(struct vmap_area *va)
-{
-	return max3(va_size(va),
-		get_subtree_max_size(va->rb_node.rb_left),
-		get_subtree_max_size(va->rb_node.rb_right));
-}
-
 RB_DECLARE_CALLBACKS_MAX(static, free_vmap_area_rb_augment_cb,
 	struct vmap_area, rb_node, unsigned long, subtree_max_size, va_size)
 
@@ -973,6 +962,17 @@ unlink_va(struct vmap_area *va, struct r
 }
 
 #if DEBUG_AUGMENT_PROPAGATE_CHECK
+/*
+ * Gets called when remove the node and rotate.
+ */
+static __always_inline unsigned long
+compute_subtree_max_size(struct vmap_area *va)
+{
+	return max3(va_size(va),
+		get_subtree_max_size(va->rb_node.rb_left),
+		get_subtree_max_size(va->rb_node.rb_right));
+}
+
 static void
 augment_tree_propagate_check(void)
 {
_
