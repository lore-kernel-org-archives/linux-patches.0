Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051828;
	b=AH9/xmvHSzmQB+Q8/uneFdSHoGYbKUciofRKgsvitmaubJicjlvO/xW/l9ERExsHufKa
	 lDlLQ1vVGLGK3DnYvB+4cFRU7aM98Tv5frqlYRZeUvpshDumT9+asrP6lkYqNM5x0L9hE
	 BQg3EF9lIlsZbhyetlgXOYfC2M13XDsm04rsgDnXeEIIlToCs0l90fy5GDiWL4S8pSuBZ
	 mNje+OoJy9FS/w51S3J23o25XkIRajdalzlX2nfYyyxW9RQImBIiU0oEmg1GvdI5QnMyh
	 K8Orj2rB+dfm+FLTV2UAxnhhpFdEdMq/1I3HhQW0E/iHdh3fSJSIdtVXmZkD7horePg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051828;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=17XWqEycDfR55z0RsGKmF5s/A99V03wEtpigjgw6k40=;
	b=fgWZ/eGSN6VqumgWcWeotFbM4+Z8M43FGtYc+aPHIymYZFjaC5OOVvDzIsjbLs+FQRIg
	 9IZ2YzAiKZei2ubjlBB1HAS1Lgo/Y5NylfDClN5qlw9Vmcb3F72dNoJacJ94CXlz1ayYI
	 43Sa3SEeY1n/6HYhv3J7ZqjRcNMNI59n9WhQ1ZrdO5eYy/3GwKV0T6XTo9G4v5TdfMviY
	 prukVycuB7RKDpuFmnxryA7ZclhFx70SHoC+yqxQoyKk1hI/5+cazSFCmEMFyb41yaTcR
	 1woX1NXBmVcCQrEVJvfQAjA/lYI+j03MUfCG/eQElPIjnaTgIxDL1HD7Ys41bMIY0/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2OFGw1QT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 163E8606A31C;
	Thu, 19 Nov 2026 01:30:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2OFGw1QT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 662B71F000C4;
	Thu, 19 Nov 2026 01:30:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051827;
	bh=17XWqEycDfR55z0RsGKmF5s/A99V03wEtpigjgw6k40=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2OFGw1QT++MiPXzFjcmt8eFjUqO3C1/zwed8L4H/lRYPp35Vik3XlE5/1lz3AuRGw
	 bnaJ5T5GGdvMq6RWQsk16HNf2j14kJ68VRcS/sO5A9lO9w+8u6cp864nzNAyCbm6R0
	 A2mosuXM6JM50NzGEDN0X4zMF9ac9/OpNSbWUVPk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Coddington <bcodding@hammerspace.com>,
	Anna Schumaker <anna.schumaker@hammerspace.com>
Subject: [PATCH 5.15 0346/2214] NFSv4/filelayout: Anchor page coalescing on pattern_offset
Date: Wed, 18 Nov 2026 15:33:42 +0100
Message-ID: <20261118150024.554771222@linuxfoundation.org>
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


