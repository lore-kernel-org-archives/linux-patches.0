Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059143;
	b=Cn+fltnok8ZyX90CKgiOtfg5tq43CTm9kO4YFwlVNNhNJjQr3C+Cs0/pTNs8ULFk3o7o
	 p/bGwBmU8iK8dapE86MOhh+d8jB+mLat+dzUzqWeFpeKBVvN+MTlMkUnq5cG3bI7d6pCN
	 GZ3YEiJ8ohZiPSzIhm3GanrptdjYIuXX1jClZNiSjJHbY9GA9FO1kys1pFbeEB4h/IVA7
	 ZQVjpD0M6cwPybYTU8pN6Z6K3PcMX8WySQNwHjjaVPne1p6vCX8JkN6VJuAQuZIMiPaFA
	 0RInk/JRSB/YAXbmHNKqb/OU5DGIzCy0PEvpsHUpn7Jnefk4jhjHu2MCjrwPkeETXRw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059143;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SYkDVaZST3QYmLQLrwDQ/z/AZUjzUtExtABXm1OCoug=;
	b=DCHSEOfjsNR7zyvQ4zv/sKaTHBAIgLAB1u1lA8xmU+hiV8lOlosNjTVFRbnO5uQYTyD3
	 lneo0JxkY4pINKvVkoXejGsAzV4G0ZEUHhefUTcqEUbtqPyrlWNV5zwofQMrauvj3TV5r
	 DNMUQBlwWfqPk0SFAMVPTtuQpCjGqYgao2pLkehx5qmpvqSr+3CleQaLyZ8yrfrBKQqBZ
	 k09v+Q3DCRmevznYNfdLKPy1hQTe3K6AbI0YqBlGu0GcuQydL8X1CVgGX+XOBEW9NH4vG
	 Q7o1Z+1nIwE3yspuY9ojTUsmcumkOdIZW+FjMcERUf6P/HzAMdSbygtVLbOB5OTB1kQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Exa1PkWU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A593606A320;
	Thu, 19 Nov 2026 03:32:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Exa1PkWU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 908EA1F000C4;
	Thu, 19 Nov 2026 03:32:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059143;
	bh=SYkDVaZST3QYmLQLrwDQ/z/AZUjzUtExtABXm1OCoug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Exa1PkWUtTvwaEJ4CjFHOcfwofRqSXiT+PZRXCmTZbilz6g3agH+uda78UCaKS8Ha
	 uTsJi/ivJzqAXHWFC1gQCzPV89FOdlvg66OLCgPNG06J0wt1s3qz8+UAbgbIe3fIHZ
	 B23zCvLwIhdvnD3f8KOYU+bym0cu5xQtVdGQwQo4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matheus Alves de Almeida <matheus.aalmeida@inf.ufrgs.br>,
	Andrew Morton <akpm@linux-foundation.org>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Pedro Falcato <pfalcato@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0710/1848] fat: hold truncate_lock in fat_write_failed()
Date: Wed, 18 Nov 2026 15:45:48 +0100
Message-ID: <20261118145945.600937006@linuxfoundation.org>
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
index bab9b202b4966..4b5eca334b268 100644
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



