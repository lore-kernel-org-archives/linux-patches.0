Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618338;
	b=uhXI12GgbqXWi8CMPsartnGHXAPD2uS/zj/zSjsVoZ1yXRilxxwzI29IK+8c6MaX+bLu
	 /hfa4BPO0PL99FKUcecC1k+LYhwdUJ7Z55QjhUkk/HCP3OaE6pHuEfEMNMsxDlxGcm2Tp
	 qEQbVj3cDpNJMWgHWRMG8xM/epBFbYozBRs1qOWWoSp93mO8dI7xrKihFRqB+7/1jnK6U
	 xwxFUFboBRCyMkriRDbG0F6SB+K3LnVCaK1Euz1atnvlph4JyGzTYZX33LCjbRI5iyx85
	 vYeVOnNCkFOwyT7WMPBi/5seFU/vvKHzTbZnQV+vAcqkokQ1pxFr9HXgvSHiuxoOAQQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618338;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vP+lZm2hznDlu8E/Zdi/PDcqjvGNWs1IVT5y3kkLdsg=;
	b=LYA/EIjnUyIdX2JhafqY/Os3yP2DjTkcVlG5uAKmFy5ZnrzADaHfaee1OIlCAU3QLx/r
	 h5GNmmwro2sDqL1ILtqsLEO6f1u91bxIAh1JA3LgevevDV7t/u6G1/aiOie1LwBcnUwDS
	 tYjA6qZTk8JKI5UkdZYnqbKjfz31+PsNrUVfOtnXtQrabx1jVEafCy4jh+J7Ekf47chN3
	 ff/ALpc/YUIr7DNutPPJO0wfpv+vuV2iJgYRZxz58YR2KPPkY/H3r86UfzqDMvIPNHvCa
	 mqLJ+td7GrwutMljz3LgxI35i2fmDkkHsKUQnvPf0Vrje4tcPLKWr5hjjb2FU31Yc4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YbbzLcKn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 055D7606A33E;
	Wed, 25 Nov 2026 14:52:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YbbzLcKn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3DA71F000CF;
	Wed, 25 Nov 2026 14:52:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618337;
	bh=vP+lZm2hznDlu8E/Zdi/PDcqjvGNWs1IVT5y3kkLdsg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YbbzLcKn5yBzS+r9WL2600XiXIUKK2Ppj8vAHAO6FB3eXCCLG/WXk10HX1QxTc8pu
	 UTfpJ29gbjwOCS7UJuiCSnmvXNpyv/irf/1KwItSKssmF7aeEnAxElr2HMdUtYbwRY
	 +Lu7ZRk9J2QowEDt3dSMmA/VY6Og2D9OGw87HvKU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0247/1005] null_blk: dont finish zones to set them read-only or offline
Date: Wed, 25 Nov 2026 15:26:25 +0100
Message-ID: <20261125143827.523490976@linuxfoundation.org>
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

[ Upstream commit 973bf587d79f061beffdd392e77012a07f25fcd6 ]

null_set_zone_cond() calls null_finish_zone() to release the zone
resources held by a zone before setting it read-only or offline.

For an empty or closed zone, null_finish_zone() first runs the zone
resource checks, which can close an unrelated implicitly open zone, or
fail. As the error is ignored, a failure for a closed zone leaks
nr_zones_closed, permanently lowering the effective active zone limit.

Setting a zone read-only or offline requires no zone resources, so
release the zone resources held by the zone directly instead, using a
new helper, null_release_zone_resources().

Fixes: d3a5738849e0 ("null_blk: support read-only and offline zone conditions")
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Link: https://patch.msgid.link/20261022092158.2248831-7-cassel@kernel.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/null_blk/zoned.c | 35 +++++++++++++++++++++++++++++-----
 1 file changed, 30 insertions(+), 5 deletions(-)

diff --git a/drivers/block/null_blk/zoned.c b/drivers/block/null_blk/zoned.c
index ecdc8d68ca2a9..015f5d304c7ce 100644
--- a/drivers/block/null_blk/zoned.c
+++ b/drivers/block/null_blk/zoned.c
@@ -743,6 +743,33 @@ blk_status_t null_process_zoned_cmd(struct nullb_cmd *cmd, enum req_op op,
 	}
 }
 
+/*
+ * Release the zone resources held by a zone, before changing the condition of
+ * the zone to a condition that does not hold any zone resources.
+ */
+static void null_release_zone_resources(struct nullb_device *dev,
+					struct nullb_zone *zone)
+{
+	if (!dev->need_zone_res_mgmt)
+		return;
+
+	spin_lock(&dev->zone_res_lock);
+	switch (zone->cond) {
+	case BLK_ZONE_COND_IMP_OPEN:
+		dev->nr_zones_imp_open--;
+		break;
+	case BLK_ZONE_COND_EXP_OPEN:
+		dev->nr_zones_exp_open--;
+		break;
+	case BLK_ZONE_COND_CLOSED:
+		dev->nr_zones_closed--;
+		break;
+	default:
+		break;
+	}
+	spin_unlock(&dev->zone_res_lock);
+}
+
 /*
  * Set a zone in the read-only or offline condition.
  */
@@ -759,8 +786,8 @@ static void null_set_zone_cond(struct nullb_device *dev,
 	 * If the read-only condition is requested again to zones already in
 	 * read-only condition, restore back normal empty condition. Do the same
 	 * if the offline condition is requested for offline zones. Otherwise,
-	 * set the specified zone condition to the zones. Finish the zones
-	 * beforehand to free up zone resources.
+	 * set the specified zone condition to the zones. Release the zone
+	 * resources held by the zones beforehand.
 	 */
 	if (zone->cond == cond) {
 		zone->cond = BLK_ZONE_COND_EMPTY;
@@ -768,9 +795,7 @@ static void null_set_zone_cond(struct nullb_device *dev,
 		if (dev->memory_backed)
 			null_handle_discard(dev, zone->start, zone->len);
 	} else {
-		if (zone->cond != BLK_ZONE_COND_READONLY &&
-		    zone->cond != BLK_ZONE_COND_OFFLINE)
-			null_finish_zone(dev, zone);
+		null_release_zone_resources(dev, zone);
 		zone->cond = cond;
 		zone->wp = NULL_ZONE_INVALID_WP;
 	}
-- 
2.53.0



