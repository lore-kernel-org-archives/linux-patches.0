Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043536;
	b=sutEsQEgUgVE43oHUlaYOEhd6uaHdrK1xVgr0jNO8rNwIFiz64cT94iEHQOpux0l60PX
	 qoplTE7OUSytwKtTGi9Dw9SgHnShPCG0pv6pkR549TK44FW9w+WKGNAbusG9gfY4J+bBj
	 aPgIc8WM+425HRRzZHTvynVbuTfiBwmvHSql/4+ATq4g1JqohRA0IfNMXrrgvT74UEEkf
	 IYYbntiulCSQv4M+aQUs6zoo/bKa+a5w+N9JN5TehmY2sHFL6c5zN9YWcAgN4cyIHYdYk
	 6ifJV7OfOL9Pd4Ib8e+/bzN1QzTx+pIpEGp+EWTHB9xcXhbVvGXn8nOazv8zSFvRZbw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043536;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UAfE/aIykhewpT7fBgEoKohdF3XHCXwULbCPr+ig8iA=;
	b=iPTSQNXKtLNsn29HalW3jbKXxjXfv6FXC0vvgiW7kut+2CGvguAgBHPM3Ot+zVKvSv6K
	 6yGnIA3u0QDekPtmmYQQ9XWZZ0TxE1MGpANx34cVD1GPCMplzStu5LLu8l1SlH6PGmETB
	 LuO7fQTiQ7wvsCOqQIZryzo75QIempf/jIg4QLK9eQo5mAfSkcHAQ2CSJxMpDeagNs5cf
	 OHS8X4xlD+fQ7Cwg1FGN68uCPVQFjau9njq8EtAxCRil7ugMRudLpx2OhP+dJ3SHwvPZ9
	 KPvlztGBb9bJu8rUWI+HfzUH+EjKIErCFMV8umwmRaVi/IuNZMUtKcvxPEgbzX2SvQA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SaxI80QR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFB6D606A31C;
	Wed, 18 Nov 2026 23:12:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SaxI80QR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 081AB1F000C4;
	Wed, 18 Nov 2026 23:12:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043535;
	bh=UAfE/aIykhewpT7fBgEoKohdF3XHCXwULbCPr+ig8iA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SaxI80QRxso1hEab7399tk9ARRCTcvodIdn20T/eiAe8euO/vbGEEcdLJ+pcXoIqC
	 k9gaNwibz5sy/xa5dr7L4EMA2OOkFi18q81fW3/jDB4VOn+Q52vrHJF+eGzEaL5ilr
	 MPEhkn/NszBGCaOIPTaOVW5bCJCWXaqU584T1khw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0246/2857] ksmbd: allow I/O on directory named streams
Date: Wed, 18 Nov 2026 15:21:20 +0100
Message-ID: <20261118150210.304099851@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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
index 8631e57df5994..a1ab487d2c09a 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -378,7 +378,7 @@ int ksmbd_vfs_read(struct ksmbd_work *work, struct ksmbd_file *fp, size_t count,
 	ssize_t nbytes = 0;
 	struct inode *inode = file_inode(filp);
 
-	if (S_ISDIR(inode->i_mode))
+	if (S_ISDIR(inode->i_mode) && !ksmbd_stream_fd(fp))
 		return -EISDIR;
 
 	if (unlikely(count == 0))
@@ -506,7 +506,8 @@ int ksmbd_vfs_write(struct ksmbd_work *work, struct ksmbd_file *fp,
 
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



