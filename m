Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057878;
	b=oCNBzdw57aQfY8aROeFZETTKU1x1prQn4xQMw0Yr6y+UsWFo9hUJFyrS9oHDrYGXMZPS
	 RPHijtouxEScauwWrPAAfSY0P1GGJ1cz6+6YFN6BfLXPyZLVdra+j30Fk8uju+2rT51tE
	 olNQ8jGz2JTsG2ZXCzApMVRZwoewNv1zIdPavh23PR/jIMTZ7mFLH8FrN2/mmhjNBreuh
	 qamy/qougQn4iP9TAroXkIKFd1h7qfaXmLBFHSJsQQyKLRJykFvDVA+z6pXT/bBPPDesc
	 YTpImXXxKGaUtOXp6Mu7q+0B8sl4+9qFv3TNeKoEqmYEyY7C/ex2VuPu2slagY2q3xQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057878;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=opIVg9lamoFI4lW/dzJKbFR/uMYRzGW1sgx4ZZEvXts=;
	b=31jqnR2MHJk8x0drzKJm3jkvZCfOTNe6f6s/atwe4cfi3crh50o3AE7sCmvcw0xxeLxy
	 VYKgP6YdabNq27YOVUYNNIeJ9I1TLf/khuKjZC/4KzP+CGw/atEG6sBYExZY5ASmF/bKa
	 TfOfY7rs42Dt62D1r5SaZJkk+bWtNWJ3Hl+4BwuxJ+12H9XF3alrmHrw10CzR9Kc35vxI
	 hViTgA058X00X93HlWUjK3ddCQW+0Nfj2aDmlQAWTf5p4ILclHU58xxfGTURYLQCEN+KC
	 gFiim4ntJzCyQglAEc1lSZieUhs1O5W91bVu4/iZaTtywkRnQcPfSmtOOy4ejkKIUxg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="qHH/cZuu";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23FF5606A325;
	Thu, 19 Nov 2026 03:11:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qHH/cZuu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F0F51F000C4;
	Thu, 19 Nov 2026 03:11:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057878;
	bh=opIVg9lamoFI4lW/dzJKbFR/uMYRzGW1sgx4ZZEvXts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qHH/cZuuAO3QucpYIBEWpxWSsYPoPhXMmaZC1a7iKJ3SpjPh2esK/tdGf7sPlQ1zx
	 aKZkZr2KQgPjtBpbSm7pvAlnRzOcx3LwuU68pOuRmmFFg6jE7RxvU0YNXTeiEx020P
	 VbxyssYsrwjrV8aqvO3x1LGih85x1O0aMZ3xCDts=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Coddington <bcodding@hammerspace.com>,
	Anna Schumaker <anna.schumaker@hammerspace.com>
Subject: [PATCH 5.10 0286/1848] NFSv4/filelayout: Anchor page coalescing on pattern_offset
Date: Wed, 18 Nov 2026 15:38:44 +0100
Message-ID: <20261118145924.126742340@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -802,7 +802,7 @@ filelayout_pg_test(struct nfs_pageio_des
 	unsigned int size;
 	u64 p_stripe, r_stripe;
 	u32 stripe_offset;
-	u64 segment_offset = pgio->pg_lseg->pls_range.offset;
+	u64 pattern_offset = FILELAYOUT_LSEG(pgio->pg_lseg)->pattern_offset;
 	u32 stripe_unit = FILELAYOUT_LSEG(pgio->pg_lseg)->stripe_unit;
 
 	/* calls nfs_generic_pg_test */
@@ -814,8 +814,8 @@ filelayout_pg_test(struct nfs_pageio_des
 
 	/* see if req and prev are in the same stripe */
 	if (prev) {
-		p_stripe = (u64)req_offset(prev) - segment_offset;
-		r_stripe = (u64)req_offset(req) - segment_offset;
+		p_stripe = (u64)req_offset(prev) - pattern_offset;
+		r_stripe = (u64)req_offset(req) - pattern_offset;
 		do_div(p_stripe, stripe_unit);
 		do_div(r_stripe, stripe_unit);
 
@@ -824,7 +824,7 @@ filelayout_pg_test(struct nfs_pageio_des
 	}
 
 	/* calculate remaining bytes in the current stripe */
-	div_u64_rem((u64)req_offset(req) - segment_offset,
+	div_u64_rem((u64)req_offset(req) - pattern_offset,
 			stripe_unit,
 			&stripe_offset);
 	WARN_ON_ONCE(stripe_offset > stripe_unit);


