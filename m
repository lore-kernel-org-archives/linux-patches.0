Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8C516CDA9;
	Mon,  8 Apr 2024 13:32:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583139; cv=none; b=VTJWkuaemBtjVK/n/iKaqV9xETmGsnEm1d1EHN09+Bfw+qAYu9tJFnp4jJUdnb7KK6G6II2KMLsVltAH7HsGfvpe+xeTgSE3gnQseyIMV1gBdY5e7kG9nMvGL8DiJjHd0rOhsdXCPZ0fRDEiJ7B/NcMmiKb49ZzcG/LQu/vSXmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583139; c=relaxed/simple;
	bh=GoQS4DrOYXVKJ5/VpivvpQZAgcO+3qSfur1J+Xb+vuA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MjfEnVQFRqIm5NLwxwLX5gsgGKDpQygt/C0Iiu6wZV3snVIvyiX34HwyhhuW6cKmwjdFLMwZoa4Te+76C78hrych07oU/B53FtmwzQdaeQXOIttH3xsd3uQzUOdOYUUaFPPpjjUC2/XlNCdlxnNLcLJVZNx+dOTj9MlAstBrBqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qfrWOICc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qfrWOICc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C32FFC433F1;
	Mon,  8 Apr 2024 13:32:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583139;
	bh=GoQS4DrOYXVKJ5/VpivvpQZAgcO+3qSfur1J+Xb+vuA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qfrWOICcOJkbCeOP12EMfVDQZidZRkk4fJ/1T62B9U78IM9CyaUxb6meMQqWFdW9Q
	 JG5hKpkxjR4DZ9LLbD6KyFtB2VZ6C9U6PxAGaE/C/XjaoheMoCTl/ycL3XwGGbB16y
	 k/I7/f2HEUCHUKn3B5wI6PBbv2Dludl1gWJ5/EGQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff layton <jlayton@kernel.org>,
	"J. Bruce Fields" <bfields@redhat.com>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 211/690] nfsd4: remove obselete comment
Date: Mon,  8 Apr 2024 14:51:17 +0200
Message-ID: <20240408125407.174794094@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: J. Bruce Fields <bfields@redhat.com>

[ Upstream commit 80479eb862102f9513e93fcf726c78cc0be2e3b2 ]

Mandatory locking has been removed.  And the rest of this comment is
redundant with the code.

Reported-by: Jeff layton <jlayton@kernel.org>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/vfs.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index 59e30cff920ca..925aa08ca1075 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -744,9 +744,6 @@ __nfsd_open(struct svc_rqst *rqstp, struct svc_fh *fhp, umode_t type,
 	path.dentry = fhp->fh_dentry;
 	inode = d_inode(path.dentry);
 
-	/* Disallow write access to files with the append-only bit set
-	 * or any access when mandatory locking enabled
-	 */
 	err = nfserr_perm;
 	if (IS_APPEND(inode) && (may_flags & NFSD_MAY_WRITE))
 		goto out;
-- 
2.43.0



