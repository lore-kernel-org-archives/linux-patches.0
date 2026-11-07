Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061709;
	b=OrR1o8v3JlPflmYgvxxsATqJbFVu8xBqaug43SqzOxUaNQ2HhMH0PuOgeVDag0jQqmUf
	 TzsCI6Va7wkgtMG9ojZfzwkNwY79Ex2itNRx8rvOKlEwrzhf/J2RiRSCbjABwP7utMQHF
	 zo+1XzBTzCg1cXWvcwAp6mUYwHD25xu3uy4yS0/AAzRUePq9NA0SoOJENAVe6Z45xBK7h
	 DgO+i6vNc0rkNcXcehlphCNbDvd9/8nn5DulXMxRMA0LwUl0+j9NRiCz+jFT38t77fU5Y
	 FYhPP6ajdAe/YEnmfOI9wDB4NLzc7u69hB5YLfDHj9AIQKTl4wXjXHd9SvkaxrTJqSw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061709;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YFEI5O4JF2n/A9osu1pFw1HjoaZDUBsZV6GpTQ4LjOY=;
	b=Pt342D4PaZtPPiH85JeRQYAP/BKY7GW7yO1yXE0QmUiOYxa+2S1v+pHzVzWPh5EqETwE
	 sBP++yLPxuoU4j9mtKSSuPDVcTSig8UOt7jkkYoNZKzGhbtqzPCbqJNMK1k4K5sFIE5AW
	 oYa6FWj1ql89EulzWkRxxxg0lbNC2+4Ln9jgp1v4fyLlQN6QqM7sk10XnrUaliOQUgsTR
	 UCaPYE46fdrD2rDojZhOwQ7c9CaTLICjts1LUQzgZ5/rYAeOw65aPC48LNh/pMneLYpX1
	 YSw7/HelC+UYj05Qdb+JJWwcviOLQ2R2c/xoivLFRQP45TxC+gMTgeZNG4W8J7U6DKw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yr3m4fBK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45E65606A326;
	Sat,  7 Nov 2026 14:28:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yr3m4fBK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4B441F0089F;
	Sat,  7 Nov 2026 14:28:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061709;
	bh=YFEI5O4JF2n/A9osu1pFw1HjoaZDUBsZV6GpTQ4LjOY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yr3m4fBKiluzVtK+v2EgsKpvnJ2NKXMnrH9VngNWJei8Ds2DxeR2QUTlLMWIH8h9y
	 1EXsRItlLBpHkvpIdCjM/pKye4y75hqVXZfXRb5DL90MzOWfd1rkH7LhMUM1PRCD8F
	 2v2H+dq71z3csUBX64Q7jZQLFNfyZuvWCLFXyFQ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Coddington <bcodding@hammerspace.com>,
	Anna Schumaker <anna.schumaker@hammerspace.com>
Subject: [PATCH 6.12 0757/1536] NFSv4/filelayout: Anchor page coalescing on pattern_offset
Date: Sat,  7 Nov 2026 08:46:13 -0500
Message-ID: <20261107135018.794542269@linuxfoundation.org>
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
@@ -796,7 +796,7 @@ filelayout_pg_test(struct nfs_pageio_des
 	unsigned int size;
 	u64 p_stripe, r_stripe;
 	u32 stripe_offset;
-	u64 segment_offset = pgio->pg_lseg->pls_range.offset;
+	u64 pattern_offset = FILELAYOUT_LSEG(pgio->pg_lseg)->pattern_offset;
 	u32 stripe_unit = FILELAYOUT_LSEG(pgio->pg_lseg)->stripe_unit;
 
 	/* calls nfs_generic_pg_test */
@@ -808,8 +808,8 @@ filelayout_pg_test(struct nfs_pageio_des
 
 	/* see if req and prev are in the same stripe */
 	if (prev) {
-		p_stripe = (u64)req_offset(prev) - segment_offset;
-		r_stripe = (u64)req_offset(req) - segment_offset;
+		p_stripe = (u64)req_offset(prev) - pattern_offset;
+		r_stripe = (u64)req_offset(req) - pattern_offset;
 		do_div(p_stripe, stripe_unit);
 		do_div(r_stripe, stripe_unit);
 
@@ -818,7 +818,7 @@ filelayout_pg_test(struct nfs_pageio_des
 	}
 
 	/* calculate remaining bytes in the current stripe */
-	div_u64_rem((u64)req_offset(req) - segment_offset,
+	div_u64_rem((u64)req_offset(req) - pattern_offset,
 			stripe_unit,
 			&stripe_offset);
 	WARN_ON_ONCE(stripe_offset > stripe_unit);


