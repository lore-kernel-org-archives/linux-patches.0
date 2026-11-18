Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035015;
	b=Vh0UeEKF5h7Z92uDBmN+rcV8GrUpNoSM1tr7T6sKgV7fz2ti5yf3h36r5/AldsbW34Kw
	 VdiV+0IateTAcfBUBJoc4WRAccc0QwYzTSjUnPPXvrnoq1rGWoE9y1nKdRyQzRPE7BzfF
	 If0LJe7F0/0LHfUUbAwG08OXRJCzAE8od8OUwBplMZ1qLN19ba0TemMyQTlalav3RExO2
	 UGafYmP0Di9wDpYzdwW36HK896R7yysjFDqPBaElqh2x5Su4q7XkXsl8ld0eJPIomYVFe
	 x+TLLCAOZ97C5sC2jAvYqfqvrl63jrV7Fh1xTp+XrfyBewPpQzLhrps/x62FYU+px6Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035015;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xtOYbVETQysHNLQigeOeQUq7Qa7u44AHd1SK+dfcS4k=;
	b=SG1c2pxyjpsjNAnUc/jgIM6WIuTHyvemvCbuAvQUMAlj7EI8OI0ffRbjAM9UgecGz5fq
	 bvBPm251cF6U7edH2FmVphjx6oMLsk3mWF328OgIyvfNHuhDfaugQyDBdMPGdR4Qyp+aO
	 QTexHJV1FJsflBJ8IbupP/e9Q5HvsWuOoLd7l4otwJMqpahaPIVp3iEf2Svmwrj3dDksJ
	 eyDmHCKMgfiR2misHRiUVIc+mfg5y5EqpM5dMEIdQZBVKi+96oKeVA9EQxDGFlbrxMn5C
	 dpB1mj4eGOJZTgEAlaJaeTsYApNKDX4wa2kDDLfyHEjsJ42YNQAaa+u59wVT0vdx+og==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WvCIeJSt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4A94606A31C;
	Wed, 18 Nov 2026 20:50:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WvCIeJSt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A2D01F000C4;
	Wed, 18 Nov 2026 20:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035015;
	bh=xtOYbVETQysHNLQigeOeQUq7Qa7u44AHd1SK+dfcS4k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WvCIeJStZTZzMZMKTWe9bfmkcI+ecttVVU+Ikhxv4XUhUe6mljuHD2nxyl/Tr9jyb
	 L47VidE9aKnbpq66cg+Ay1HL7uKGuNu612HT8xmS39dh72KNEzl5S756AGLqYwFco1
	 megL1EWDuKZqVclT0EU/t8J3T/hEnTlZp3ry6zXM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	DaeMyung Kang <charsyam@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 6.6 0574/3318] ksmbd: preserve unreadable named streams on open
Date: Wed, 18 Nov 2026 15:19:56 +0100
Message-ID: <20261118150334.692275824@linuxfoundation.org>
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

From: DaeMyung Kang <charsyam@gmail.com>

commit 80c816c047f7cae3c99cc75740c1f5d2c4d97b45 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/smb2pdu.c |    2 ++
 fs/smb/server/vfs.c     |    6 +++++-
 2 files changed, 7 insertions(+), 1 deletion(-)

--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -2520,6 +2520,8 @@ static noinline int smb2_set_stream_name
 				     xattr_stream_size);
 	if (rc >= 0)
 		return 0;
+	if (rc != -ENOENT && rc != -ENODATA)
+		return rc;
 
 	if (fp->cdoption == FILE_OPEN_LE) {
 		ksmbd_debug(SMB, "XATTR stream name lookup failed: %d\n", rc);
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -1812,7 +1812,11 @@ ssize_t ksmbd_vfs_casexattr_len(struct m
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


