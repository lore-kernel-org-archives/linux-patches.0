Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 155A313E022;
	Tue, 18 Jun 2024 12:44:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718714676; cv=none; b=FtxVyVOL1NoS5cH25ZW9WGT0k2VXhhYWofYC7NY2UhSSKan1bzNxEajcV7u979u25qKVJbGIUQzHUCVCi5kTXc+uc5rmXY5xPxO8laIq/TB4lAPJPNg97ubjZP8UHZ5Dkm24m2HYT41jKyOO0vOSH5w1S3k6SfejQblYzzERRNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718714676; c=relaxed/simple;
	bh=v/jTdsTWDEaxCCWB6/WkNvFW8ENQuIqAfon4djbOVLg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XCy+WQT9QKIgieTz1To6yT4GFt6NdRxMJ9XPpP6Ee4KH58y+QlonBxdhEL015/PUCHZZa7L3b6DZqYPdgBw730VF8lg0CsXomEBeoaPX1vSl5iO/1K1aRu2/wHdB9JphYSor8aY9JIZwRcFJt/mdwsehHy8xJwZ45qpNom03Nd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UkOSSLZz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UkOSSLZz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39E3FC3277B;
	Tue, 18 Jun 2024 12:44:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718714675;
	bh=v/jTdsTWDEaxCCWB6/WkNvFW8ENQuIqAfon4djbOVLg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UkOSSLZzbQ3543X8B1FixsJsCW+D38dKk7GGJOOpUIxyI+PZ9Q/yxbtohFIghbeGg
	 MPNk+B7UZtLKe7tGeq3TYg4Vd2Y8ySnzFdOUoTLYyJMLXKErAT3Qh6WaxaPM6wD7pg
	 Zd/4nJysqWvrF2cON0+rVer7UUoSGPybuR4legJ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 051/770] NFSD: Replace READ* macros in nfsd4_decode_remove()
Date: Tue, 18 Jun 2024 14:28:24 +0200
Message-ID: <20240618123409.261159070@linuxfoundation.org>
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

[ Upstream commit b7f5fbf219aecda98e32de305551e445f9438899 ]

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4xdr.c | 11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index 6036f8d595efa..d4e1e3138739c 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -1255,16 +1255,7 @@ nfsd4_decode_readdir(struct nfsd4_compoundargs *argp, struct nfsd4_readdir *read
 static __be32
 nfsd4_decode_remove(struct nfsd4_compoundargs *argp, struct nfsd4_remove *remove)
 {
-	DECODE_HEAD;
-
-	READ_BUF(4);
-	remove->rm_namelen = be32_to_cpup(p++);
-	READ_BUF(remove->rm_namelen);
-	SAVEMEM(remove->rm_name, remove->rm_namelen);
-	if ((status = check_filename(remove->rm_name, remove->rm_namelen)))
-		return status;
-
-	DECODE_TAIL;
+	return nfsd4_decode_component4(argp, &remove->rm_name, &remove->rm_namelen);
 }
 
 static __be32
-- 
2.43.0



