Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216365;
	b=nzLDgF3RRVBRihEeUI6n5wMj6yuWDpvngoJSFDZwKILtQ+UiQo+LrQExuQuBhkCxL05/
	 VdexgRodkyj10eQGc36DamgEmqqhhy4G+akp+GBxKMMKPQgsfO4MEiW2LwyWnvnqD8qUe
	 ninEBj/ZemEba1cUQQ6l2BvxxucO4XGDOfN+VIVPe5GZEQs/kTerIch5UDC2hYN+0c87R
	 NyyEjLy8rBtdAS/lR5e0Uy5a5UR6X/l6FwMYBj5Scp20M574jw05oIIK9bEw2zuV9N1ah
	 rZ5JRsBCvckVf8o27gLD1Zd9GXNGdtEyqcjKRUMrmlLMEkvvtW0LSc+T9+gRSYtH7yQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216365;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nqw5lS7SB786aP29O0mkLDRA0sEOrHLRYAhx+HRNGXA=;
	b=ywb1QJ1iuQy/sdRQIY7dqz9eUWIfDsVTf/bpPCC26BOAlj2i51s61TL7ywIAEbauxzxx
	 Rcb3qIQNz2tVBz3zTVm2M2kJsAOjO9fTRYAoLVv+jt4RrYAsG0rsKtjJaqvaASVJlYGCG
	 HNm03EJn2rNnMzv9iUfRNQZ8ga/r2UgTGmgaoFDUJSgqIwjCDnymwhj6eja2h6OYFEa2q
	 iSp1V66tSvrtvOMsH/x7C2ZVYxclC1wB2w+rrz64HBfieAPlD0Z4NDz8VJ+s/O/Nn5fD+
	 TuYCCv2VpWMlBLwSjo8iyCvyphC+2JF0E4Yuu4upGMAWj4Ji5f7wsqWDlXYMbVnwFaA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=V0Z3d2Yn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE64D606A31A;
	Wed, 28 Oct 2026 19:39:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=V0Z3d2Yn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 246FB1F01825;
	Wed, 28 Oct 2026 19:39:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216364;
	bh=nqw5lS7SB786aP29O0mkLDRA0sEOrHLRYAhx+HRNGXA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V0Z3d2YnH7lLVVe+tv/IMbK3eyqmm0dEdU024h5zKaUxv220B37IlpUe96RuXDpun
	 jN5/bcxigYpenUQManyFMqiseh8SufLqiylwCwMItIYvCsVpafsE6jFPiQ5lGxLh/f
	 1Hm7wa8NedLHB1nWvIcv4VhhvSdrdhYth4zFvRDk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhansong Gao <zhsgao@hotmail.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1532/1887] NFSv4: Fix incorrect argument passed to nfs4_delete_lease() in nfs4_add_lease()
Date: Wed, 28 Oct 2026 18:00:28 +0100
Message-ID: <20261028170534.326919832@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Zhansong Gao <zhsgao@hotmail.com>

[ Upstream commit 468e458ffde907ba19acd2102ca1fbb8f6fbede2 ]

When nfs4_add_lease() races with a delegation return, it calls
nfs4_delete_lease() to clean up. Previously, it passed priv,
which can legitimately be NULL. Passing a NULL priv eventually
leads to a NULL pointer dereference in generic_setlease().

Fixes: e93a5e9306a5 ("NFSv4: Add support for application leases underpinned by a delegation")
Signed-off-by: Zhansong Gao <zhsgao@hotmail.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs4proc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index bde81060f833e..321c6e86b0b0a 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -7640,6 +7640,7 @@ static int nfs4_add_lease(struct file *file, long arg, struct file_lock **lease,
 {
 	struct inode *inode = file_inode(file);
 	fmode_t type = arg == F_RDLCK ? FMODE_READ : FMODE_WRITE;
+	fl_owner_t owner = (*lease)->fl_owner;
 	int ret;
 
 	/* No delegation, no lease */
@@ -7649,7 +7650,8 @@ static int nfs4_add_lease(struct file *file, long arg, struct file_lock **lease,
 	if (ret || nfs4_have_delegation(inode, type))
 		return ret;
 	/* We raced with a delegation return */
-	nfs4_delete_lease(file, priv);
+	dprintk("%s: raced with a delegation return\n", __func__);
+	nfs4_delete_lease(file, &owner);
 	return -EAGAIN;
 }
 
-- 
2.53.0



