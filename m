Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72DE3143C4E;
	Wed, 19 Jun 2024 13:07:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802438; cv=none; b=nvNx/45649X2YjVCQ4GO1mTNd5UbYIEQ46tGcg5FhLQFF/nXIXTXbLbPCCH6jnZTOwnlDe7/lMLBAZMWEBMMUMJSEMhTzhPchCFusVjmVVsWV/9r+3keSCPqfAGNn5NReK1HogWyJYJxmloWpCcqb7gay5+u7ciPLhrNUyKsWaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802438; c=relaxed/simple;
	bh=BrDZDrKTLp5qS72EdONpQVw3y3MVACzerMX1JH2UDQw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RnUxm2xFAkpr/Lv5CpxSMpdYdhJcj8yZyH4y27Z3tiyClEU5desFnsNkwRBOPltvwOzZmw5UBjEw0cmYj83w5DVGb2JSEBynazK9Sw95+YNDtPggdZTsBhPkJxdZPPABxntEAyLhnyRHm/CoWKJNT24mQ1uFgCGPEuo1uqB0kyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tiY+PxhV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tiY+PxhV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE17DC2BBFC;
	Wed, 19 Jun 2024 13:07:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802438;
	bh=BrDZDrKTLp5qS72EdONpQVw3y3MVACzerMX1JH2UDQw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tiY+PxhVC5+RBKcFQVoFtDSkNP7162gjozjh8yKlEKtOzFIAvPc0qo+ps4F46fFum
	 kcPN528yw+NMKkWPuG8pRQqqeAuwGwyALh0nkXO+GKVB233CQbTmC2995WmZ69ULyF
	 IARC/8Emh2r7jU3aj3hCoUvj+5uRSLVZHD01382s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.6 197/267] null_blk: Print correct max open zones limit in null_init_zoned_dev()
Date: Wed, 19 Jun 2024 14:55:48 +0200
Message-ID: <20240619125613.895074935@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125606.345939659@linuxfoundation.org>
References: <20240619125606.345939659@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Damien Le Moal <dlemoal@kernel.org>

commit 233e27b4d21c3e44eb863f03e566d3a22e81a7ae upstream.

When changing the maximum number of open zones, print that number
instead of the total number of zones.

Fixes: dc4d137ee3b7 ("null_blk: add support for max open/active zone limit for zoned devices")
Cc: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Niklas Cassel <cassel@kernel.org>
Link: https://lore.kernel.org/r/20240528062852.437599-1-dlemoal@kernel.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/null_blk/zoned.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/block/null_blk/zoned.c
+++ b/drivers/block/null_blk/zoned.c
@@ -112,7 +112,7 @@ int null_init_zoned_dev(struct nullb_dev
 	if (dev->zone_max_active && dev->zone_max_open > dev->zone_max_active) {
 		dev->zone_max_open = dev->zone_max_active;
 		pr_info("changed the maximum number of open zones to %u\n",
-			dev->nr_zones);
+			dev->zone_max_open);
 	} else if (dev->zone_max_open >= dev->nr_zones - dev->zone_nr_conv) {
 		dev->zone_max_open = 0;
 		pr_info("zone_max_open limit disabled, limit >= zone count\n");


