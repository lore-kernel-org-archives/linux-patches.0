Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585632;
	b=DKlXjhag1XKOX4uFXigpJwAvyoCgqARL/RjZRzmPKea4WDlGSqiRxLfV65CXJXyDSrPx
	 G6EdkxJVJHurwPpmphz661YM67ZRKGsvxApU7ozEjIkZ00yLENFHGE3dZeMejFErmVknI
	 K1QfN9Q/sCA4ZdNK0ZugL0ps1t+VIbcTq2bQoI27ehJs0uxpOQ7bxZoSlXMy1uU+S4i5V
	 h7OEhr/C7eXLVL4MLcKca5rGIF1ESsqa4FwaUp3cWWlcnEKX93XwNP2ImLqK/3Hl0p6qU
	 8HWyHWa8QMaJaaxkq3Mw5OBN3/Mp1IomzaAbQQDbsRxpIY2vwkOto3NCa3+rjtrRA1g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585632;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=otsViD4y1iwvJQTLQ+S2qbUW0CDONTauI9myiXO5py8=;
	b=c1GCNM4bXp8dk+DCHSLUZGetHuTXa+2AH+yCaYS9DizbBma0POKFPrrmusuSVb1LWBtG
	 LS5dTP8HmJo41CeDJvnHAypY1uJ24DjPWxoVRtNJgqJ/EPk8PhvSzu+FXGzrt2OTnH3/x
	 vg9oUrZvYMSln6zvp3eAwa1Ovfmh/WNSNFGSPWeMZ2rkgH/p3o7NAsr/kGH6b3zZw7qEQ
	 1T2dw/3vHTe97OlZDyVS4e+BJrW6IjioSeCim3GfLZDUcqm5UQ6UD7Arf4YHcJt8mwwcf
	 Jfd3wEywSn3ZeMjIhUf2ejmgly6ebjF1tk+hLh4xud5hQ+3BWiGCMAE9rjImasca1SA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dH9VkTdF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F93760A262B;
	Fri, 13 Nov 2026 16:00:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dH9VkTdF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 131DC1F000C4;
	Fri, 13 Nov 2026 16:00:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585632;
	bh=otsViD4y1iwvJQTLQ+S2qbUW0CDONTauI9myiXO5py8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dH9VkTdFQ6dWLLcnO/7y3ITxE+zxdX2CoQduodBmWvT0JYYByNJPpBguth6D6Et4B
	 ZaBNr5sFCe+ECpAYsI5m39JwLBU4zbR07pA/DSfYn6re+NzfZy2OS2RlsgLZv3MYjS
	 7E6Xj85+oxlp7tlZbiztJxfxwU1ub4uV+83EKxEE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Heming Zhao <heming.zhao@suse.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 252/507] ocfs2: do not read the entry array of an empty xattr block
Date: Fri, 13 Nov 2026 10:49:16 -0500
Message-ID: <20261113153803.099429859@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

From: Joseph Qi <joseph.qi@linux.alibaba.com>

[ Upstream commit cd7c3563a98fe8c984463d83772e518cb7e68356 ]

ocfs2_cp_xattr_block_to_bucket() sizes the name and value area it has to
carry over from the block's last entry, so an empty block makes it read
xh_entries[-1].  That lands on the header, where xe_name_offset overlaps
xh_name_value_len, and block storage never maintains that field, so it
reads as 0 and the copy runs from the header to the end of the block.

The bucket that comes out has xh_count 0 but a name_value_len of
blocksize less the header, and a matching xh_free_start that claims
those bytes are in use -- nearly the whole bucket with the common 4K
block size -- while the last block of the bucket holds a copy of the old
block's bytes.  Nothing but a trace event reads xh_name_value_len, the
copied bytes came from the same inode and were wiped before the entry
was removed, and ocfs2_defrag_xattr_bucket() recomputes xh_free_start,
so this corrupts the header rather than leaking anything.

Leave the bucket empty instead, carrying over the hash the block was
keyed by, since ocfs2_add_new_xattr_bucket() and
ocfs2_xattr_bucket_find() both read xh_entries[0] of an empty bucket.
That read is the exception ocfs2_xa_remove_entry() documents rather than
a new out of bounds access.

A block reaches the conversion empty when truncating an external value
back fails partway through: the "reusing" and "overwriting" callers of
ocfs2_xa_cleanup_value_truncate() remove the entry without setting
ctxt->set_abort, so ocfs2_xattr_block_set() sees a plain -ENOSPC and
converts.  The "growing" caller does set it, and the block form makes a
single attempt with no defragment and retry in between, so that is the
only route here.

Link: https://lore.kernel.org/20261024151012.1059683-7-joseph.qi@linux.alibaba.com
Fixes: 012255961c9e ("ocfs2: Enable xattr set in index btree")
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ocfs2/xattr.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 571c40f5dd447..4d00a26ece3c1 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -4534,6 +4534,21 @@ static void ocfs2_cp_xattr_block_to_bucket(struct inode *inode,
 	for (i = 0; i < blks; i++)
 		memset(bucket_block(bucket, i), 0, blocksize);
 
+	/*
+	 * An empty block has no names or values to carry over, and the
+	 * xh_entries[count - 1] below would be xh_entries[-1].  Leave the
+	 * bucket empty, but carry over the hash ocfs2_xa_remove_entry() left
+	 * in the block's xh_entries[0] so that the bucket still holds the key
+	 * it is looked up by.
+	 */
+	if (!count) {
+		xh->xh_num_buckets = cpu_to_le16(1);
+		xh->xh_free_start = cpu_to_le16(OCFS2_XATTR_BUCKET_SIZE);
+		xh->xh_entries[0].xe_name_hash =
+			xb_xh->xh_entries[0].xe_name_hash;
+		return;
+	}
+
 	/*
 	 * Since the xe_name_offset is based on ocfs2_xattr_header,
 	 * there is a offset change corresponding to the change of
-- 
2.53.0



