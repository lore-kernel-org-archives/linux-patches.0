Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026200;
	b=Vz+43xATA6H8qyRZzQNwvu0F0e6rJVZt9srVX9MWcX5u7uk95JvnuRtfqXDZRj9goe0l
	 WggjtBsLrokhwI12aOnyQcuJYZtA08rWHaw24QHDmAiyrQzPw2z0s42WW2ml2moYGK/bg
	 7nIUvnKW5zWmR1st/9dRxJb/HmksDbCckbIfFpWaRdNR40Mh+6X1imVpDwmagNyTdL3tz
	 POGlRiUi+yzTJ+GoU63qsmK0wrzIcTZEIZjYuXLjKC3n2vAqzTS4asuOcrvVmj5wJ/Lzl
	 tC9jJGj3dRIZC1GqZNqH9SnCYdsKuFTpVz9sdjx1iUGHNOMwOO+b8L1Lz+mDpq/dm7A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026200;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vOuKmCOzMSf21dzgSchqo16yf21RDk0doWcwS/UMvo4=;
	b=T6m42uuqPpaRrjMWmBUycTYE/16S2daro9m/B7JjobDu6GrgK9q7n4BsDRXMGtBJ4ZNY
	 TKwTitwYVGJ4WiF6Y4k/J9cQahszOOXkFisdHJrYqWm1InTY2ryBD+6B1nvZr4NZk1my8
	 HMcd/Tk+TzfNPaPfUoC/ODmUzWSNo3LrkX9crYMRPzDVMjH4S2L6lGQY5PYH6do3rh6HD
	 MJefxz48TrtiNbBWyA67bpr9iKQvvqg37BUzCZXPIBez7Vt2WsKtydXNgAmmp2iAmQcEv
	 VL/tUQdhdjmeTqDBa02m7SXMutOEIrQut6Xx0BtDLWZvIhbI48p8BGXvALb/iliuSPA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NL7gJSH4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB67E606A31C;
	Wed, 18 Nov 2026 18:23:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NL7gJSH4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F6B61F000CA;
	Wed, 18 Nov 2026 18:23:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026199;
	bh=vOuKmCOzMSf21dzgSchqo16yf21RDk0doWcwS/UMvo4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NL7gJSH4DKypqITzNa6e0LHz7VBYajwDZJiTJP3c+t6+AfKPVYTtsvmMzchjFPyZF
	 vxJ4/4elT/e84oWsdSYW1ruzBTeLWU8dst8SoWqZ5Qfl40hz4XkF7b3dzpgGkZ+et1
	 /kCUJZO/qUUOG/IU47NWNJNDiEjUzCHW7Ftaid1M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Hannes Reinecke <hare@kernel.org>,
	John Garry <john.garry@linux.dev>,
	Tal Zussman <tz2294@columbia.edu>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1350/2151] block: dont fall back to buffered I/O for atomic writes
Date: Wed, 18 Nov 2026 15:51:25 +0100
Message-ID: <20261118150211.218005390@linuxfoundation.org>
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

From: Tal Zussman <tz2294@columbia.edu>

[ Upstream commit 9fd1afea19fa7c4ba438a1d162739e0832073a4c ]

blkdev_direct_write() turns an -EBUSY from page cache invalidation into
a 0 return, so an IOCB_ATOMIC write is retried in full through
blkdev_buffered_write(), with no atomicity guarantee.

Skip the buffered fallback in blkdev_write_iter() for IOCB_ATOMIC, as
it already does for IOCB_NOWAIT, so the -EBUSY case returns -EAGAIN and
the caller retries, matching __iomap_dio_rw().

ext4 has the same fallback and only warns in it. For block devices the
fallback can be skipped before any I/O is submitted, so fail early
instead.

Fixes: caf336f81b3a ("block: Add fops atomic write support")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://sashiko.dev/#/patchset/20260802-blkdev-fixes-v1-0-a82fc549fd74%40columbia.edu?part=2
Assisted-by: Claude:claude-fable-5
Reviewed-by: Hannes Reinecke <hare@kernel.org>
Reviewed-by: John Garry <john.garry@linux.dev>
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
Link: https://patch.msgid.link/20261009-blkdev-fixes-v6-6-307939c387df@columbia.edu
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/fops.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/block/fops.c b/block/fops.c
index 1b3d86b85da9a..17cdecf39398c 100644
--- a/block/fops.c
+++ b/block/fops.c
@@ -815,10 +815,11 @@ static ssize_t blkdev_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	if (iocb->ki_flags & IOCB_DIRECT) {
 		ret = blkdev_direct_write(iocb, from);
 		if (ret >= 0 && iov_iter_count(from)) {
-			if (iocb->ki_flags & IOCB_NOWAIT) {
+			if (iocb->ki_flags & (IOCB_NOWAIT | IOCB_ATOMIC)) {
 				/*
 				 * The buffered fallback blocks on i_rwsem and
-				 * on writeback of the data it copied: return
+				 * on writeback of the data it copied, and
+				 * can't provide torn-write protection: return
 				 * the short direct write instead and let the
 				 * caller retry. The bytes already written
 				 * still need a flush if REQ_FUA was not set.
-- 
2.53.0



