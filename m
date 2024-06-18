Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A5F31B47A8;
	Tue, 18 Jun 2024 12:42:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718714569; cv=none; b=DyjpqnRZx97uq4AY/hNW6AAEsjLS26LNr/UCxwYicVT8jBbMkQIW8Nur8wm495b0XoJtRbztxDXXsOsqjO6arES8pYKRwamhAu7fySCmOoumF1rLJ0w8YHiG1JRTLAph9p80l88MTWNY8VE11+zWl9WAlqo9ZnGMmsbqdh4l7ws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718714569; c=relaxed/simple;
	bh=NXv5uQ3o/zrMraBVh6y+f+9+Y7cqTYHoQh+RYDfrZ/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Eset2egs+BjB6H0XjeQex54jmyl1RL3h6Uaei3mgYcbNUH+/FF4WfEAIsboXhK4EVZEqRiIJtplobMqSe/vX+wee0Xe7XE75FXrCGachVxUm3adKgaKkwAgcxg3AMbZVyuKko+LX4KScA0fHIiYfwS/2+jNZ/kZjSbcnx3bfOEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dkKLhThy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dkKLhThy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47CE1C4AF49;
	Tue, 18 Jun 2024 12:42:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718714568;
	bh=NXv5uQ3o/zrMraBVh6y+f+9+Y7cqTYHoQh+RYDfrZ/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dkKLhThyC/j+jQ5998GkZrPEegrdGy+pkzhvZgIpr+Jdhl6bI5QfSGu6eP1iuabCJ
	 /IzWQleHf0/ZRFDZE4aLNabnuW42weNwgFacC3IZS/orJRovgl4tPJqwP4EA6BmZ2b
	 ljUiiAMFIlay3Rc/Uy3ErHbvbPtvsodM37bZx9ms=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 015/770] NFSD: Replace READ* macros in nfsd4_decode_access()
Date: Tue, 18 Jun 2024 14:27:48 +0200
Message-ID: <20240618123407.883721217@linuxfoundation.org>
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

[ Upstream commit d169a6a9e5fd7f9e4b74e5e5d2e5a4fd0f84ef05 ]

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4xdr.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index 8c694844f0efb..f3d54af9de92a 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -439,17 +439,6 @@ nfsd4_decode_stateid(struct nfsd4_compoundargs *argp, stateid_t *sid)
 	DECODE_TAIL;
 }
 
-static __be32
-nfsd4_decode_access(struct nfsd4_compoundargs *argp, struct nfsd4_access *access)
-{
-	DECODE_HEAD;
-
-	READ_BUF(4);
-	access->ac_req_access = be32_to_cpup(p++);
-
-	DECODE_TAIL;
-}
-
 static __be32 nfsd4_decode_cb_sec(struct nfsd4_compoundargs *argp, struct nfsd4_cb_sec *cbs)
 {
 	DECODE_HEAD;
@@ -531,6 +520,19 @@ static __be32 nfsd4_decode_cb_sec(struct nfsd4_compoundargs *argp, struct nfsd4_
 	DECODE_TAIL;
 }
 
+/*
+ * NFSv4 operation argument decoders
+ */
+
+static __be32
+nfsd4_decode_access(struct nfsd4_compoundargs *argp,
+		    struct nfsd4_access *access)
+{
+	if (xdr_stream_decode_u32(argp->xdr, &access->ac_req_access) < 0)
+		return nfserr_bad_xdr;
+	return nfs_ok;
+}
+
 static __be32 nfsd4_decode_backchannel_ctl(struct nfsd4_compoundargs *argp, struct nfsd4_backchannel_ctl *bc)
 {
 	DECODE_HEAD;
-- 
2.43.0



