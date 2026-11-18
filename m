Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016070;
	b=Vo0zHZqNdfF6GLlLUAGqaf/T+52Z5Q5fz66zMFn2bC5AcL+hHmcl30rbBBUJ0ZOMOS2Z
	 nGCKiQNsWALOWCLOdVIkMjfnNI/0ApoZ61jea67NaMjg11AFX5tNt49VMEjKgy54awthr
	 F0R8B/BLnPhTUjipIExUvpftanVPTF/xFDp0AeU0T78MPN+sId2MpD2bdo+sisWoJ1SCK
	 vxMFzujrkOuBUcRQmjk6kak8aZ+IckLbOYhWZVI6NDqF8OEjZJyv5OieH/0WrjNHzoeiq
	 fWbrkesvCkA7IXy76W2TsmeHGRnacKx0LwHByFJvEwq90T7MZcreU1CVmlV1gVoBuQQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016070;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FRaH5O5NsoVkoSikbdaoyuLZtl6B0GQTA6+JA9VVlzE=;
	b=uzC6JwIKneKTDkxykA13IuGDNlu8FMqTRoxQzvR4U+0NZIj0ivB20ZOTX1W5HJx1LytY
	 FTTIbxFFfwC0BJxVGmflBmFg6cTrtk8dEK/+MpDQp0CVjyziEFQ21vtM9eUulgFbflpL9
	 fOB2tVSPD1UWSFs937XobKwt/7PFXmkR8CuoI+8WyS8OSGfwkwuv4GVyTgrlw6B+0vrez
	 HlcaHudse/Se+YvuUZljmBOWgw5bY8AU9EF4qidp2bx1mKNnJoZoS6pr1holbHKz9rgeX
	 p8qDN/FHJtDjCWmWxenvqz3fyq8VDXHyhjkyZykxPEsRf1xvdqQ6M1QSTgL0IbcQTlg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dH2CrHvy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56565606A331;
	Wed, 18 Nov 2026 15:34:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dH2CrHvy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A88FB1F000C4;
	Wed, 18 Nov 2026 15:34:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016070;
	bh=FRaH5O5NsoVkoSikbdaoyuLZtl6B0GQTA6+JA9VVlzE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dH2CrHvy8yOTanQ1V+PRahsJJygVTN9M+wxU9bCM+5r7Ri6HNnZWvIn+VUVFbVFkB
	 4Viibe0Imu43ww2aJB91/RWp8wOND4PHibWZTKk5XE8QYHLsT2SJV+aHfBPkt/xYtZ
	 hlEZeNsvc6r7lDSJP833tZM3izyb8g25ul/u+u7U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	VEGA <vega@nebusec.ai>,
	Jan Kara <jack@suse.cz>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0399/2651] gfs2: Fix journaled truncate range end offset
Date: Wed, 18 Nov 2026 15:27:19 +0100
Message-ID: <20261118150302.202705857@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 73c6269711639..9c5a434b231bf 100644
--- a/fs/gfs2/bmap.c
+++ b/fs/gfs2/bmap.c
@@ -2416,7 +2416,7 @@ static int gfs2_journaled_truncate_range(struct inode *inode, loff_t offset,
 		if (offs && chunk > PAGE_SIZE)
 			chunk = offs + ((chunk - offs) & PAGE_MASK);
 
-		truncate_pagecache_range(inode, offset, chunk);
+		truncate_pagecache_range(inode, offset, offset + chunk - 1);
 		offset += chunk;
 		length -= chunk;
 
-- 
2.53.0



