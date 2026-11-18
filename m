Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051427;
	b=L7Q7KgSqdGZIBEGIqKIc1jcKYRBEqAUd5/2SASlHcWe1G4d9Bed9yGKmuhXC1bRIWYku
	 BUdsMA8aH0FmvVZbhrtq4933mB3R9+yXNL1wwVMvPiuP1aNS8MpsxxeM6NkmdsRFQrdIq
	 ut54izTPJVGiT0JQDHqZz5AXL+CmaK9bEjfmAz8PY2CD0GfW9OrZ75CUR5eXvj2X0kSAm
	 2CpiKm4pRGt+G599Hlez8uZaZm8XIKcH9LCdh7LX3eZnCvzdaHMnhgztYLOcjpcyTrXRX
	 ZP3RtrCDMFRBbVGc1Bv82SGwXtfl+B4YiU0JWYFll2mNvx5IUmBqQ5O7XEK1wNOCxpg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051427;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=diSqTv/URJyc2iPGvH+hDJkGv6vaauHlgnphCfSye3g=;
	b=xZ9TI0uz7pA/zoKjzpH05dIfDv+ZT8+q2LA53vnxSNCztYTLco7IwAqpzkSnAglgVJzp
	 OhsW+1QBlM3VN7vD7J9B38H+j5A9xKavO9IiGUt0JqbvYVVNx2+a2g01ojiBetl/ahu9J
	 Loh/pWPkak7SDCfs0JskJxWxMDQvkICRlP8rdWeSF2h2OZUNy7Ow106QDrGG762UMq0SF
	 bWj/U48pdZaEfg6QlS2P5yHeAgsHQCte0Sxw7irfgiIAa7ZHMo3jLEfCYS5BxRpk/TpQ2
	 w4yFaUEj8OPWWZeZW3bYHtxvDgQcUyUOLBWf07cIz6yiqI6FwLRMCsIoaQeXt/S4xMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HYPh4vvK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CD10606A320;
	Thu, 19 Nov 2026 01:23:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HYPh4vvK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79DC11F000C4;
	Thu, 19 Nov 2026 01:23:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051427;
	bh=diSqTv/URJyc2iPGvH+hDJkGv6vaauHlgnphCfSye3g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HYPh4vvK6R/RG32+99QN/YZ72Im/6mdMOZp08gUGB/WgpSmRbIiE9cD4wJER5We0k
	 epcmD5nnvHn8ZVL/7bxApqGheq8hJ/dI/hxBqMhTFcSh+lX6y8roXZ5Vvun7OQTF6N
	 UAuy8Jseb/2XtsVs9CFKDZOdBdEPTOt6eJgpVOrU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiaming Zhang <r772577952@gmail.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0203/2214] hfsplus: validate extent record length before writing it back
Date: Wed, 18 Nov 2026 15:31:19 +0100
Message-ID: <20261118150018.326766535@linuxfoundation.org>
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
index fad1c250f150b..fce00b8c4f223 100644
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



