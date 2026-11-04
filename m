Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831735;
	b=1gki1o7TO4xtQPYKdpfQagu5Mjt8BaJFMA/coJOGCU//M19peJg6scYC5Pj/WGttAvc9
	 jr2SSCrvrw+guWOwHJulgPmhumzXPYDUA1CPYPgyqOuszhzPZPwHS8IjkWDf+q/bTvoIf
	 Chpx1KoW76KIAtcbyYstdgscYnsMnRER+oglsPpbTyIdXq9HlJvLPyEzN4wLGq0E/Buhs
	 tzISTmeDvkVYOMv+sBHltuJO7rK5e/VU3UUXZG9sHGXKwPdNHSwWzAmqDVvRkNcnfS5EA
	 XjfImd+UfqZyKWKKMClC2n1ekUjKYS0o+CHASKxKgugrfjUmY8FSUmSTxmTVF9v4XlA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831735;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3Gp/DtZYIYJre8PKfbWZ6n+hHr406hW9pPiU05I9txY=;
	b=T2NB4N1engG7R/kKawIzFnyYIrPEpR0xnM+n+Sfqu64mZObQ/iVVYYFfFhL60JLWFr80
	 A6AEabYeQluxEf76jVw2xh9lgRFRdoM3c+N95thGwwBkSwu7ta7DHQKV8sxXNluch5ARD
	 a9Xt3el6h0xATsCtMFMCfgF6dXGqB0RAGT1UOlvLbD94VE1bU7xV1eeQNevVGH0KSy15Y
	 EWZNt/t/0FYCGZFZocAUPeTEiOT9Q5DaCOFGsAEtm1VT+DcKzPgOZTbdcuXI19SQwc5Mw
	 xwTFEHuQxxoBQeyJRlWT7qL5PxE7N9/bwa4wKxMdUz2zLbc9b9R9nNOYkgkz7sSkwxg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="K6/IVrXF";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D060C606AB28;
	Wed,  4 Nov 2026 22:35:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K6/IVrXF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32CCB1F000C1;
	Wed,  4 Nov 2026 22:35:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831734;
	bh=3Gp/DtZYIYJre8PKfbWZ6n+hHr406hW9pPiU05I9txY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K6/IVrXFPS4YACk89vxd3enq1H+79aWI1O6EG/NUOPE+oO6XnksonHZi4lFk+CtIz
	 tWEANkM/cR+J6cW3DMSSQEsqsbktCdhH3ZvCbwlAx3YfCzoub95/WrQp+2YMqvs7Qb
	 c0mB1e9Xi7UytuRhPtuUYiWIm7kxomwHfll1/A20=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Coddington <bcodding@hammerspace.com>,
	Anna Schumaker <anna.schumaker@hammerspace.com>
Subject: [PATCH 6.18 0880/1005] NFSv4/flexfiles: Use the full 64-bit stripe_unit
Date: Wed,  4 Nov 2026 16:10:13 -0500
Message-ID: <20261104211107.893417284@linuxfoundation.org>
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

commit 0cc1191538b1523dfe944eedc799fdd146c05fbf upstream.

ff_layout_alloc_lseg() decodes stripe_unit as the 64-bit value the
protocol defines and struct nfs4_ff_layout_segment stores it as one, but
both consumers narrow it back to 32 bits: nfs4_ff_layout_calc_dss_id()
divides with do_div(), which casts the divisor, and ff_layout_pg_test()
copies it into a u32 first.  A stripe_unit that does not fit is silently
truncated, so the client stripes on a unit the server did not specify --
or divides by zero, if the low 32 bits happen to be clear.

Divide by the full value, with div64_u64() and div64_u64_rem().

Fixes: 20b1d75fb840 ("NFSv4/flexfiles: Add support for striped layouts")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-fable-5
Signed-off-by: Benjamin Coddington <bcodding@hammerspace.com>
Signed-off-by: Anna Schumaker <anna.schumaker@hammerspace.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfs/flexfilelayout/flexfilelayout.c |   12 ++++++------
 fs/nfs/flexfilelayout/flexfilelayout.h |    2 +-
 2 files changed, 7 insertions(+), 7 deletions(-)

--- a/fs/nfs/flexfilelayout/flexfilelayout.c
+++ b/fs/nfs/flexfilelayout/flexfilelayout.c
@@ -997,9 +997,9 @@ ff_layout_pg_test(struct nfs_pageio_desc
 {
 	unsigned int size;
 	u64 p_stripe, r_stripe;
-	u32 stripe_offset;
+	u64 stripe_offset;
 	u64 segment_offset = pgio->pg_lseg->pls_range.offset;
-	u32 stripe_unit = FF_LAYOUT_LSEG(pgio->pg_lseg)->stripe_unit;
+	u64 stripe_unit = FF_LAYOUT_LSEG(pgio->pg_lseg)->stripe_unit;
 
 	/* calls nfs_generic_pg_test */
 	size = pnfs_generic_pg_test(pgio, prev, req);
@@ -1012,21 +1012,21 @@ ff_layout_pg_test(struct nfs_pageio_desc
 	if (prev) {
 		p_stripe = (u64)req_offset(prev) - segment_offset;
 		r_stripe = (u64)req_offset(req) - segment_offset;
-		do_div(p_stripe, stripe_unit);
-		do_div(r_stripe, stripe_unit);
+		p_stripe = div64_u64(p_stripe, stripe_unit);
+		r_stripe = div64_u64(r_stripe, stripe_unit);
 
 		if (p_stripe != r_stripe)
 			return 0;
 	}
 
 	/* calculate remaining bytes in the current stripe */
-	div_u64_rem((u64)req_offset(req) - segment_offset,
+	div64_u64_rem((u64)req_offset(req) - segment_offset,
 			stripe_unit,
 			&stripe_offset);
 	WARN_ON_ONCE(stripe_offset > stripe_unit);
 	if (stripe_offset >= stripe_unit)
 		return 0;
-	return min(stripe_unit - (unsigned int)stripe_offset, size);
+	return min_t(u64, stripe_unit - stripe_offset, size);
 }
 
 static void
--- a/fs/nfs/flexfilelayout/flexfilelayout.h
+++ b/fs/nfs/flexfilelayout/flexfilelayout.h
@@ -220,7 +220,7 @@ nfs4_ff_layout_calc_dss_id(const u64 str
 	if (dss_count == 1 || stripe_unit == 0)
 		return 0;
 
-	do_div(tmp, stripe_unit);
+	tmp = div64_u64(tmp, stripe_unit);
 
 	return do_div(tmp, dss_count);
 }


