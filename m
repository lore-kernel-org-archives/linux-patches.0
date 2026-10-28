Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212388;
	b=SCs95lekbAkGi2ibr/tvkwPiEsa8Af1HBaISBaLgMihgCxKHg2MQJM+FzVGfe88MSNBp
	 DYpa8V2xppmt0GcFX7i9kOpLJhA0/S99PxiSDR7/ny8oIs59pJ9YCPkOZ3qMVjIhdjwaE
	 MkIDL9dUdHD3h/76DLaFc//orH7rTl5P+bhTXw3oZr6WRIDNqNKAiyJAZWQdPZpPNRQVh
	 l6973KEOJMz6zXiSoIw2ZgqQgq+3pW1seX3k+THekpM6wQIG9tYrIYFXpGzzVi5yy4dkR
	 gyh5xUoFjXScgu2o7Y9sf2sk5IQc0CuOHvGpu/VD64UiF8LzuRH3ssgi4CRBhreF8fw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212388;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CGOz/cG24cp9QxLCjnpO5QdFDPouAtB49FyCov/IKaE=;
	b=n6plibTztSptOzlw8GlmNxyFqHv0PGNGVRv8u6EvH9E7Ocex6347/tXCp2g17ELMCYtp
	 +8VWUBT5n1YbnGSFmGbdwCMAYl2RBK+ioWaojEQggXa1ioSuO6hh7aXlkTxmiTxpyvp5I
	 jMT/MsktJ+KI+WfdVdL7H8SlQgAkBC7rjnNmxH8jINsBYQA1dlAO1WTiBBo0y9fzF0rTU
	 a68oLYPktA2FBNE7Nc6XFBONKNwZEdRvJZsi0eSktV1bEkza9tsd7o3NeriS4XVT8dicj
	 sb7QSZ1edT0qeF3od6fE6cb31tTxsJ0id2/tuj8q6aeyH6PGf1aDLRy8BA7yFeHo7Bg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=phwT9xDd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5C29606A31A;
	Wed, 28 Oct 2026 18:33:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=phwT9xDd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FFCD1F01825;
	Wed, 28 Oct 2026 18:33:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212387;
	bh=CGOz/cG24cp9QxLCjnpO5QdFDPouAtB49FyCov/IKaE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=phwT9xDdISF/X/H4Tf8gWzNhJF07/l1qqGdYdkICyFzj1lTnElhAk2XQpwhAQQA9F
	 HRpa2FY7whqAoya8a1m2l+l/dXs8Jfhqhg22Xs2w6T/cE7RPvm2XNvMLtGSNeqlgx/
	 BF9b2dGppmjS+hd4j4NI/2YS964qLFqYqKF8l/Uo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	April Cardenas <april.cardenas@canonical.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Bharath S M <bharathsm@microsoft.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0136/1887] smb/client: send lease break ACKs thru correct session for multiuser mounts
Date: Wed, 28 Oct 2026 17:37:12 +0100
Message-ID: <20261028170502.331801229@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: April Cardenas <april.cardenas@canonical.com>

[ Upstream commit ebc5660132ddd244b57f03ed324922013a3d7363 ]

Currently, when cifs_oplock_break handles a break request from the server
it searches for the appropriate tlink to handle the request
but incorrectly uses the current fsuid as the search key, eventually
causing read errors for users with multiuser mounts on NetApp.
Fix this by using the tlink from the cfile struct instead to respond
through the correct session.

As breaks are handled in a worker thread, the current fsuid
isn't guaranteed to match the session that the break is intended for.
This means that cifs_sb_tlink may search the rbtree using the wrong fsuid,
and return a tlink with an incorrect session than
the lease break was intended for. As a result, the breaks
may be ACKed through an incorrect session.

While it seems that Samba/Windows Servers 2016-2025 ignore this as long as
the lease key is correct, we ran into a case where if you're using
NetApp ONTAP or Azure NetApp Files they will reject the ACK
and return `STATUS_LOCK_NOT_GRANTED` errors on any future read requests
a user may initiate through their still held open file handle,
and the server will eventually close the file.

In the dmesg logs, the user may see errors like these:

CIFS: Status code returned 0xc0000128 STATUS_FILE_CLOSED
CIFS: VFS: Send error in read = -9

With a multiuser mount using NetApp, this issue is really easy
for users to hit on a wide variety of kernel versions
by attempting to copy a file from the share
to the local machine through GNOME Files/Nautilus.
This copy will always result in Nautilus throwing
a `Bad File Descriptor` error to the user and fail.
With this fix, you can copy files through Nautilus without issue.

>From looking at the traces, it seems that glib will
open the file first, and call listxattr before actually attempting
to copy the file data. The listxattr call always triggers a break,
causing the copy to fail.

The proposed fix returns to the way the client grabbed the tlink before
commit e8f5f849ffce2 ("cifs: fix potential oops in cifs_oplock_break").

The bulk of that commit (checking for list empty) remains untouched, and
I think the change to using cifs_sb_tlink was intended to avoid a
NULL/ERR deference on the tlink as well as update the reference count.

I believe this fix should preserve those safety properties, but of course
I'd appreciate any corrections here.

Fixes: e8f5f849ffce2 ("cifs: fix potential oops in cifs_oplock_break")
Cc: stable@vger.kernel.org
Signed-off-by: April Cardenas <april.cardenas@canonical.com>
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Reviewed-by: Bharath S M <bharathsm@microsoft.com>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
[ Removed unused cifs_sb and sb declarations because this branch lacks their remaining upstream use. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/file.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
index 35689e7bb16a7..d2187882c236f 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -5180,8 +5180,6 @@ void cifs_oplock_break(struct work_struct *work)
 	struct cifsFileInfo *cfile = container_of(work, struct cifsFileInfo,
 						  oplock_break);
 	struct inode *inode = d_inode(cfile->dentry);
-	struct super_block *sb = inode->i_sb;
-	struct cifs_sb_info *cifs_sb = CIFS_SB(sb);
 	struct cifsInodeInfo *cinode = CIFS_I(inode);
 	struct cifs_tcon *tcon;
 	struct TCP_Server_Info *server;
@@ -5194,8 +5192,8 @@ void cifs_oplock_break(struct work_struct *work)
 	wait_on_bit(&cinode->flags, CIFS_INODE_PENDING_WRITERS,
 			TASK_UNINTERRUPTIBLE);
 
-	tlink = cifs_sb_tlink(cifs_sb);
-	if (IS_ERR(tlink)) {
+	tlink = cifs_get_tlink(cfile->tlink);
+	if (IS_ERR_OR_NULL(tlink)) {
 		/* drop the reference taken when the break was queued */
 		_cifsFileInfo_put(cfile, false /* do not wait for ourself */, false);
 		goto out;
-- 
2.53.0



