Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E452E18C324;
	Tue, 10 Sep 2024 10:42:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964937; cv=none; b=ux9UVMKhIHbWSHfJ+fCfSjaVIQXd/wzV6C8dJ+Y/4msRlt0g//Sa+aXuYfBGY+7r43zedsyGhiS+4Q+gQ9+ZDxxAmPy6aDHDXFGrxSydD9trbdh4P2zcbWzMQWEZHwHKJPlu5hxuLF3iH7WoV0Uzm3ivAol2luxWakkhnNeCsfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964937; c=relaxed/simple;
	bh=wsH4mMwghhoRsofZ0cMHrDquCvPj2jT8kyiSbPyLs/k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CSTLWs6nD6MPoyOleZsjjJ5AUFxqZSh/jP29c9BYh33EbjGvarcny96ZNsYytNfAf9MzNngdORchknGdbpWxDdpH1BDW/FZMBkotiXMaKN3RNMXBEmDzvis7wn261NJ38C1REiawzidd1E6uZHdG5mc/3OsvaN1PhT715mB9KWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l6ng0g8F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l6ng0g8F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68788C4CEC3;
	Tue, 10 Sep 2024 10:42:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964936;
	bh=wsH4mMwghhoRsofZ0cMHrDquCvPj2jT8kyiSbPyLs/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l6ng0g8FUvp0apQVo3fsc5hhTRd2Lk4kEmCjPydvLN7z5o1w0slGet4d+zh3uxd3x
	 kvMZCPwx6CEasySiGtHmeJfEM5722s0T73Ld1MQJfFGLk8kgTHigJAw4FxysperBIP
	 Vr9Bf3ooIt6fyzsYVJPZR7TPWOKXoCMiRckng1nM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.10 081/186] NFSD: Rename nfsd_reply_cache_alloc()
Date: Tue, 10 Sep 2024 11:32:56 +0200
Message-ID: <20240910092557.842472898@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092554.645718780@linuxfoundation.org>
References: <20240910092554.645718780@linuxfoundation.org>
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
 


