Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618916;
	b=yp38sesF4cYP0wM7rk5w9WL/x+XZe++M8xcKl+xswjSeUOfzukKeU/uDT+zz9VLHWsyn
	 8gzgEbVE/wRa/F0X5x9vamF6p76g7ahOA7HoUfdf6fyMDXKp+mOp4qyS6SIwDm5Ze03L1
	 UA8y+QHiSvhzh+WP4kPiFoe6LyzjuqrCTqkZwtZKEFBdIKqy/HoOqhbZa5y2phquau6xl
	 3hKbM02flXxUwpouwzDrruWGeK3W1QTiWM4NulI8O6j+aBCesWMI5HCRo0qPyr7lRN3uI
	 VregKARQZcBbTagAkth8tJqYs0ur4yXlAJ+AjDdp2t1xf7DJ0bCEvsMygKbvHt8McIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618916;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=buGXFy5ZlctzW2L+RICwtQ5+u9NUWjH/EuwwBLLQP6Q=;
	b=NnfpSdl0QyOPlwTheVEeoZFV5Fcgfw/+A3rVoE2sTifiO1XZPNPTlxe3JwjcISb9NGaV
	 nKXvF6PTFnm1717E9DqVvdG0uvJczpJOOFw4rdsMUTI9qLs/1ut9onTnxue+pWbDUEQV6
	 6hpJWdqVyc+D1FXkLcTwlZhsfVg40Ap2RBh5nFRFZ2j0k7w/XZsSJTy2e9S/29dORNUnu
	 GbDTIaOWr9nHpihAaWKyaBZkdOTcFy0KaCu5/J9tyefTgdFzC9yUS7XESO9var6NnZs3i
	 FICqQG0dGiCC90v9sf0yYu9fK95JK3X+ROkS7nAeJomw1Y7mRimSGzxOn4AuIaY0fZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZogImnx+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C0F1606A31E;
	Wed, 25 Nov 2026 15:01:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZogImnx+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65DF01F000D2;
	Wed, 25 Nov 2026 15:01:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618915;
	bh=buGXFy5ZlctzW2L+RICwtQ5+u9NUWjH/EuwwBLLQP6Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZogImnx+g5HddndD+PGTq/a3jKAmnltjYqTgJRNxYfY5q4TactbKC+4JGen9W/O9k
	 chZ9qNcaEi2Hf3at2yBFZTFHBDfUICzQtB5sIKPgu3onHS5jswghMHC3KdMHNyfFTx
	 /mD7ErY3LX5AqPb8isgoy61pWtEnPGNQPRsCT/48=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avi Weiss <thnkslprpt@gmail.com>,
	Anna Schumaker <anna.schumaker@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0429/1005] NFS: update ctime for atime-only UTIME_NOW requests
Date: Wed, 25 Nov 2026 15:29:27 +0100
Message-ID: <20261125143831.803025959@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Avi Weiss <thnkslprpt@gmail.com>

[ Upstream commit a38d7cc8c90f0d093550487c2905b51db0be1522 ]

When an NFS client holds a timestamp delegation, utimensat()
with atime set to UTIME_NOW and mtime set to UTIME_OMIT reaches
nfs_setattr() with ATTR_TIMES_SET but without ATTR_ATIME_SET.

There may be other paths that can reach here as well.

The delegated-atime fast path treats this as an implicit atime
update, clears ATTR_ATIME and returns success without updating
ctime.

Add check for ATTR_TIMES_SET along with ATTR_ATIME_SET (OR) so
explicit timestamp requests use the normal SETATTR path while
incidental atime updates can keep using the local shortcut.

Fixes: e12912d94137 ("NFSv4: Add support for delegated atime and mtime attributes")
Signed-off-by: Avi Weiss <thnkslprpt@gmail.com>
Signed-off-by: Anna Schumaker <anna.schumaker@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
index 4fa6c5547ab86..cb414396063d4 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -740,7 +740,7 @@ nfs_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
 	} else if (nfs_have_delegated_atime(inode) &&
 		   attr->ia_valid & ATTR_ATIME &&
 		   !(attr->ia_valid & ATTR_MTIME)) {
-		if (!(attr->ia_valid & ATTR_ATIME_SET)) {
+		if (!(attr->ia_valid & (ATTR_ATIME_SET | ATTR_TIMES_SET))) {
 			nfs_update_delegated_atime(inode);
 			attr->ia_valid &= ~ATTR_ATIME;
 		}
-- 
2.53.0



