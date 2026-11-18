Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051856;
	b=R6AGlC4ji9KnGn7xlkYtSN+CnE/w2qqKZUj3zzcO/phb+dWlcNs2wHPxgMFlYVE3QbP7
	 1zJS9zg1uMAgiq0evrcN7a0JMTL7d3zDtWtERffRH8+Y/WGe5kZPGbbHag5imdxHYD8VZ
	 UbUlZgl0LEO4NLyJ8Zr+dBGI26h/iAZIRWbX/d162Ie4pwvJ9c84I2JuIK8CXOG4vK7E1
	 IC/2k38msdlTi6BnvsGZO4wgXFVPXPHQUoQXJnJIJQmmxN9sblXOD6AsR1YHjSMNT0jFL
	 LBN1dIUvGxzn6LSGFYhXD0y6+iFXmRud0r7DjNLPD8YqQ/Dd98Eq2IsrhPmh6JQxyFA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051856;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vHRltzwoscTCJW+EZfbmIVyb086fAQd4veRm4qi08bw=;
	b=10anYSdzNDm+PW9/UVrREKRk6IasuHMGb4Hkhb9kIqxwSS7nC2jROHuc7Z8FlR7od7aR
	 U6mr4JiBz1TJhzOMBbJEXtqq4GkMfYW8tTjYcOnw97WWObUdDmJkMafp17nZY3gn85POs
	 n2Pi3PbJPIzbRQMeaGr+GJ39hvA2ND5umTMHEKj+ZlUIZzMw6LlemqRMKXPOdQx/sXcDi
	 BMjEvHX2VrGZdBulpYEPMCUXNfYnSF0k3p1Pk0ti7SPrRlcU8tC+g6TySajOc3zV5oL4k
	 tcMhWHSBodt52jfd2R30hVyDs5D9BIUVn6LAI2PcXliJxS7Fuw2dtKq9+pyG6wx4AtA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ynilY7D4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E07E606A31C;
	Thu, 19 Nov 2026 01:30:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ynilY7D4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EF911F000C5;
	Thu, 19 Nov 2026 01:30:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051855;
	bh=vHRltzwoscTCJW+EZfbmIVyb086fAQd4veRm4qi08bw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ynilY7D4l50my7GWEUOgLAVG9HN4xN6yveyVoBoniIjCk0v60OKu0sUjuHsMVrX+/
	 DStKJOdFdOOIQwGJBCeuWqD7/jYDNXJXCBnUuCWti6l3JtRpiogUW58W1BRKbM3YbM
	 dAgrM1n3WLAwLhq0sCFzX49/btUhu8tIoo+yxutQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	NeilBrown <neil@brown.name>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 5.15 0355/2214] nfsd: honour client-provided attributes for NFS4_CREATE_EXCLUSIVE4_1
Date: Wed, 18 Nov 2026 15:33:51 +0100
Message-ID: <20261118150024.902152970@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -357,8 +357,8 @@ nfsd4_create_file(struct svc_rqst *rqstp
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


