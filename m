Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B967B1773D
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:16:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C7DAC433C7;
	Wed,  9 Aug 2023 11:16:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691579777;
	bh=ol2SnMmYOzZLtJrR4jWi2/SJSlbCvgKt6uN495wqYj8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y+XV6ulyuFVQCmKYKxYCwBuAg/LXg0YL4N7E/36Bk+Ea/4B6yaDqpRCygUC/A/JKa
	 Lm5of/NSwq/bIkOHbz8fLN8j+bt6OtIscam/CFTo1H5FFiSqPIg/I5sdtsDmJjzUCV
	 tRLUVpB0IbAG1z9HfuxW6A+zXulV/lhBU+b9QqTI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dai Ngo <dai.ngo@oracle.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 4.19 113/323] NFSD: add encoding of op_recall flag for write delegation
Date: Wed,  9 Aug 2023 12:39:11 +0200
Message-ID: <20230809103703.269610277@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103658.104386911@linuxfoundation.org>
References: <20230809103658.104386911@linuxfoundation.org>
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
@@ -3403,7 +3403,7 @@ nfsd4_encode_open(struct nfsd4_compoundr
 		p = xdr_reserve_space(xdr, 32);
 		if (!p)
 			return nfserr_resource;
-		*p++ = cpu_to_be32(0);
+		*p++ = cpu_to_be32(open->op_recall);
 
 		/*
 		 * TODO: space_limit's in delegations


