Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829122;
	b=spe/IG/b81+s+7Cv1+pkE/JA/PxHgwD+yGmETfXG3tTAOQzLk5LFX5zRuFqD8ZMTjKTH
	 IVBq0bWHuuYWau05FZHFzPpNBbphSuCXNPhr6YCbYkxqp1Ywi0zAQvHtcTkHNLxuIDHsC
	 k617GuWPY5OH1e9wzgAbS71NdJVTMmKHtTS9c4kGU7gaVfF8s5jxblU0yagYic7GcjLf4
	 EVMWxHuE42sFvSXgBcEzbVm0skjfugVlOi+LDgFrNUTXdJfYbNWyyt/oRqqOStq65e6PE
	 pDbcEm72ayCeJNQzGxTTdET+Vwy4ke3bx7cFEiOPLkkky9cLI/ZAX2WNuxY02mP/9cw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829122;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Hh5vZe2DJRxPLoR5+qV2Gs7197MqgAHbRTGnu36AJps=;
	b=zzhs6gifg4Hdr5u7Wz2XI9CGwsgSjaw5G8OcwlOv4ClInVuYqgpe8sXOyUOjcXEZ/zLi
	 7jnjkNLieKgN4jlCdYK2q3BljKQVBTRmENVBq0Raj8n/QWvy4QcEG2Iq81k15zcNxTWCZ
	 cnYanwZKSALKOB91NGps0SyXslWBrdII89SBici1Zi0gQaMZszSekQWoMfroQ//KowkmY
	 r0P3Knj57+RGc20dwR6c/xaSj5b2e8z09hUqt9U/E/zrAOtPN4GSEV2YuzDwq4aG9iX2P
	 Wr4hFwksfHEWvzt77K3KdaY1AZYS8zYJyf9xSKw2El4jLrk+sNwDi/OKXTlCSSPXUlg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1ys07BjE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D9F36083633;
	Wed,  4 Nov 2026 21:52:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1ys07BjE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFF631F000C1;
	Wed,  4 Nov 2026 21:52:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829122;
	bh=Hh5vZe2DJRxPLoR5+qV2Gs7197MqgAHbRTGnu36AJps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1ys07BjE1dRmSIanpiq+6aom9lF5g3DGf49APfphZyNIgnzOcNbAlT1iEAGb8JyD+
	 3B9ys80ATo58ucnSHxGMXaQj8zxLkGXZi1odIRJ7Dm6EIaoBWOqvMShr/m/cNMzmKM
	 QquLwC+8DRNEVAiu/kf+7lQh31oq7qClQiAgl2BU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aldo Ariel Panzardo <qwe.aldo@gmail.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 7.3 433/547] nfsd: zero NFSv4 COMPOUND tag padding
Date: Wed,  4 Nov 2026 16:10:17 -0500
Message-ID: <20261104211050.650587282@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
@@ -6788,8 +6788,7 @@ nfs4svc_encode_compoundres(struct svc_rq
 
 	*p++ = resp->cstate.status;
 	*p++ = htonl(resp->taglen);
-	memcpy(p, resp->tag, resp->taglen);
-	p += XDR_QUADLEN(resp->taglen);
+	p = xdr_encode_opaque_fixed(p, resp->tag, resp->taglen);
 	*p++ = htonl(resp->opcnt);
 
 	nfsd4_sequence_done(resp);


