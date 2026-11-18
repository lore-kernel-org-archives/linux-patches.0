Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028558;
	b=WoJqgae6haf+h7HCCw0s7mPXIDQqklNgx62tp85nCfjVVUpanC5sTKYAovUGlJxIGWfn
	 ifflyClrJqXdzSrybX3l0o+Bt/RfaIuCaSpeWIZWFTPysxAt7h1TP3yaxEnFif62TyMlM
	 2HRjNh+47QEgFMi2Y5rDVclfpO5mraZ9hWEc6bI/+u9UdyBNVQhsKB/SxtU43lTONG5RR
	 x1U9mBA2HQz3IfwfO90DVrO4kimpE3iH4RuLHbki20X6ZTTpGqpfBuvPhkduzO5mFkUvw
	 fajuGGxYcONR4u5cThCA3Y5loaA5mtep72UnCaBSgoa3pKGfMWMT9NXKR3owKl/fN3w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028558;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sWprpG0Z76Kcm3c2DXvAIooYP0551ipYcwf529Y2TIA=;
	b=tMkZw581n8BHIhSQee01LBaMFJH3SxVqkxRK4duB2GoBILovK+oF+Ol7dHUpwAW59+Er
	 phffepYGDV1ThjrXeMhQx2mpfsiuHnp/dW11RPxEudyZEnUgEwXBUUoo9j7LtnXFkB2Fv
	 gydKLk/ut9MNqnjWXGwLPoNQGmTi0/xckDyjzKBTecplzubXUbEkmS3kOBzMGmJJYL05r
	 0LcyUekV8jkJ9nb3owoPDWRgnx0d4jvPAwl4TPFkt1bfdCkxWjWs/1ze6ier5I6ZfO19M
	 4qkcB1vwscWEkyDumKBk3DHhjozBnqMPndp9y5/5wXhxM79UXSA9CY+aubP4fOrnslw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Neqg5wT9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45092606A31C;
	Wed, 18 Nov 2026 19:02:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Neqg5wT9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 920811F000C4;
	Wed, 18 Nov 2026 19:02:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028558;
	bh=sWprpG0Z76Kcm3c2DXvAIooYP0551ipYcwf529Y2TIA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Neqg5wT99VMgQf379UaxCKc6OVWzI7M9BGxP4+URRVmFA25+Ypg6SngQeMwNP76Fb
	 GLFAYZwcUBPacvcNT00bdbrZe29cxC7UzgLu7JlYKmhmlPx8UpulSeoQ1ZEkBcoGZK
	 22CuwEEeNGv7ndb3r3xIUfnJF3gLJ5IDNEUDeMvU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <mason@kernel.org>,
	Amir Goldstein <amir73il@gmail.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0021/1756] backing-file: enforce append-only and immutable backing inodes
Date: Wed, 18 Nov 2026 15:35:48 +0100
Message-ID: <20261118150008.754159802@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

[ Upstream commit 19b18e01d0361ce495be153ecce80b581086ab3f ]

FUSE passthrough opens the backing file anew whenever the FUSE file is
opened. fuse_passthrough_open() passes the flags of that open to
backing_file_open() which opens the backing file with vfs_open() and the
credentials of the server. But vfs_open() doesn't go through may_open().
So the backing inode is never checked for S_APPEND and S_IMMUTABLE. The
checks that did run were done on the FUSE inode and that one never has
either flag.

So anyone who may open the FUSE file for writing can overwrite an
append-only backing file anywhere or write to an immutable one. The
server only has to register the file and a read-only or even an O_PATH
file descriptor is enough for that. Registering requires CAP_SYS_ADMIN
but the writer can be any user that the server lets open the file.

The FUSE inode is checked instead of the backing inode in a few more
places:

- do_mmap() refuses a shared mapping of an append-only file that was
  opened for writing. A FUSE file opened with O_RDWR | O_APPEND passes
  the open check and can then be mapped shared and written to at any
  offset.

- fcntl(F_SETFL) and RWF_NOAPPEND refuse to take append mode away from a
  file on an append-only inode. On the FUSE file both succeed. A
  synchronous write still appends because the backing file was opened
  with O_APPEND. But an asynchronous write is submitted with the flags
  of the user's kiocb and lands at the given offset.

