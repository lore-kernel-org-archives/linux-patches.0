Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028507;
	b=f7dJH/for73XlCRkzQz835MU96B9xxan0JVSF2fjxy835md1gaq+Hmp8rQ0zcqm46zPx
	 DzNq8J4ZmEF7e+2OF9ZoIAaWawf9HVgbSbEX7+wxrY8ubWOLDHmudqkMHdd/wbe20E9wX
	 cEoMnEeFGU6J2EP4Mh9rkwQwEE9GG77F/ytGCMrYeEWN6a60dJoiNGfrtzkidTjJnfXnQ
	 eXKRoE+lDwlJkm94Ps79RsJT8PFuxAOZ7A0YduK7gZz0NuHVEDuleTWXS3QZtkf/ZR+KY
	 fu3wCmrVscJffmm+pa+8Qby4vD8wuK+eHLg7cm7/4nbuOl4HsLVedaEMvI3GSzQrtCw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028507;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6WbXt+rYowWrjLfFq7Zc+UM9yIGB8D1+SFJanl6WnXI=;
	b=N3Z4TbyAnZgJEFfVRRAI/Innc+MakdIgIynUaavAD0f2RsAlRfyzN9YSVNsGC3k3GFXL
	 WVVFo2UNlu0kfxgvYegi7BoQ3z4jk1Inp2nNt7C/t6OpIBu2ULQkCqSj/9LJpkkIQZ+Aq
	 zj6f9WLUod2LJsCBe9xKrfBvr9YSL/P/CkXi0fhwevtDbi2BhqpRn3X/XtT25yhKW1Qif
	 KtWLKtrgI4MPaxardSFuzEHNgKONYVPsKDas7gkM6ZLrEVHnbO1P3Or2IOzpx51+6IGpG
	 90yjy/LMePap6tHgLbwuDBEySecDHq9zRVgbo0O8C8rWckd8USQcafvuITYLK6HNFUw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pdVwRqta;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9400A606A330;
	Wed, 18 Nov 2026 19:01:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pdVwRqta
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC4811F000C4;
	Wed, 18 Nov 2026 19:01:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028507;
	bh=6WbXt+rYowWrjLfFq7Zc+UM9yIGB8D1+SFJanl6WnXI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pdVwRqta7n4kP/tzSzEa6DPUTy5R0UMLlnBtBhy7Bcqva/V7fXrMQSWSJHEGnbYPu
	 fCJg8/kOt3MlEU21xzkHuGgXwluAau1elWGLV9vPBudSg4A6iqk620mkqdc79EqMmS
	 bA3sQjQ/3AqVUs6MrbRmQ3k3rvdfvfwqUDp5wx6U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Bridges <icb@fastmail.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0007/1756] ksmbd: enforce the read-only share flag when creating a stream
Date: Wed, 18 Nov 2026 15:35:34 +0100
Message-ID: <20261118150008.265591156@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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
[ sashal: omitted the writable-tree check in the AFP_AfpInfo stream synthesis branch ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 1af013ae66f94..2577fbce80c4f 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -2574,6 +2574,9 @@ static noinline int smb2_set_stream_name_xattr(const struct path *path,
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



