Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7EDA17C;
	Sun,  1 Sep 2024 17:02:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725210179; cv=none; b=YATjX7DROsSo6gdj7TRJExrvu3BF4PqNCHgE9IN0v7UYuvI14fxZKvf0bZQL0gLUZU+WAF7JOoW8qfG0lyKrwaxMtDTLfRIDNF8m1uO/pXvAZ1amwgF6K8wm2lettPnXD0g50rh9XXm5r1mqmPqcsq95iVbcyWj0xu7g1RhI4Y8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725210179; c=relaxed/simple;
	bh=uEN1T0P/M7/ZI9Mob5MgekN4KyQotvqzdXuXNZzxOoU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S+3sTEbe4UhQuFMmoLbJEKmaFUiswe8OVqZDmzPpi9ZKkhbWPCpsb0oklzh7tlApka2lbyHCi4XzCOrKLsoaCaX19+KbwJdbNv/cgckgH924O4hHwQuyLQCludyR8nBeLfSr/maX+B4+lC8QdP21lOixRfj3gGev88nIGvMBl1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lqPbN9dR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lqPbN9dR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBCA3C4CEC3;
	Sun,  1 Sep 2024 17:02:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725210179;
	bh=uEN1T0P/M7/ZI9Mob5MgekN4KyQotvqzdXuXNZzxOoU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lqPbN9dRPvrQuzq2Bi01Ct0asQAGz+WflvEYRl8FyJvou02jvFzQycLxAr9wQHGaj
	 kWzmjUMz7ASh/8JwhkMUgmpaWGaggF+0YUxbCQrsQiZZwuQ+C9Vy0VCCJ6Yg7yPLn5
	 1aHXj+xQeV/758cR3dWz47l/XL+CPs8UshXChDPc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 113/215] NFSD: Rename nfsd_reply_cache_alloc()
Date: Sun,  1 Sep 2024 18:17:05 +0200
Message-ID: <20240901160827.622193294@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160823.230213148@linuxfoundation.org>
References: <20240901160823.230213148@linuxfoundation.org>
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

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit ff0d169329768c1102b7b07eebe5a9839aa1c143 ]

For readability, rename to match the other helpers.

Reviewed-by: Jeff Layton <jlayton@kernel.org>
Stable-dep-of: 4b14885411f7 ("nfsd: make all of the nfsd stats per-network namespace")
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfscache.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/fs/nfsd/nfscache.c
+++ b/fs/nfsd/nfscache.c
@@ -85,8 +85,8 @@ nfsd_hashsize(unsigned int limit)
 }
 
 static struct svc_cacherep *
-nfsd_reply_cache_alloc(struct svc_rqst *rqstp, __wsum csum,
-			struct nfsd_net *nn)
+nfsd_cacherep_alloc(struct svc_rqst *rqstp, __wsum csum,
+		    struct nfsd_net *nn)
 {
 	struct svc_cacherep	*rp;
 
@@ -457,7 +457,7 @@ int nfsd_cache_lookup(struct svc_rqst *r
 	 * preallocate an entry.
 	 */
 	nn = net_generic(SVC_NET(rqstp), nfsd_net_id);
-	rp = nfsd_reply_cache_alloc(rqstp, csum, nn);
+	rp = nfsd_cacherep_alloc(rqstp, csum, nn);
 	if (!rp)
 		goto out;
 


