Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793830961;
	b=uS7SmJigHhUd+cAjbmziUuH2DhEnVSiE5iMXKyptPrM/DN7JS387U0WU9iAE1zMkrKJD
	 NipqmN7AZa9uopuAnMcU3q4xYyuOhWKf0PM0vh8GkHQKcRla7c37ff+m2u4zAKVq5YIKz
	 F8NRyVM/cncvIeTjgAvT7hRnPYOmVXU/dGrjrX54ErYDei169us8jzK9r9srIogeOvrnb
	 6mpplWaGl+n9U3K6ATR1av3DCMBLfWkOwEUWJIIvKv6PTEve0dGWYdQgwUIUdi8j2azbA
	 tXoaAOnd6FMGePnsvRgkT+E4xvitxD8LIXPiU3z2eDdp6VzqY3dP7wiDj46mLb7eulQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793830961;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6T5w+JfUGVuf2SHLTUhFWpNp8FuJh2cc1YnUYKgQwMw=;
	b=274czjwFrAJRpDNE4ryT8c8CLx44cXcFUBv9Jr1jYEUKYThKMBsMmKSu26xxzpBqypKK
	 gS1tQT8F/hzWGNFPSePfXI64MHmWmoQ3auD2hT0SHHK8wtGOH9sXoyPxkUcqZujlhpbVT
	 l0r1K9ukqK1bYRWbvmywoGGNg7WoLsB8bPTWtZYHtHdyA7fGs4rjmr5VE0Itl9oX58fpu
	 S0uFQEOV4xIQIRtwmC5dJvlpa6Wkzcl2mF8eyLkQi583mKH26AuCMG+C86TggnEmLdbyM
	 HKIR61mCkH6RsTKxCr7mvcIeNG/LqL+P5l7Vm3/yx3kXBv+ibEMtBPrGtSxxLlXMb+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SzMdlOco;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FCDF606A876;
	Wed,  4 Nov 2026 22:22:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SzMdlOco
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF3E31F0093A;
	Wed,  4 Nov 2026 22:22:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793830961;
	bh=6T5w+JfUGVuf2SHLTUhFWpNp8FuJh2cc1YnUYKgQwMw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SzMdlOcoDZjyw99Ph9X5TRJI75HP6THxga5uMB0e0Y8PSWCUjh2rXdc46L7lDDwnO
	 KlVBCfAh+EOLYbm982Wt9MDyQTI+DV+LEGZFw66Q68p0jhRsoFHtL+gjXdFKY5kvy/
	 9eTEanEPuD4XeBq0BQVcqlFWR3NqHmVLCKMPb7hw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiaming Zhang <r772577952@gmail.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0387/1005] hfsplus: validate extent record length before writing it back
Date: Wed,  4 Nov 2026 16:02:00 -0500
Message-ID: <20261104211054.927208740@linuxfoundation.org>
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

From: Jiaming Zhang <r772577952@gmail.com>

[ Upstream commit 627b7865c062ff642c0000f3a4775f1a44b986a4 ]

__hfsplus_ext_write_extent() writes the cached extent record back into a
B-tree node using fd->entrylength as the length, and fd->entrylength is
derived in __hfs_brec_find() from two on-disk values:

	fd->entrylength = len - keylen;

A crafted image can keep both len and keylen valid but make fd->entrylength
negative (keylen > len). __hfsplus_ext_write_extent() doesn't check
fd->entrylength before consuming it, and hfs_bnode_write() takes the length
as u32, so the negative value turns into a huge one. The copy then reads
data past the end of hip->cached_extents, which is only
sizeof(hfsplus_extent_rec) bytes long, and leaks kernel memory into the
image.

Reject an fd->entrylength that does not match sizeof(hfsplus_extent_rec) in
__hfsplus_ext_write_extent(), mirroring the check already performed in
__hfsplus_ext_read_extent().

Link: https://lore.kernel.org/lkml/cbd7003314c530d4f910eacf019ff80adad6687e.camel@dubeyko.com/
Signed-off-by: Jiaming Zhang <r772577952@gmail.com>
Reviewed-by: Viacheslav Dubeyko <slava@dubeyko.com>
Link: https://lore.kernel.org/r/20260810092422.1691377-1-r772577952@gmail.com
Signed-off-by: Viacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/hfsplus/extents.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/hfsplus/extents.c b/fs/hfsplus/extents.c
index 8e886514d27f1..11c990d18ac8a 100644
--- a/fs/hfsplus/extents.c
+++ b/fs/hfsplus/extents.c
@@ -110,6 +110,8 @@ static int __hfsplus_ext_write_extent(struct inode *inode,
 	} else {
 		if (res)
 			return res;
+		if (fd->entrylength != sizeof(hfsplus_extent_rec))
+			return -EIO;
 		hfs_bnode_write(fd->bnode, hip->cached_extents,
 				fd->entryoffset, fd->entrylength);
 		hip->extent_state &= ~HFSPLUS_EXT_DIRTY;
-- 
2.53.0



