Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210513;
	b=LOshmjvAkjIYo6V/fxCKRJDJnv/fc9iQ0f/cIwLDmXWi7zyBdFqzggkPj2WersNOQaSa
	 x+PInDDthX7v5g7IZJJzNzZ1wojtRshmgTg1CR+6+T8NMnJMRAyPKeJT7eXyTGGK1R8k0
	 MBgD1hqxUAlwkt9/6m8syh4wbbnZ596iNosHB5leLcx1f0PXwKSPpjFEQe2kX7ZYM9Fgz
	 7GEHXKvRt0FcYrdNw6yLumwAXd+6/pB8W2nMjw243rg1JzVKTzBv+M8ykLn6GR/wP8aTE
	 FuKdhwhBqJTksQGAFudMwl8a6qARnhJnCNHcVgD5zLrTwbwQUYr2iXN0A71ZmhJfvqw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210513;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fOlNnvL/77PITpZ5N6Co0cHPvjrwurIklv2QQIfUzck=;
	b=hZf5H09uElYtNpWIZWWdOnGPHD9Putp0Xmkj6ZKqdAbCUJ2GehAjEHn1vR7CZmchip32
	 wHqkbn96xec5uOt+/LBv3sUVqvJSSjmHQ16hcCazINn/fKZ6NQxbnJPVWxkaBJpgm1C9H
	 Cn81JZCnF7Wm6ZAkKFowAB60CVSpmqvOMd6kENUajfj96nMkpcgquKr9dqNqp0Wfteu6s
	 BYopJhz2JtuU3HaKFgI6guPXxWwiBYobXJmxaJ3CsY8ovVG/VFqWG5H69+tAII/7JVYB9
	 dbE4MYnD9SynqR9mjuHkJhs+C0AXS8jiRxEOX35mdFulQ5HTRdUoAU+X+SAv/pNIMFw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Y/D6YA2n";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8322606A31A;
	Wed, 28 Oct 2026 18:01:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Y/D6YA2n
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B434C1F01825;
	Wed, 28 Oct 2026 18:01:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210512;
	bh=fOlNnvL/77PITpZ5N6Co0cHPvjrwurIklv2QQIfUzck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y/D6YA2nf7CREjDM/Bgx9TyiSCk01utCmASYKd4NkhOnxsObfeDNw64zje85kp/Xx
	 XeKQLmVfOg/mtqKKYMmDZDmrLvLUKUFSj/ZYMjvykc2nc++b79vx6Qn5xu52zSbN6J
	 UT0VPdciAh83Ri+UT9DyCkLMtBaL6it4dTni+UP4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 052/571] nfsd: check nfsd4_acl_to_attr() return value in nfsd4_create()
Date: Wed, 28 Oct 2026 17:53:19 +0100
Message-ID: <20261028170009.262603714@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit 2c7912732184773dbd371a411da87af1cc080b86 ]

nfsd4_create() stores the return value of nfsd4_acl_to_attr() in
status, but the switch(create->cr_type) block unconditionally
overwrites it in every branch. ACL translation errors are silently
discarded, and the CREATE proceeds without the requested ACL.

Add an early exit check after nfsd4_acl_to_attr(), matching the
pattern already used in nfsd4_setattr().

Fixes: c0cbe70742f4 ("NFSD: add posix ACLs to struct nfsd_attrs")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Jeff Layton <jlayton@kernel.org>
[ cel: prefer NFS4ERR_BADTYPE over NFS4ERR_ATTRNOTSUPP ]
Link: https://patch.msgid.link/20260611-nfsd-testing-v2-5-5b90e276f2d9@kernel.org
Signed-off-by: Chuck Lever <cel@kernel.org>
[ retained unconditional ACL conversion because the older helper already handles null ACLs ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4proc.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index ecf10e6fdab36..4aa9c5e09bebb 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -762,7 +762,23 @@ nfsd4_create(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 	if (status)
 		return status;
 
+	/* Sanitize cr_type to avoid returning ATTRNOTSUPP. */
+	switch (create->cr_type) {
+	case NF4LNK:
+	case NF4BLK:
+	case NF4CHR:
+	case NF4SOCK:
+	case NF4FIFO:
+	case NF4DIR:
+		break;
+	default:
+		status = nfserr_badtype;
+		goto out_aftermask;
+	}
+
 	status = nfsd4_acl_to_attr(create->cr_type, create->cr_acl, &attrs);
+	if (status != nfs_ok)
+		goto out_aftermask;
 	current->fs->umask = create->cr_umask;
 	switch (create->cr_type) {
 	case NF4LNK:
@@ -829,6 +845,7 @@ nfsd4_create(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 	fh_put(&resfh);
 out_umask:
 	current->fs->umask = 0;
+out_aftermask:
 	nfsd_attrs_free(&attrs);
 	return status;
 }
-- 
2.53.0



