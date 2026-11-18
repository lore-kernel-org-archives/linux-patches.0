Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034281;
	b=R7APJMSf5PTFOT+eK26jXj3i0lZmwvhPKXqN6ejyMF6rjbSaSdd5U3McwglbLvd5BwUt
	 ljs1l6KE75FWSbceJW1pgkM/0r89bHodqYsdXHrcvg7d6kSVQIo/CDPXTLacnSFM+A8Ld
	 ktMgFDX1vmGc9bdUChTAjDaq1M8YcRnyqRTUYL8XwThT5oCQTQZaX8SKOIzgPtpFZWsAH
	 0A1F2Xfsg/kFPglXnEwzuicN4fvGR8/PfzyKXIx/H230vQAeLlQpE7L2ZlEyG3DSk5FTa
	 qKXyMTrj/ZNQY9fAO7XW7UymGdAdg/JVre7T7IB5XrFtREPm8CKishv4k4miCtsENTw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034281;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yUwLlEieeFLqp93WdM2nC7YdQ2Ep1gRGZjIS3wQFhbw=;
	b=dcMemACnsr2W88HNG0bo22FZoQsP0RKtWWwLq2e275PD/pGE7vamick21whagNuTI4gY
	 gt1Rt/HHq9B+JUgfBb+VCWPKFe43058AvtxyWBj4n6KA4bdeuFFQ7JBrkGFGKQU2dnt5R
	 IbkprWFJ6RR2AOnCEPK9Q2BYtD6EE8bakcWIZgxv1zJ0n7ACQmE5Ki96H3dO4beDQtPS6
	 9HSaNmwR0x7rCngeugRgZl/v996+Ccarv34H4xzU8eRpopy8+X3crEawaHbznDYyUUzXL
	 pVyf94uchoy1VLo8ncs9gZ6xSuatSvzUsddTr2aRQ6yovWcJINXRQ3JkBZ5c7I4Unew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EbYP7AEB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B31B606A31C;
	Wed, 18 Nov 2026 20:38:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EbYP7AEB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B74A1F000C4;
	Wed, 18 Nov 2026 20:38:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034281;
	bh=yUwLlEieeFLqp93WdM2nC7YdQ2Ep1gRGZjIS3wQFhbw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EbYP7AEBJTytSA3HTpO7MXYkmChNP7tEHx+ys9NzbqMqz+6VcJbBWWK0x5+yBtQhx
	 LCQm/M1D70rvvKcMFauwrh7+8v9oqr1dQEIoRP1rqxf7DYsbR3P55KkGObvW5sMFKU
	 SIThmZmsNn9FadbDZPoLb36oJ0X4cpVrNBfNToxg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0287/3318] ksmbd: allow I/O on directory named streams
Date: Wed, 18 Nov 2026 15:15:09 +0100
Message-ID: <20261118150324.190198844@linuxfoundation.org>
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

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 8184c425a19d44f138d42b44cc363917c08e5f1c ]

Named streams are stored as extended attributes on the base inode. The
VFS read and write helpers reject directory inodes before or together
with checking whether the handle represents a stream.

Permit read and write operations when a directory-backed handle is a
named stream. Continue rejecting direct I/O on ordinary directory
handles.

This fixes creation of the directory stream in smb2.getinfo.complex.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/vfs.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
index fd1697c2d6655..9b0accb224721 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -375,7 +375,7 @@ int ksmbd_vfs_read(struct ksmbd_work *work, struct ksmbd_file *fp, size_t count,
 	ssize_t nbytes = 0;
 	struct inode *inode = file_inode(filp);
 
-	if (S_ISDIR(inode->i_mode))
+	if (S_ISDIR(inode->i_mode) && !ksmbd_stream_fd(fp))
 		return -EISDIR;
 
 	if (unlikely(count == 0))
@@ -503,7 +503,8 @@ int ksmbd_vfs_write(struct ksmbd_work *work, struct ksmbd_file *fp,
 
 	if (work->conn->connection_type) {
 		if (!(fp->daccess & (FILE_WRITE_DATA_LE | FILE_APPEND_DATA_LE)) ||
-		    S_ISDIR(file_inode(fp->filp)->i_mode)) {
+		    (S_ISDIR(file_inode(fp->filp)->i_mode) &&
+		     !ksmbd_stream_fd(fp))) {
 			pr_err("no right to write(%pD)\n", fp->filp);
 			err = -EACCES;
 			goto out;
-- 
2.53.0



