Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023609;
	b=wx+eZjOwlHPCi0lMQUgB1QLUaxU0zFLUbS6RC6/N/pDYNBW9tBxeAMP9o0FU4kJeHPQj
	 zj4aYq1qGXdJdMLV7zzkZZhAikkJKWk8jHzRNEahXr8GUTaWT6D7VAYigCdjgBIC1/PGf
	 iUSlxknano3lshKdEuzfI8s0OmsijTZhPCqby6KGxU3mMKnuUC8pu9n2hkNZ79hHqI4zF
	 i9BqrT4SkBCg+1cFI/k5b4ucC6iC00bzRUlYBPaNctA2pcsOEreEG6LC3vnmMyvt9DJPZ
	 9HK0vGfmFh2hY3L7ZUDLzH8QM3xOfbLCqJtgbIrXs2HWfksOB9npUeIiDhHvzgP58IQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023609;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8M0nDIthW7gF5yv2FcXBHPzbZIqQY+IAcjUI6k02Ca0=;
	b=BfU5x7+NSjaB614Q0Ztv4re2ycU2zodwWa09eb51LnplAIRWnuAPEOGnzSUoTSStFfW0
	 /H7ywrtvH77s1PhIu4yTOUfF6Ng/CTNxM1bfgGIdVj2+bzQC32C9Si4D5lC/XqUopdmx/
	 +eGwzORTAmDS5GCyFNS6/X7JSYcJtc21OKxvy6zHXSkgHtPUGIDsCbARy9saOB4PnJrMe
	 SfJoF1i629O0tIXAb9VoSSAP7w99XCetK7Fa6tfkGBuhjkpitdoj+4m0i3qar6obozczo
	 uZ5ozL3G3yrw/Fbvh1yKEtEoVabktooqcNJbOidCGLErokIFg3B2vIB01G7xZPdwBzw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LkivBt8e;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43F87606A320;
	Wed, 18 Nov 2026 17:40:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LkivBt8e
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A3D61F000CE;
	Wed, 18 Nov 2026 17:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023609;
	bh=8M0nDIthW7gF5yv2FcXBHPzbZIqQY+IAcjUI6k02Ca0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LkivBt8etzsoqj5yGe57spmWMoPcsPfD85mpGqKM60fghNL9tbpG5kAzG/rSW/q9e
	 +VfK569HiZdgX0lmO3Qb+yxUl1/rOV0phi7S/w9+suIRGDtN1nqsHRq9GX/mSnklC3
	 5C2ehk5UiaglMOpTQE3g2Y7cGS24VUfFGjZpR284=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	VEGA <vega@nebusec.ai>,
	Jan Kara <jack@suse.cz>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0389/2151] gfs2: Fix journaled truncate range end offset
Date: Wed, 18 Nov 2026 15:35:24 +0100
Message-ID: <20261118150136.240562723@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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
index 836e260099c39..119e01c56d6a9 100644
--- a/fs/gfs2/bmap.c
+++ b/fs/gfs2/bmap.c
@@ -2413,7 +2413,7 @@ static int gfs2_journaled_truncate_range(struct inode *inode, loff_t offset,
 		if (offs && chunk > PAGE_SIZE)
 			chunk = offs + ((chunk - offs) & PAGE_MASK);
 
-		truncate_pagecache_range(inode, offset, chunk);
+		truncate_pagecache_range(inode, offset, offset + chunk - 1);
 		offset += chunk;
 		length -= chunk;
 
-- 
2.53.0



