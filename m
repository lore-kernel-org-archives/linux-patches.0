Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061725;
	b=zfeNH+ijtoZiqNjMdVL2Bh+eaC6i84zJ+zH8U00f1RULdhQ1gg6rLkiuKYF0tAAONHQX
	 RbbL++joU0uV/JpPdwkqKNFcRoez2rLm72MSh32Hpif9hNohsFGbPeaNPYLesX35K3pr9
	 lQEAgW5n9DZof/ZS2YZVtw5KYJ+gZMCYnduZFfzRQeuBIgaJ3ZqCkA3VD3SEd5DvLegSL
	 Mu2uxSbXd4XAdi/JAmG8nbRVdzDoTMfoAEICR5bdJnhduvwEBEbp/2KGp2x0A1BvApe2J
	 fcFhCNwFZywoSDUT1zL1lLUCFTNvDCdBrNLDOurMQ40lMbfgqgQntJircJH0WWQQMBw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061725;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QBWuy5xPwi27breLHISAeI0xqQPqlRRXJkRb+TTmDyY=;
	b=GRsSiOAPLetQ1tKvXkXY0bq0wTygduK7nB6et9QY4XO/6lWAmFpofk2MYlvwLNCSs8pH
	 v/vMveZcn7TnsoDjjaoGq7lXRsAi60wuRcx6Nq5ZRlwpNq1JWeerXKAMgKzl33MQKazg7
	 KI0chIdPlw7GpfFrNvt0m1kvuS+b2asZRy9pzE8lQMgnKkXZD5fRObvMss3lIIqjiPYpt
	 W6f6a232T/qQko8Qu9PQ85xOOAkjNVLQyn5tTDWqzokUQgziv4qS40T0VKHbOmPddIiab
	 zJzIBX0a2b4qJxKIXZMMf176qTPYqE7R55ohCuLvg/NC57ZWeDODX/rrG4a6eDKgxXw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eeqZpRMB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D615606A32E;
	Sat,  7 Nov 2026 14:28:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eeqZpRMB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 472FB1F008A1;
	Sat,  7 Nov 2026 14:28:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061725;
	bh=QBWuy5xPwi27breLHISAeI0xqQPqlRRXJkRb+TTmDyY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eeqZpRMBmhEI0Q24dsxaPYjNWUuM6HhchgW+6Ca+Wm5FdJy2AIHysTpzA/FNxMIEN
	 LnrK7FCsHDtCh5uNk+lhvS/h79pOmUuuQX0VJtS+K+dKUZNFTBXRnG9til3qjCeZxC
	 g3jo6PcbTflnDPsBVad6dGL+TBCiTSbtREyOLkh0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	NeilBrown <neil@brown.name>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 6.12 0769/1536] nfsd: honour client-provided attributes for NFS4_CREATE_EXCLUSIVE4_1
Date: Sat,  7 Nov 2026 08:46:25 -0500
Message-ID: <20261107135019.132503589@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -359,8 +359,8 @@ nfsd4_create_file(struct svc_rqst *rqstp
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


