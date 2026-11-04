Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831728;
	b=mrQ/axkFScp3zFFeDzp1oFBUAz0h4WO3ZIQJf1oUjBxYboO2x5BLpWXWvKFDHhoRTfxl
	 hsXhXAjxf2a/2EweshDIWqRhb8ciJO35vWcQSD3XUfhX5XR8X8sOzCekngQKG8gLAb5WC
	 IgJy4OEuYAHlKtd+zs1vy6rwtFMznW22+IPvWSXhZ795ePd4ZHGkWZTfajydH36OFZbEm
	 YKLjtuFYXlAMQEjUWKBbkMz+VZxXoOkqCEY3rSAX4Bg2EHIQWIFy0m6bjndxA+F+Dfhfq
	 a8PFm/n0prW8azoVL4uvm4vJfbARr1Rhn3I3CutDI6/lQYnyPzzlNK3+UQv043JyQ/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831728;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MXdyztOkoUIF/MY4EG3Ev+5joYjKeRacNX9+s53tt+c=;
	b=j6sr9APa0WScWJRuruEqkzPRtuuq8zkGwRXuFsuKpS/mSzYmhlqR8+FsfdYJcorYo28Y
	 5quCZ6D2AVYQV/WDZE+uZOVmgVza8qUVL6Tncckj3EgDNpuFd/hv/LWdchiV4tH9+v/9j
	 NvwpLLMxpq0Fcv3YlPZpVE0uOUZs6q9ofGgWOY31huFDlYUULGcdiBczz8WDahNa/b4uL
	 psR4YftjtPJcIKG2tW212yt1ItonFzmgcZgKMJNI9dNqEFOpnfQNNH8rKrB9sAVyDOsRn
	 3RFASwHLFI9q6A8NH91nxY1novpZFSI4sGmKknFiOiyXX3SjD72oQe2lby6fAe30vsw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MujFOT4c;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC73D606AB1A;
	Wed,  4 Nov 2026 22:35:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MujFOT4c
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8614F1F0093A;
	Wed,  4 Nov 2026 22:35:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831727;
	bh=MXdyztOkoUIF/MY4EG3Ev+5joYjKeRacNX9+s53tt+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MujFOT4cZGqSTRcYx1OGyVSAQ6EryjNIPUj/MtzUYr7icd9BTWfhpxjKTZ/VnhQBG
	 fAPl79rEDX5r2Qb3WPK8jhWPBVlJD3ubxW78fbSVlwMhynApcyOUrxJUCMCbCvc8G3
	 zOb7al9bmDYX5mVI9yn5OKxPxOjR62xoF2r9QSxQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Coddington <bcodding@hammerspace.com>,
	Anna Schumaker <anna.schumaker@hammerspace.com>
Subject: [PATCH 6.18 0877/1005] NFSv4/filelayout: Anchor page coalescing on pattern_offset
Date: Wed,  4 Nov 2026 16:10:10 -0500
Message-ID: <20261104211107.814902731@linuxfoundation.org>
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


