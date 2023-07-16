Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 210888F57
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:56:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BAB3C433C8;
	Sun, 16 Jul 2023 20:56:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689540971;
	bh=FWQD2QO8jybz1qxsN0ZByN3w8b+lUw/krCs9GI/86KY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rEcazSejlxKXpUO2mIMhSl/LeIWZ6Jw4ARV4r06lwlO3zTfhfUhwnlVaTA7+dmNaM
	 8ftp+Qh6so1rQwsOixB+8K+s4Q5jpoQYVNPp6Wy19gvrNlTygfQwsk1ZqDlzneOGGB
	 3PjrgmJwGOU0zLyDyAH4Nazs/USGRBMpa2K6k1kQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dai Ngo <dai.ngo@oracle.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.1 526/591] NFSD: add encoding of op_recall flag for write delegation
Date: Sun, 16 Jul 2023 21:51:05 +0200
Message-ID: <20230716194937.480976116@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194923.861634455@linuxfoundation.org>
References: <20230716194923.861634455@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dai Ngo <dai.ngo@oracle.com>

commit 58f5d894006d82ed7335e1c37182fbc5f08c2f51 upstream.

Modified nfsd4_encode_open to encode the op_recall flag properly
for OPEN result with write delegation granted.

Signed-off-by: Dai Ngo <dai.ngo@oracle.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4xdr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -3872,7 +3872,7 @@ nfsd4_encode_open(struct nfsd4_compoundr
 		p = xdr_reserve_space(xdr, 32);
 		if (!p)
 			return nfserr_resource;
-		*p++ = cpu_to_be32(0);
+		*p++ = cpu_to_be32(open->op_recall);
 
 		/*
 		 * TODO: space_limit's in delegations


