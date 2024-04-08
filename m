Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 200127FBBB;
	Mon,  8 Apr 2024 13:47:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584025; cv=none; b=UTTwTB/W7VIKUkDwZoA5piSO32ylXrK0UtI5KOscRqox4/TqjZewu4SEmkJZ82tyTD+DRdbJSDWRLJHZo0aywOn0/7KibVQWktjZfgB5YTaDWb25AZTtOohuO05WbJI1PihZ8xtSOumMrdlINsZ4xbWj6H+ZXNeAsebGSyCTuzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584025; c=relaxed/simple;
	bh=aiynq9ohYylBLI9X1Ovt6i/2PC6JVVjE/Yc1NorMcNA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OHZk/Ne2a2JJWrP0UumwwQt++oFI0rEGSpT1xYlP8m4QTPevZLq8G3p9MUcbha59/OPEyNqs9FHKN/TvrN1A+peEbfputw8vNix7aLajJRZKxNDuGQWQm5fPIt+8RpRGqSVJoL8COWfGRX/W+fEORfKdbjZcB5X9dc1tskFSbag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cI8hCJNz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cI8hCJNz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C54EC43390;
	Mon,  8 Apr 2024 13:47:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584025;
	bh=aiynq9ohYylBLI9X1Ovt6i/2PC6JVVjE/Yc1NorMcNA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cI8hCJNzLuc/jHI/oNxJ5nelj2vrVCWkUDlbaTq0UQKMsVF/I9Hs+OTCt0lTpnM1a
	 O9yu5YQxa6HOkxJnWVvRSXltittbWkCSsHqBoTTQwvTg4r44KW1a/W4JQ7P5f8XPvq
	 wst7Vru8enxQ6VgZUUmHboABXdbZG46GQsfbSf9g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 322/690] NFSD: Remove dprintk call sites from tail of nfsd4_open()
Date: Mon,  8 Apr 2024 14:53:08 +0200
Message-ID: <20240408125411.287087210@linuxfoundation.org>
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

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit f67a16b147045815b6aaafeef8663e5faeb6d569 ]

Clean up: These relics are not likely to benefit server
administrators.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/nfs4proc.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index f0cb92466da84..611aedeab406b 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -622,13 +622,9 @@ nfsd4_open(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 			break;
 		case NFS4_OPEN_CLAIM_DELEG_PREV_FH:
              	case NFS4_OPEN_CLAIM_DELEGATE_PREV:
-			dprintk("NFSD: unsupported OPEN claim type %d\n",
-				open->op_claim_type);
 			status = nfserr_notsupp;
 			goto out;
 		default:
-			dprintk("NFSD: Invalid OPEN claim type %d\n",
-				open->op_claim_type);
 			status = nfserr_inval;
 			goto out;
 	}
-- 
2.43.0



