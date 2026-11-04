Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831343;
	b=HU+6s8IhXCQrCEv1OipaLLbITBizImFmFa5n0nMaTXDLMuQKUn7x9nx2/YhUqTmWplQ7
	 HbxNUtjWi5ALNsoD1b60p3/U8RufJfb5MbZCjV7IocrcOUMA7UqQF8P2ghrhmryImZEwj
	 f7nu8FeQPoto4H/Jg1aPGSEo9Iakc3BNM7J1iIjUYB49CiAW5x4KiQVI0hTpFldBvhIyB
	 ZgyTfVrYeLi8XSZ14loXVH5krrUW+1OkPCI1Sw/KeXQphkZyma8wc7dk+f0x7RvN8kr1S
	 yB7PMg0946CqD/vzzOer4/u7hXc1NuWFGjPCGpmVzlIg6vS0kh0nWBhAh3MB1UADmwA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831343;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=A6+FRuv65TUj1yUNfWmhJAIY+P53zbpHRqEQBddYpwU=;
	b=e8BvYP60tpcNoyjo8DQKtTTqHvJY22TUi6AQIhXu4P5AY3kDFlxaOzo7d9c3M/ULoBcf
	 07WixtAvy77UJCZQL0H38dCmUMtPOzDgRzq3Dc9y68PAECR6/9zGGe0otFy28T+CmeZKu
	 kbuTfrz0b70qA/e2MvgRYT8XUFawePMet7k1Nuaho+KoibxyqSARx0CaqqI/ISQWXmmFm
	 RcGuOImRn0cD0pzdjallpMSK2R1pW+uK8UH3urK3NjMMpUOui8gKWK9DLfuhRxmNx5+4C
	 Jag33djqFiOHIHaNEyIIulPM7vBxcCfFeG8kV+Uk/x8af+RZe5lxOgI2pZNbazpLJuA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pFmOAKnT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07DA6606D81A;
	Wed,  4 Nov 2026 22:29:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pFmOAKnT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B194A1F000C1;
	Wed,  4 Nov 2026 22:29:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831342;
	bh=A6+FRuv65TUj1yUNfWmhJAIY+P53zbpHRqEQBddYpwU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pFmOAKnTyu5hN7A+AOFlLUu7CyVJNFADBCSbrb0eRHgzEH23q0t8MxP3eJlQByPOo
	 9EZChQG2Zw+5+jzb/OsFn3f6UttYgbndBSq8pmajwkFtOe2VB43TStKL04OQy49SpF
	 6QfCjvqs2DTn8jo5YjnhQm8/E3+OjmVhpqY+bp9A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	DaeMyung Kang <charsyam@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 6.18 0647/1005] ksmbd: preserve unreadable named streams on open
Date: Wed,  4 Nov 2026 16:06:20 -0500
Message-ID: <20261104211101.858746804@linuxfoundation.org>
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
@@ -2543,6 +2543,8 @@ static noinline int smb2_set_stream_name
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


