Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047380;
	b=dx6HcDSbwJdDElr/CM3D6fuTTeQOEXm3pzVLkvdUPqshUfsrQDvF1HZoUZlHtK9ifV5d
	 YiVYk2D9hbA2B8hm6h4nEKIpyv9MKZ0ksdU6V74r+K/zbg0uMeNILWL/BBB2EQiNxVdb2
	 l1l12zLc4CC1zquCunmf6OUfOO+Rb0PQiCTPEwJfZmVqjl8r1KzmZvFRW7IHf3H6d33Yk
	 rwN3wNJgBwDXuf4LcEtoaehCUnNTmMjlVtu0/8PiM+vkOX3nnTzjwO1EA4vKTNOAlXd4Q
	 8M16UCl1wZsAU+Gnu2goLaaeoL8tyg8EwQlhFNiDSwcDm038qCJMFtUBfELu3I4yMjA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047380;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1Za8RQeYbZO1CSXH/acFF5nowDRH//in76A+D0dmNo4=;
	b=XZ/O4zvkrXZvpTIRZOEmdaRfBEkILnvb8SR34obs0Rklb7PwlHG5JS/I7QiNVH0SDFST
	 jX9lHeNTDI3IEVxSLPNIxVHDKg2RD+d9a9zJQIF41EugY6nF8u3m6Ztss2qtvwzu2jk7w
	 8Zoe/xEQw7rpRniRkKRDOyl1LbPBx4cgamqnNI0jUkSDkd2PwAytLLAF0UR/XK+CdWb1b
	 WZioplBgdU/MlGtHVtnoALhF78MBEjEgrJxqU2S3NpeUzijRCuzCco3cNgjUhqOVmcNpe
	 8rfapUTS5O+81/qXdHvS/8bMx2Ohb4uhH1/Ce3T7vjCtqb8P2UVnMZcqfR/aiWBBrRQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pJq0H9n9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62802606A31C;
	Thu, 19 Nov 2026 00:16:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pJq0H9n9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB2591F000C4;
	Thu, 19 Nov 2026 00:16:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047380;
	bh=1Za8RQeYbZO1CSXH/acFF5nowDRH//in76A+D0dmNo4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pJq0H9n9MZC7+Izl+Cv7o4FcLCb6vyuZtJC8DUpr5aj4SbQWJAi9dLquARfQMKGSi
	 KRo62VKqXSU0hmdVrHx7Q2xHdLnClXn6SgoJdQQnbhJ1Sh2GgQyAKQY8cBzFxhATuv
	 exCmbRjGgDf1W/O/a6s+DRuKoLzEMX2jItaoFps0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Bridges <icb@fastmail.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1618/2857] ksmbd: enforce the read-only share flag when creating a stream
Date: Wed, 18 Nov 2026 15:44:12 +0100
Message-ID: <20261118150259.607928907@linuxfoundation.org>
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

From: Ian Bridges <icb@fastmail.org>

[ Upstream commit 09139429fab3a5114c18d7c15fb161511d4d66c9 ]

When a share is read-only, smb2_open() rejects opens that would create
or truncate a file. Creating a named stream on an existing file with
streams_xattr sets neither O_CREAT nor O_TRUNC, so it passes this check,
and smb2_set_stream_name_xattr() then creates the stream. On a Time
Machine share, opening a missing AFP_AfpInfo stream also writes one. A
user who can write a file at the filesystem level can therefore add
streams to it through a read-only share.

Do not create a stream or synthesize AFP_AfpInfo when the share is not
writable. Existing streams still open normally, and a missing stream
opened with FILE_OPEN still returns STATUS_OBJECT_NAME_NOT_FOUND.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Fixes: eaff8e924f60 ("ksmbd: synthesize empty AFP_AfpInfo xattr on first probe")
Cc: stable@vger.kernel.org
Signed-off-by: Ian Bridges <icb@fastmail.org>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
[ sashal: Omitted the hunk for absent AFP_AfpInfo synthesis while retaining user_ns instead of idmap in the xattr call. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 069ecc1d90b52..dec5da960af52 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -2559,6 +2559,9 @@ static noinline int smb2_set_stream_name_xattr(const struct path *path,
 		return -EBADF;
 	}
 
+	if (!test_tree_conn_flag(fp->tcon, KSMBD_TREE_CONN_FLAG_WRITABLE))
+		return -EACCES;
+
 	rc = ksmbd_vfs_setxattr(user_ns, path, xattr_stream_name, NULL, 0, 0, false);
 	if (rc < 0)
 		pr_err("Failed to store XATTR stream name :%d\n", rc);
-- 
2.53.0



