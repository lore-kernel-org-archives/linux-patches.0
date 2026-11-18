Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057917;
	b=IwnF3eqntYpCncIVgwK+X4p/DqN732XFGQcpSRA7+smpwnyI6qwExBHCslzABVO4A1jt
	 I/vYWvL3k62e1rin/+PZ/Z6uqSomk00g8oqPnGdV2z//NfEb5bdT88wRjDAw53Gyj7S/Z
	 gVz11LZ4jyrrNCxkkMfsSxAEP2bGrd5hZ3z5lRHOWcbBC4ntBLDUJD3WB9Lt409d+jXLq
	 a2zVAfDkwE9Erzd2DNo3DLAOvPlKQu/Ry2ZfPhGHBHQyEWWVVPwLLwjTpTdgzVaupaw6W
	 D0vx32r0Ub3QL6gmTIagBRBrR8OeQmT674wGoiPpxHFqy9WS7s7AVMt0sH/6H9+hvTA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057917;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CEWaWh67nN9WmBDkmQ9gBFXC2r0yxzTmjkMbPzU7gzw=;
	b=rNbJmFH3TidNhDIUSbrSwHycSBWxKOphZWRS8f3MZVlkbqfmE/Kl1Lbe5vk06Ev0V3/9
	 SAmDoOI5OIULqIexXGjGAGSVY8c/O/v5RaYBZU2JILh4pG4Uj6DAgAxrmmP1kZLhpXW49
	 w1hT3KKjze2b7vMb35/cxA4j1HuDJII5BbcDHlexO9jcPCkVbMma1gTuwpmwrwYjbSTRt
	 ZBQ0PfimtLQ+1Fsh0XYzHwRrBcZ0a4alcSFE+QAJEhnzynWaeZPxLxuoXrvPBfSoGHYBr
	 3aZd1Xa9wMICjEqaHpxyCUaECUiTCyuxDHUBSeWQEQAi/Q6NFKV9C4v7HPDdQgtNAQA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Rg9d5Dpk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E01D606A31C;
	Thu, 19 Nov 2026 03:11:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Rg9d5Dpk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F4291F000C4;
	Thu, 19 Nov 2026 03:11:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057917;
	bh=CEWaWh67nN9WmBDkmQ9gBFXC2r0yxzTmjkMbPzU7gzw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Rg9d5Dpks3QwijpsEfaSfB42j/mKqKwHGSgmU+5r2nMqOOHakZBob2sxP1USJJHf1
	 9R+bsgfM6Nvjse98+yt6WfhxhJYdiLBY0LYETlfTelNfAO8HPUpzHCInE5Omc7riPS
	 1GeV4v3dFY++nZo7+0e2/CljLIOa2JbCik2f7qPU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aldo Ariel Panzardo <qwe.aldo@gmail.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 5.10 0299/1848] nfsd: zero NFSv4 COMPOUND tag padding
Date: Wed, 18 Nov 2026 15:38:57 +0100
Message-ID: <20261118145924.581605015@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aldo Ariel Panzardo <qwe.aldo@gmail.com>

commit 3f1181cb09c85499286c7f462d93530b0ebcafcc upstream.

nfs4svc_encode_compoundres() copies the tag bytes into reserved XDR space
and skips directly to the aligned end of the field. xdr_reserve_space()
rounds the reservation up but does not initialize the padding bytes.

A remote client can choose a tag length that is not a multiple of four,
causing one to three stale bytes from the response page to be returned in
the COMPOUND reply.

Use xdr_encode_opaque_fixed() to copy the tag and clear its XDR padding.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Aldo Ariel Panzardo <qwe.aldo@gmail.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Link: https://patch.msgid.link/20260915160049.3105481-1-qwe.aldo@gmail.com
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4xdr.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -5545,8 +5545,7 @@ nfs4svc_encode_compoundres(struct svc_rq
 	rqstp->rq_next_page = xdr->page_ptr + 1;
 
 	*p++ = htonl(resp->taglen);
-	memcpy(p, resp->tag, resp->taglen);
-	p += XDR_QUADLEN(resp->taglen);
+	p = xdr_encode_opaque_fixed(p, resp->tag, resp->taglen);
 	*p++ = htonl(resp->opcnt);
 
 	nfsd4_sequence_done(resp);


