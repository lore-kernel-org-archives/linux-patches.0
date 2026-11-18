Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035415;
	b=vX/r5OdvNsxOphj5CVSRy7K8YonpDROTWaccyKhWWGK7IsFLd6MwXok+yYYbzLSkwpaJ
	 WMJ0X9JGhr50o2rjCO7RqsjR6dF+mknt+6daNQ7D01VO2vYk915I9KWhttep6WYLEWAzU
	 H5o/Kcev3e4Us/vD1gkTWf+YpEVu2AS9xChHHEeb2nqsVUb7LUD7fouWhWVky2eh/Dxb8
	 hWONIbt6W7gFW2tR1c3P0IUpIv1BejWRvXFNVC+ZcPiTkvCI45TOSILFGyEzqsGstunzf
	 hqhhLHOM64ModOTuNVBSagdIKL4nwCfa9xrV2/rZFc/IrgBsIOVfZ+NbzNUADIl5trA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035415;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1+yK84jys2fQqMkUGkNRqKr/3LUlhkMOYxDR1IasM5E=;
	b=Pxd8mRK3XhzFPTWYcIjs0WJXHNdTStECZiX5Henzjh6HGtqrKjVpNfIiYGbY635IRCSA
	 FE3FP5YJrV7ZnkP0uhpJ964eZxZqj4NOiGN5+K0ACQ+oESZNazbVrco4EDgYM65+2uWH1
	 qg8htSshFw9UMDttBK8WoN1E7LOymOAaP6RrsHFbiodoYY+FRz4KMiYCee8uLcXta/3zT
	 MzVMtJ/CWeYY34W4ADlIMrPvUci+Bf4sFx0PQiUou60YIlIYBi3EBjfGwDotkppMh/3m4
	 N2lRlJtyauWBEccypUOXsvNQFKm61FjS4g6GSdxSTe7bJ8fhhFx6cAGAqSe01NzXknQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JHIsOPPU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E653606A325;
	Wed, 18 Nov 2026 20:56:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JHIsOPPU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E45A01F000C4;
	Wed, 18 Nov 2026 20:56:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035415;
	bh=1+yK84jys2fQqMkUGkNRqKr/3LUlhkMOYxDR1IasM5E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JHIsOPPUZeY7c9hhRb6YhQdeH6tNG69c2YHCOxAYfxtrRbqh8EjwWBOck94pmC0Q6
	 AX6IHw9oWPIgU59hOQZkODsJZ9Supy+A6CWI5fjX9aOwZlbQXHE9OdkNaPbJrrkH+P
	 DmufNGBhuKZedLsPP6XS+79iYGQRDg/2f0LKVD+c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	NeilBrown <neil@brown.name>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 6.6 0693/3318] nfsd: honour client-provided attributes for NFS4_CREATE_EXCLUSIVE4_1
Date: Wed, 18 Nov 2026 15:21:55 +0100
Message-ID: <20261118150339.076712857@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: NeilBrown <neil@brown.name>

commit ddfabbc7840891e09cd500ab97c9cd36b650ec24 upstream.

When a file is created with a v4.1 OPEN which requests
NFS4_CREATE_EXCLUSIVE4_1, the request can include attributes to be set.
However when the mtime/atime are set to hold the verifier, the other
ia_valid flags are cleared, so no attributes requested by the client are
used.

This code was originally written for NFSv3 where NFS3_CREATE_EXCLUSIVE
never includes attributes.  When it was updated for v4.1, the fact that an
exclusive create CAN include attributes was not handled properly.

Fixes: ac6721a13e5b ("nfsd41: make sure nfs server process OPEN with EXCLUSIVE4_1 correctly")
Cc: stable@vger.kernel.org
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: NeilBrown <neil@brown.name>
Link: https://patch.msgid.link/20260717093001.1972119-2-neilb@ownmail.net
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4proc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -358,8 +358,8 @@ nfsd4_create_file(struct svc_rqst *rqstp
 	if ((iap->ia_valid & ATTR_SIZE) && (iap->ia_size == 0))
 		iap->ia_valid &= ~ATTR_SIZE;
 	if (nfsd4_create_is_exclusive(open->op_createmode)) {
-		iap->ia_valid = ATTR_MTIME | ATTR_ATIME |
-				ATTR_MTIME_SET|ATTR_ATIME_SET;
+		iap->ia_valid |= ATTR_MTIME | ATTR_ATIME |
+				 ATTR_MTIME_SET|ATTR_ATIME_SET;
 		iap->ia_mtime.tv_sec = v_mtime;
 		iap->ia_atime.tv_sec = v_atime;
 		iap->ia_mtime.tv_nsec = 0;


