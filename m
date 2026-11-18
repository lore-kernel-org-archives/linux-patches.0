Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037687;
	b=gjxjSKiVq3snC07hV/RN881Y/eM51FMS9ywLgFNOgG+PdUMSq4GhQN3ath8IRr9+FU90
	 ThNJjRGXftNcju159LsJlMbIqDqCtJQ6SNexilib8uq2g8r1IXYxdZO58hUavrul89Tz7
	 5laHY/MvxR4Ch8mXS8g++xmPfXrlpagxD20aZBgXJIuXLyTHWpJb3Qstkh9Yu/uNXgOOv
	 ZxiEmIJHq/nKD317zbxkZLuQUSUhFi7dyNB8pBpbkXV5b/vZ3ltbWRB0RTtHuARkigfnJ
	 pLwMVqoWpht2iQGHXg7pEUPRX6I73tSpcfuds/gKhbB1G4tkFrE1rW06llAdpDFk5Fw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037687;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9MF3Sqro4TXiLex9AXkuc2P8Vjh7lQh9JNHi7rEWcU0=;
	b=y8Dj4z/0GL6/Lk254dOrXUd1Z5Kh5vM28hr57ePyxVBQkMWT9bLcY3AAU3uF1/fsbrQB
	 dwQHJr1gVeU07y5V2G6rQ39r86aNezEmX7h1ab8kEUzg6zKCJLkfb5R3X0QRbF4lGx4h3
	 VkzXa02YJ5HenddxXetx3WWQ6/SqaXKZaxZ04LSBuJiQGxyCUZbcHnEz18ocT5J70VwiY
	 0E7dzXlXDSmY56cDz+sgsAdUPnUcUIjUJ/Kss13VXiF8SLvH5b6FRZtym9oTQy2a+M+Bb
	 6xG3SszmGJKqeqcxIgeIZFrua5DH6TDysSjm7AoCCy2fpA9MJCR2adSpWkbF8URUORA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=a5Gnoljm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A3C7606A31C;
	Wed, 18 Nov 2026 21:34:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=a5Gnoljm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3D671F000C4;
	Wed, 18 Nov 2026 21:34:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037687;
	bh=9MF3Sqro4TXiLex9AXkuc2P8Vjh7lQh9JNHi7rEWcU0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a5GnoljmvWZTMwAFYDeSKISwXLzpK5P8Tbw1SiUGxZLq1N6bY5mIoYngdCMZqTmhy
	 y69oFrnylb+MrwiH7Tx3URXXnLTHiQDLedBtaD+2Fq75OOi4LhfWa4CA7YNqAoCemA
	 bjjYMmtsCqoPSN6riztf28jxzogWPqlThBBq1j1w=
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
Subject: [PATCH 6.6 1485/3318] ocfs2: do not read the entry array of an empty xattr block
Date: Wed, 18 Nov 2026 15:35:07 +0100
Message-ID: <20261118150405.452441131@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index deebe5e52f59c..baa6593f85b8e 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -4520,6 +4520,21 @@ static void ocfs2_cp_xattr_block_to_bucket(struct inode *inode,
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



