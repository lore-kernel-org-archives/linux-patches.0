Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3C2313DDDF;
	Tue, 18 Jun 2024 12:46:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718714802; cv=none; b=QLnxnqf2j4aaJizcIA8ko5t8uzvXTVOYA4mt6uylvEdR8dcVKwWUzzLMYYIX0J8ChenQwRSl3Zkbnr2MycTH42HsPkoy3ptthRbQaJaIn9NMshJzTiMcbSwgIvW84vHedhLJZW7wtKy3O3G7/HRi1JTgg7QzXWBquvZEocPZ4vM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718714802; c=relaxed/simple;
	bh=rnUh1XV/m0ot6qkS3F5HFmGM+vTkVre8qp8kmvrCCCE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ym/ERcw2NOqDhQFFStO3+GLlvu/SuHrup4Lw1Pc5BcbJ6mPy7rsr93bkkyh63kM4K9pxsqh7/w2YQqOZYHz7+78+xqAyckVpEB0CvbPWui6hR9vvaZ3C+FWXpeA0rU5YBpT4cedahWCq+gnlhw5FwI7Bih/vMTDrDUgSBXnoA4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xZKVvTJw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xZKVvTJw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A9C3C3277B;
	Tue, 18 Jun 2024 12:46:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718714802;
	bh=rnUh1XV/m0ot6qkS3F5HFmGM+vTkVre8qp8kmvrCCCE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xZKVvTJwbvOb4/sC59tO9O4/AmUcEgt+If6Z630GPyMtcCG06vmKwRcgKLYhBR5RA
	 q9ouOqVtxze+lg/rzjHs5guOhOwm8YEyckCUItSnjki0bSSCPVnTHJ6dDmkSvLJpTj
	 hsX+pqOSvjsbSeAQH3VvX+2qQ759SldTOMKGQX+Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 093/770] NFSD: Remove macros that are no longer used
Date: Tue, 18 Jun 2024 14:29:06 +0200
Message-ID: <20240618123410.863793924@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 5cfc822f3e77b0477e6602d399116130317f537a ]

Now that all the NFSv4 decoder functions have been converted to
make direct calls to the xdr helpers, remove the unused C macros.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4xdr.c | 40 ----------------------------------------
 fs/nfsd/xdr4.h    |  9 ---------
 2 files changed, 49 deletions(-)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index 30604a3e70c0f..315be1c1ab85c 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -102,45 +102,6 @@ check_filename(char *str, int len)
 	return 0;
 }
 
-#define DECODE_HEAD				\
-	__be32 *p;				\
-	__be32 status
-#define DECODE_TAIL				\
-	status = 0;				\
-out:						\
-	return status;				\
-xdr_error:					\
-	dprintk("NFSD: xdr error (%s:%d)\n",	\
-			__FILE__, __LINE__);	\
-	status = nfserr_bad_xdr;		\
-	goto out
-
-#define READMEM(x,nbytes) do {			\
-	x = (char *)p;				\
-	p += XDR_QUADLEN(nbytes);		\
-} while (0)
-#define SAVEMEM(x,nbytes) do {			\
-	if (!(x = (p==argp->tmp || p == argp->tmpp) ? \
- 		savemem(argp, p, nbytes) :	\
- 		(char *)p)) {			\
-		dprintk("NFSD: xdr error (%s:%d)\n", \
-				__FILE__, __LINE__); \
-		goto xdr_error;			\
-		}				\
-	p += XDR_QUADLEN(nbytes);		\
-} while (0)
-#define COPYMEM(x,nbytes) do {			\
-	memcpy((x), p, nbytes);			\
-	p += XDR_QUADLEN(nbytes);		\
-} while (0)
-#define READ_BUF(nbytes)			\
-	do {					\
-		p = xdr_inline_decode(argp->xdr,\
-				      nbytes);	\
-		if (!p)				\
-			goto xdr_error;		\
-	} while (0)
-
 static int zero_clientid(clientid_t *clid)
 {
 	return (clid->cl_boot == 0) && (clid->cl_id == 0);
@@ -5478,7 +5439,6 @@ nfs4svc_decode_compoundargs(struct svc_rqst *rqstp, __be32 *p)
 	struct nfsd4_compoundargs *args = rqstp->rq_argp;
 
 	/* svcxdr_tmp_alloc */
-	args->tmpp = NULL;
 	args->to_free = NULL;
 
 	args->xdr = &rqstp->rq_arg_stream;
diff --git a/fs/nfsd/xdr4.h b/fs/nfsd/xdr4.h
index 2c31f3a7d7c74..e12fbe382e3f3 100644
--- a/fs/nfsd/xdr4.h
+++ b/fs/nfsd/xdr4.h
@@ -386,13 +386,6 @@ struct nfsd4_setclientid_confirm {
 	nfs4_verifier	sc_confirm;
 };
 
-struct nfsd4_saved_compoundargs {
-	__be32 *p;
-	__be32 *end;
-	int pagelen;
-	struct page **pagelist;
-};
-
 struct nfsd4_test_stateid_id {
 	__be32			ts_id_status;
 	stateid_t		ts_id_stateid;
@@ -696,8 +689,6 @@ struct svcxdr_tmpbuf {
 
 struct nfsd4_compoundargs {
 	/* scratch variables for XDR decode */
-	__be32				tmp[8];
-	__be32 *			tmpp;
 	struct xdr_stream		*xdr;
 	struct svcxdr_tmpbuf		*to_free;
 	struct svc_rqst			*rqstp;
-- 
2.43.0



