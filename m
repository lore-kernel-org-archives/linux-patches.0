Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29C4B15B561;
	Tue, 18 Jun 2024 12:45:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718714711; cv=none; b=MTHL9ctcImEwMoPeMDDzdriP75DgqKuxiymNJP/4c/KkI1eIbWvFGrAcpFtCY3Qt+RLfvADkZGuLYwH/AgWGg2cYNzKIaJ/BbRg3oS6g+qUYc3cWoNj1J3TV2YspPKGW5se2BC21g8N+9iR101bKfdQ8N5E07MiUopjs1AtLdGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718714711; c=relaxed/simple;
	bh=y6WMxuP7LToTkH+1MrFH0cyXfCh+iM5qicyeKe4F76Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qWHW0QJNK5ISiEaCyK22CtevoJveU/Lfzo1leVyI9u8TWAgYEL+YvI6pnJ+pv0R8QUQi3rocA9y2/eGWphv1YEbG+MF0vZCU69KRWH3HusJqGsC+SH0Kov7ksbFQqAt48hcYCHjx9InLZzbjZujU/VNHc97nXlAOrXxGTJYFVDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rg6HbAHR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rg6HbAHR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A38A7C3277B;
	Tue, 18 Jun 2024 12:45:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718714711;
	bh=y6WMxuP7LToTkH+1MrFH0cyXfCh+iM5qicyeKe4F76Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rg6HbAHRpujPxeC/fiD886QvsQgfmg3vwQFiyxgdymZgatHHBCkD2Lmu/u6FAAEUt
	 pQoeatnVmXyRLhqSWhjIc4ufPWPVP/1TbpKpnwQB3fvv/XkpqVnv6KIFeBhxM1l25z
	 /BV7xcFCn8iJYlcLtAOHCNFdJUb3DWorVQT9DeKw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 062/770] NFSD: Replace READ* macros in nfsd4_decode_backchannel_ctl()
Date: Tue, 18 Jun 2024 14:28:35 +0200
Message-ID: <20240618123409.678506206@linuxfoundation.org>
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

[ Upstream commit 0f81d96098f8eb707afe2f8d5c3fe0f9316ef5ce ]

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4xdr.c | 18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index 6f3c86bee6211..efd1504cd02b6 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -788,17 +788,6 @@ nfsd4_decode_access(struct nfsd4_compoundargs *argp,
 	return nfs_ok;
 }
 
-static __be32 nfsd4_decode_backchannel_ctl(struct nfsd4_compoundargs *argp, struct nfsd4_backchannel_ctl *bc)
-{
-	DECODE_HEAD;
-
-	READ_BUF(4);
-	bc->bc_cb_program = be32_to_cpup(p++);
-	nfsd4_decode_cb_sec(argp, &bc->bc_cb_sec);
-
-	DECODE_TAIL;
-}
-
 static __be32 nfsd4_decode_bind_conn_to_session(struct nfsd4_compoundargs *argp, struct nfsd4_bind_conn_to_session *bcts)
 {
 	DECODE_HEAD;
@@ -1483,6 +1472,13 @@ nfsd4_decode_release_lockowner(struct nfsd4_compoundargs *argp, struct nfsd4_rel
 	return nfs_ok;
 }
 
+static __be32 nfsd4_decode_backchannel_ctl(struct nfsd4_compoundargs *argp, struct nfsd4_backchannel_ctl *bc)
+{
+	if (xdr_stream_decode_u32(argp->xdr, &bc->bc_cb_program) < 0)
+		return nfserr_bad_xdr;
+	return nfsd4_decode_cb_sec(argp, &bc->bc_cb_sec);
+}
+
 static __be32
 nfsd4_decode_exchange_id(struct nfsd4_compoundargs *argp,
 			 struct nfsd4_exchange_id *exid)
-- 
2.43.0



