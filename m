Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1B8B3EAC83;
	Wed, 20 May 2026 17:39:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298770; cv=none; b=oNJW7JNFKjCkgeqJbAPTEENyCK/rgrcYlpKw6hzprBJXjpn9ojGaufNNUZzzL7lYlSLYT2ybZ3JMD6zWuWszpm5FYiRRlpWUGNfqL5fITf8ComKvlPqxupU+hfGByT5JG0hc7N2tCX7JtarZQKtc2rE7Z8SXxQCnuZHrMGlbVBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298770; c=relaxed/simple;
	bh=fgty9NbmefqfooTdBrhyndvLuDQ9j+jdvANTPpTR+aU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iLmQLa4qL96NzBcQ7EYB/HGksDgvUofYY3fyrPODoONVkM8rvKpwvZ8Q2iMSNXacZku4L8PgxYVYjWRL3k35/2gfRISiOMrj1KQtJ56H7KrsgC8l4E61/A01v1JMMNG4MoUs0+Soi9TKJRk2g2+qpsGPDMYSykF8j06gjOcmEo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rIft4IvG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rIft4IvG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 294931F000E9;
	Wed, 20 May 2026 17:39:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298769;
	bh=484QOXaGcVA//0q2SqsYPDMnmgWGPXajXRuSp2ha9aY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rIft4IvG9ZxtRyOr9DFLfe/fUhC3vNDax/9hSPTcr6GSkKY0d1XZKjemPqc+E/g7A
	 evBkIpx/YNjXTpxOBLx5edTETkEIsEDtMwRyQjacX6sIyO/SGQ2DwI4MRzHf2qBruR
	 gCwkxbHffZVrOm4BEPrEY9bHioXuVx/Qr9D7T9E4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anna Schumaker <anna.schumkaer@oracle.com>,
	Jeff Layton <jlayton@kernel.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 538/957] nfs/blocklayout: Fix compilation error (`make W=1`) in bl_write_pagelist()
Date: Wed, 20 May 2026 18:17:01 +0200
Message-ID: <20260520162146.202469125@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 0e4c67373e4f9..83e4a32b30182 100644
--- a/fs/nfs/blocklayout/blocklayout.c
+++ b/fs/nfs/blocklayout/blocklayout.c
@@ -381,14 +381,13 @@ bl_write_pagelist(struct nfs_pgio_header *header, int sync)
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
@@ -429,7 +428,6 @@ bl_write_pagelist(struct nfs_pgio_header *header, int sync)
 		}
 
 		offset += pg_len;
-		count -= pg_len;
 		isect += (pg_len >> SECTOR_SHIFT);
 		extent_length -= (pg_len >> SECTOR_SHIFT);
 	}
-- 
2.53.0



