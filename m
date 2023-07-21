Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D377220F88
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 19:07:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54600C433C7;
	Fri, 21 Jul 2023 19:07:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689966442;
	bh=4oYA4QarjJODrSVu7SNKc/gcTKP7ciVNKRrNq+uaXl0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O9Ji1fu/XWncg0i7KVUPl4RNtgTklfi10VZcoyRRHIypKT8zVU4YpySg33fFXXYwy
	 liQY+WKr8YWQkR4jKSv332E5AdS3EZ1eoSfUhOnC1JrNS89z2evVt1U52Clb2OwSs/
	 x7GIH2lKBJShVp3yj08YTlnuPbxu/Tn7cm3KQK+s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dai Ngo <dai.ngo@oracle.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 344/532] NFSD: add encoding of op_recall flag for write delegation
Date: Fri, 21 Jul 2023 18:04:08 +0200
Message-ID: <20230721160633.096513550@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160614.695323302@linuxfoundation.org>
References: <20230721160614.695323302@linuxfoundation.org>
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
@@ -3816,7 +3816,7 @@ nfsd4_encode_open(struct nfsd4_compoundr
 		p = xdr_reserve_space(xdr, 32);
 		if (!p)
 			return nfserr_resource;
-		*p++ = cpu_to_be32(0);
+		*p++ = cpu_to_be32(open->op_recall);
 
 		/*
 		 * TODO: space_limit's in delegations


