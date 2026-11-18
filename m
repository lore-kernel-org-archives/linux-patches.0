Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059082;
	b=vcj7Dc4PsyJeyCWrEpqrgtHXxGDGWpzN/5n3XZjxFtai/xwlIUvPnCf/q/p6hUC2dImk
	 OB64+sStyOFM2XLsmGS1bY3ryfCJrcOaRVPkAc/NgB1QiUJKNJRSIQUCDnWv2+kMaWm8b
	 vrltPab3uBq7QS+KevRp3gB0YNjmrQqiOArIOVJIvXfxjI5ukuDbPxEtIjPhDJUfS71v+
	 Dhx0BB3qGNB2KapmGWB2aOTmOcgEYayaCn+jb6uhMPfR1iXv/Oxyj5QZxY8DD0fK+Bfuk
	 kC3gFNCeOVxZx6tHAL2blThc/qMcyO9eAqWYwPreXsi0cwH0bUX0zuAR72sXSZ1g6mA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059082;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=k0RpElcwTCrBrxfD49+l0xkkBW+LXOBgp4UVrDUGccY=;
	b=wbOvDEPnm1DViFXSZRMH/u9pvjFVOQytsivkcW58nWL4BgQX70x17WLCgdjW3EnbfswA
	 axBr50+g4Uc6DNZHUDwDV/+RMSy1zyd/zm5DOzHI2P0Jb9xlbl7SKT0sm7DDF1JliR2uC
	 eocm202qVINupnRUo9zy4Da7VvXnBr4RLowlVHGH+7DiYGaTd/Dg35m9S/5di26HqfQKR
	 CXSB0Wnow6PXao56YlDsFVxxi1qk3i7svnskodk5G9VJIjhCqeCLaeeVsnK3SLBWDQoNg
	 vCn9UMofMgf9USx88oPNSoTvWEGNQ+qBJZfeedX01JG9Hw6GtVRXjdKowN/oKQwXDlA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PYKFHjNw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EDC6606A325;
	Thu, 19 Nov 2026 03:31:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PYKFHjNw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1AFF1F000C4;
	Thu, 19 Nov 2026 03:31:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059082;
	bh=k0RpElcwTCrBrxfD49+l0xkkBW+LXOBgp4UVrDUGccY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PYKFHjNwff2x6OhTF8SOVhF5ukcLWvzfJ3CwjNyQhJ0PjQK9cp5P494e9ks1PBicA
	 NUkpv0rYQw6F97JAOHRSrxiDhHvzwFMS3ptF8vxletZlZqxcSMyZh11CTJXpWz+c68
	 pyFeMFoHdjH0dacx8FLHCTeviMKrZtFZeyVOp/hQ=
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
Subject: [PATCH 5.10 0708/1848] ocfs2: do not index before the entry array when dividing an empty bucket
Date: Wed, 18 Nov 2026 15:45:46 +0100
Message-ID: <20261118145945.531017209@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 4e71a6e24cf90..3303930f62ac9 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -4758,7 +4758,15 @@ static int ocfs2_divide_xattr_bucket(struct inode *inode,
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



