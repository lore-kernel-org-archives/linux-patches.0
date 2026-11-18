Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058951;
	b=cEX37tx9LC+96ycX7TCqNNxLOOiEEedghwAuo6FlLVHpFOXOhHrDF7K/eZ5kPYPkAQoq
	 hYlJJCbT64TsnE9jxR/2JGAl6MkrKNixyJLy6oAWdPnv9oY9enAd4/hXFtCIFDbKWJVEx
	 8DFmRd5YbgSAV5WTbCmV4jXKXGTgrx821hbfuqM7kJIFHiLgfk52d/XaoEOdgIWB8ZhC8
	 8k0nWTuHciMbOgdYXYgQFaY1fFzpCnZ+uh+aDT2BtwCeOF7spDlJtcjH+9W5d5FqXQbhP
	 PSEeKo8gao59h8MV1hm0UWySY9p7SWZ1HsjaAHtO+FZP8+SP0Uz4idxCyL3i08w5MXA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058951;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6gcRc9JuaHao65SIeN7NFFTtBe30F9GKUsP6EGkrXR4=;
	b=ND5vXAWQZwZI0jAhtVYxRuLqwWMrrsBoDJ2v5uXTsHyAnvsduMgQNB1e3OLVTM9n17y7
	 38VJFi1N56qngPDpwZPFNOrOAX9tSij5Gwafaav+e0P383UsJveZ5kInqbCJCsUAmgiYY
	 hwTRvk/BZRo5Z6lPPUX0kF0EgQKJziMD6LGBeywJ/XSCQpk2qHu4aKMT+V0Z/1DO7uGos
	 W4GQiV351oj6Y+YravPKU9wrPbtjf4NnHlYWPi3r5FozPKLOBPGzl1u2DbGLJm2qJooNA
	 Wht6Cle/Df//mPsTXcmiIEAaxPetuaQuciOO+pSOqU2vyrfOBOumUdrf+h9zuNBGhSQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m3eD5jLp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F4E2606A320;
	Thu, 19 Nov 2026 03:29:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m3eD5jLp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EF241F000CB;
	Thu, 19 Nov 2026 03:29:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058951;
	bh=6gcRc9JuaHao65SIeN7NFFTtBe30F9GKUsP6EGkrXR4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m3eD5jLp1bfaZJDQ8pRIi68bGLKKSSyqe+EQy70ZPT3Rq9CD3BA85vUfYNwPnSp60
	 FeHDw1mXPEehw28GGKC0oHVlSujI96bYD5uqRDEDNF0EWz9YTx2/GYKu7qIsiZgnXm
	 ekFOH75QT5TgREqTx9zz/ZpTNxdkHXrEp1xStx8E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <mason@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0617/1848] ovl: take a snapshot of the name for copy up
Date: Wed, 18 Nov 2026 15:44:15 +0100
Message-ID: <20261118145941.107269354@linuxfoundation.org>
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

From: Chris Mason <mason@kernel.org>

[ Upstream commit 65bf000962a33ec9d2488e4e1797b6cf630abcbb ]

The copy up of a directory reads a freed dentry name when a lookup
moves the directory at the same time.

A pointer to the name of a dentry is only valid while something stops
a move of the dentry. ovl_do_copy_up() keeps a plain copy of
c->dentry->d_name in c->destname, and ovl_copy_up_start() only keeps
ovl_rename() away. When a lookup finds the same directory under another
name after a change to the lower layer, d_splice_alias() moves the
dentry and frees its external name.

With a delay in ovl_do_copy_up(), a chmod of a lower-only directory with
a 60 byte name raced with a rename of that directory in the lower layer
and a stat of the new name, and KASAN reported a use-after-free in
lookup_noperm_common().

Fix this by using take_dentry_name_snapshot() for c->destname.

Fixes: 829c28be9bb9 ("ovl: use d_splice_alias() in place of d_add() in lookup")
Cc: stable@vger.kernel.org
Signed-off-by: Chris Mason <mason@kernel.org>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
[ sashal: adapted snapshot handling to caller-side destination-name initialization and direct-return error paths ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/overlayfs/copy_up.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index 07772f54e24f2..01baaa941b5f1 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -709,6 +709,7 @@ static int ovl_do_copy_up(struct ovl_copy_up_ctx *c)
 {
 	int err;
 	struct ovl_fs *ofs = c->dentry->d_sb->s_fs_info;
+	struct name_snapshot name;
 	bool to_index = false;
 
 	/*
@@ -737,13 +738,23 @@ static int ovl_do_copy_up(struct ovl_copy_up_ctx *c)
 		/* Disconnected dentry must be copied up to index dir */
 		return -EIO;
 	} else {
+		/*
+		 * ovl_copy_up_start() keeps ovl_rename() away from c->dentry,
+		 * because ovl_rename() calls ovl_copy_up() on source and target
+		 * dentry.  It does not stop d_splice_alias() from moving a
+		 * directory that a lookup found under another name after a
+		 * change to the lower layer.  That move frees an external name,
+		 * so take a snapshot.
+		 */
+		take_dentry_name_snapshot(&name, c->dentry);
+		c->destname = name.name;
 		/*
 		 * Mark parent "impure" because it may now contain non-pure
 		 * upper
 		 */
 		err = ovl_set_impure(c->parent, c->destdir);
 		if (err)
-			return err;
+			goto out;
 	}
 
 	/* Should we copyup with O_TMPFILE or with workdir? */
@@ -775,6 +786,8 @@ static int ovl_do_copy_up(struct ovl_copy_up_ctx *c)
 out:
 	if (to_index)
 		kfree(c->destname.name);
+	else
+		release_dentry_name_snapshot(&name);
 	return err;
 }
 
@@ -895,7 +908,6 @@ static int ovl_copy_up_one(struct dentry *parent, struct dentry *dentry,
 	if (parent) {
 		ovl_path_upper(parent, &parentpath);
 		ctx.destdir = parentpath.dentry;
-		ctx.destname = dentry->d_name;
 
 		err = vfs_getattr(&parentpath, &ctx.pstat,
 				  STATX_ATIME | STATX_MTIME,
-- 
2.53.0



