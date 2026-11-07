Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061738;
	b=tPAaTXF57AbsBxDjA+BIApUQtuIkZI0Qdo8cj5k12x4KkrVUsQO5QNxaBuafsJoAqwfx
	 Pb1YEdkzuAfD+PwmadtpEk/NZHYy/suvYQWmaed2ms2z6kWIxfHzndQBmUD5tfFy4rtR9
	 Pbpx3/1qS+bBeajdNcrVBUSdJR85y/0rXgvvu0iNBis/7rjm5HhRLw/Le7g0i49BtOQBo
	 +I8vaO533bfrstgwQ0zj6xs+dJAjFoorm8r40vL0wNdEdP72Axj/OrneHwNzUuhUKEzRt
	 Bp7LjVVH80/eZV9P0ryVqI4Ib3dUnv0i15zQleR5SAMjmOhszVfH6TTo41nHujab/eA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061738;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RlYT8c87zrBQabzpRtxYahdKSjCD+Z7IPOknoCVK3Xs=;
	b=CfmuF+PZxtGFR+XUd3V3b0anQ1qamqhI9HXuD+RZad77LPBnwcVZOCHKF8eHZKLgQ+aw
	 UKZqO9BrXmmHDjdwU9DCEAqrdoR4hBicOyPZEpQpPJV8uI0NnbmCH7CGALsWVHXCmQMIc
	 B18RJLUY9J51bJRf6O1zoRyonlxvozrSXLlGQu8Ld1hlT4nOrXQJzdjaeyXuzWZLGSBsJ
	 0RLU55+s78bFlGya3MPtaFQgQ3UzPdn47KrOExe5BA57elKx23X9QdKkPg/V+Eh2Xl9cQ
	 +EkU1mLuVjr/LQz+hPAcbBPxJG/FDz1gaPRiHE6uRZmkF2b06ubWn1SIoBV9VRrfKdQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Vei/WUmF";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B5E2606A326;
	Sat,  7 Nov 2026 14:28:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Vei/WUmF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D6F61F0089F;
	Sat,  7 Nov 2026 14:28:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061737;
	bh=RlYT8c87zrBQabzpRtxYahdKSjCD+Z7IPOknoCVK3Xs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Vei/WUmFu9fSNAmnX4KsD7dI2ubo60lb0+8iV2LFSXBwJ1dq8gYTaOFmou9A4sDyS
	 XAypFIN6PgVNkhx2d0z751Tat2P8K/HT+fHEpV+cuF8G8GADDs5+aWQPJktgsPCP+x
	 W4Iazg8Hf5ASS+CFgL7rARwoD7oTVHC/pfha6xws=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aldo Ariel Panzardo <qwe.aldo@gmail.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 6.12 0778/1536] nfsd: zero NFSv4 COMPOUND tag padding
Date: Sat,  7 Nov 2026 08:46:34 -0500
Message-ID: <20261107135019.385527293@linuxfoundation.org>
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
@@ -5922,8 +5922,7 @@ nfs4svc_encode_compoundres(struct svc_rq
 
 	*p++ = resp->cstate.status;
 	*p++ = htonl(resp->taglen);
-	memcpy(p, resp->tag, resp->taglen);
-	p += XDR_QUADLEN(resp->taglen);
+	p = xdr_encode_opaque_fixed(p, resp->tag, resp->taglen);
 	*p++ = htonl(resp->opcnt);
 
 	nfsd4_sequence_done(resp);


