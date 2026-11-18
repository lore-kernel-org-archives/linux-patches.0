Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035524;
	b=fa0Jw8ytlE4/e3Cvqh/5mKBy5bGgH1kTKYAtxSQJbTyOdfbXSqif/41d76HaENd3ORTU
	 DnFQ0CzymwB7UVqgYxI0ia9j7tiWdeaQYz2vqPkKLtVvpj4z1BRiHD4RKp1L+c8/AnbsO
	 /jUj9rX1rm7BFT5//c93yGw8KCHBj7UveDWqbz7eJ4SDPv/iI0oJjftb5f18+qdDT8aBO
	 8jkCZyY1Rnl+/BWh7Ot6EmnLVk2UpAPAgyr6smDMM2YpZVqbTCPc/Ix8IyhhN3PV7pr49
	 GmT0v2angN+ig0iw8D2NrhSVbPs8wymFGal+YK8QLwpV0PDw+4VGR35D7MCHxFjXC6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035524;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2/UUlZ6iye0J1X84dxQQuZc08nowOFq8nM8puJyD3l4=;
	b=j2UvDqrmzSmHA6yw+MovJSeXRQ2RZ8Eh9ej3nZr/pfQ2udEKCjgMvWpN6ZMAvotoWe5F
	 T9jy3vL5l6yUW6XGmQa91vnsms5pFQ3tFf8iGquF+m22gf9ACDr9XWs9H+SrpyzlMhfq6
	 lv6KNlQFgsHkxbOZV1FBFEsEFuN0IR4sHh/1LrvsoFGCnCkp177f9JdKijbR1W0QSLFOZ
	 ou4NED7Uy9tuXfiqu8hQIjbZ4AdOZY4CnCnGALJOV5G2/B547KOKNFhh8Ci9LHRjGfVUD
	 GWXMTE+jVWXwY4F63raM5NrnVbM57Cypmc+EyJPRYDZhgLLJPjYCTzBOrblP5I6bwEw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=N6XLSSoT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 669B6606A31C;
	Wed, 18 Nov 2026 20:58:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=N6XLSSoT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B85911F000C4;
	Wed, 18 Nov 2026 20:58:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035524;
	bh=2/UUlZ6iye0J1X84dxQQuZc08nowOFq8nM8puJyD3l4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N6XLSSoTCHb0otjq55ZFcTl40zC3GUl7RUPErbHM+amssGWIissxZ1eQVfcXpp/ls
	 nPKVJsfpDzUOXqiLvwSRvSQTR+LQ1z6UrqwhLIxazs7tAyQI3TpLbYMJ+WEH/iWT/i
	 WgZiiYtZk9L9I+wrazNGAt6nn3JrMfPfcY15oB+M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aldo Ariel Panzardo <qwe.aldo@gmail.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 6.6 0698/3318] nfsd: zero NFSv4 COMPOUND tag padding
Date: Wed, 18 Nov 2026 15:22:00 +0100
Message-ID: <20261118150339.286932548@linuxfoundation.org>
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
@@ -5539,8 +5539,7 @@ nfs4svc_encode_compoundres(struct svc_rq
 
 	*p++ = resp->cstate.status;
 	*p++ = htonl(resp->taglen);
-	memcpy(p, resp->tag, resp->taglen);
-	p += XDR_QUADLEN(resp->taglen);
+	p = xdr_encode_opaque_fixed(p, resp->tag, resp->taglen);
 	*p++ = htonl(resp->opcnt);
 
 	nfsd4_sequence_done(resp);


