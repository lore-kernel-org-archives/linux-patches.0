Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793830924;
	b=MrkK2ohF5Vpf1ef76BzcGz8RFkAE+dY1aBOdkNTbfOxZS/SIc3iXRUvNGPgd1WkW/x0q
	 CXWy68fdYHyqG72h7XeZanQ0U5ofsrXqcsjtjtTkGle6FQt+8uepi7mXppT5AkktrUSd4
	 isM3fH2DkKO+gaf8PJP5gB0WAuhkz2q37px8qiaUsbBLGnn84BQtgW0T6PUS33bmwGrnR
	 Ge0AewetexZtmetj4tQjcvRwDNWgBbstVtKBIlm5FmQ7/f9z4q2wSrJLbiSYfeOZXmHG6
	 BNki+eJCmQYQNswHCYwg+Pwl1Ro/jUDJv/hCvUj63zLoWqsJLp/rsS2ZMwvJ1vVdj5w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793830924;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=u/R8SHaQM8lZbmT+Ni+2noF+d+p4i5eDsgzw0cKeSKU=;
	b=2SjnS6vyiKrAfO71vvB7U9+9IYd5m27q3g4fFtFzlW5aAB9wc04my2z9jK8UL9XAsfVg
	 EgG5rFO0FRSDQu3VhkhjngjKsQ3Yl7OYPSffs/2tOU6+rR2r5hhQf2L4mgfguWGgVzn4h
	 HsIMt9eyLO+er4NwD5bD+3k8aNzeIywSbc8evG5BgPheBfyCeEZ9iPxLymzQbDcItq42n
	 6GpNLT9DRp7TlEQ9rQTJumdHnY/neMjwQcn1i1L/ioGkMMZFoskxd8X6mXgAwllX8iLbw
	 ojKxurjQR1GuuZHd5fH53JU44uLa5z7mjFOtq4SxcO0KTXLKrAxwzfHV9a5PKqvFUeg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JKo51YKL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70617606A33B;
	Wed,  4 Nov 2026 22:22:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JKo51YKL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0967C1F00A15;
	Wed,  4 Nov 2026 22:22:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793830924;
	bh=u/R8SHaQM8lZbmT+Ni+2noF+d+p4i5eDsgzw0cKeSKU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JKo51YKL7qNL+a8PfPc8m60Adt2L3xAN2PTXqtNmJd/C/WmIu0joF/RMhHbt/iobQ
	 VbLvF5snUemEb9oHBKLJlROaF1/5Km1sya5neXqselLiajbCbnLQr5E/AfJX3YC9pD
	 aAI6c+ytIkZHATzDLJ6ICADGG22HDwqz8NTUkZto=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0405/1005] ksmbd: allow I/O on directory named streams
Date: Wed,  4 Nov 2026 16:02:18 -0500
Message-ID: <20261104211055.423614633@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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
index 3ac5f3f48121d..47c289ad9c3dc 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -372,7 +372,7 @@ int ksmbd_vfs_read(struct ksmbd_work *work, struct ksmbd_file *fp, size_t count,
 	ssize_t nbytes = 0;
 	struct inode *inode = file_inode(filp);
 
-	if (S_ISDIR(inode->i_mode))
+	if (S_ISDIR(inode->i_mode) && !ksmbd_stream_fd(fp))
 		return -EISDIR;
 
 	if (unlikely(count == 0))
@@ -500,7 +500,8 @@ int ksmbd_vfs_write(struct ksmbd_work *work, struct ksmbd_file *fp,
 
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



