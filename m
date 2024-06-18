Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9775E13C675;
	Tue, 18 Jun 2024 12:44:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718714687; cv=none; b=cJvHWKfhoXNz27k8zTgYl3h5HTkDUKWN6iPk85Q2JYFw63YyYqt2fmV3IKrHzbiiKKynT0pZu54nniIu/xQCRJMqrs5bC39sUIHPmYTgYerS9DEDi4udqWoT5R0gHpQtrFN2ZUVGIuuqk2rsdQKn6w+FgWIaEnvbL6u8jSFA0zE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718714687; c=relaxed/simple;
	bh=yI3mlPrTM6rrbiXxwlXgpma2vxDOx/Ek6+a1jKSR/7c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kBWNNfuYetxxgzZS+9BMV7RuHjEkL/DBjEwe/L2moEMqyCUBADz6qe2KMm+B/PR+L7fInUiIuIgJVK8ulWHejPinF5hhRDk05DFsbcabfoxCKz5+HFdaQ3DH6I+88ZU9yweoaYepgtOVL1xd+CH+xBGaF8+QsAivcO8l9fNqYfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yCo/0qan; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yCo/0qan"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B4B7C3277B;
	Tue, 18 Jun 2024 12:44:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718714687;
	bh=yI3mlPrTM6rrbiXxwlXgpma2vxDOx/Ek6+a1jKSR/7c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yCo/0qanvtsY1feLJaXzeRcNddD8oSQuLwQOJItmiBghP1et2B1uZvU/9Bvj0fZEF
	 F5GBRKWhm+GwpN3QSKNjqzgStu6P8DPGGAPP7Dd95u+wRdbqUFVBhrKGAWrBuLd0P8
	 thEIvdHHQ9zdK4usYwr+8HCVoi2M7Y9E9NsswFrU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 054/770] NFSD: Replace READ* macros in nfsd4_decode_secinfo()
Date: Tue, 18 Jun 2024 14:28:27 +0200
Message-ID: <20240618123409.374220663@linuxfoundation.org>
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

[ Upstream commit d0abdae5191a916d767164f6fc6c0e2e814a20a7 ]

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4xdr.c | 11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index 51b59b369d726..42d69c0207ce8 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -1279,16 +1279,7 @@ static __be32
 nfsd4_decode_secinfo(struct nfsd4_compoundargs *argp,
 		     struct nfsd4_secinfo *secinfo)
 {
-	DECODE_HEAD;
-
-	READ_BUF(4);
-	secinfo->si_namelen = be32_to_cpup(p++);
-	READ_BUF(secinfo->si_namelen);
-	SAVEMEM(secinfo->si_name, secinfo->si_namelen);
-	status = check_filename(secinfo->si_name, secinfo->si_namelen);
-	if (status)
-		return status;
-	DECODE_TAIL;
+	return nfsd4_decode_component4(argp, &secinfo->si_name, &secinfo->si_namelen);
 }
 
 static __be32
-- 
2.43.0



