Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621415;
	b=yhpgKJ71tvLCYMef54KMPjdeGPmrcUdtulZxAV2HVe65KHFg+NoiVSDAXYMwd5C14V70
	 KJbdlL5RtcFi4tkQ/Gfp3ze+8H9UIT/d5SSophkoKZZFLml9NYumpq7Ccbuv+qTlLU366
	 /0C85KNTkPoRqzBA8Y2zPxNQ/uxpmOnLYYIa6hLp22XdJ4MaFevLA5uwkIkusY2zQYOGz
	 Dr8OsQXPksFbnNns0OtPuaN8Km+l5vdE7a1Kwn7z58xPMxEnVE3wRJoTaN5qqtgzIBOld
	 5fL67rY4mOQlG81BGH9oGnulIDso+ShXLwU3G3Ll+2rQoEVabUZM9jp19IFW+pDQ16g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621415;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IcfN29tmzSmkgmV7a2rou8LUfE2Yb7REdVbah7mLyDQ=;
	b=E/lglobenVpTy65s3VYay+5314qTDEwb4Gztrtzrb8EmFjTWwRtP9pxQhTOPJJX7Vou8
	 lm40fIWB/wURS8ekJRG8IFdNq2TrYc7wu3Crpypi3So7wqiGByFoTd6/kjDiLL6pP/mME
	 zlOV2waXua218E0TmHZlqanP7Ml9ExT+PqGWxjNH4Zh7q0zgwQ+CFiErKBAJWiEao0jJa
	 eoU/r2p3dEG1UTPAGehQkCcMKPBCKSNBuqqP8GWXAFd5DkVw1qkA20huG5hurlzbWgYy+
	 ZwjvoOUpoRXynCXD2H/MwhQ8P7R1RZ/Guvwejmei/xd3GoD7sXcfGZHdgydFHfR8l+A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dlFCWczW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA44F606A691;
	Wed, 25 Nov 2026 15:43:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dlFCWczW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C06C1F000C0;
	Wed, 25 Nov 2026 15:43:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621415;
	bh=IcfN29tmzSmkgmV7a2rou8LUfE2Yb7REdVbah7mLyDQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dlFCWczWyRwXrH9HOJyDdywodRubo3jlTggcFmulGJ84E4R9MlEvS73BwOUIX/HAn
	 k293OCY8XyzKja8fk7kZSst8OBTT4Nu8Fl0c0LzDXdHUEnk8BQ6omp2enmVZiwIpQK
	 d4Boc79o5fzAjtsnaHiX6tyf4OOco/3wzfa1X0J0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shao Mingyin <shao.mingyin@zte.com.cn>,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 219/990] zloop: reject mismatched conventional zone files on restore
Date: Wed, 25 Nov 2026 15:26:26 +0100
Message-ID: <20261125143827.219193487@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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
index a49170a6565a2..8c80231c0873c 100644
--- a/drivers/block/zloop.c
+++ b/drivers/block/zloop.c
@@ -865,7 +865,8 @@ static int zloop_init_zone(struct zloop_device *zlo, struct zloop_options *opts,
 
 		if (restore && file_sectors != zlo->zone_size) {
 			pr_err("Invalid conventional zone %u file size (%llu sectors != %llu)\n",
-			       zone_no, file_sectors, zlo->zone_capacity);
+			       zone_no, file_sectors, zlo->zone_size);
+			ret = -EINVAL;
 			goto out_fput;
 		}
 
-- 
2.53.0



