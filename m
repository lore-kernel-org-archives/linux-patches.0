Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 440B8158A35;
	Tue, 18 Jun 2024 13:10:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716234; cv=none; b=EjRGyYme8WeyVNiZTyA0RUo/FRw7EhrHTpXK6n5wjIpovAv3LGo3Lez7Jytrvk+0lgNTiy4EMEoEMX5TSfghLwdo/NaUKQrP63B1E9ZwxwdFATlSPNhNILjd/2QlfV+PHcN/Go8Yf0D/cgFGPxEeO0TTYoAZe9vKi9IyO05+1BQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716234; c=relaxed/simple;
	bh=Qdl5qnnzQs0lDJ1/j8zpXhgscIgHoyCxTWfk9xaNCgI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mh8JIg8tf+PwCBU3rGkE9j1T54mpKYsyBk+elNATHy8eAMJI82U4BDxPwRmlanAWFOhiRK5yE5QfTG4NTfytccXegWapNW1iHXQARMoKtTUVbKq90d0CAKdZqrItePYiWEKkfMmezstxz95g2XF9rzbZj+8Dbz9M/aaH/YuzBE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yOtzcHUt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yOtzcHUt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63293C3277B;
	Tue, 18 Jun 2024 13:10:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716233;
	bh=Qdl5qnnzQs0lDJ1/j8zpXhgscIgHoyCxTWfk9xaNCgI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yOtzcHUtyvRVSKJsQMtYJB8HLqNhutN0Ve0SVOXRi33Lc2JpOS0M+4Tb4odUJ+3In
	 r4/hQ27vHqfQtdjuZV6rKinkrHakAAviXwdHV0F+TXZGpdL3a9t/hBjQtx9v674cht
	 h93v9uxUbV4h6WuIhnz9k2nv8HrOTBEMm8LC19eY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 576/770] NFSD: Remove nfsd_file::nf_hashval
Date: Tue, 18 Jun 2024 14:37:09 +0200
Message-ID: <20240618123429.528355626@linuxfoundation.org>
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

[ Upstream commit f0743c2b25c65debd4f599a7c861428cd9de5906 ]

The value in this field can always be computed from nf_inode, thus
it is no longer used.

Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/filecache.c | 6 ++----
 fs/nfsd/filecache.h | 1 -
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index dd59deec8b011..29b1f57692a60 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -167,8 +167,7 @@ nfsd_file_mark_find_or_create(struct nfsd_file *nf)
 }
 
 static struct nfsd_file *
-nfsd_file_alloc(struct inode *inode, unsigned int may, unsigned int hashval,
-		struct net *net)
+nfsd_file_alloc(struct inode *inode, unsigned int may, struct net *net)
 {
 	struct nfsd_file *nf;
 
@@ -182,7 +181,6 @@ nfsd_file_alloc(struct inode *inode, unsigned int may, unsigned int hashval,
 		nf->nf_net = net;
 		nf->nf_flags = 0;
 		nf->nf_inode = inode;
-		nf->nf_hashval = hashval;
 		refcount_set(&nf->nf_ref, 1);
 		nf->nf_may = may & NFSD_FILE_MAY_MASK;
 		nf->nf_mark = NULL;
@@ -1005,7 +1003,7 @@ nfsd_do_file_acquire(struct svc_rqst *rqstp, struct svc_fh *fhp,
 	if (nf)
 		goto wait_for_construction;
 
-	new = nfsd_file_alloc(inode, may_flags, hashval, net);
+	new = nfsd_file_alloc(inode, may_flags, net);
 	if (!new) {
 		status = nfserr_jukebox;
 		goto out_status;
diff --git a/fs/nfsd/filecache.h b/fs/nfsd/filecache.h
index c6ad5fe47f12f..82051e1b8420d 100644
--- a/fs/nfsd/filecache.h
+++ b/fs/nfsd/filecache.h
@@ -40,7 +40,6 @@ struct nfsd_file {
 #define NFSD_FILE_REFERENCED	(2)
 	unsigned long		nf_flags;
 	struct inode		*nf_inode;
-	unsigned int		nf_hashval;
 	refcount_t		nf_ref;
 	unsigned char		nf_may;
 	struct nfsd_file_mark	*nf_mark;
-- 
2.43.0



