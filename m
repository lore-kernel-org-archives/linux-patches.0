Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96DB16453
	for <patches@lists.linux.dev>; Tue, 22 Mar 2022 21:43:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61053C340F2;
	Tue, 22 Mar 2022 21:43:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1647985383;
	bh=xOP4VsLcA/A6DThG+5c6QHsNCq7VcSxGTkMgyqZJ33Q=;
	h=Date:To:From:In-Reply-To:Subject:From;
	b=gRWk7wOp07OmBgxLZEXng+qBoCDeBf4+F6cG9CkWZ6o2Q+wt55EDTudRO4ULwFVbL
	 UNoDDrczYoPQGcIlznv7urCMmGH0NVRVxEye+gU941C7L9lyGEhxM1ROZA3tUhI1cH
	 Tsbozdvs5ofP6QtPTkw1JAGkkoxXKv0za/fEzoJs=
Date: Tue, 22 Mar 2022 14:43:02 -0700
To: urezki@gmail.com,lpf.vector@gmail.com,libang.linuxer@gmail.com,akpm@linux-foundation.org,patches@lists.linux.dev,linux-mm@kvack.org,mm-commits@vger.kernel.org,torvalds@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 089/227] mm/vmalloc: fix comments about vmap_area struct
Message-Id: <20220322214303.61053C340F2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

From: Bang Li <libang.linuxer@gmail.com>
Subject: mm/vmalloc: fix comments about vmap_area struct

The vmap_area_root should be in the "busy" tree and the
free_vmap_area_root should be in the "free" tree.

Link: https://lkml.kernel.org/r/20220305011510.33596-1-libang.linuxer@gmail.com
Fixes: 688fcbfc06e4 ("mm/vmalloc: modify struct vmap_area to reduce its size")
Signed-off-by: Bang Li <libang.linuxer@gmail.com>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Pengfei Li <lpf.vector@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vmalloc.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/vmalloc.h~mm-vmalloc-fix-comments-about-vmap_area-struct
+++ a/include/linux/vmalloc.h
@@ -80,8 +80,8 @@ struct vmap_area {
 	/*
 	 * The following two variables can be packed, because
 	 * a vmap_area object can be either:
-	 *    1) in "free" tree (root is vmap_area_root)
-	 *    2) or "busy" tree (root is free_vmap_area_root)
+	 *    1) in "free" tree (root is free_vmap_area_root)
+	 *    2) or "busy" tree (root is vmap_area_root)
 	 */
 	union {
 		unsigned long subtree_max_size; /* in "free" tree */
_
