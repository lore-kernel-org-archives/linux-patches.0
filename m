Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D95C01B142C;
	Thu, 15 Aug 2024 14:07:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730828; cv=none; b=b2nGecY3r5pkwemLDvjaCV3XC8joWVzqFtPoYc7vcCjcZCGb7sdLJmbDGdJNw56Ae/MCAmP6su+vPzAOCp7M1iYQ9UH2gfbLO4lFSukMR7P/rBLuGM0xc5NHsggy1/TCwHZurDeRsDvF3UB84kSj+wjmIEy0CFQj71JIXaqaTRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730828; c=relaxed/simple;
	bh=2Kj/WuridUQ1BmJ+TZHjVIYy2U7JsRwMmInHq16Ez88=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hg4l1BfEifYhQO2NJKP2dqfTrOX2XmzTHNld/Vd9MtNlxTrYlIdqR82AOIK4laxPVqnSlJjYlsUCYNp8xYdJX8Wd4jZqfaMTzqyOuYjOaNZFS0Ae7wTERqwde9spUVo/HF10dSf2zmfl/KaTMFIbrIWsA/+XSZOnwq73P4QGNUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VYLiw0Tz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VYLiw0Tz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BF27C32786;
	Thu, 15 Aug 2024 14:07:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730828;
	bh=2Kj/WuridUQ1BmJ+TZHjVIYy2U7JsRwMmInHq16Ez88=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VYLiw0TzlYbkPtUHWUlc4Nsv6kiQEuq2DJZfFkyFsDVtRT/5PckixPXnSvYp1jVXT
	 PrFnBSriOJsb7yTGYhIwHHS0664qcLF8yjFIO2IrL6MVaqmBvRqNCBwhFiph05iHI4
	 GUd4p/ehIhTQxeBcOtumYjvdLueNN2fRs9saJyQo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.1 13/38] NFSD: Rename nfsd_reply_cache_alloc()
Date: Thu, 15 Aug 2024 15:25:47 +0200
Message-ID: <20240815131833.463817769@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131832.944273699@linuxfoundation.org>
References: <20240815131832.944273699@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 
@@ -481,7 +481,7 @@ int nfsd_cache_lookup(struct svc_rqst *r
 	 * preallocate an entry.
 	 */
 	nn = net_generic(SVC_NET(rqstp), nfsd_net_id);
-	rp = nfsd_reply_cache_alloc(rqstp, csum, nn);
+	rp = nfsd_cacherep_alloc(rqstp, csum, nn);
 	if (!rp)
 		goto out;
 


