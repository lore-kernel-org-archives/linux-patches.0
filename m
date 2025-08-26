Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B7F535AAA3;
	Tue, 26 Aug 2025 14:42:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756219323; cv=none; b=TNzNYv9QFTd+R8HdyQb8V4J1GwpaRXAF7oDuI/odIAYbFcohtLvgAuOuIutFNX/RqrO4z73M5YRtfwP6VReRk5jWJZWYHoLBv3TFZT5mhYlGOiJiLD5Y+KEJzxc01uHS2GW0noiDrI8xEKBD35C64YhQOMps/VGD7Q6YGf/YLwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756219323; c=relaxed/simple;
	bh=DeEOE73FH5WpgzGjmbZ5yfGauThmv+40xDNYO6WkagM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PbHQIF1JzXx8NS7S5ygv2hb2+xOqLSOMmltdWhcIGLJfCSkh/68rkRi5e02eDwg2pflbZtY/zh9OzwC5KtfHuYGqAiAHli2JLRl/4Rnz/ZAVYnUswJy3Dk1ir129kKhlfczdscAzR2k8PBTDFBqiMmpSKzQIAGiPnfkbg469r8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nPLX9/4s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nPLX9/4s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C9C4C113CF;
	Tue, 26 Aug 2025 14:42:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756219323;
	bh=DeEOE73FH5WpgzGjmbZ5yfGauThmv+40xDNYO6WkagM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nPLX9/4sM1aRYfr/NugtSnTOr3CyULyvcFMOtcBfc/klS4JLhHy4OZ6V2eyaJ5FeL
	 kO2kHtARjqSDeAnMtverPkyrXA+NtK6OA4EpGeabPPvervnhP7L3NrjnW29Sf60J0l
	 h4hd15MJCVKG0j2wXqdqJ5KLobGdF5O/gsNLRJu8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaohe Lin <linmiaohe@huawei.com>,
	Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
	Minchan Kim <minchan@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 337/403] mm/zsmalloc.c: convert to use kmem_cache_zalloc in cache_alloc_zspage()
Date: Tue, 26 Aug 2025 13:11:03 +0200
Message-ID: <20250826110916.159224885@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miaohe Lin <linmiaohe@huawei.com>

[ Upstream commit f0231305acd53375c6cf736971bf5711105dd6bb ]

We always memset the zspage allocated via cache_alloc_zspage.  So it's
more convenient to use kmem_cache_zalloc in cache_alloc_zspage than caller
do it manually.

Link: https://lkml.kernel.org/r/20210114120032.25885-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Stable-dep-of: 694d6b99923e ("mm/zsmalloc: do not pass __GFP_MOVABLE if CONFIG_COMPACTION=n")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/zsmalloc.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -357,7 +357,7 @@ static void cache_free_handle(struct zs_
 
 static struct zspage *cache_alloc_zspage(struct zs_pool *pool, gfp_t flags)
 {
-	return kmem_cache_alloc(pool->zspage_cachep,
+	return kmem_cache_zalloc(pool->zspage_cachep,
 			flags & ~(__GFP_HIGHMEM|__GFP_MOVABLE));
 }
 
@@ -1067,7 +1067,6 @@ static struct zspage *alloc_zspage(struc
 	if (!zspage)
 		return NULL;
 
-	memset(zspage, 0, sizeof(struct zspage));
 	zspage->magic = ZSPAGE_MAGIC;
 	migrate_lock_init(zspage);
 


