Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064667;
	b=uhlsGl/FOwL+LxvP5SZ3BgdcOo8mhXLLVdwgisKkDOShYlgVrH0EXA8SW/bT0VYfJndM
	 N0mzdaHQFmSqZGwtbQi6l8tiU+jO81mSCWFOrEvF9B7ivkbwVbuLehoNkyE+ADE6NYWEn
	 QN3dOescHq6g5ZgQu4KYKF4aRQ1b45bdzgk966XaW5VRZeijnC/4Nw5K8F9hnhUKSgGPV
	 LeR9vLeWW2Vm//s4tzkP1/IZ7JD4ZsGL30YnRngqxzznSgcDB+85HPyBxHS5xnS0yhRIw
	 tnuvPcHHSzdTzdgi6VWYBxybrnVIpKKBfhG1APD/FBQ97olpfR1uKzh/v9tGd+rQ8kg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064667;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sBZZd5rCgrqTU5oTy5/5Mi6Ws/t01oqNPJIxoMXFteU=;
	b=DNwfPul6J2vOOneCGR4kNpwyPjedyJyBo4jN9VXg7rUfzttaY9gCOUTcgmDZY8SfZ8VZ
	 fiEFc2UDcxdb37tMxK76zlKYZLaUbQQCLRZwGeCCegznh0dMiU+KwB3a8ct83DUauIjBy
	 rt6Uqj0pRDmScWJfeVkqIpRwof239WVccryto2s9qnX9+3JaZvqdC9EXD4Z9/yFQhGR+J
	 stjFia5m8q485t4o3kXvAaAIWTZjWfFvd3Pjwm29ftv3orS3FHAHr3RBtlwGEu4IEaUMG
	 rub/G+3O77/PmMrKnd1MXSODG1LTSLOCAetO0Aa1EFMqsnsFDAdmphAvRb8I3bh653w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gptp+Nsj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E658606A9CF;
	Sat,  7 Nov 2026 15:17:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gptp+Nsj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08A931F008A2;
	Sat,  7 Nov 2026 15:17:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064667;
	bh=sBZZd5rCgrqTU5oTy5/5Mi6Ws/t01oqNPJIxoMXFteU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gptp+Nsjvl/QJSqSdbeTEZm01PxHfERZ//WmqUKm2bwJllFo8XBa6ROR5OTJ0sr7d
	 /sJDM9X2oH4OQNxa83DdhQlN3HvfFjXr+svJMLXzE7pAzjGnDw7cUC+TWzw6PLPoFn
	 fIF/2hU+B0PR7tHMW1e7Xm6MymtOXRWhXU+sGHmE=
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
Subject: [PATCH 7.3 0664/1257] mm/shmem: dont release a swapin-error marker as a swap entry
Date: Sat,  7 Nov 2026 08:49:20 -0500
Message-ID: <20261107134957.593285384@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/shmem.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index af531eea77b93..93714b47f414b 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -976,6 +976,7 @@ static long shmem_free_swap(struct address_space *mapping,
 			    pgoff_t index, pgoff_t end, void *radswap)
 {
 	XA_STATE(xas, &mapping->i_pages, index);
+	const softleaf_t swp = radix_to_swp_entry(radswap);
 	unsigned int nr_pages = 0;
 	pgoff_t base;
 	void *entry;
@@ -992,8 +993,9 @@ static long shmem_free_swap(struct address_space *mapping,
 	}
 	xas_unlock_irq(&xas);
 
-	if (nr_pages)
-		swap_put_entries_direct(radix_to_swp_entry(radswap), nr_pages);
+	/* A swapin-error marker holds no swap slot, so just drop it. */
+	if (nr_pages && softleaf_is_swap(swp))
+		swap_put_entries_direct(swp, nr_pages);
 
 	return nr_pages;
 }
-- 
2.53.0



