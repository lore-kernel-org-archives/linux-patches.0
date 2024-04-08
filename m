Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD5D77CF25;
	Mon,  8 Apr 2024 13:49:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584159; cv=none; b=r2n2BlFHkMWWES3EQorvmCCEec67K+3Dwtn5ke4JOUHvXoZMhncZq6HvQixCzK6dP3bJfvFZFawDIyMnO7fGZKwjBQ+feqODoW1T130RE6LeqiPRLlfUuW4gZD6OJAqwaxQRRCHRkI1d2n0NHDeTdwPBCzmsizzijeFKwouFdrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584159; c=relaxed/simple;
	bh=YhRySYSd09zU1F/5bc9XWpPeuO/D7XEzZvEKcE8A6lI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xg1yp4HPl0kUiAScQi5XpKljGTOB5GTkON3niGne5L0dMkY9ICrOH3ZANANuk/XYSaEh1xeDNLi9KeTKOJOJoPGjkmw/jM3AckVSpZQN7Dq2/G9aklNbZVThvnjXqMclBSDLZB63fHRml3+2U5udR3jxoI4s9YXH00Uzv7MXdh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PhHNW3Zi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PhHNW3Zi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37DE2C433F1;
	Mon,  8 Apr 2024 13:49:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584159;
	bh=YhRySYSd09zU1F/5bc9XWpPeuO/D7XEzZvEKcE8A6lI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PhHNW3ZiQVyF3bPOCA9HEnevtuzLJCxtOolVAaQQngxJYEEDPxeEF6/oh3FWy6b5b
	 Q+GySZGK0wLwFygX3gib/c1pJWRaXzZlEB6Zhl8HEC4ajHpIcnJwfyLsTMJ3T5lnxe
	 OMya1k28YLCjiD+zdjOXlPTLJZyTXgQUGIUZcea0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Jiaming <jiaming@nfschina.com>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 343/690] NFSD: Fix space and spelling mistake
Date: Mon,  8 Apr 2024 14:53:29 +0200
Message-ID: <20240408125412.036771667@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Jiaming <jiaming@nfschina.com>

[ Upstream commit f532c9ff103897be0e2a787c0876683c3dc39ed3 ]

Add a blank space after ','.
Change 'succesful' to 'successful'.

Signed-off-by: Zhang Jiaming <jiaming@nfschina.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/nfs4proc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index 5b56877c7fb57..d70c4e78f0b3f 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -828,7 +828,7 @@ nfsd4_create(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 			goto out_umask;
 		status = nfsd_create(rqstp, &cstate->current_fh,
 				     create->cr_name, create->cr_namelen,
-				     &create->cr_iattr,S_IFCHR, rdev, &resfh);
+				     &create->cr_iattr, S_IFCHR, rdev, &resfh);
 		break;
 
 	case NF4SOCK:
@@ -2712,7 +2712,7 @@ nfsd4_proc_compound(struct svc_rqst *rqstp)
 		if (op->opdesc->op_flags & OP_MODIFIES_SOMETHING) {
 			/*
 			 * Don't execute this op if we couldn't encode a
-			 * succesful reply:
+			 * successful reply:
 			 */
 			u32 plen = op->opdesc->op_rsize_bop(rqstp, op);
 			/*
-- 
2.43.0



