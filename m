Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B2761581E9;
	Tue, 18 Jun 2024 13:06:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715968; cv=none; b=VLSBWyPUp9rV6SPjjy+bqSn+w6TebrbDyS1xAMAzevYZlvZ9Zj6R6HHfRrfVmR7RuNicDPZfmwbiIxPx5rBUWtJaSm80vx1dLYZthlo0v77hBZleXnaFNCyDEg/ActcEg9DfZ9+Io80vSuQ62/ZsX/ktKvxY+P2ky5M+VZdOxN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715968; c=relaxed/simple;
	bh=Cna+XtontIopK0HERRUwCKHIJdixjAQNaDIq0mANfpk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gOIpA6kqn7I6ZCcxKDbAwXTjUYzd9b1ap1jfGXjyFmIQFVF3+VYepCFI04LIXjUorVVI2qpcTS/OW/KE9Ca6adK7QhQiPVGIG0/6tACHdFdIh3NPDxgGBrwbdhZBdbF+YH1ZZo7OQClqHJUvrWjy67k0VsGzpzwLC1hCOjC5JuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lR63nOhL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lR63nOhL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90182C3277B;
	Tue, 18 Jun 2024 13:06:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715968;
	bh=Cna+XtontIopK0HERRUwCKHIJdixjAQNaDIq0mANfpk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lR63nOhLvEw7ghGeZCvLYjr/Dd6u7jNomvk+KbxTXpeBQ4UKKomMpXI8jJjB9uiAw
	 WDQkQ4xLkOC8p69LNo56x202ELrnWrWgMdLVg3ad1xQOXRWMp0eTK01kCsh8ga6dkw
	 A01c0ygpsSwHnKzStq09LbD9pkJ/oOxfVVFhC9yI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haowen Bai <baihaowen@meizu.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 488/770] SUNRPC: Return true/false (not 1/0) from bool functions
Date: Tue, 18 Jun 2024 14:35:41 +0200
Message-ID: <20240618123426.153668743@linuxfoundation.org>
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

From: Haowen Bai <baihaowen@meizu.com>

[ Upstream commit 5f7b839d47dbc74cf4a07beeab5191f93678673e ]

Return boolean values ("true" or "false") instead of 1 or 0 from bool
functions.  This fixes the following warnings from coccicheck:

./fs/nfsd/nfs2acl.c:289:9-10: WARNING: return of 0/1 in function
'nfsaclsvc_encode_accessres' with return type bool
./fs/nfsd/nfs2acl.c:252:9-10: WARNING: return of 0/1 in function
'nfsaclsvc_encode_getaclres' with return type bool

Signed-off-by: Haowen Bai <baihaowen@meizu.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs2acl.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/fs/nfsd/nfs2acl.c b/fs/nfsd/nfs2acl.c
index 96733dff354d3..03703b22c81ef 100644
--- a/fs/nfsd/nfs2acl.c
+++ b/fs/nfsd/nfs2acl.c
@@ -247,34 +247,34 @@ nfsaclsvc_encode_getaclres(struct svc_rqst *rqstp, struct xdr_stream *xdr)
 	int w;
 
 	if (!svcxdr_encode_stat(xdr, resp->status))
-		return 0;
+		return false;
 
 	if (dentry == NULL || d_really_is_negative(dentry))
-		return 1;
+		return true;
 	inode = d_inode(dentry);
 
 	if (!svcxdr_encode_fattr(rqstp, xdr, &resp->fh, &resp->stat))
-		return 0;
+		return false;
 	if (xdr_stream_encode_u32(xdr, resp->mask) < 0)
-		return 0;
+		return false;
 
 	rqstp->rq_res.page_len = w = nfsacl_size(
 		(resp->mask & NFS_ACL)   ? resp->acl_access  : NULL,
 		(resp->mask & NFS_DFACL) ? resp->acl_default : NULL);
 	while (w > 0) {
 		if (!*(rqstp->rq_next_page++))
-			return 1;
+			return true;
 		w -= PAGE_SIZE;
 	}
 
 	if (!nfs_stream_encode_acl(xdr, inode, resp->acl_access,
 				   resp->mask & NFS_ACL, 0))
-		return 0;
+		return false;
 	if (!nfs_stream_encode_acl(xdr, inode, resp->acl_default,
 				   resp->mask & NFS_DFACL, NFS_ACL_DEFAULT))
-		return 0;
+		return false;
 
-	return 1;
+	return true;
 }
 
 /* ACCESS */
@@ -284,17 +284,17 @@ nfsaclsvc_encode_accessres(struct svc_rqst *rqstp, struct xdr_stream *xdr)
 	struct nfsd3_accessres *resp = rqstp->rq_resp;
 
 	if (!svcxdr_encode_stat(xdr, resp->status))
-		return 0;
+		return false;
 	switch (resp->status) {
 	case nfs_ok:
 		if (!svcxdr_encode_fattr(rqstp, xdr, &resp->fh, &resp->stat))
-			return 0;
+			return false;
 		if (xdr_stream_encode_u32(xdr, resp->access) < 0)
-			return 0;
+			return false;
 		break;
 	}
 
-	return 1;
+	return true;
 }
 
 /*
-- 
2.43.0



