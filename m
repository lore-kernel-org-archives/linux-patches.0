Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F05F1411F0;
	Tue, 18 Jun 2024 12:46:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718714773; cv=none; b=uzdy2h0K37OxUAqPcji3O4743NSRKkfGzxrE9kytI+sH+ZGw8GCvGqWlWsYQehLQpFP5m7rKe61wihLwF4g1Sn6KsZQ/fL6jakwsp4HYMQUJ9xj3/3iZiMkjkGZc2UXclSn2PPC+ceSIDcwTIIMH/0TMtZAYBjc7nUJUS58horc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718714773; c=relaxed/simple;
	bh=D/gZKISEsLakeh2MKBwQhI30Yr66dvhQlpyWoWw5WzM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eiN69fecyYHjFnFVL1cn6FZR6319vtfElPeMzXw9Yo5leDTN9vnAVExG9y5X0Hxzc2OeGa90JdcvG1ub4ExVdN5PjkxqeqPgir7elpKYH8zGCbwxeoROpwSQWbxP/ahwtZIwYkZJYj2xuQeKMUTgCKdI41PxejWkW7rnLtRnYJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B5cPrNhA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B5cPrNhA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAFAAC32786;
	Tue, 18 Jun 2024 12:46:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718714773;
	bh=D/gZKISEsLakeh2MKBwQhI30Yr66dvhQlpyWoWw5WzM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B5cPrNhA/RbxtMJrDQtqPl/if7z33abghG4Ngf+eXTMlzegg4sXgkl76XO96oGYNh
	 23NS7Ef2sU7WrZvGCDtOWaRFFNByp1ysPnSwR6FqZJkTKuUEHrjL3VJ7iY9s/CYPf2
	 jWgOrbNZZP3rPAs/80fvJiVYdEVHmG8TghJ2X+R4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 084/770] NFSD: Replace READ* macros in nfsd4_decode_copy_notify()
Date: Tue, 18 Jun 2024 14:28:57 +0200
Message-ID: <20240618123410.521779034@linuxfoundation.org>
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

[ Upstream commit f9a953fb369bbd2135ccead3393ec1ef66544471 ]

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4xdr.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index 2529368cbbc0b..09aea361c1755 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -2032,25 +2032,25 @@ nfsd4_decode_copy(struct nfsd4_compoundargs *argp, struct nfsd4_copy *copy)
 	return nfs_ok;
 }
 
-static __be32
-nfsd4_decode_offload_status(struct nfsd4_compoundargs *argp,
-			    struct nfsd4_offload_status *os)
-{
-	return nfsd4_decode_stateid(argp, &os->stateid);
-}
-
 static __be32
 nfsd4_decode_copy_notify(struct nfsd4_compoundargs *argp,
 			 struct nfsd4_copy_notify *cn)
 {
 	__be32 status;
 
-	status = nfsd4_decode_stateid(argp, &cn->cpn_src_stateid);
+	status = nfsd4_decode_stateid4(argp, &cn->cpn_src_stateid);
 	if (status)
 		return status;
 	return nfsd4_decode_nl4_server(argp, &cn->cpn_dst);
 }
 
+static __be32
+nfsd4_decode_offload_status(struct nfsd4_compoundargs *argp,
+			    struct nfsd4_offload_status *os)
+{
+	return nfsd4_decode_stateid(argp, &os->stateid);
+}
+
 static __be32
 nfsd4_decode_seek(struct nfsd4_compoundargs *argp, struct nfsd4_seek *seek)
 {
-- 
2.43.0



