Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590752;
	b=nRlu19mY8u0Ynp5sMO/vmkvGAw9zyAywveGf7f23O68glaLsTnueEYqJFcemieJo7JR2
	 X9qlRxUz0gKLOTeIkF6ljyEJkBlevdWc4bRMYfC3jBknfUTMvwGLyJK3F8c27Qbe+dJ9b
	 CI4a9UzlGUjecsOTahDBV0+sVQdAshEGiVrjKIOVe7s+wWZiw4frlQAAokh6grrpN5R0D
	 JbShgY4eGNJhxAXUa0AGtKGWpB/E+/oNNB1WRUolP2SvoUtvodhFdbv+m2OawBT+AfRWM
	 K/pCQMvi6TerwbWovhWUpXe0uKUcbyKHJcXLN7jfU1YzD4hd7GuCK2ar3pkAmJyxbFg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590752;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JPMiV7aqQAJc2B1VkfdkvoGFy1VjhkPLdlEntvor0Ac=;
	b=5PXqSRKtbmVxL9UaBuDLAwVqBI5+fNtzOC+4dmsG2oPVd0floQICkX9SG6EdWx7szm/6
	 RU9HfDRAtnhrnde/A2H0tOF1GdGqTSZOTc64MtF/g6Peio/G70ZmJjbCjuMR0pVdPB7Q5
	 IXEJMDuMki6x+thGNw3HeFO0Y+BwJPpglWhk7QO9AuykeWcvCiQ1wpWwB516Lwi6biLBP
	 XHRz2BQu+fPCjUcKl7HFF7dvqqNHSCmEyHydMOw5I2oEIChHLM9Fh3OTqpZHWD+FaOQUW
	 kJc0yIcwdJDodZBcN49zqGXwJZIXewHG8u/gRrTm2iXsUiaBLxUyQ8kGwXFaTRQ9XxA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xKpNUyEx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F21C607C346;
	Fri, 13 Nov 2026 17:25:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xKpNUyEx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 416B31F000C6;
	Fri, 13 Nov 2026 17:25:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590752;
	bh=JPMiV7aqQAJc2B1VkfdkvoGFy1VjhkPLdlEntvor0Ac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xKpNUyEx/wFdO5QC2ru4FhecPVrNHlGn/Du6zi+wbQZPQG+YdYdAsdxS38BHBWx5R
	 iQEkj+P5fQqtElWthJbQbDW3xsIyoGPamKTilZ07q+WGs43gxT3IoUJqIZorb625ES
	 Md0/HkJGNJ7N2n5M46iSIpCbkPJgktHzyRkXGB64=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Carlier <devnexen@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	syzbot+23b25ba3c6bf971f9c57@syzkaller.appspotmail.com,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Baoquan he <bhe@redhat.com>,
	Barry Song <baohua@kernel.org>,
	Hugh Dickens <hughd@google.com>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Sasha Levin <sashal@kernel.org>,
	Chis Li <chrisl@kernel.org>
Subject: [PATCH 6.18 646/686] mm/shmem: dont release a swapin-error marker as a swap entry
Date: Fri, 13 Nov 2026 10:52:59 -0500
Message-ID: <20261113153843.669587405@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Carlier <devnexen@gmail.com>

[ Upstream commit e4b92891aaca0d37b5973362dd14747a65406650 ]

A failed shmem swapin (eg, EIO) frees the swap slot and leaves a
PTE_MARKER_POISONED entry in the page cache.  On truncate or eviction
shmem_free_swap() passes that marker to swap_put_entries_direct(), which
warns because it is not a swap entry.  There is nothing left to release
either way.

Skip the release for non-swap entries, as every other caller already does.

Link: https://lore.kernel.org/20260920155002.1030454-1-devnexen@gmail.com
Fixes: ac2d3268284b ("mm/swapfile.c: remove the unneeded checking")
Signed-off-by: David Carlier <devnexen@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: syzbot+23b25ba3c6bf971f9c57@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=23b25ba3c6bf971f9c57
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan he <bhe@redhat.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chis Li <chrisl@kernel.org> (Google)
Cc: Hugh Dickens <hughd@google.com>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: <stable@vger.kernel.org>
[ sashal: adapted newer softleaf and swap-release APIs to the existing swp_entry_t-based swap helpers ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/shmem.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 6f4c85a3f6410..5ce1c0ddf8cde 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -948,6 +948,7 @@ static long shmem_free_swap(struct address_space *mapping,
 			    pgoff_t index, pgoff_t end, void *radswap)
 {
 	XA_STATE(xas, &mapping->i_pages, index);
+	const swp_entry_t swp = radix_to_swp_entry(radswap);
 	unsigned int nr_pages = 0;
 	pgoff_t base;
 	void *entry;
@@ -964,8 +965,9 @@ static long shmem_free_swap(struct address_space *mapping,
 	}
 	xas_unlock_irq(&xas);
 
-	if (nr_pages)
-		free_swap_and_cache_nr(radix_to_swp_entry(radswap), nr_pages);
+	/* A swapin-error marker holds no swap slot, so just drop it. */
+	if (nr_pages && !non_swap_entry(swp))
+		free_swap_and_cache_nr(swp, nr_pages);
 
 	return nr_pages;
 }
-- 
2.53.0



