Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618325;
	b=1xAkE4yKf6VrVBWwI1sbqoQXzb01VaBOb+ZrIl8lPuGY3gYvsQWDDopVl24yUDTdur3T
	 yCAZi834XVm87YWX8tpt0P4cs7UFXqGnSCRDoPwqkFXILJEBAzoacm1tq9tGnOw/T4UY/
	 10pptPLqDV1qOcuieIUshHplNE6yyh/gJpKVcznZVQtZIRCbvpJ7tnJq7zJQBVFg2c+id
	 N/0pRoj9BjGGY27Itxp2xft0NTzkrgrLSrte837ixXQiH1/kB3k3YO/7fDlpvY81G6RK6
	 /HYBwP2tc+jQu9ReP9d63qwcEflhott7zdFDsYrPKNXMiJHDaWZB1YBflUhFDb0XQOA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618325;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lYqZxte2WqzdVixTp6S06K9oX9Wrkb3GF1/8ddcIrHc=;
	b=pA5ADGn0BQNZK2GY8P36qcCQKZTRbpWFqNG7qnfuCw03trAWVhrP+Z1WGUPxnhGGH69A
	 +bzjUQUhLs9/xi3RHM09iF19ejrC1xYORargmDsgIfTVAXxpHLQ0KhPZzBU2IP5vV8OpB
	 sxzreZwuYNeOJlt9apG/JpNyx8iAVVoHDfWTzxWbDXD/MS0i6oH4wSo5cYzPlyTHfDGhh
	 wrDiql8pa2GssWn3EyFvZ8t3nDNGiXyNSkAD7AgCxc6Gtpd2CkLigdximN9nCrPnihSbw
	 hfz9o91tqIPR/OZizuO9izfmMFAaddXyRAQOK2wwLVh+XrkMkomP5iy/bmu9Lj99peg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ecul3e+x;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C4D1606A321;
	Wed, 25 Nov 2026 14:52:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ecul3e+x
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D6451F000CA;
	Wed, 25 Nov 2026 14:52:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618325;
	bh=lYqZxte2WqzdVixTp6S06K9oX9Wrkb3GF1/8ddcIrHc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ecul3e+xwFRorETogqP4W18fzhIkLNO4vKNJyL286MDqnro6cNkuqJvsUfBrCL0YS
	 Zk8Nl0y/ebOIXZoebQxi4Bh97IKSE9F/LdaI78V8HwgfqpnyYGpkkLPrRyoesdX6bk
	 /dabAHev+deA6OmPur6fD0dILUctZzIeoPvxj2rQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shao Mingyin <shao.mingyin@zte.com.cn>,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0243/1005] zloop: reject mismatched conventional zone files on restore
Date: Wed, 25 Nov 2026 15:26:21 +0100
Message-ID: <20261125143827.429440162@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Shao Mingyin <shao.mingyin@zte.com.cn>

[ Upstream commit 09c2e203e0ea8b68e7c9500401fa0ab60baf1a9d ]

When restoring a zloop device, zloop_init_zone() checks that the size of
each conventional zone file matches the configured zone size.  The check
prints an error and then jumps to out_fput, which releases the zone file
and returns the value left in "ret" by the preceding vfs_getattr() call,
that is, zero.  zloop_ctl_add() therefore treats the zone as initialized
and continues with a zone->file pointer that was already released; any
I/O to that zone then dereferences it.

Return -EINVAL, like the sequential zone path does for the same kind of
inconsistency.

While at it, print the zone size that is actually compared instead of the
zone capacity, which may be smaller and only made the message confusing.

Fixes: eb0570c7df23 ("block: new zoned loop block device driver")
Signed-off-by: Shao Mingyin <shao.mingyin@zte.com.cn>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Link: https://patch.msgid.link/20261031221610676B5VoVcwMgkoDNVZH2bVDO@zte.com.cn
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/zloop.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/block/zloop.c b/drivers/block/zloop.c
index 8884fa63c23a4..5e3eb2c7004f4 100644
--- a/drivers/block/zloop.c
+++ b/drivers/block/zloop.c
@@ -1151,7 +1151,8 @@ static int zloop_init_zone(struct zloop_device *zlo, struct zloop_options *opts,
 
 		if (restore && file_sectors != zlo->zone_size) {
 			pr_err("Invalid conventional zone %u file size (%llu sectors != %llu)\n",
-			       zone_no, file_sectors, zlo->zone_capacity);
+			       zone_no, file_sectors, zlo->zone_size);
+			ret = -EINVAL;
 			goto out_fput;
 		}
 
-- 
2.53.0



