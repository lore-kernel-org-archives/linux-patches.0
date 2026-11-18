Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031621;
	b=iesCFH4L1LGkololcur9gfGkK2NZKCB+tgl4bPG/W7aIvY2d/0KNmGyS9qFAmJe2Stii
	 PcTXiJDSd5F+zmwd3ZwMjqxeScDl3dHZkESbeqW6c6BXtA8EHIR+0G5LAfJgGForH+b8m
	 IuCKI1MGPkRN4FxE5bEKFfu7U0MwToLkUOeDdz0ZQSVeyCbpPZotz8dLG+ZtjGIjHXlBo
	 4XhuLj3T1jHvmky0Ed/GaDL5EUdiLONnf6Ql/ZdYSUmH4b6g7e560NMUV14lakbG35Pxm
	 XUxG4Iid+WMTzehSDctxkZASUe8tLYhyZ6l2Lp79HzB2o1bypGXoLv90eL2PvGGadmQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031621;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=m0R2p71HcYP+4+DmLSa+mcWwR71MUuNaM5aPNv0M/Vs=;
	b=XjTm3ihsV4+xd4n4hehGlvt162oOE+lk4OzkemoC1wYgHfVJTws5VJIqLJYoHNMKC8J/
	 AAGyqEgLWf5uC2huULhqE+Vv4jwskNEI9BTxAwQjiTKCt3JhBRtCgpLTg55nHDFen98GV
	 44VNpoSAekGqZa8abPuedZuyIJPf7MrsZw2jMvhoyQgb8wN6/seLy4tDcUItzBoVAb5zX
	 LrH99H3inT5U25cgPpM/dXREkgP5mDRUgF1+Jez4+j1hte1ny3wp1RgE8hC910B2RUUsa
	 eQSisncsyUxebz/zf/AmUpSjTj1KE1t0TufHHoRo3Q4enOBA+1uVoCNk0rF6O4Pwt2Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BeH7z2KG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44AD2606A32C;
	Wed, 18 Nov 2026 19:53:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BeH7z2KG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E2601F000C4;
	Wed, 18 Nov 2026 19:53:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031621;
	bh=m0R2p71HcYP+4+DmLSa+mcWwR71MUuNaM5aPNv0M/Vs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BeH7z2KG3SPP+w/IUfCBmk5bbdUsUgDKrPOOd/vCYWxTX8wnlRQ+aNQkDUrZ/qDvB
	 uQHZwEccE8ZW+RCuQkEvaNyWamru3miDg3YNNZUf+okDI7YQtUDjvZBfMDOyakYLxz
	 kP981fsJEElLFsx24PDdXr1641tgMDtxZIcjvbso=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Mei <xmei5@asu.edu>,
	Weiming Shi <bestswngs@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1122/1756] fs/ntfs3: do not mark frame pages uptodate on read error
Date: Wed, 18 Nov 2026 15:54:09 +0100
Message-ID: <20261118150054.775261493@linuxfoundation.org>
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

From: Weiming Shi <bestswngs@gmail.com>

[ Upstream commit 80218408836fa6fc91a9c26a9c014f81abf9e41f ]

ni_read_frame() ends with a loop that marks every page of a compressed
frame uptodate regardless of whether the read succeeded:

	out:
		for (i = 0; i < pages_per_frame; i++) {
			pg = pages[i];
			SetPageUptodate(pg);
		}

Non-critical frame pages come from __filemap_get_folio(FGP_CREAT) and are
not zeroed. On an error path that reaches out: before frame_mem is
written, these pages keep uninitialized page-allocator contents but are
still marked uptodate. A later read() is then served from the page cache
and returns that stale kernel memory to user space.

For an unprivileged user mounting a crafted NTFS image this is a
repeatable kernel memory disclosure.

Mark the pages uptodate only on success; on error leave them !uptodate so
the read path re-reads them or reports the error.

Fixes: 4342306f0f0d ("fs/ntfs3: Add file operations and implementation")
Reported-by: Xiang Mei <xmei5@asu.edu>
Signed-off-by: Weiming Shi <bestswngs@gmail.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/frecord.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/fs/ntfs3/frecord.c b/fs/ntfs3/frecord.c
index 609b90a7c3191..7e5c13a42e44b 100644
--- a/fs/ntfs3/frecord.c
+++ b/fs/ntfs3/frecord.c
@@ -2479,7 +2479,6 @@ int ni_read_frame(struct ntfs_inode *ni, u64 frame_vbo, struct page **pages,
 	u64 vbo_disk;
 	size_t unc_size;
 	u32 frame_size, i, ondisk_size;
-	struct page *pg;
 	struct ATTRIB *attr;
 	CLST frame, clst_data;
 
@@ -2710,11 +2709,10 @@ int ni_read_frame(struct ntfs_inode *ni, u64 frame_vbo, struct page **pages,
 #endif
 	vunmap(frame_mem);
 out:
-	for (i = 0; i < pages_per_frame; i++) {
-		pg = pages[i];
-		if (err)
-			clear_highpage(pg);
-		SetPageUptodate(pg);
+	if (!err) {
+		for (i = 0; i < pages_per_frame; i++) {
+			SetPageUptodate(pages[i]);
+		}
 	}
 
 	return err;
-- 
2.53.0



