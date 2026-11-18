Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019433;
	b=0koB72msOtRg5Cep8t1YsQAtsbp4nd/A1efgxrvPzoTl+yCo5KJ8gElWsqb641uY/VqR
	 6xb9WPDHftAJ4DH6OQr52j5dcXVvSaGhg5nkILGA8vKKVwyGlnCDPgsjlXkqEYce4zbg0
	 l2sdplhSUGOIy1s7FWCxgCZZAKehVXBTL0iQJk+bwSw53Bww91YJ8ch1gOGRcm7B+HeSc
	 7e4LKZ5eUcNwzgJEyt8VIaLG5L5CO4QoNLmIML5foOOg9LOHe7iyS8y0VySsE2Bdgh61M
	 NXJL4OPbzJLhhdfiARmINiAZRmQk43Z7h/lkphFzRU/QQ3yvzYRcIZQtdZuLqMjk0LA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019433;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Fd5VQHxYxlb5BG89vJjTYdZKbLGtf7fsEjiV2Ojp5yY=;
	b=Jo+obh7HsIO6dRBiyvMedLgOEC2vaPHZ5oNys/1HJ0zBPRkAjH9xdQVaYt4jRayMtQqP
	 iD1dT16YqGK3MQ7jDAbpX7I6WcpSA5522CzeBPdg1NQXDjU0A2kN6XiG587XXBIwYyeeU
	 4U4MerYwFbqadXdhbJEa3xnS+wNUzrrszLiqAZnUkwrxv8BTqaBRbz8pjFBTzuZjIY58k
	 mJoRkoyHhjlLZRUpSGplXG9VvZaFUr1dKY35h1AHiLEzeH0QtALc3qili857upqOdCHAC
	 nYONjYI0+fMeGgVRgCb80qcFbHn+22VAyiy4/l5SH9GZkQJ7IJAji5W7on/rPULNydA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XU2ygycI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B1E660A262C;
	Wed, 18 Nov 2026 16:30:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XU2ygycI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAA281F000C4;
	Wed, 18 Nov 2026 16:30:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019433;
	bh=Fd5VQHxYxlb5BG89vJjTYdZKbLGtf7fsEjiV2Ojp5yY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XU2ygycI8dRKRrWsBoOHrYy1E7EDVYVTpVU9kj2nmxsp9vZ7C82NxpUTdUh2W1SK9
	 G0K6K2nPsZVANBi+R7Fj3aLly+JCAzKC3SoJ+QAQIzEAehINUXmNWGOyuqvFWoeSah
	 I5YrdpnpY5kw/W0pZxx0oBCGDI8iO2MREJDp8wgA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Bo Liu (OpenAnolis)" <liubo03@inspur.com>,
	Binglei Wang <l3b2w1@gmail.com>,
	Gao Xiang <xiang@kernel.org>,
	Chao Yu <chao@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1594/2651] erofs: fix xattrs handling when metadata compression is used
Date: Wed, 18 Nov 2026 15:47:14 +0100
Message-ID: <20261118150345.282232924@linuxfoundation.org>
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

From: Binglei Wang <l3b2w1@gmail.com>

[ Upstream commit 6b722cefbf83558af07586ca94cdb4b370d5a82d ]

erofs_bread() reuses a cached folio on page index match without
checking folio->mapping.

xattr.c calls erofs_init_metabuf() twice on the same buffer without
erofs_put_metabuf(); the two in_metabox sources differ, so buf->mapping
can switch while buf->page still belongs to the old address_space.
The next erofs_bread() then reads the wrong mapping, dropping shared
xattrs with METABOX.

We require folio->mapping == buf->mapping in the reuse check; otherwise
drop the cached folio and re-read via the slow path.

Fixes: 414091322c63 ("erofs: implement metadata compression")
Cc: Bo Liu (OpenAnolis) <liubo03@inspur.com>
Signed-off-by: Binglei Wang <l3b2w1@gmail.com>
Reviewed-by: Gao Xiang <xiang@kernel.org>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Gao Xiang <xiang@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/erofs/data.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/erofs/data.c b/fs/erofs/data.c
index be63b89f08622..a726be5e27ca6 100644
--- a/fs/erofs/data.c
+++ b/fs/erofs/data.c
@@ -33,7 +33,10 @@ void *erofs_bread(struct erofs_buf *buf, erofs_off_t offset, bool need_kmap)
 
 	if (buf->page) {
 		folio = page_folio(buf->page);
-		if (folio_file_page(folio, index) != buf->page)
+		if (folio->mapping != buf->mapping)
+			/* the cached folio belongs to another address_space */
+			folio = NULL;
+		else if (folio_file_page(folio, index) != buf->page)
 			erofs_unmap_metabuf(buf);
 	}
 	if (!folio || !folio_contains(folio, index)) {
-- 
2.53.0



