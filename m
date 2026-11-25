Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625395;
	b=ABowVB4bEP+1gXQHawCUzPCXjJu4GK+og+Q4D+uHSVFHNnzb2+OgFOjWaNI7oF8HBbBU
	 SBnVn+vf+oMkQx/16doClX4CVGAe510HQANQyNd/Fz2Btvkg1929gBt1ESNumEEqhgwKF
	 hTgG8T1dYtJcYno3bQcHjY3wgvLRoN8dTUHLP2geaxZgp0Fppr8dOQkJIXWA0tL8/TuWm
	 WLpl8XDaYNViDWX9muJs4OmYrm8jkC8YIt/HWxSuMoZRsC/mR5FDidOjRd0+fAkmQg7u3
	 1MBjjwxzubrdQgNUPhaDxdiTRtKc+jeSwNZq25ZXOQzUR8EN2ewr/CVpUf4MsBJIMOA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625395;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=folAU638OtiOARpcvhlwALqP+Nl7t5s3NjVC6SG2tqY=;
	b=AYJrimAN7vf2h4nB3Hz3R9ZB8Oq5ySdE+khcjq7Tz1K6kVcIqpvZZbNjOQ0gw4WCnW2i
	 uoxbRdoLxSsv/n8MqCRVco37Yi957yhqvY4YBAEkMe/QCFWL278hMZNCGbZb0n5gDtP1C
	 Oacz+RmEUiho4b/Mgaaj9skhEIDEhIO+YpwViWRt23P/5+/7X9eRCnJoeW1B/9xqAHfEB
	 /hrvyqMCgNgUnAS+TyPNBZ2hyxnJEjjOgQPlZGaC7KxhKN0DNRZ8yYw4r4STHdr0FGNYK
	 Ns1mhfql7rvPM5X3KRF3QeEM6AvQcpd0tFwCCEJHPO8sEJDL8cVMcc75g5zaatXYUyg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UxmRKK5Y;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1B5D606A31E;
	Wed, 25 Nov 2026 16:49:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UxmRKK5Y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3A751F000C4;
	Wed, 25 Nov 2026 16:49:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625395;
	bh=folAU638OtiOARpcvhlwALqP+Nl7t5s3NjVC6SG2tqY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UxmRKK5Yg5IX4/OOj6OF9MYZCF+bktYKos2z1CWTnBnfODX7/Mm1l2Lw9ctjJKNhI
	 Rrviks2ZzgakbC3/6Pkz+yjocq0clBAXvSkx2166inko9c6/QQexkl5sZEwcBVqx/m
	 zkj1E9K6uFkmCxyFw5FJsriSOHK2OuHGwD3QJ/jU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	Ming Lei <tom.leiming@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 501/816] ublk: use global index for reported zones
Date: Wed, 25 Nov 2026 15:34:09 +0100
Message-ID: <20261125143900.785901282@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

From: Li RongQing <lirongqing@baidu.com>

[ Upstream commit 80897c7e5ae5c56f37a2eb004328edcb4da7cdd1 ]

ublk_report_zones() may split a zone report into multiple requests when
the number of zones exceeds the temporary buffer capacity. The index
passed to disk_report_zone() must refer to the zone position in the
whole report, rather than the position within the current request.

Currently, the per-request loop index is used as the callback index,
causing each chunk after the first one to restart from zero. This can
make userspace callbacks receive duplicate zone indices and may result
in blk_revalidate_disk_zones() updating incorrect entries in its zone
state array.

Use the number of zones already reported as the base index for each
request so that zone indices remain continuous across all chunks.

Fixes: 29802d7ca33b ("ublk: enable zoned storage support")
Signed-off-by: Li RongQing <lirongqing@baidu.com>
Reviewed-by: Ming Lei <tom.leiming@gmail.com>
Tested-by: Ming Lei <tom.leiming@gmail.com>
Signed-off-by: Ming Lei <tom.leiming@gmail.com>
Link: https://patch.msgid.link/20261011063555.1142277-13-tom.leiming@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
[ sashal: Replaced the per-chunk loop index with done_zones in the zone callback, keeping this tree's cb(zone, done_zones, data) form because disk_report_zone() doesn't exist here. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/ublk_drv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index ae954ee1e3529..443054f89244f 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -371,7 +371,7 @@ static int ublk_report_zones(struct gendisk *disk, sector_t sector,
 			if (!zone->len)
 				break;
 
-			ret = cb(zone, i, data);
+			ret = cb(zone, done_zones, data);
 			if (ret)
 				goto out;
 
-- 
2.53.0



