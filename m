Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831761;
	b=sqn1MXjklMMmYTif/lcy7VZx7CyJKWtXgiiai40zZ2DXSY9s32rkc6p1nqHQd1L2hj7u
	 mxCiYaSgxF9vHxO/ukOSMZCe+CLYK41GJM3XXYlykuU538yVSeTOFdhMEuSYCH2ewzUPA
	 EK24atxj9GJi8atq7+4mPETlLci1Kpfeo2r03Mw7eigTGdxhP+JyxTCQWm1FcTWY3j/Pa
	 Z6jNhzwJOWf+7u1kJrEKw8970ppPSL9TlaEmHZWkTNWnLGZAnrHibiAR+HPWi2Ika3CiD
	 tmowD6/za/Wn7QLc+C9FTvcQ+Yea+spHn86nvilSBi8ZTtLE4X/01F+paIObEuEi1Sw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831761;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=p3Z/fEDJCWpPaB8pr+f9lbNucVu+s4mCEc4MvDjm/Tc=;
	b=rKs54LIbQutdJu83/dK/mx9jZEI4jirOrDyCI5foDilGMB64UlHtpdPT23JYTo57NAz2
	 xIq0VpeFSGnHSNVzzLpatjVbP1dTXmmvigCRrOMALlDm4nE/c7sNJJM5+m0er8SKSmUyH
	 55SNqNNtuRrdo4uQAWDLmdxmKZUKqDBwDupGe94c8sysVR4/MYhJM+LYPdnY3gvaxc/Nx
	 YYcjyDEYku2edg0cd9qidXBFXgUeGuhMG0ZwmIwYgdo9aEV8TQAYFWXBuYDIEUubFId3e
	 FjJ5aRnWygl69ry3V7wlGrMYoWWWebLfMfTQKTZwfqVEzljJ691n5OSg6Kpu2LHWn0g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=snvuh03k;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 542B4606A31B;
	Wed,  4 Nov 2026 22:36:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=snvuh03k
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEB131F00919;
	Wed,  4 Nov 2026 22:36:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831761;
	bh=p3Z/fEDJCWpPaB8pr+f9lbNucVu+s4mCEc4MvDjm/Tc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=snvuh03kjk904xuk0HwUHhm0ZqIxryzJ9y3LVIF8ylUKkqRV70idiXu6T8v96SKzT
	 E30VV5ypXA51x6l03jcuwymROfj9d746ML6gpz8BjLUsDXCA3oekJJBFPjGM5mLbHO
	 ELZ2l+O3KtO71iDJE9tlkjfAQ8XkYd2IJ0TUqvZE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	NeilBrown <neil@brown.name>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 6.18 0896/1005] nfsd: honour client-provided attributes for NFS4_CREATE_EXCLUSIVE4_1
Date: Wed,  4 Nov 2026 16:10:29 -0500
Message-ID: <20261104211108.306618973@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -363,8 +363,8 @@ nfsd4_create_file(struct svc_rqst *rqstp
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


