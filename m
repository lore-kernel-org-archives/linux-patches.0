Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029469;
	b=4eUOIfqhmlwjgtiDYqt2VL9TrthDtMofcX5EL7DLzJqvCeFphjBrMDDqm+U2aNJm1eWE
	 cqqFF5k5KcLoCpWA3JFUBfV1S81rfMaMdtgp2KH8D00n7A2TuN/RABtW02QCmoNrWz51y
	 OeNkzg/d0LZ+AXSjydOB+izxlKd5FF1SdJjpp5uqRiIC19G2hZVHSTnSjO0u9nW7uN+vv
	 iVFDvWG6S2SXKmmmHtL3d/KDtD44lpqrrZriy9e77SaDomx8/G9Ossk03tO23Mstdyy+B
	 YHRkruySYSeilp3B48rhf+V1X1oXjiGzTN4+HSDo4hBWL7kNOWff6q34wa7PJzTjdag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029469;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NUpVF8QYPwUeWIsoNfA2RugqCJy0H26QUH0BuJhCfmo=;
	b=o/syo6c5eXSyek9Y6VdW3Kqddw8PpFSMMlE+NvjH4wqgJYMSSKeCR8lWTB5xpNxFkQ2a
	 lu1pVgjc/LuAX3o6Xeio7Jj4wkO9KQsrvWqoazD2kTNjI4bee0VALaW79QLKZJRZejL/j
	 FDeoNrp3g4O7xO7WdQ2xHLynFvcTwiCcSQVk6bpCcGnUUdZCoQw2OqKKO3y36PXQGMaWr
	 VQIblknrCPyDInvqL4unyGVchoeRxoGlCKHtrRioiSVuEB0dkQkEMrRUnYts2aCrj73B1
	 XMduo1gmI91mSkE4q+OK70KiOMM8hLPhXQrlUCLr2tx4mHawR/OnIqVf0GX416ragCQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TMTbOynQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EDCC606A31C;
	Wed, 18 Nov 2026 19:17:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TMTbOynQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF0AB1F000C4;
	Wed, 18 Nov 2026 19:17:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029469;
	bh=NUpVF8QYPwUeWIsoNfA2RugqCJy0H26QUH0BuJhCfmo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TMTbOynQ+QrvYOedwJodx4lXHKoMJv+d2eisaXsndhXSt8TZ+mHYrQ0YCsc87ydNv
	 oeIs7Sm7pblNnqH7CvezZuH9TR8H8VLT36fSg2PB5zJV7rao2uGWVRy9GQi+VRD056
	 5V+kZ2H2sSqoM5GGsL13vv2QbMSGust9adx6xkyw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	VEGA <vega@nebusec.ai>,
	Jan Kara <jack@suse.cz>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0359/1756] gfs2: Fix journaled truncate range end offset
Date: Wed, 18 Nov 2026 15:41:26 +0100
Message-ID: <20261118150022.622056983@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

From: Jan Kara <jack@suse.cz>

[ Upstream commit a52652efd8f985397e87669f505af83f06e335cf ]

The third argument to truncate_pagecache_range() is the inclusive end
offset, but gfs2_journaled_truncate_range() passes the length of each
chunk. A hole punch at an offset larger than its length therefore
creates an inverted range.

Commit 86066914edff ("gfs2: Don't support fallocate on jdata files")
disables fallocate for jdata files.  Otherwise, the following bug
could occur:

The MM truncation path then underflows the unsigned partial-folio
length and passes an oversized range to folio_zero_range(), triggering
a BUG. Pass the last byte of the chunk so page-cache invalidation
covers the intended range.

Fixes: 4e56a6411fbc ("gfs2: Implement fallocate(FALLOC_FL_PUNCH_HOLE)")
Reported-by: VEGA <vega@nebusec.ai>
Assisted-by: LLM
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/bmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/gfs2/bmap.c b/fs/gfs2/bmap.c
index c87ce7d10bd18..d02df07dcfbdc 100644
--- a/fs/gfs2/bmap.c
+++ b/fs/gfs2/bmap.c
@@ -2407,7 +2407,7 @@ static int gfs2_journaled_truncate_range(struct inode *inode, loff_t offset,
 		if (offs && chunk > PAGE_SIZE)
 			chunk = offs + ((chunk - offs) & PAGE_MASK);
 
-		truncate_pagecache_range(inode, offset, chunk);
+		truncate_pagecache_range(inode, offset, offset + chunk - 1);
 		offset += chunk;
 		length -= chunk;
 
-- 
2.53.0



