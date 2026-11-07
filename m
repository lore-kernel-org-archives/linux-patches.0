Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060996;
	b=0d9CRpfdI6Q6O6rPSimH7YFIQ14sWlZPM9OyTj+qbbbk0oieJeH2wW46PHOLQAPq70ul
	 VvNcn695u1AvKIwe/Q5TyIX1bZIHZeaNzdchsNFPjURNTMoCKhH4XilEOryjYf8ZrTue2
	 JV0Op8aNuvVPppz0u4iNMiGtz7H8+H9WKo+gGVdYJQC803cw3UTXvsPtEGGsaaiYzzDPo
	 48wXWQ9KJpnOd7RobSzeZPzAjBYel1mMdDKIyXVp8q8WjreiEql6zPaD6ctp++tS4XKID
	 wR6LL5FTRabpinDLvpZr5TfSvTigeKK4yWU6PXTtxEduP1YGu/8x9WFA7+h4oeNKMWA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060996;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=J2J640MM/jPM+DCgkkXADKcGe2U/R+ydhkLkIs7dbHU=;
	b=21JA8ILQcdjhstOCfZrrHc8WT0UN3qd91QE+4GLg/jT6+HTV9TjlOTYqvJHrRsmZi96c
	 VRAc7czj75CIA8mLarFF2u/gJd+p1LIWAU/qmx2mYISRNfFPnGlM40dj3YAv00zdRllLI
	 uP8rWi3vnyOct2Oo8VWdtMLNROKPWyK5CujGNrvRdhPD2mBk+kIovtnaOExK5tb3Uc1pE
	 8c8vIxxP5sMmJWtOIdA7EjjCE7yYWILwKQwG40YC9XpE8W8DoFrSrCrYsXysTMe8ZtCcZ
	 +tVvxoZSUNiOPaUT9ae2Mnnc3LE9U/TT+kpdJXE+wP3o82AohjQ1DcQQU2X6u1KEbkg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Yzq8S/7M";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6FE1606EE86;
	Sat,  7 Nov 2026 14:16:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Yzq8S/7M
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E2A41F008A4;
	Sat,  7 Nov 2026 14:16:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060990;
	bh=J2J640MM/jPM+DCgkkXADKcGe2U/R+ydhkLkIs7dbHU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Yzq8S/7MEOwG8D7YkpCPypf2hMZoTzkXf4x81b1V4ujTqQ8BcKaq/578a/fVWh3Wv
	 qdzxj645nzrUqweVXLHq3Z0LGEtV6tT4QWt4CskrllunSnGltA24+MYPfRb2yKoA9V
	 qzGtdDiRqHCRzCnbGasq/kEGHNaW6XG/JtFJ1yL8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0339/1536] ksmbd: allow I/O on directory named streams
Date: Sat,  7 Nov 2026 08:39:15 -0500
Message-ID: <20261107135007.208831536@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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
index 967f669974861..9b973d7064988 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -374,7 +374,7 @@ int ksmbd_vfs_read(struct ksmbd_work *work, struct ksmbd_file *fp, size_t count,
 	ssize_t nbytes = 0;
 	struct inode *inode = file_inode(filp);
 
-	if (S_ISDIR(inode->i_mode))
+	if (S_ISDIR(inode->i_mode) && !ksmbd_stream_fd(fp))
 		return -EISDIR;
 
 	if (unlikely(count == 0))
@@ -502,7 +502,8 @@ int ksmbd_vfs_write(struct ksmbd_work *work, struct ksmbd_file *fp,
 
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



