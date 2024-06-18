Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8459F14532B;
	Tue, 18 Jun 2024 12:47:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718714846; cv=none; b=LRDTcYwA2bJCQ8tII1wwOHOFDeKpPAnWDYHdM992UdJSSE5WMQq9IszJKTvmabv7I+HxXyUVNSqNL0seour5t8FUMb2MQmjlxV6MoaAA0QV2j3XSG6TGvKqNhNeOTg1NYOa5eKSEJWRivIgNZPSTNPtzV8QCz2JotWhrsKcV0hQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718714846; c=relaxed/simple;
	bh=D3DjJ/m3BX/gdqkmEKzFIzUqzeldqUWBi8SYh4cV2aA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fW5t7v99uA0jaiL5AW0lVR/+IXB4CWBjqsQ7YiU25G56DbXz520FYWEVwRrsuUJRgyB4rXbefQ7c8RjMzofnlc0lI90DRqHnSJLwJOOTw+H7jDy/YjDZMgBqSaOf+YPD7oFLfuB8upyeErsYwe1pXnNGUppqy4ZMNZdGXu07Kac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Prppwkgv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Prppwkgv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 033CCC3277B;
	Tue, 18 Jun 2024 12:47:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718714846;
	bh=D3DjJ/m3BX/gdqkmEKzFIzUqzeldqUWBi8SYh4cV2aA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Prppwkgv9TpMYu4J1jbEQoPowtlLkjIamt9wdKHFzmdKeadqlxv/Zoai+JQWqBYJh
	 X38NQu0R8o6LNDUeAAdSq+ND5ctcaVH+c4NEg826sfCo/NGKNszwoFIyja1UpnY6HV
	 DN0dXgYpiPWOD0bHKpPnb6mPoFFhYDyaIANmWaF8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 076/770] NFSD: Replace READ* macros in nfsd4_decode_secinfo_no_name()
Date: Tue, 18 Jun 2024 14:28:49 +0200
Message-ID: <20240618123410.217180331@linuxfoundation.org>
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

[ Upstream commit 53d70873e37c09a582167ed73d1858e3a2af0157 ]

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4xdr.c | 19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index ae70070a58213..0561b43855839 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -1356,17 +1356,6 @@ nfsd4_decode_secinfo(struct nfsd4_compoundargs *argp,
 	return nfsd4_decode_component4(argp, &secinfo->si_name, &secinfo->si_namelen);
 }
 
-static __be32
-nfsd4_decode_secinfo_no_name(struct nfsd4_compoundargs *argp,
-		     struct nfsd4_secinfo_no_name *sin)
-{
-	DECODE_HEAD;
-
-	READ_BUF(4);
-	sin->sin_style = be32_to_cpup(p++);
-	DECODE_TAIL;
-}
-
 static __be32
 nfsd4_decode_setattr(struct nfsd4_compoundargs *argp, struct nfsd4_setattr *setattr)
 {
@@ -1918,6 +1907,14 @@ nfsd4_decode_layoutreturn(struct nfsd4_compoundargs *argp,
 }
 #endif /* CONFIG_NFSD_PNFS */
 
+static __be32 nfsd4_decode_secinfo_no_name(struct nfsd4_compoundargs *argp,
+					   struct nfsd4_secinfo_no_name *sin)
+{
+	if (xdr_stream_decode_u32(argp->xdr, &sin->sin_style) < 0)
+		return nfserr_bad_xdr;
+	return nfs_ok;
+}
+
 static __be32
 nfsd4_decode_fallocate(struct nfsd4_compoundargs *argp,
 		       struct nfsd4_fallocate *fallocate)
-- 
2.43.0



