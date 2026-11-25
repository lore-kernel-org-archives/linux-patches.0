Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618334;
	b=wnb6TknjNWhrtkxTQKdagke5ZjWMcyKWMcfdaG3AhvQXeTQ8AoeL3mA8mK4By9ndvAZZ
	 /5dZxet1STWiZaXKoFk0I5coFwFMZa5eVQseXXXH381TbC7caaQvI/d6NyXybTf+cqHBJ
	 wZRhr/aW6nvq2tNvDSQxFGMUHh5e2vXHhrFmeXbJEJ5kaB/KRyGsDs0s9zectJ0mvRHXK
	 VDdsgJS9lHZh9YBEdBendonxAqw6oV+V77Zo3q6AhBSK657m11zKTHb/7TaCcHnwbRmFB
	 q8t44YbE9mzflaiQ8fNlpQf8A0KpdQtV+w0uhZ/BpkeZ+6fyiqxnk6TW382yLXJcsXg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618334;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ow5D6YqQX9rixTVlwJJ4te59x72ZMuGtiFxlf+jT6FI=;
	b=HOeYvAVGXEVbFGGDW4llWGR5WpF1fv0fA/ZY8GBvqjrX1kF2N7Vq4QxG7OjuTYWfBNa/
	 f7eVbZojuAaOWgK10tiHko1yJH9UqqlclQmLqLRwjSzR9BNzL5LTtrLGsUDLWbjywFILL
	 yIHsap2Mur+JLNxQhHeh/V70skluIPbYVEc6rzB4woW3lnsX8X1GnlreOq3DtKd+VSXsb
	 xrb0GY4T2mtSGWsouTJFsNdgF5kGy8GAwxKcu44e8Wn78T+idj7aDil3m8mAM9eoReBUo
	 DLkDf6P3eBfOdNz8EjL+i6PEB19TkrWrvSAfNRFzcffdX1h7NJY0ohYBICkEgQ0iMxQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=biMwJNbh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3614C606A321;
	Wed, 25 Nov 2026 14:52:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=biMwJNbh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E07E1F000C4;
	Wed, 25 Nov 2026 14:52:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618334;
	bh=ow5D6YqQX9rixTVlwJJ4te59x72ZMuGtiFxlf+jT6FI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=biMwJNbh3JOC0vvkAlwmyV+eBRGGguH214ZB9y6tXD4Z55r7SmZ1Z5lfY8M8CzaKh
	 S5CQLKI/E/HubMpiJQMLmZE6pQwDD1QTx3V0rI2u6wDuxBGl4KmEZ/mSC+I4UBu/be
	 t4JoriNO9GjcIBtcoMfADa4rj8iFYX2oiQl7UyR0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0246/1005] null_blk: fix opening closed zones at the active zone limit
Date: Wed, 25 Nov 2026 15:26:24 +0100
Message-ID: <20261125143827.499789634@linuxfoundation.org>
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

From: Niklas Cassel <cassel@kernel.org>

[ Upstream commit 6f2b59737bf9cf3623719857ac149f0d431db109 ]

When the open zone limit is reached, null_check_open() closes an
implicitly open zone only if the active zone limit is not reached.

Closing an implicitly open zone does not change the number of active
zones, so this check is wrong. For an empty zone, the active zone limit
was already checked by null_check_zone_resources(). For a closed zone,
the check makes writing to, opening or finishing the zone fail with
BLK_STS_ZONE_OPEN_RESOURCE at the active zone limit, whereas ZBC-3
(4.5.3.2.7.2) and NVMe ZNS (2.1.1.4.1) require closing an implicitly
open zone instead.

Remove the check, and update the comment above
null_check_zone_resources() accordingly.

Fixes: dc4d137ee3b7 ("null_blk: add support for max open/active zone limit for zoned devices")
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Link: https://patch.msgid.link/20261022092158.2248831-6-cassel@kernel.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/null_blk/zoned.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/block/null_blk/zoned.c b/drivers/block/null_blk/zoned.c
index 7e9b5ffb9e841..ecdc8d68ca2a9 100644
--- a/drivers/block/null_blk/zoned.c
+++ b/drivers/block/null_blk/zoned.c
@@ -311,10 +311,8 @@ static blk_status_t null_check_open(struct nullb_device *dev)
 		return BLK_STS_OK;
 
 	if (dev->nr_zones_imp_open) {
-		if (null_check_active(dev) == BLK_STS_OK) {
-			null_close_imp_open_zone(dev);
-			return BLK_STS_OK;
-		}
+		null_close_imp_open_zone(dev);
+		return BLK_STS_OK;
 	}
 
 	return BLK_STS_ZONE_OPEN_RESOURCE;
@@ -330,8 +328,11 @@ static blk_status_t null_check_open(struct nullb_device *dev)
  *
  * ZBC states that an implicit open zone shall be closed only if there is not
  * room within the open limit. However, with the addition of an active limit,
- * it is not certain that closing an implicit open zone will allow a new zone
- * to be opened, since we might already be at the active limit capacity.
+ * it is not certain that closing an implicit open zone will allow an empty
+ * zone to be opened, since we might already be at the active limit capacity.
+ * Therefore, the active limit is checked first for an empty zone. A closed
+ * zone already holds an active zone resource, so only the open limit has to
+ * be checked for a closed zone.
  */
 static blk_status_t null_check_zone_resources(struct nullb_device *dev,
 					      struct nullb_zone *zone)
-- 
2.53.0