Do the checks on the backing inode. backing_file_open() refuses to open
an immutable inode for writing and an append-only inode for writing
without O_APPEND, just like may_open(). backing_file_mmap() refuses a
shared mapping of an append-only inode, just like do_mmap(). And writes
and splices to a backing file in append mode fail if append mode was
taken away from the user file.

A FUSE file that was opened before the backing file became append-only
can still write anywhere. That's what happens on the native filesystem
as well and the backing file of such a file isn't in append mode. Two
differences remain. F_SETFL succeeds and the next write fails. And FUSE
reports EIO for a refused open because it turns every error from opening
the backing file into EIO.

overlayfs uses the same helpers but it mirrors S_APPEND and S_IMMUTABLE
in its own inode and a chattr through the overlay never sets them on the
upper inode. So for overlayfs this only changes something if the upper
inode is changed behind the overlay's back.

Fixes: 4a90451bbc7f ("fuse: implement open in passthrough mode")
Reported-by: Chris Mason <mason@kernel.org>
Cc: stable@vger.kernel.org # v6.9+
Link: https://patch.msgid.link/20261029-work-fs-ai-fixes-v1-2-88f22792f6f7@kernel.org
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
[ sashal: Retained file_remove_privs(ctx->user_file) instead of file_remove_privs(iocb->ki_filp) to match the existing API. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/backing-file.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/fs/backing-file.c b/fs/backing-file.c
index 2ed8f17aa5f48..a0caad973766b 100644
--- a/fs/backing-file.c
+++ b/fs/backing-file.c
@@ -35,9 +35,21 @@ struct file *backing_file_open(const struct file *user_file, int flags,
 			       const struct cred *cred)
 {
 	const struct path *user_path = file_user_path(user_file);
+	struct inode *real_inode = d_inode(real_path->dentry);
 	struct file *f;
 	int error;
 
+	/*
+	 * may_open() checked the inode of the user file, which need not carry
+	 * S_APPEND and S_IMMUTABLE of the backing inode.
+	 */
+	if ((flags & O_ACCMODE) != O_RDONLY) {
+		if (IS_IMMUTABLE(real_inode))
+			return ERR_PTR(-EPERM);
+		if (IS_APPEND(real_inode) && !(flags & O_APPEND))
+			return ERR_PTR(-EPERM);
+	}
+
 	f = alloc_empty_backing_file(flags, cred, user_file);
 	if (IS_ERR(f))
 		return f;
@@ -224,6 +236,14 @@ ssize_t backing_file_write_iter(struct file *file, struct iov_iter *iter,
 	if (!iov_iter_count(iter))
 		return 0;
 
+	/*
+	 * F_SETFL and RWF_NOAPPEND can take append mode away from the user
+	 * file. They checked its inode, not the backing one.
+	 */
+	if ((file->f_flags & O_APPEND) && !(flags & IOCB_APPEND) &&
+	    IS_APPEND(file_inode(file)))
+		return -EPERM;
+
 	ret = file_remove_privs(ctx->user_file);
 	if (ret)
 		return ret;
@@ -312,6 +332,10 @@ ssize_t backing_file_splice_write(struct pipe_inode_info *pipe,
 	if (!out->f_op->splice_write)
 		return -EINVAL;
 
+	/* splice refuses a user file in append mode, so F_SETFL cleared it */
+	if ((out->f_flags & O_APPEND) && IS_APPEND(file_inode(out)))
+		return -EPERM;
+
 	ret = file_remove_privs(ctx->user_file);
 	if (ret)
 		return ret;
@@ -343,6 +367,10 @@ int backing_file_mmap(struct file *file, struct vm_area_struct *vma,
 	if (!file->f_op->mmap)
 		return -ENODEV;
 
+	/* do_mmap() checked the inode of the user file */
+	if ((vma->vm_flags & VM_SHARED) && IS_APPEND(file_inode(file)))
+		return -EACCES;
+
 	vma_set_file(vma, file);
 
 	old_cred = override_creds(ctx->cred);
-- 
2.53.0



