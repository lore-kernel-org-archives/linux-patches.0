Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037684;
	b=PEPj7efX7xQMDffmVIIl6Pt4kcfvVRNVa83D5xSp2JG6W1zb4WZPhLrXkh8etBk1sj2o
	 vnuSjLuFMf+C+SMKixoUwGrwSZkAYIqT+gsi/hJeTKVffNfNlGSU4wcQWofFAXNfYRjt8
	 2i58v6EqgJm4RDz1eED4TRNSjjuhvK4mLoB2dQ20sWJt1Cu7SjmqIuvKb47E1s75ldEFa
	 nOoDQ/YtAUljIK4tJ6suilZGJ+UzYK7LsY5DFy4bsLQC7OjYqdaGpSsbplFQWIiDEOwbC
	 1JZk4zqnoXPink/Wgzz6yCqpVxa/0IAgcz0M4EekNfCEJG3jJx9ivj2fRhHOoivxkwA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037684;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=J1Qzzqil5kHB/+MCRx8HGkCEhy7e55Xtblvt186B5po=;
	b=OnYj4YDd17FlU6b0cQGfvPcfOYxI8o34alloP0tBn1b1DDTSXb+ahub+kF16Duy8TGfg
	 fxVpbt/u0Iy9wn0ZUSyAcv7lLdUouRntAWhkYJN1j1CCOMbGqRIygPUxZHxzH78gmbcnP
	 MKWpZ5zcdpj5Nch9iUAxnhusJ7PuFys6vi6ki5hVzPx5b2cmy3uOHxd1qFPpiXuARt0Vx
	 D6IppiWI3bsV9xA+bqzurDo1fUX2Qsz5t+tJ7vA37wm3RjM1krDLUbBFS6iLAH+SYJkzZ
	 Z4SnwIfn1LTOeNWNso6tvjw4UkQPtrJIcYYMUDQWaZtBTWpnHtKJ6tcBiM6DsibEnQg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FEQqz2vh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA53A606A32C;
	Wed, 18 Nov 2026 21:34:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FEQqz2vh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A1A11F000C4;
	Wed, 18 Nov 2026 21:34:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037684;
	bh=J1Qzzqil5kHB/+MCRx8HGkCEhy7e55Xtblvt186B5po=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FEQqz2vhzYYOIRXR4XJBUBkSGmiS5HZhmIiP6Mm9W6I76Wlb5eluxpjVlCdqjpc3X
	 pMOy4qMG0NM8ASVKFWH6Gykliqo7RK8TI2G+XAD1wnxuMEd41mVcMs8ejcPAXobsY4
	 IdMT22+uwmz/gmDLz40Ds/fJfOwBsdVbv4cRKLz8=
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
Subject: [PATCH 6.6 1484/3318] ocfs2: do not index before the entry array when dividing an empty bucket
Date: Wed, 18 Nov 2026 15:35:06 +0100
Message-ID: <20261118150405.422681695@linuxfoundation.org>
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

[ Upstream commit 7133a0d0954c109f1764ebf8ab32d7e757a6c587 ]

ocfs2_divide_xattr_bucket() appends an empty bucket carrying a sentinel
hash when the source bucket has no divide position, taking that hash
from xh_entries[start - 1].  ocfs2_xattr_find_divide_pos() returns count
when every entry shares one hash, and its loop does not run at all for
count < 2, so an empty bucket comes back with start == count == 0 and
the read is xh_entries[-1].

That is outside the __counted_by_le(xh_count) bounds of xh_entries[] and
lands on the header, so the value picked up is
xh_count | xh_free_start << 16.  One above it is written into the new
bucket's xh_entries[0] and committed, which leaves a bucket whose first
hash does not follow the bucket before it.  ocfs2_xattr_bucket_find()
binary searches on xh_entries[0], so the broken key hides the range the
sentinel was meant to cover: getxattr() answers -ENODATA for an
attribute that is stored, and an insert can go to the wrong bucket and
leave two copies of a name.  The cross cluster divide hands the same
value back as a tree record's e_cpos, which then claims a hash range it
does not cover.

Read xh_entries[0] instead.  The branch is only reached when every entry
shares one hash, so for a non-empty bucket it holds the same value, and
for an empty one it is the slot that carries the bucket key.

An empty bucket reaches the divide from
ocfs2_check_xattr_bucket_collision(), which reports no collision for
one, through ocfs2_add_new_xattr_bucket() and
ocfs2_extend_xattr_bucket().  It does not take a failed set to get
there: a divide that finds no position is itself what leaves an empty
sentinel bucket behind, and a later extend can pick it as the target.

Link: https://lore.kernel.org/20261024151012.1059683-6-joseph.qi@linux.alibaba.com
Fixes: 80bcaf3469b8 ("ocfs2/xattr: Proper hash collision handle in bucket division")
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ocfs2/xattr.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index a0dd18fd5940d..deebe5e52f59c 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -5038,7 +5038,15 @@ static int ocfs2_divide_xattr_bucket(struct inode *inode,
 	start = ocfs2_xattr_find_divide_pos(xh);
 
 	if (start == count) {
-		xe = &xh->xh_entries[start-1];
+		/*
+		 * start == count means every entry shares one hash, so the
+		 * first of them carries it too.  An empty bucket has no
+		 * entries[start - 1], but its entries[0] still carries the
+		 * bucket key: either the hash ocfs2_xa_remove_entry()
+		 * deliberately leaves behind, or the sentinel a previous
+		 * divide wrote.
+		 */
+		xe = &xh->xh_entries[0];
 
 		/*
 		 * initialized a new empty bucket here.
-- 
2.53.0



