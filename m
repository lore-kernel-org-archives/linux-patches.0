Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044300;
	b=bfZiNnNu9EWrtohvNdIs384CxmncgCqmicFaNtLmbNe9wZS2dlx9I2OGN5OsT1HOhzNL
	 Ia6mYtd6SRFNf2L4wcjtfYLZqO6IaAOkpOU/kIk0lcDimhTzKhhUkY073R+5fhztctkrT
	 yM64SyJut8jwXuC27QYx/j/yhV6pkUMDA4WfGsncqDf0nFoTmfwjGKAk518F/Z3p9j96i
	 pVsBQ/2N1328P0fDk4S1+d+6CvpzwC/pvs8Jr64jpBdpAA+D33gorQxz90PCGTKbFCF4+
	 5z4GxRo/yayFQq59JiBp0xZ2l6f5VLYjR9btlWWP6WNo3VxaaOyGihmXYPWnnP8EEQw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044300;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=86REJPejbupGntKzP9RWzmdAYpMg80OVRYOLhIiWyfM=;
	b=JNlk1hBaa+xV7n+mshqEMMbwboHfksBoI8ULHGTKymrpeRgnv3EkMaPZT4tWSUh744l6
	 QjflsFXGjUycWGb9eSRJHe2+caQHpJd4/o+eirj0lxLu19+i4IcNcvC6qYbh/XUj2CTQx
	 K1Q29FcS8aooFQxR1Jc7HqXLnsZYdBEh07RmEiCEFL9lllU820OgZKn6r7b+Rn1P4RAgO
	 tj6snll3BlE4ilU6lPvcgCZzv6ubKn/2+JbpHsA49MdApKCnuSWOlWD29EkSPuzJYWnAH
	 qH4RkiuWl7Gj69oHmsfPRnnpCR5xNw0MCo7XiC3mOu5kX6SVPuTv6929/C0YTONBjww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tcQhpXJ0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6554606A325;
	Wed, 18 Nov 2026 23:25:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tcQhpXJ0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBFDA1F000C4;
	Wed, 18 Nov 2026 23:24:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044300;
	bh=86REJPejbupGntKzP9RWzmdAYpMg80OVRYOLhIiWyfM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tcQhpXJ09hZGdHa3dlEXByU3gj0HIWh0o5kfeOaevOpWQx4PhR6ipc3MzrF/Io3WW
	 nV69Aq6aGZGpys0SsOL/918ubAbrmuaJeQHuxmg/j8OObYGRydZHA1mJqFpshShz/I
	 Mqkf4Dr1CYuVVwpoGFr3nHVnOoCQDkJ7U/0A4fUY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	DaeMyung Kang <charsyam@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 6.1 0515/2857] ksmbd: preserve unreadable named streams on open
Date: Wed, 18 Nov 2026 15:25:49 +0100
Message-ID: <20261118150220.007513953@linuxfoundation.org>
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
@@ -2533,6 +2533,8 @@ static noinline int smb2_set_stream_name
 				     xattr_stream_size);
 	if (rc >= 0)
 		return 0;
+	if (rc != -ENOENT && rc != -ENODATA)
+		return rc;
 
 	if (fp->cdoption == FILE_OPEN_LE) {
 		ksmbd_debug(SMB, "XATTR stream name lookup failed: %d\n", rc);
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -1804,7 +1804,11 @@ ssize_t ksmbd_vfs_casexattr_len(struct u
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


