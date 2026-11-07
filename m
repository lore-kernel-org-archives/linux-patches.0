Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061493;
	b=gXmgUk1wxKHEXZie0oS4+0edhGCiKs3aaRHlNfv2r4wFBBLx1htL7I9L87HcpdUaGb4W
	 bU9V/S7q3z8QCtPyYBO0TBkiuTzysXpHBmzrVQgXqLGJu42pmMN43FiLc3zFxeBvhxfXE
	 4jWytQBnlBrxDtrTOlSf3IqoWB3rQk1aa9wUtLOFnMhf7nqPkX0z3Iouixr5CZmiaq4oU
	 UMFvkWeFfmytY99sg6DaOg4l6logV8emkBDZtTDhrCXNIhuVRxYK+/PSC2Mry1tk59eQZ
	 n/lK+pz6hUryeSRKdzhFZsHK0h1Mh34reL/RzeSd0bBTJc/WNmF1womoSU0qoOKrryA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061493;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6livFuJIrxPTNjAxMaCHPcZs1UJ6Sg7YEQlBoR/rmQs=;
	b=Cc20Gj5V06shhBCFQKWHiBHlDjZ4iDDU6zjCKbYAZQb8Yxwq0cCub/ExR28UUKv2pquv
	 PSHmYxrP6kbTdaWU1Ve6NT4/Ukvw/uWmUWCqCWeky+xs1j5ev7wInGjiD+ShQ8TcW/EPy
	 MoLAI9PLKzlH0nsfDWgT63pgIoAf7IUXJHdFdbTAOO/rOZ4C+n67udSyMAgVs55wQxfHW
	 ox5CNOg/05JmynQTh4R4vSvZj0DybUJesKoHVpb17yd5TsC5LsMZQTfNxnkM9gmpagoaR
	 VHBTqvzeLD8oLKyhTgKJG4JlKA7v1nPUKO4fSNcVSgbF9e5KtQUnEMiuKObKuwaciOA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ixV19Ue8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8CAE606A326;
	Sat,  7 Nov 2026 14:24:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ixV19Ue8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C8CD1F008A1;
	Sat,  7 Nov 2026 14:24:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061492;
	bh=6livFuJIrxPTNjAxMaCHPcZs1UJ6Sg7YEQlBoR/rmQs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ixV19Ue8e0K7Aqfu6+emCDgzfKoYcXHOvy6HqX/xEoz7yFi7GDsozYnfxeU24anXS
	 wWYp5euc5/pfUuFSciUfzBXCr7+AFBWQERMbvq28jdGyFsCF4zywOoeKSpJp1rnrVu
	 N5paLokmYH01MdCODySJIInAx+GawxBAVY38LCA4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	DaeMyung Kang <charsyam@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 6.12 0589/1536] ksmbd: preserve unreadable named streams on open
Date: Sat,  7 Nov 2026 08:43:25 -0500
Message-ID: <20261107135014.077624319@linuxfoundation.org>
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
@@ -2548,6 +2548,8 @@ static noinline int smb2_set_stream_name
 				     xattr_stream_size);
 	if (rc >= 0)
 		return 0;
+	if (rc != -ENOENT && rc != -ENODATA)
+		return rc;
 
 	if (fp->cdoption == FILE_OPEN_LE) {
 		ksmbd_debug(SMB, "XATTR stream name lookup failed: %d\n", rc);
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -1818,7 +1818,11 @@ ssize_t ksmbd_vfs_casexattr_len(struct m
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


