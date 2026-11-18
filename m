Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052002;
	b=lxlXWraPHObdiwe8Hcuwn3Asx1lYVCYCsMc6/VEg2IeS32c8nRh2OR//MpoV+YRY/niE
	 Kv3R2OiyOfuM4VACITCZDSXstzO3EduV0LZam6cFljA7q2lggaMdnBQ+pOfOF3srEN/qC
	 Q7ucafDZBz75268mgpmxqR1dRpyy1aWP3Q7Ty4PriFtzo+LhxhhFmgu0W/GNp3Z99wcHs
	 X3Bjvcf5XzQTaq6F0bqtZr/pJtPxgrZgqCDXSQhgbDI7+QIZpGSTo43UWHs0DtHabwIRt
	 /RT45vbUQ6FfkbdGffOdRfwVdMZAfUrx1tVvmmKa8EcKW8AHbCS3XA9sftmd16wGRvg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052002;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Nf6jVb00g+FTQ8O2UyqkMlvHcDdrtoO1xTzd+hW7uXk=;
	b=mD9+AXact+PEEjHfwezpS4LiWuuExI0hrO7IbwqrUOc/rpmrVBS8TugNkLeK2Bnf/Vcl
	 SH/xEesX2K6uadGJLNOslCbakPadVnuBvm/t89IVGZ0z70XoqmA/GJcz7mzTg63LDU37I
	 UFyKMWHDA6E2PutljEbayLX0RwuItL/48NJW9kh8QX0R6vJRdQRU0v0MBezuV0FS9IBYZ
	 yreDQptPOfPT9hycETzFBNXhVUdnA0XTJMQQ8SLjdAsEBqHRlGCRR9hW6Q0YV4NPDHqza
	 DYQavJR1Xdrv9zNovyxGAzLEw2Xz/3MI5SIv8eiytNcD8d97pf1+Z1mp/GS1/iErouQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oupPC+9i;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84A91606A325;
	Thu, 19 Nov 2026 01:33:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oupPC+9i
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D55211F000C4;
	Thu, 19 Nov 2026 01:33:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052002;
	bh=Nf6jVb00g+FTQ8O2UyqkMlvHcDdrtoO1xTzd+hW7uXk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oupPC+9i9hOefh7kKBisA+T0AgWauX18S3lYXJczFT+F8fhPUIoHMxbUOFRhMSaZ6
	 GuB+2XVxFLqmQsXrUyTCRrFnZ3HNIPjhIfnyvxWBkAV2/PkuMjBIzQU2JyJJSbDOse
	 ASPcs4wQ07wsi93PCVeHC9weu8Qp/9eK7bVL1j/A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	DaeMyung Kang <charsyam@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0407/2214] ksmbd: preserve unreadable named streams on open
Date: Wed, 18 Nov 2026 15:34:43 +0100
Message-ID: <20261118150027.053437194@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: DaeMyung Kang <charsyam@gmail.com>

[ Upstream commit 80c816c047f7cae3c99cc75740c1f5d2c4d97b45 ]

A write-only client can open an existing named stream with FILE_OPEN_IF
without permission to read the underlying file. The case-insensitive
lookup finds the xattr name, but querying its value length then fails
with -EACCES. smb2_set_stream_name_xattr() treats every negative result
as a missing stream and replaces the existing xattr with an empty value.

A failed xattr list is not proof that the stream is absent either:
for example, -ENOMEM can lead to the same empty replacement. Preserve
listing errors and create a stream only for -ENOENT or -ENODATA. The
latter can occur if the xattr is removed between listing its name and
querying its value. Return other lookup errors without changing the
stream.

A write-only FILE_OPEN now reports access denied instead of name not
found. FILE_OVERWRITE_IF and FILE_SUPERSEDE on an unreadable stream
also fail instead of appearing to replace it. Stream writes and EOF
changes already need to read the old value, so such handles cannot
update the stream after opening either.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Cc: stable@vger.kernel.org
Signed-off-by: DaeMyung Kang <charsyam@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ksmbd/smb2pdu.c | 2 ++
 fs/ksmbd/vfs.c     | 6 +++++-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index 13069c375a906..ed2b655978d24 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -2519,6 +2519,8 @@ static noinline int smb2_set_stream_name_xattr(const struct path *path,
 				     xattr_stream_size);
 	if (rc >= 0)
 		return 0;
+	if (rc != -ENOENT && rc != -ENODATA)
+		return rc;
 
 	if (fp->cdoption == FILE_OPEN_LE) {
 		ksmbd_debug(SMB, "XATTR stream name lookup failed: %d\n", rc);
diff --git a/fs/ksmbd/vfs.c b/fs/ksmbd/vfs.c
index aff2d0f22c8fb..a063d7a006ecb 100644
--- a/fs/ksmbd/vfs.c
+++ b/fs/ksmbd/vfs.c
@@ -1713,7 +1713,11 @@ ssize_t ksmbd_vfs_casexattr_len(struct user_namespace *user_ns,
 	ssize_t value_len = -ENOENT, xattr_list_len;
 
 	xattr_list_len = ksmbd_vfs_listxattr(dentry, &xattr_list);
-	if (xattr_list_len <= 0)
+	if (xattr_list_len < 0) {
+		value_len = xattr_list_len;
+		goto out;
+	}
+	if (!xattr_list_len)
 		goto out;
 
 	for (name = xattr_list; name - xattr_list < xattr_list_len;
-- 
2.53.0



