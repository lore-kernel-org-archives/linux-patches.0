Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831778;
	b=AssLN6VoTk0ptuBCQx8E5HBr1ifKzTQspTffjTN5cItfqlYK9hIqOOlzZzuLDXmFd7yq
	 CRVV+/DlG3xfjPnfzmVk/L8eI2DAZEn8mtwjnZBupxU/N8yZ95B37iJmzXoEik2ULk3pR
	 pVWqbNi+5v+S+pnS3ilQ4UFzNoLVB5U+15W41wrydHEsVf7OKGKEOshypFMPXokSSho2J
	 pCT7g3pVHOxgbPij/pD2xWBdUKK+Ef2BS+oYYsJtDpQuqwU5K+kEDHsDTUP74aoevV7ax
	 oAh3nx2H5mxD0CXBHi3KVPASTNX5mKak6mbMdultGn/KYje5jXe06u5kMGMzItXNxIw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831778;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CBOb3Tgt0p4Cog/8Fje/t5EWgyuTVfjQGDQpo/lMEYc=;
	b=5YOt6ceynIpvlQc4nNBzyd3l7XaqBb4wooLjumi3cHyRamcNYDY1BsXo4MNaB5aOckS5
	 tZQAbqbdrkOAQ0zrf8jZ8pjTU2XSIlaE+lcw5lwglxay3a2ZBhiovYszieAzKKp21+VgK
	 aK6+Ggi3j38MPbaYY5FuyWjnWZx0gV39J6mr98a8HHhHBsQ2gmiLDB0wZNXsDNgR3j3OW
	 ZogqnSbklLU6TTMShvFA2mJkUR3ZwjI34t+z+JQXpJnSRv6jVH8stPITmyaUF912DLtnd
	 /OvPXn7g6cyCvnxVedCaXOPUk1RbbOyH9gJOC6KNraUKOVcYqpVe8SmRAfrqVyIREqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O3s4nwP4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32D58606A326;
	Wed,  4 Nov 2026 22:36:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O3s4nwP4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2B691F000C1;
	Wed,  4 Nov 2026 22:36:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831778;
	bh=CBOb3Tgt0p4Cog/8Fje/t5EWgyuTVfjQGDQpo/lMEYc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O3s4nwP4BGBb5HKlu5ukYJ/bpThN/vS4WSGpRivtcGUMQnQTV52IgDFuuF74OMYcf
	 wmFR9jLarkMa985pnTG2SnlRIKqUSujcehPYVznnxd0aQ+UOoLbMA3uMJbl9B9N7hv
	 03uEW07CzM69b99mUiZDwVJ0crHZxA5MZSxOsDBw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aldo Ariel Panzardo <qwe.aldo@gmail.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 6.18 0906/1005] nfsd: zero NFSv4 COMPOUND tag padding
Date: Wed,  4 Nov 2026 16:10:39 -0500
Message-ID: <20261104211108.561442248@linuxfoundation.org>
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
@@ -6051,8 +6051,7 @@ nfs4svc_encode_compoundres(struct svc_rq
 
 	*p++ = resp->cstate.status;
 	*p++ = htonl(resp->taglen);
-	memcpy(p, resp->tag, resp->taglen);
-	p += XDR_QUADLEN(resp->taglen);
+	p = xdr_encode_opaque_fixed(p, resp->tag, resp->taglen);
 	*p++ = htonl(resp->opcnt);
 
 	nfsd4_sequence_done(resp);


