Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DD363B7B72;
	Sat, 30 May 2026 18:07:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780164451; cv=none; b=rxwWuO/kJSyLcRFtP2vVTBSoPHhYkaN1Z2cVs7IQUbWU9BAo8BvjOaapX+q8pd6wk0LHW0ix7m8BS9oz57xecuipIUd54zjJ1ApWc+GUaWoovGcU1+jXxzWN0Ye67o/+YmNy1K+4a5bFZcduOXycoScEPr90hqEHO1nfYRmr0To=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780164451; c=relaxed/simple;
	bh=OeIelfQd5K1H0D7rOm3lCnY8mvBGgy1973LDL+A/dKQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E0PmN/sD/WGco3EsNL76LqIO1zaShLGPbK8I/ZekyI5PUlAQWtDseXeUkt3fZQWqYnB7iMjkKkFPV8Wt8Qb7Zyxyjr3wnAd+JmKadMzJ4mz1ip08htIYd5SiVUiexTvM7TEmUZayIzHokhmtJs098cH/ZzwhzEfsuOZ4hh1hjSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kqjKyw4Z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kqjKyw4Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 507861F00893;
	Sat, 30 May 2026 18:07:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780164449;
	bh=N2ahyQoNWP/hjb1gcTjk4pIeMR5rt6efI2yiX4L9H4Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kqjKyw4ZMW4qNGtM6yv1cS5E8AlNcBxOyyscPnL51q9YC+UIdv3DugtPAmXK7LLmb
	 +PtiG7J70U9UhHMpkVIHPLdG8PjPVCYRn4+eAPz6J/UausQ/NJJih2fiaZN5P+vZkS
	 nROVtYNklpggmd/SeGtsmr02dxbm3MejyRydGzj8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anna Schumaker <anna.schumkaer@oracle.com>,
	Jeff Layton <jlayton@kernel.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 530/776] nfs/blocklayout: Fix compilation error (`make W=1`) in bl_write_pagelist()
Date: Sat, 30 May 2026 18:04:04 +0200
Message-ID: <20260530160253.907612082@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit f83c8dda456ce4863f346aa26d88efa276eda35d ]

Clang compiler is not happy about set but unused variable
(when dprintk() is no-op):

.../blocklayout/blocklayout.c:384:9: error: variable 'count' set but not used [-Werror,-Wunused-but-set-variable]

Remove a leftover from the previous cleanup.

Fixes: 3a6fd1f004fc ("pnfs/blocklayout: remove read-modify-write handling in bl_write_pagelist")
Acked-by: Anna Schumaker <anna.schumkaer@oracle.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/blocklayout/blocklayout.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/nfs/blocklayout/blocklayout.c b/fs/nfs/blocklayout/blocklayout.c
index 76423557f5b3d..54a18a9540aae 100644
--- a/fs/nfs/blocklayout/blocklayout.c
+++ b/fs/nfs/blocklayout/blocklayout.c
@@ -399,14 +399,13 @@ bl_write_pagelist(struct nfs_pgio_header *header, int sync)
 	sector_t isect, extent_length = 0;
 	struct parallel_io *par = NULL;
 	loff_t offset = header->args.offset;
-	size_t count = header->args.count;
 	struct page **pages = header->args.pages;
 	int pg_index = header->args.pgbase >> PAGE_SHIFT;
 	unsigned int pg_len;
 	struct blk_plug plug;
 	int i;
 
-	dprintk("%s enter, %zu@%lld\n", __func__, count, offset);
+	dprintk("%s enter, %u@%lld\n", __func__, header->args.count, offset);
 
 	/* At this point, header->page_aray is a (sequential) list of nfs_pages.
 	 * We want to write each, and if there is an error set pnfs_error
@@ -448,7 +447,6 @@ bl_write_pagelist(struct nfs_pgio_header *header, int sync)
 		}
 
 		offset += pg_len;
-		count -= pg_len;
 		isect += (pg_len >> SECTOR_SHIFT);
 		extent_length -= (pg_len >> SECTOR_SHIFT);
 	}
-- 
2.53.0



