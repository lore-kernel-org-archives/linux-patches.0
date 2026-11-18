Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035387;
	b=wgse4EJQVO8U8vMnm7vVLLJyO92cI6gqW2Asb4ZDdSCDmkM9qLbS2yo4FRtwKtC7AY7K
	 uUc8xPSnD9msMdyxT7KPffJrxaCqxitv7nzDrnX9U+wBOGgKOAVgmHB0Cgnvr2esQr5Q0
	 zVAnaE/XoZxbcUqnMHLcIpwcCacJ3NuxEgXXs1k7W8N6Uja2vdnyOS/Z8ASdkGRr/pB0L
	 X61nv/iXNdN4Z/j3JxvCSONHYRBCtPZ2+896V/u0Iho4F+tlXX4jk8EJ5s5UKcaU0+Kmj
	 NwAY78aBrIeAj78DlfjtQ5vSOlexmt0dJHf4O4HNcFk7td2pZk9+iPdl/CZUWhfDPTg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035387;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hT1p2MvR86OcsyusZstD7G7Rns+tOSFmwe8hOCAFq6k=;
	b=vjIROZ0hDARCM4dICLY9HjlHCoorE0/hzR/wrfSSkqHAQyw9Rq7FhjgHltwDsFP4ivw/
	 ymdixlMhA5iD8voB6sw0v2R9IbM3RziSzh7gv6DXqvBD8dSo7J6zRlWOtqADqS8UA3NNJ
	 AzSbGbKh0q8CrJj7vsJU+pS/Y/g0dq9yZkAzcuTpb3zsSS0pw4NRVs8D5q9QWq2+Tp5LD
	 E5X/CLPptofmcrD9KHTMwwEw7+lx1anpwy8kH8IHJZaUdh9ALBexLrfszOzz7E82xp/fc
	 YrB2WKYZGjNvY/iV6WePt/ihy12h/RgV4NsrCjRNSz0cH5AYBbpfGHYZGaosIFpA1lg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IGp4c8aZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE3BD606A325;
	Wed, 18 Nov 2026 20:56:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IGp4c8aZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CB4A1F000C6;
	Wed, 18 Nov 2026 20:56:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035387;
	bh=hT1p2MvR86OcsyusZstD7G7Rns+tOSFmwe8hOCAFq6k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IGp4c8aZcnQuXs+9HsEdtgSmJWpmCB3FbXXJ5FHCxFwD+hE5qsAD4OJXSYMte1PFR
	 R79ntMZi0bdsOQNsExP8bgt7JAuMDwy3PkEd2vLZ3Y1BihozEI9c/bhc7juzsYas2b
	 FZWyurEAlkBYQLF0J+tEC4sZ5iaUKoRIUnqkMxGc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Coddington <bcodding@hammerspace.com>,
	Anna Schumaker <anna.schumaker@hammerspace.com>
Subject: [PATCH 6.6 0684/3318] NFSv4/filelayout: Anchor page coalescing on pattern_offset
Date: Wed, 18 Nov 2026 15:21:46 +0100
Message-ID: <20261118150338.733313208@linuxfoundation.org>
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

From: Benjamin Coddington <ben.coddington@hammerspace.com>

commit 7f2d221b01f356b6bb3bb6efef998f8b28339824 upstream.

filelayout_pg_test() bounds page coalescing to a single stripe unit
using an offset relative to pls_range.offset, but the data server is
selected by nfs4_fl_calc_j_index() using an offset relative to
pattern_offset.  When a segment's pattern_offset and range offset are
not congruent modulo the stripe unit, the coalescing window is shifted
off the DS-selection grid, so a coalesced I/O can straddle a stripe
boundary and send the bytes past it to the wrong data server.

Anchor coalescing on pattern_offset to match nfs4_fl_calc_j_index().
Stripe-congruent segments, including the common whole-file pattern_offset
0 case, are unchanged.

Fixes: c6194271f94b ("pnfs: filelayout: support non page aligned layouts")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Benjamin Coddington <bcodding@hammerspace.com>
Signed-off-by: Anna Schumaker <anna.schumaker@hammerspace.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfs/filelayout/filelayout.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/fs/nfs/filelayout/filelayout.c
+++ b/fs/nfs/filelayout/filelayout.c
@@ -804,7 +804,7 @@ filelayout_pg_test(struct nfs_pageio_des
 	unsigned int size;
 	u64 p_stripe, r_stripe;
 	u32 stripe_offset;
-	u64 segment_offset = pgio->pg_lseg->pls_range.offset;
+	u64 pattern_offset = FILELAYOUT_LSEG(pgio->pg_lseg)->pattern_offset;
 	u32 stripe_unit = FILELAYOUT_LSEG(pgio->pg_lseg)->stripe_unit;
 
 	/* calls nfs_generic_pg_test */
@@ -816,8 +816,8 @@ filelayout_pg_test(struct nfs_pageio_des
 
 	/* see if req and prev are in the same stripe */
 	if (prev) {
-		p_stripe = (u64)req_offset(prev) - segment_offset;
-		r_stripe = (u64)req_offset(req) - segment_offset;
+		p_stripe = (u64)req_offset(prev) - pattern_offset;
+		r_stripe = (u64)req_offset(req) - pattern_offset;
 		do_div(p_stripe, stripe_unit);
 		do_div(r_stripe, stripe_unit);
 
@@ -826,7 +826,7 @@ filelayout_pg_test(struct nfs_pageio_des
 	}
 
 	/* calculate remaining bytes in the current stripe */
-	div_u64_rem((u64)req_offset(req) - segment_offset,
+	div_u64_rem((u64)req_offset(req) - pattern_offset,
 			stripe_unit,
 			&stripe_offset);
 	WARN_ON_ONCE(stripe_offset > stripe_unit);


