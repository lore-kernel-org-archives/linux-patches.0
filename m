Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022539;
	b=z8kmToxWIWM11kg4+QN+FFv0Fuh+ArbZD3lPgf+FbembsqR1Ve7wND9DYxQ7mXTzxxO0
	 rFaGIphcDxr6mwo5JjNuUsCc9SqPVgjTSYDuv/IexZb0nCWwmHQUc5gS0HTeeagJZjuFA
	 8URew565KGt9PUpgYqWN1Q0euG1Njxjj7IrYmCAn4au7lthKQnCC92FfsCJupgZyGYE/m
	 Rf/86Nsh5fHrkaxzJibXrQAHf2O4nQiDyryO+vqYh12tNN3c2bVXurz+SpOahlBuWYxPa
	 DsyNoHxnhPMwfucUygEPmarl94YijctsKvF9nB9Zh4LNj977p0Rb429uKnXBwgoG/fw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022539;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IWl16gxjR8FJVOf1KXn7BxVOeuoU3Wh3/b+xM305cgA=;
	b=sWHREepzEmpd74LQMpwlzuKV3f97TXLv3feodNhKnKhw7rSIUDmMlh/JtetsdXbLQnCX
	 UrMfr2608uKqVsBK8YXX5POF9TkdEdkeizieMF5nnq+/Y2xP3OUXfdXe+W3k64rsSv+8b
	 4hhK8KeVTEVkwXrqsfVITFSZ7SnMIFtbBPE0JVWj5L5kPYb9KdfgJV/zSDT3apSWyOJc4
	 SMwnQX5BjdP+UbOdIw+rRPjhri6YSrzoLAuH9G50vPZtLplRQKCbpaU9JJjsVhivhLh6r
	 F9b9By/hvIlmbfGYw6a3kTQHJE1NR+R8/8DCxUAeY8rHnLUtGju90pQchNNyBGYKE9w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1Tw3eLhX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8065B606A333;
	Wed, 18 Nov 2026 17:22:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1Tw3eLhX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5EF31F000C7;
	Wed, 18 Nov 2026 17:22:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022539;
	bh=IWl16gxjR8FJVOf1KXn7BxVOeuoU3Wh3/b+xM305cgA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1Tw3eLhXXrXc54BQ0V3vf+bFbMCV3CgoV1PA8GYVC395GGKjXzX/wSP8v+ax6Eo45
	 W+ssUaki0bbe8cZwrRGxEg32/EWr6rNwibuItk8Is6Qh8EG2BHpMZwHxdC400kJBke
	 VRBN1fq5wiBQd4JlrwLCVgNB/m6I42AtI/mW+fM4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Bridges <icb@fastmail.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0008/2151] ksmbd: enforce the read-only share flag when creating a stream
Date: Wed, 18 Nov 2026 15:29:03 +0100
Message-ID: <20261118150121.942806929@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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
[ sashal: Omitted the AFP_AfpInfo creation guard because automatic creation on Time Machine shares is absent. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 6ad50aab3dfcb..55d4727facc51 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -2567,6 +2567,9 @@ static noinline int smb2_set_stream_name_xattr(const struct path *path,
 		return -EBADF;
 	}
 
+	if (!test_tree_conn_flag(fp->tcon, KSMBD_TREE_CONN_FLAG_WRITABLE))
+		return -EACCES;
+
 	rc = ksmbd_vfs_setxattr(idmap, path, xattr_stream_name, NULL, 0, 0, false);
 	if (rc < 0)
 		pr_err("Failed to store XATTR stream name :%d\n", rc);
-- 
2.53.0



