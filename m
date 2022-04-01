Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AE7E137F
	for <patches@lists.linux.dev>; Fri,  1 Apr 2022 18:21:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6190C340EE;
	Fri,  1 Apr 2022 18:21:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1648837263;
	bh=eZ2HMLynMVKisQsVjiOEKtM9S5co7bsJ7fU8NsRUXWc=;
	h=Date:To:From:In-Reply-To:Subject:From;
	b=f3NvgHOmWoCd8IoOgY+Int/TbldLEjITe1go7JFL+ZcoGXIxD0ZPaKs1AzGRZfmpe
	 iFeNNzyLRqy147hCoN7EYjErmVx4LBXGTjpWHjAYx3lXuDOnavnVEtEl8uhZtiSEiA
	 05DvbzeXO5rzM4kTRKioxTwN1WJclmRtp6gcI6cg=
Date: Fri, 01 Apr 2022 11:21:03 -0700
To: willy@infradead.org,sunhao.th@gmail.com,david@redhat.com,konishi.ryusuke@gmail.com,akpm@linux-foundation.org,patches@lists.linux.dev,linux-mm@kvack.org,mm-commits@vger.kernel.org,torvalds@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <l>
Subject: [patch 05/16] nilfs2: get rid of nilfs_mapping_init()
Message-Id: <20220401182103.D6190C340EE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Subject: nilfs2: get rid of nilfs_mapping_init()

After applying the lockdep warning fixes, nilfs_mapping_init() is no
longer used, so delete it.

Link: https://lkml.kernel.org/r/1647867427-30498-4-git-send-email-konishi.ryusuke@gmail.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hao Sun <sunhao.th@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/page.c |    9 ---------
 fs/nilfs2/page.h |    1 -
 2 files changed, 10 deletions(-)

--- a/fs/nilfs2/page.c~nilfs2-get-rid-of-nilfs_mapping_init
+++ a/fs/nilfs2/page.c
@@ -436,15 +436,6 @@ unsigned int nilfs_page_count_clean_buff
 	return nc;
 }
 
-void nilfs_mapping_init(struct address_space *mapping, struct inode *inode)
-{
-	mapping->host = inode;
-	mapping->flags = 0;
-	mapping_set_gfp_mask(mapping, GFP_NOFS);
-	mapping->private_data = NULL;
-	mapping->a_ops = &empty_aops;
-}
-
 /*
  * NILFS2 needs clear_page_dirty() in the following two cases:
  *
--- a/fs/nilfs2/page.h~nilfs2-get-rid-of-nilfs_mapping_init
+++ a/fs/nilfs2/page.h
@@ -43,7 +43,6 @@ int nilfs_copy_dirty_pages(struct addres
 void nilfs_copy_back_pages(struct address_space *, struct address_space *);
 void nilfs_clear_dirty_page(struct page *, bool);
 void nilfs_clear_dirty_pages(struct address_space *, bool);
-void nilfs_mapping_init(struct address_space *mapping, struct inode *inode);
 unsigned int nilfs_page_count_clean_buffers(struct page *, unsigned int,
 					    unsigned int);
 unsigned long nilfs_find_uncommitted_extent(struct inode *inode,
_
