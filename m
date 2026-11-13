Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590350;
	b=xSZenO+oZCWkXahqQVigzzolXRGt8iXF+yc1isGCBWCLuRcF3BbkCvZ7Zkd3oFUoebhb
	 sEC/E+J4v6JcEhqPa6U5LbxFM+StA05/Z1AcbsxYmSpDSlYqDNoNMv8GyXRpl49jQyPM8
	 OJzdtxoBv8rYhM74+wqNpk/XTQbcwLlq73vmq5ZprDZYiA3Dl22kVqeuNPswK9igqVrQP
	 w2vf5uhi/IKzNgvjtou6IeIsCCL7eXQMzBmYNUq/aHKjghkgtf5E01kMu7TlEjH2ZKZK2
	 esYdUkT76rLl034Gej1s4MxKUTYfrm/qVoc06xO0iUnJPunY8ruNdcaQ0WqDoIQPITA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590350;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=29JqeFu9oRc8pOFp1p2cD3U6/xeVF5vfMmYQTxqhPN8=;
	b=b1fGG27v76xiKMsh0vAN9MwGGGblyBW9+GpyTbb71cbkoxcyVDYfLS0qOQzFqufhRFui
	 0/hbxbXbELf7EeO5rkIw5w1HgivLcpAbosFnZdcx11QEkSDtkQXtBDAM0PpS4DLOWDKU5
	 vYuwTyhqiuRV9UZoOt1OxLijcNSujbx5WJZjikenxwXNAuird6DxmdIDi5sVt8CvSbkB9
	 yjQXRHgbsxeOFSkFRiBMy98vMpmRSOZNiNF0Je+HsdMIw+czHHRSXWYZhgK6w7pqZSPKN
	 IvquPFr6AynNmtW2nu4dSd801tsrXafvwZq9c3AIVtBr7WijpNzBpMClCHFlc2tLOHg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m1u4cJiO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B575608316B;
	Fri, 13 Nov 2026 17:19:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m1u4cJiO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EFD91F000C4;
	Fri, 13 Nov 2026 17:19:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590350;
	bh=29JqeFu9oRc8pOFp1p2cD3U6/xeVF5vfMmYQTxqhPN8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m1u4cJiOY+GGf0pOfPQ6hgLt7GFnJUNSPn13cRznMTFZ1T0JZruS89SQJ88YEZcpI
	 /nXJdMzXrZ1DIPs7OmmZQD21wdTougyfsaP9TiLGvOirlo+DvUAC6C91srEASWnXbM
	 y+u0rto8IN7lEH3vuntfyRTXxauvD0DiVa6uecZs=
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
Subject: [PATCH 6.18 328/686] ocfs2: do not read the entry array of an empty xattr block
Date: Fri, 13 Nov 2026 10:47:41 -0500
Message-ID: <20261113153832.037377257@linuxfoundation.org>
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
index 5f263d24bbc3b..921d050c37581 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -4296,6 +4296,21 @@ static void ocfs2_cp_xattr_block_to_bucket(struct inode *inode,
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



