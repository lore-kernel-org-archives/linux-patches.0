Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F5761586C6;
	Tue, 18 Jun 2024 13:07:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716071; cv=none; b=E5idMQ1y133oTboOFUFXUhVQi6FcZNpUzfT0yhmELVIVA6v4DjbE9v2C+pIgvJ3UD5dDTTm5HI4esTmPJYGGHnRqQFotALLRztFPzXrji+2hAPY6QMcvEpXVme5Q1R6Vs6PGjw1jnjwXgpEl5NSXL8KRECg4fHDFFRAeNHsPF+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716071; c=relaxed/simple;
	bh=zDFWo7+QZIgeR3yLwwGFl0GjaT61xVAARlwm58+xEgk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oMeJYw33+U21xPJ2scwLNpkycq2Zwkj+HxzpirViX5EQYNiYBBnqWrdtYGtcZ3MKzxvD2UWC41PWSE8gK2JLrlRHt9w3mgAQYFZ1tontX4i1ZJT4Y3IcM4WF4pShfiuwfeUNS+tv4dusyW8be9WFhlVcfeX3ctDdnh2WgcCFIZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=smOjD+d8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="smOjD+d8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45005C3277B;
	Tue, 18 Jun 2024 13:07:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716070;
	bh=zDFWo7+QZIgeR3yLwwGFl0GjaT61xVAARlwm58+xEgk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=smOjD+d8SqZi+ZMSZ48ratSd99y5V7+sIL+anlOXSAt9cQc3qUxi83RKprh9Gm/Tq
	 SkJb/1On/xOBXP+GitJTnTP3eYcrUUMrYsfur/fFdl3sPukg/AEg4SkyNmxW/SXr1A
	 BTNpa+yLNrSw9ElXi7e+e0+fSHnhdc6A7ZdNlc38=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 523/770] NFSD: Clean up nfsd_open_verified()
Date: Tue, 18 Jun 2024 14:36:16 +0200
Message-ID: <20240618123427.500076429@linuxfoundation.org>
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

[ Upstream commit f4d84c52643ae1d63a8e73e2585464470e7944d1 ]

Its only caller always passes S_IFREG as the @type parameter. As an
additional clean-up, add a kerneldoc comment.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/filecache.c |  4 ++--
 fs/nfsd/vfs.c       | 15 ++++++++++++---
 fs/nfsd/vfs.h       |  2 +-
 3 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index 7e99e75b75d73..3c297ccfcc59d 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -996,8 +996,8 @@ nfsd_file_acquire(struct svc_rqst *rqstp, struct svc_fh *fhp,
 
 	nf->nf_mark = nfsd_file_mark_find_or_create(nf);
 	if (nf->nf_mark)
-		status = nfsd_open_verified(rqstp, fhp, S_IFREG,
-				may_flags, &nf->nf_file);
+		status = nfsd_open_verified(rqstp, fhp, may_flags,
+					    &nf->nf_file);
 	else
 		status = nfserr_jukebox;
 	/*
diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index 26ae28b6f9b02..5c8dc1a05e57e 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -852,14 +852,23 @@ nfsd_open(struct svc_rqst *rqstp, struct svc_fh *fhp, umode_t type,
 	return err;
 }
 
+/**
+ * nfsd_open_verified - Open a regular file for the filecache
+ * @rqstp: RPC request
+ * @fhp: NFS filehandle of the file to open
+ * @may_flags: internal permission flags
+ * @filp: OUT: open "struct file *"
+ *
+ * Returns an nfsstat value in network byte order.
+ */
 __be32
-nfsd_open_verified(struct svc_rqst *rqstp, struct svc_fh *fhp, umode_t type,
-		int may_flags, struct file **filp)
+nfsd_open_verified(struct svc_rqst *rqstp, struct svc_fh *fhp, int may_flags,
+		   struct file **filp)
 {
 	__be32 err;
 
 	validate_process_creds();
-	err = __nfsd_open(rqstp, fhp, type, may_flags, filp);
+	err = __nfsd_open(rqstp, fhp, S_IFREG, may_flags, filp);
 	validate_process_creds();
 	return err;
 }
diff --git a/fs/nfsd/vfs.h b/fs/nfsd/vfs.h
index f99794b033a55..26347d76f44a0 100644
--- a/fs/nfsd/vfs.h
+++ b/fs/nfsd/vfs.h
@@ -86,7 +86,7 @@ __be32		nfsd_setxattr(struct svc_rqst *rqstp, struct svc_fh *fhp,
 int 		nfsd_open_break_lease(struct inode *, int);
 __be32		nfsd_open(struct svc_rqst *, struct svc_fh *, umode_t,
 				int, struct file **);
-__be32		nfsd_open_verified(struct svc_rqst *, struct svc_fh *, umode_t,
+__be32		nfsd_open_verified(struct svc_rqst *, struct svc_fh *,
 				int, struct file **);
 __be32		nfsd_splice_read(struct svc_rqst *rqstp, struct svc_fh *fhp,
 				struct file *file, loff_t offset,
-- 
2.43.0



