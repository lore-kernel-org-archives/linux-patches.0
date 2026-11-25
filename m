Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624425;
	b=Sb91QTaDIsUPWBFelhi4O+JnCA/svUC9iVWHgXjmZOCO7PsMLySJ8Nz/6+jMlB68ixV6
	 C9Y9w+fIuDWBROKI4qkySqVtczQRE3xE9NWNn9itBJgJgP4QNwoujlNBB00+l0Z7w+7cx
	 7eMTiYk2rJnHFnH7diBZeF8b6uWpGAdYvLdWdy0/TEwcU0zzPzr72GbOMZFg8Z6BbCGU8
	 k3BdHFfHrs5Jit1+xNTG7DT35BzrDNyvxL7/LBG9+8eVxRM+HzijCV3HWLwbpeJGd45RW
	 oZFw8SB9PSncUJVjl8Eyg5WvgwBt0KBrnCgER54YP5QXI7Laxtyla+CaTbR+CsA8EXA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624425;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=16OvuAlOTk4q2kZopJfMg8qqEMDrqBPvNg6/P1ock+U=;
	b=SHdgqvxr7P6HLTlIOBw/SdcHij6Ack9sEIxQ+k2XjQo0+MqCdYKW7n7OsZGQJGeBLwHj
	 Cs6Zpx2YKkbrs4c14yWWLU+KW4+ErqwIgE12Q9RzibfidtCsyJg3wV5YD1vBUzqkCbjOs
	 9ckGbvhWFn2A+c+gNljKK3Nwhgu9bQGuowXKWNYUTFH6vEEOGcDdeHlHSOAFmpz4WNQhj
	 7RMuV1fMn3ojeGtoS5fL6O4sd1uV+h8n9eMZdwPnqLuwnlZ4oa69cnCxJN6LZz1eLNhHT
	 tEELRjw73CUsQs7PZVqSl7Bw4o4mPaCibuPj8Vkb5J88ZWG7VxnVa9FDbQ/cS+tUEuQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dGsF+lAG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26482606A339;
	Wed, 25 Nov 2026 16:33:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dGsF+lAG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65B721F000C4;
	Wed, 25 Nov 2026 16:33:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624424;
	bh=16OvuAlOTk4q2kZopJfMg8qqEMDrqBPvNg6/P1ock+U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dGsF+lAGr4iJKq1dtAWo9p1JoHViJiGSjmWFBi5AFzHBqWpOxFtkC2jWksTAKuYEK
	 nbDlNDVDAdvSgEevZhRu0HHhnIeAZod3X5tRrhqg+Y/8obsNE99d2s8bEh7Y+/rIFq
	 09fo8FR93kCqgYn1OeXFkh3oeYWqhcY9ux6N3tHg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 189/816] null_blk: dont finish zones to set them read-only or offline
Date: Wed, 25 Nov 2026 15:28:57 +0100
Message-ID: <20261125143853.569824972@linuxfoundation.org>
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
index badedb4769220..512e3181d5b5a 100644
--- a/drivers/block/null_blk/zoned.c
+++ b/drivers/block/null_blk/zoned.c
@@ -731,6 +731,33 @@ blk_status_t null_process_zoned_cmd(struct nullb_cmd *cmd, enum req_op op,
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
@@ -747,8 +774,8 @@ static void null_set_zone_cond(struct nullb_device *dev,
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
@@ -756,9 +783,7 @@ static void null_set_zone_cond(struct nullb_device *dev,
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



