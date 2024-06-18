Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FA6D13C675;
	Tue, 18 Jun 2024 12:44:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718714679; cv=none; b=tV2nWOuGC9/FCbmfAf7Pae7gHIgEA7F5YbKVccFZwxaemtmO3A0BgmJH343e8NVYCPoMU9RmQq2ahAUYiMh1wNtFD02RLx1lnDK0qVk790fhUZYEoViynPKMB5kzxvHes5WRxUW4CxOMtv/Fv22z/yfJntTJoDjmQT7txH6ufFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718714679; c=relaxed/simple;
	bh=MVWh4Dssul6ov5OjVi+vY9V8iQAUNKrWhQTuMoite8s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VU6fNjuPvStud2TnuzJktdpOR78CZxEVPIEx2NGX66Xz8ycFUUkdvBvs/9fHU1+p55bofUAEQxahRJT4W1p6taBMS1/8d2M+UUx+NFSm2OfnpskILqp+mzmZFMblP0SvXt4M/TonzEArb1tUHgBsBynRMk0O2PHpw7njE7OCMXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FFhl8Jc7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FFhl8Jc7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 373D8C3277B;
	Tue, 18 Jun 2024 12:44:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718714678;
	bh=MVWh4Dssul6ov5OjVi+vY9V8iQAUNKrWhQTuMoite8s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FFhl8Jc7RqXgNFdMuyx9pSLztDrebH+JEeKwHq79iK0RWgNxJ1vwFnzb7T7BEVw2R
	 w7yPqku3KPsLHZ+5Mo4JQ3ESGMUTfXqTxCt4AMNxegtMBKYE2mvkeKy1ZUvU3FOW7t
	 EnAyn8N4xLczOwVA08FHhD2ZXNTxMNaiCGdQcmM0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 052/770] NFSD: Replace READ* macros in nfsd4_decode_rename()
Date: Tue, 18 Jun 2024 14:28:25 +0200
Message-ID: <20240618123409.298727348@linuxfoundation.org>
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

[ Upstream commit ba881a0a5342b3aaf83958901ebe3fe752eaab46 ]

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4xdr.c | 18 ++++--------------
 1 file changed, 4 insertions(+), 14 deletions(-)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index d4e1e3138739c..adf4a6fb94d4c 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -1261,22 +1261,12 @@ nfsd4_decode_remove(struct nfsd4_compoundargs *argp, struct nfsd4_remove *remove
 static __be32
 nfsd4_decode_rename(struct nfsd4_compoundargs *argp, struct nfsd4_rename *rename)
 {
-	DECODE_HEAD;
+	__be32 status;
 
-	READ_BUF(4);
-	rename->rn_snamelen = be32_to_cpup(p++);
-	READ_BUF(rename->rn_snamelen);
-	SAVEMEM(rename->rn_sname, rename->rn_snamelen);
-	READ_BUF(4);
-	rename->rn_tnamelen = be32_to_cpup(p++);
-	READ_BUF(rename->rn_tnamelen);
-	SAVEMEM(rename->rn_tname, rename->rn_tnamelen);
-	if ((status = check_filename(rename->rn_sname, rename->rn_snamelen)))
-		return status;
-	if ((status = check_filename(rename->rn_tname, rename->rn_tnamelen)))
+	status = nfsd4_decode_component4(argp, &rename->rn_sname, &rename->rn_snamelen);
+	if (status)
 		return status;
-
-	DECODE_TAIL;
+	return nfsd4_decode_component4(argp, &rename->rn_tname, &rename->rn_tnamelen);
 }
 
 static __be32
-- 
2.43.0



