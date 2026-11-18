Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044537;
	b=QBn7U8ZPIDPkEeIHfbjlGdcrqQcacJK9xr+p6dTPEp/xkMRzN8igKzQb7ZdZMWjDLlpb
	 FbDup7TAJCl5I19z91xVdWtBa1HsOlRx3j8h5i3b/uftZr+CdBCzH+uxKu4Za2jyRxGV3
	 klt6ln0su+IydF1vEV+v2CJwsbmiuk/lWZG0A9BZgdZy5ri9CEQOjNgJDXNE6qMybSg5H
	 vx0/qmrBg/E2U4yqk4Fxaoq4TRMi6JUBQq5QYHfqRwO75u+VuLY1G/Vz9yUJSLd8lQoYE
	 Howq3Zwax4TQYt5e+vrnES0pkmTtMn+L1TIOKJyadZvjyac+4Uszxqs9+imdFl/jwhQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044537;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Cjwrzr0o2fU4urtYRpaSW/qjairc4iMy8CtYAHH0Eco=;
	b=WuQAAPOiTAKdmoY5u1Nq9iWaWtawmWBZw24qeCNW4sRnvLmADvAy7OPnnf6DxqmAVNBS
	 5rMrvr7e+jkGmxvtqGjxDCP6uQvm6sTN2U/psj7C7TSux44fPa7ewCwwg/SfGFnbuGdv2
	 vpmT37cZW2SagazvHsC3w3C/1lQt8CCouZUXUJOJPctqPUbQD141zLGZSNr4Lzu6OyvC4
	 6wqCZAXYFdw4l7mm7S7CTYRm0QmDsMJqwhSjD/mfrup6t9E9aosmGrsAL+rZV4N7o1/D/
	 Cy5l1QWuzZP6YiG226gysmGNq3jQNjtRvQxBc+psuhbb8G+1nBQ7YixQPDGzLE1Yn3w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=R8y3mLwj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6308606A31C;
	Wed, 18 Nov 2026 23:28:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=R8y3mLwj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 327B31F000C4;
	Wed, 18 Nov 2026 23:28:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044537;
	bh=Cjwrzr0o2fU4urtYRpaSW/qjairc4iMy8CtYAHH0Eco=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R8y3mLwjiqQpW2EGdMPzxeNKYQvL+Uy65fG3lo84zyeESV+4HuM2M65k6kaDxeNbF
	 DzZHMszn+5m9KTur1TFTXIfx1ipVwu24uTdPe11eYJ635nT/9c5VzoggOkfwJ8l2NJ
	 qT6M9AbkWh1Akfp9w5n24EfhkiWk2uzzGiCYl5H8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Coddington <bcodding@hammerspace.com>,
	Anna Schumaker <anna.schumaker@hammerspace.com>
Subject: [PATCH 6.1 0602/2857] NFSv4/filelayout: Anchor page coalescing on pattern_offset
Date: Wed, 18 Nov 2026 15:27:16 +0100
Message-ID: <20261118150223.169769897@linuxfoundation.org>
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


