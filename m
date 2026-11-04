Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831736;
	b=fEMfe4lIf0b2udjvSx0eLnpb7GA5au3r2KQk0P/MlrMcXbm3UOOIdc9GXlVshNDSGPDg
	 hTPXjEN+Y7V6xAFsmNTPZIGD/xYT6v1zxpKI8DWsN3CXbdrv7fLdSbW8PJIVAWghJJDAK
	 4nxQImnd8ehEHDrj8DvNi0C6d/6jNfmIKAGuCW4+fqDAqR4dOhkDLWBJdiooapnlvEyRU
	 KXn/+dZRv8yfhC/ZRm6yM0cWZNAFwxJnObE+kFBC/bDAevP/J9kceTj9k4VI+IVRHjgCO
	 lEciuIo+DwYoXioOGlP3KvjB58X7ymiFQ5Qdqqvx0k+wVvlnE3L2a8YK7HO6axQCWJQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831736;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Ftktt1dWiDkvYAsHzpwMYyyEaVFpUiQp9cyuX+bKjIM=;
	b=vWAUfqBxfvkx9CgmivNp3oP/R16lN6UuBnNk+vsy4CLkUnDAz6tQypLksoYHaVQx0YTm
	 9BmAIrtuUeGzJcUfOAWyCvEVmZj1OlIru/k8xqkahlt7/gqArEI7uCJ3ww/IlRL+H6L5m
	 FDYEet2MvTeD2oilFmkyab65U1ZeKBGLPnHUW4vv9iitaLsf6nparnZEnxm3jiCIhJnAM
	 Egf7/AC0wiwibGnfCiZDcu26IoQMlOl3aa47el5/HFe3rSsK8bJ2si8lZxBBa+dhV13Au
	 296iXbet0s+Khn/ILGQazOKFPzECRPLfZ0goOJE97VwFB6EhaebUVe2N+zDCfcSBXWg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="rlyb/YGj";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28ACD606AB28;
	Wed,  4 Nov 2026 22:35:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rlyb/YGj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7C7E1F000C1;
	Wed,  4 Nov 2026 22:35:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831736;
	bh=Ftktt1dWiDkvYAsHzpwMYyyEaVFpUiQp9cyuX+bKjIM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rlyb/YGjFA8DuoTCE1cay3N2fbmIj/GWgP/N6NZNkxLFz4HF8Sh+BGfbV6BXdk7+j
	 gTsBmmkVGS45QN9ZCPvs/NX/6UqQaLiFkI1N72MX3i1+K9sVoIvJvFYSp1x6mbKqmR
	 GNYCXTmtvmBk0rz6PnESyBoBIlI94eaXqcqxvg+I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Coddington <bcodding@hammerspace.com>,
	Anna Schumaker <anna.schumaker@hammerspace.com>
Subject: [PATCH 6.18 0881/1005] NFSv4/flexfiles: Bound page coalescing on the absolute stripe offset
Date: Wed,  4 Nov 2026 16:10:14 -0500
Message-ID: <20261104211107.918548805@linuxfoundation.org>
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

commit a84c62c4f03706b2c2f01dcc5fe614a4233ee75d upstream.

ff_layout_pg_test() was copied from the files layout, which partitions
data servers relative to pattern_offset and bounds coalescing with a
segment-relative offset.  Flexfiles has no pattern_offset:
nfs4_ff_layout_calc_dss_id() partitions on the absolute file offset
(RFC 8435 Section 6).  So when a layout segment's offset is not
stripe-unit-aligned, the segment-relative coalescing window is shifted
off the absolute stripe grid and a coalesced I/O can straddle a stripe
boundary, sending the bytes past it to the wrong data server.

Bound coalescing on the absolute offset to match calc_dss_id().  Aligned
segments, including all whole-file layouts, are unchanged.

Fixes: 4934ccbeaed3 ("NFSv4/flexfiles: Read path updates for striped layouts")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Benjamin Coddington <bcodding@hammerspace.com>
Signed-off-by: Anna Schumaker <anna.schumaker@hammerspace.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfs/flexfilelayout/flexfilelayout.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/fs/nfs/flexfilelayout/flexfilelayout.c
+++ b/fs/nfs/flexfilelayout/flexfilelayout.c
@@ -998,7 +998,6 @@ ff_layout_pg_test(struct nfs_pageio_desc
 	unsigned int size;
 	u64 p_stripe, r_stripe;
 	u64 stripe_offset;
-	u64 segment_offset = pgio->pg_lseg->pls_range.offset;
 	u64 stripe_unit = FF_LAYOUT_LSEG(pgio->pg_lseg)->stripe_unit;
 
 	/* calls nfs_generic_pg_test */
@@ -1010,8 +1009,8 @@ ff_layout_pg_test(struct nfs_pageio_desc
 
 	/* see if req and prev are in the same stripe */
 	if (prev) {
-		p_stripe = (u64)req_offset(prev) - segment_offset;
-		r_stripe = (u64)req_offset(req) - segment_offset;
+		p_stripe = (u64)req_offset(prev);
+		r_stripe = (u64)req_offset(req);
 		p_stripe = div64_u64(p_stripe, stripe_unit);
 		r_stripe = div64_u64(r_stripe, stripe_unit);
 
@@ -1020,7 +1019,7 @@ ff_layout_pg_test(struct nfs_pageio_desc
 	}
 
 	/* calculate remaining bytes in the current stripe */
-	div64_u64_rem((u64)req_offset(req) - segment_offset,
+	div64_u64_rem((u64)req_offset(req),
 			stripe_unit,
 			&stripe_offset);
 	WARN_ON_ONCE(stripe_offset > stripe_unit);


