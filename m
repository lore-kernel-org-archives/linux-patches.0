Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CAC115B0F5;
	Tue, 18 Jun 2024 12:43:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718714619; cv=none; b=jPCHJjP86/7E4ZiN5DuW/Wo6ojAOp+z4f+JV2bmh0DxJ+leDC77NkbDcghTEsietVdQPJdSRE4gfpFfXXSmsSmqs/SACiUzMjvsb1yJtvCNrctQAX5aLeZC/eK5+JbhfgzKjhm7PYxoP/NEIqHL5x+u9M2PeSJ5cWbJtMhA9Nrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718714619; c=relaxed/simple;
	bh=ESLhGtcooY4YbrblMH40qc8PWFUUoO48GwqvHtIg8CQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TGnMXi3oJHgdnV8wf2b6QoLLoxyAadOp5aHDZFk59gVcwoq78WIZnhn59d+GaA6+BU888TPhOmdynpq4kfJhrHZQO8jauPkv4RC9Ln+On0IoJUYz1I4NntUb/PVuU2AJanHt1Ci/f61e6/JvXHvkwSawFxFo0j5jpBzYKT3UizA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UyPmRxXd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UyPmRxXd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F815C3277B;
	Tue, 18 Jun 2024 12:43:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718714619;
	bh=ESLhGtcooY4YbrblMH40qc8PWFUUoO48GwqvHtIg8CQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UyPmRxXdgEW6b/CiBO2uBvewbGwe4Uc7Zt67HfmQm7icRGuFcrjyHnfnPwVs9H6KR
	 27vBRWSv2nsigd0GZCBaLek46ZHgGvWk6yr6kcrzdxKL8Fzhsorx8LRlOna1IC9B6X
	 ynzv6xAQxn+0nDQpcfaDEJYQvXEMaoYEpgD9Is7k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 031/770] NFSD: Replace READ* macros in nfsd4_decode_link()
Date: Tue, 18 Jun 2024 14:28:04 +0200
Message-ID: <20240618123408.495750721@linuxfoundation.org>
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

[ Upstream commit 5c505d128691c70991b766dd6a3faf49fa59ecfb ]

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4xdr.c | 11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index 70ce48340c1b7..4596b8cef222c 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -779,16 +779,7 @@ nfsd4_decode_getattr(struct nfsd4_compoundargs *argp, struct nfsd4_getattr *geta
 static __be32
 nfsd4_decode_link(struct nfsd4_compoundargs *argp, struct nfsd4_link *link)
 {
-	DECODE_HEAD;
-
-	READ_BUF(4);
-	link->li_namelen = be32_to_cpup(p++);
-	READ_BUF(link->li_namelen);
-	SAVEMEM(link->li_name, link->li_namelen);
-	if ((status = check_filename(link->li_name, link->li_namelen)))
-		return status;
-
-	DECODE_TAIL;
+	return nfsd4_decode_component4(argp, &link->li_name, &link->li_namelen);
 }
 
 static __be32
-- 
2.43.0



