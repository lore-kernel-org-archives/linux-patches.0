Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060534;
	b=0nV0h7JO6yux4AVJNlLGqCs2JKsWEkwPf/Nhpd8+PNWwcVzHOene/b2vpRlBd29wFCQV
	 SBeZXWM0rtZ9WYkVtvC/Yriv3a3xQERlpfyYRxFmOZwP5ovKu5JlPg6iqKfFvchRyGig6
	 mM32LxASoPn2CmLxClM0B/4jKelrNccwhBo3DMaeC2qimWDtlb2+CRVS0RfWivNgKzp0Q
	 8RjzqkOER6kWwQnwnm0jz8RVWg5PDvXblRHXqf7ns/6VmgxvIZBU6/NLRz8os3QG+9b4/
	 mRH2tCvFt//0YDzDAlHulGUgxdYQEPCYYd4I6gS0WGmLEy+IQhLjow/6Bh4g1YEIqSA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060534;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3Nn1rzJ3JDdb7qDl7yKysaCbB8AKMbnN8TA1JXO+N0Q=;
	b=c6yaR6Mqr0WEGwXyvpaqD0gOUBIW6z6cW5h2eQC62CJbg5YTltYY3Kq8Ti3Xuw+Bt8xi
	 lY2+lnISCJjHCxqhkpy17q9IKvgwYlf4/6WHS6oS8JXTB+G7rUDjLtIpE8sfn/WSzS4A4
	 84gW8K1vmpDyQcY1jgdiam8FuXjX3Zv/mBjmCLCWZhMtg8m/LyR2EUgrZY/mDNKkJzAel
	 6+TV4QOKO9enFEd0tEFoc8g6QY3T8C1/fuAqwZz7xAdnfCAEwUGf2vaIjYLUU8ls3+r7F
	 UOEulHtQ8qWVbx6zP6ZsJFwtgsMDxZQV0d6QeDKHm5FZv8/ccmLSqZ7rFMw/4ad1sGA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h56S6+d6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71C0D606A320;
	Thu, 19 Nov 2026 03:55:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h56S6+d6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C71EA1F000C4;
	Thu, 19 Nov 2026 03:55:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060534;
	bh=3Nn1rzJ3JDdb7qDl7yKysaCbB8AKMbnN8TA1JXO+N0Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h56S6+d6Xd45AcbCCK+GAH5YlhAnGdJghNuvGqXE0uaJDpxz+jdXVecF0o3dQH3/m
	 eGmEXws1OeD1GIxNi0OEmSfP5aMG39RWOqEJUniC/7kfR1pMYafdiiplZvTsjGgrKx
	 cI0VoJmgCKa14jbc5rfQWYt8YbYkFME9yPzrGCYY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	VEGA <vega@nebusec.ai>,
	Jan Kara <jack@suse.cz>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1232/1848] gfs2: Fix journaled truncate range end offset
Date: Wed, 18 Nov 2026 15:54:30 +0100
Message-ID: <20261118150011.464139029@linuxfoundation.org>
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
index 10b0151b2789d..df1eb7416c347 100644
--- a/fs/gfs2/bmap.c
+++ b/fs/gfs2/bmap.c
@@ -2385,7 +2385,7 @@ static int gfs2_journaled_truncate_range(struct inode *inode, loff_t offset,
 		if (offs && chunk > PAGE_SIZE)
 			chunk = offs + ((chunk - offs) & PAGE_MASK);
 
-		truncate_pagecache_range(inode, offset, chunk);
+		truncate_pagecache_range(inode, offset, offset + chunk - 1);
 		offset += chunk;
 		length -= chunk;
 
-- 
2.53.0



