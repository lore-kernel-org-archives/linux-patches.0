Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053336;
	b=aUlhiCOqr4Vx3xK0x0B2lGMN65C0IK42LPwk+ghRiw14vQ+HXeJJW+TCXHxvk/SNSbrb
	 9NwivKQ5PQi2PaZQbzQAWtjkT/tqjlAUE+VrvHDkfdgxF0v4Rp6Td/3iMbfRZD2LOQQ5R
	 HCERzEKo7zIwuGg8NP+jj5pAKSs7l45BSvMxpK3VneHskxXU+oRFTasS+tfdWkWw1gj/U
	 sIb0oY1HOQbjbPGU+/xPiSSW5cPox8NxFmR6silOGK2SNgTQq1Bq4L6vSvUmezygVWjBd
	 hK3f7A0ZrmXUe8Mgm/ibg20jbMT+wM5NtmbAR/1LaXD08fVCIDZsE0WrhgQxeLfyzow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053336;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=shJDy35+5QVpEq+OM204EE8A8xkyc4K1FrpAurLuUag=;
	b=UOvTSCLxmjLwNHDK3sO09na8Z6Vhf2ybXebQiDBnINQojmy4n86wEl+UPVjq//SUQlOT
	 IQSgGVqUwwdDvvzHlapyT3AAmhsC4UP3EGyNnZjmYXE7dhc71snMq62nfmT6fZ5WKyMqz
	 Scscn4W52E803IvHxjrvfzOU3xVcEIvSDWj4WjCTCV2wCIAtS7T4uW83v13K+yz7fdjG3
	 MfLLnV+hNugIKAYX9HO2DhiphIXMkJrCxMgyJGp6/3lH9RDLWqmGNZvYuZZbEydW70fkM
	 KHoRZ6GHpOqbjYy+sZcDUAWyGWVfSbb9I+EIy3H5a29fK30xA+TPZ4PhBWdF8++SuNg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xpT2+zQf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D7A060A2606;
	Thu, 19 Nov 2026 01:55:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xpT2+zQf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 604891F000C9;
	Thu, 19 Nov 2026 01:55:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053335;
	bh=shJDy35+5QVpEq+OM204EE8A8xkyc4K1FrpAurLuUag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xpT2+zQfO66rfVgDoc5egnZKUXHnQmCkrqB74A0yvK/DlTC1+/Ksgr+6BPeaGhB5Y
	 Pki9fBV65swE8J5/e8jY4JFASd4tFBX6Ab8edI6VhrjnIHtZzG4/yKC0tLU/J5E6Kt
	 OYPDCVVDMy2ZA+8oEJ5I6NQX9tWA8Ye1LVo2lRlU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matheus Alves de Almeida <matheus.aalmeida@inf.ufrgs.br>,
	Andrew Morton <akpm@linux-foundation.org>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Pedro Falcato <pfalcato@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0881/2214] fat: hold truncate_lock in fat_write_failed()
Date: Wed, 18 Nov 2026 15:42:37 +0100
Message-ID: <20261118150047.422989101@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matheus Alves de Almeida <matheus.aalmeida@inf.ufrgs.br>

[ Upstream commit 7b90009546f5d3f3ac9428040cd7ffbdfd60f2eb ]

The current fat_write_failed() implementation calls into
fat_truncate_blocks() without holding truncate_lock.

A failed or short extending write racing with FIBMAP can spuriously make a
FAT filesystem read-only.  FIBMAP bounds its lookup by i_blocks, so it can
walk allocated clusters beyond i_size while fat_write_failed() is removing
them.  If the chain is shortened during the walk, the mapper can report a
bogus "request beyond EOF" error, triggering the default read-only error
policy.  Hold truncate_lock for write around the block cleanup to
serialize it with _fat_bmap().

For comparison, fat_setattr() correctly holds truncate_lock during
truncation:

	down_write(&MSDOS_I(inode)->truncate_lock);
	truncate_setsize(inode, attr->ia_size);
	fat_truncate_blocks(inode, attr->ia_size);
	up_write(&MSDOS_I(inode)->truncate_lock);

Make it so ->truncate_lock is held exclusive while truncating.

Link: https://lore.kernel.org/20261021162105.62525-1-matheus.aalmeida@inf.ufrgs.br
Fixes: 16fab2015099 ("fat: permit to return phy block number by fibmap in fallocated region")
Fixes: 459f6ed3b8c7 ("fat: convert to use the new truncate convention.")
Signed-off-by: Matheus Alves de Almeida <matheus.aalmeida@inf.ufrgs.br>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fat/inode.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index de0c9b013a851..185e6f6c68151 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -221,7 +221,9 @@ static void fat_write_failed(struct address_space *mapping, loff_t to)
 
 	if (to > inode->i_size) {
 		truncate_pagecache(inode, inode->i_size);
+		down_write(&MSDOS_I(inode)->truncate_lock);
 		fat_truncate_blocks(inode, inode->i_size);
+		up_write(&MSDOS_I(inode)->truncate_lock);
 	}
 }
 
-- 
2.53.0



