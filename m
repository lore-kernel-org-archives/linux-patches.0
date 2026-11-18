Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044581;
	b=vOGIn6UBsiAQq3yWqKfBJl4Nxe8ZeOTANzkZJZFwE67d+xW7Wd9v48gMYcNM2aU1ypPX
	 bBPEiMApFOeWcUtN+TqwF/xH73wOI62tWUV8l4TB596x00m/1GWPcbbXqG8jEQmtewghi
	 A7TAUt5IRDA9Op+Y960HFxDr2lO9nXREnXo6xNkmuVc3pCY9XcokgbJeMZsPoQobL4KPt
	 kY1Vr+QXnj7CsDxTiIAy22MNaT5/u1LAoBd1T9y7TlLLNkZ3z2c9nooV3b94qcnbk3ado
	 KZJ9AYjFaHA/2jB/x024ZTdNq21UyTDIs2uq1HA6Sg8cqqaSluEFpj/ozbGyo4Yj2CA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044581;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zZ3a81sAsrDTtFnhlQQdmmNItbI2EvKb/DjzVA3SuSA=;
	b=KNUOZr5ToQ52SbIEYVTL+hCOSE+pDeLFeCWxPzWtg2nngwlbrIu26iQyxcKYjwse/tdm
	 w7bSOziF8bRViU+26HSkjbWZdY+XDW6F98xRrgwlgS2Kbr0Ob4el9kYVs/Unp/mEz/EiK
	 qZMFBkHvBANHCDflJrGJQuzcSxPTT02XCDVO7nR0ztkSYrOaX9TOEZkJ1QtjdAKpE9Ewn
	 hGwhiltrX7Z1FPjFp2FWJw1kvv3RAmOTCnIlWIC2SUmOlBPuhdtGhs+uDP5TR2cN31cRX
	 vAhnfjlBUXD9Es83fJRKx781oeshB7/AiLGZ498snNgBSShbA9mj+9AwaXD4xLfP6JA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KEP3z4Ui;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11EAF606A31C;
	Wed, 18 Nov 2026 23:29:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KEP3z4Ui
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AEFC1F000C4;
	Wed, 18 Nov 2026 23:29:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044580;
	bh=zZ3a81sAsrDTtFnhlQQdmmNItbI2EvKb/DjzVA3SuSA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KEP3z4UiIhV8P4mLQwp34UHpnlE1ahu84ZWjIKowFenHZDw3yyojt9qXZreUkL5Za
	 DZlH+q4lLPyCSELAmubb8oLp2CWSSXkqvlLkclUeE744NpzDh/kF4VnW+cx7sIWpRZ
	 S3O5QJ1Ut+ORLwAe0Jne7X98FQJZoGfPg92OuIrw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aldo Ariel Panzardo <qwe.aldo@gmail.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 6.1 0616/2857] nfsd: zero NFSv4 COMPOUND tag padding
Date: Wed, 18 Nov 2026 15:27:30 +0100
Message-ID: <20261118150223.670799046@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


