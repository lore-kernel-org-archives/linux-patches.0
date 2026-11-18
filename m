Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029790;
	b=zn/fbJ6ARpgSTXBAehdkfXGwa1zTWu13TddIiviyJT81iI5YZrX9HUSjR+7+aoHXfk+w
	 jl7eWkZ3i7XaaZcJ1JNtdZ7fsW/PW5T1nly09ObvOkUCjChUO3p29Zolhh/PEFrG4MTlE
	 R6GTbLs4N3NcyI1utvnjVlay//JnDApf5/BWoyEwYxX9wuerCJ9MDKWTrJx97w4y2o5TP
	 nR/RWaGVlPWwFm6O1OUzLGSB9WJ5hXwjlJqutaI5hFp27WvxFd/NTZgpf5ckVulYT6znh
	 BKlWPL8LLSps+bYBvE+nX+N+hU4ErDn3bBMwyVdEwN53c9BYSpm14J2AeS4aRxBCWrw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029790;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Tphv1WVgJnEq18pC8bD78GQTS+K21i8/ewosSobE8no=;
	b=dglD3FpsyfQjLB3F/1bkOSWkPJtlFoFtZczjv/v8JWPsxhm8EppZYUPZzFVLomp53Hs4
	 QxCI5JBZwoymZ7h4BYk6DZURyq/WyPiHAuqT8x4d5gDlRUQM8kLJy1C1A6CCcIVU79E0H
	 zJj5T0ND9HYQ3cLsMY2IAuX+hHx3vq4xRzddMt7R/kgiiClz86iIZ9ybGbE+8jrRhAv8n
	 f9BnqY99M9lZgpQlYYv09CkzcBC6+gEcMxNuPZ9H8osdRfI1P2IZ6PIiujP+Zjn/Y8aKb
	 /i4wP5gK0P/uLUBo78ypNrCd64+n5hRsFcBvj6EC8QY4Mzx3kP3IjDkUDSDDsO8FAEw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hi1nfDLT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C3F9606A31C;
	Wed, 18 Nov 2026 19:23:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hi1nfDLT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB29F1F000C4;
	Wed, 18 Nov 2026 19:23:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029790;
	bh=Tphv1WVgJnEq18pC8bD78GQTS+K21i8/ewosSobE8no=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hi1nfDLTeDfPHDDtRsgkS8yeMKmzYeKA71VQcYEEy9PlWR7fz+7vgm2RC8u4hngwx
	 NQpw41xP1jdCDlJ7LYNdDd/NQ+pTVduZdDSxKuwFTLJaakG3hd0X4ob8V5J6swSSUz
	 2518ERBz1CHsE9LhScVbYHxRYyGLLK5t13aTm0Nc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhan Xusheng <zhanxusheng@xiaomi.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0476/1756] fs/ntfs3: fix valid_size not being updated in attr_allocate_frame()
Date: Wed, 18 Nov 2026 15:43:23 +0100
Message-ID: <20261118150027.847125314@linuxfoundation.org>
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

From: Zhan Xusheng <zhanxusheng1024@gmail.com>

[ Upstream commit a1972501ffb15313f7ae598989bb2cd32829e625 ]

At the end of attr_allocate_frame() the on-disk valid_size is meant to be
updated to the value passed in via @new_valid:

	valid_size = le64_to_cpu(attr_b->nres.valid_size);
	if (new_valid != valid_size) {
		attr_b->nres.valid_size = cpu_to_le64(valid_size);
		mi_b->dirty = true;
	}

but it writes back the old valid_size that was just read instead of
new_valid, so the field is never actually changed even though the record
is marked dirty -- the intended update is a no-op.

ni_update_parent() spells the same read-compare-write out correctly a few
hundred lines away, storing the newly derived value:

	valid_le = cpu_to_le64(new_valid);
	if (valid_le != attr->nres.valid_size) {
		attr->nres.valid_size = valid_le;

In practice that path, reached from ni_write_inode(), re-derives
nres.valid_size from ni->i_valid on inode write-back, which normally masks
this, so the visible impact is limited.  The assignment here is still
wrong though; store @new_valid as intended.

Fixes: be71b5cba2e6 ("fs/ntfs3: Add attrib operations")
Signed-off-by: Zhan Xusheng <zhanxusheng@xiaomi.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/attrib.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ntfs3/attrib.c b/fs/ntfs3/attrib.c
index dc928a9a272af..bfb192ec29950 100644
--- a/fs/ntfs3/attrib.c
+++ b/fs/ntfs3/attrib.c
@@ -1868,7 +1868,7 @@ int attr_allocate_frame(struct ntfs_inode *ni, CLST frame, size_t compr_size,
 
 		valid_size = le64_to_cpu(attr_b->nres.valid_size);
 		if (new_valid != valid_size) {
-			attr_b->nres.valid_size = cpu_to_le64(valid_size);
+			attr_b->nres.valid_size = cpu_to_le64(new_valid);
 			mi_b->dirty = true;
 		}
 	}
-- 
2.53.0



