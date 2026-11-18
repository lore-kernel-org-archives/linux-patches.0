Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051869;
	b=Y/h5l/rp1sevmkxYQd2C0w1wf2mordaBozRPhQ/h8flq2606upXA0L1OvHvSpKzIh4D0
	 qbPHfh56xmJm2Gz04Yv9RNSMEAmAchc0z+S2F7JJ1Unv3y//F4B4PGnlOni6oz4edBbbP
	 stviv4Muu2O0MNmZT7WFKgO5xVk55Z63trRHtk5WPx3qBtgST/n7kAb29WPiPCqII5and
	 H9Ef+a0AEI8i63V42rZ01Vh10GxYEV2qpDx/eAG8t8kVlR/I9gDzTeKVQumOzaNwQ0fck
	 txaxALfmA6gauGQGTsIgkRgCe01iZj8cm8Mj0ugO8B+cjrdPjtTQ+Jz571bpmzmgbWQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051869;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JfwucbSp6sjsiRMiPlpbNWrLMYl3KHoKGJEeHsHzxeI=;
	b=XNnMYVWxhyFq6r68LB9/vmtEEHJVxtJPQLaEKnsiVdATZP8+gKNOeJBDyGOeT9t9THj7
	 F3I6iv8xgsDcnPuagmNoS5L+cXF1Z9XR0sqFQGL/I7sqBoXor5J+85pTNx8ysrYeWgC0g
	 P260CEj3kh6MsDs1hFqDbbCeI3xlJ1vBsyJXfr1Fktst23QU+zN/GL8c5BpnPJNkOMxp0
	 JL3v8qGtxVJ4SWSP3oP6HE+fOqkuYKyzxOyVn/SvQx0croDyylOfzu4tN2CLp5Cm2rzqF
	 +U+uCe9Do+MMYFsRg3/TveipRARBL3Hk4wYwQfm+W/GAfVJOhlakR7JEWWTwxOO8zig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AchXCQ1E;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF13C606A325;
	Thu, 19 Nov 2026 01:31:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AchXCQ1E
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E2251F000C4;
	Thu, 19 Nov 2026 01:31:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051869;
	bh=JfwucbSp6sjsiRMiPlpbNWrLMYl3KHoKGJEeHsHzxeI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AchXCQ1EAJ+2+Mo07qtsdUU84slresYXxqjRswaoSZcKYoYipu+Cc3796CgYEBZGu
	 OAOnSNh7Qnq4Ha2bPI8oEM+Jnx0N/Da2VqjXxlvqMDE+RYm9ONkDLIyaHJx+54qxxu
	 VKDwDRJHKhLMRCvorGlGhXU70RrqSwRKlOT9uAfg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aldo Ariel Panzardo <qwe.aldo@gmail.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 5.15 0359/2214] nfsd: zero NFSv4 COMPOUND tag padding
Date: Wed, 18 Nov 2026 15:33:55 +0100
Message-ID: <20261118150025.050352123@linuxfoundation.org>
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
@@ -5546,8 +5546,7 @@ nfs4svc_encode_compoundres(struct svc_rq
 	rqstp->rq_next_page = xdr->page_ptr + 1;
 
 	*p++ = htonl(resp->taglen);
-	memcpy(p, resp->tag, resp->taglen);
-	p += XDR_QUADLEN(resp->taglen);
+	p = xdr_encode_opaque_fixed(p, resp->tag, resp->taglen);
 	*p++ = htonl(resp->opcnt);
 
 	nfsd4_sequence_done(resp);


