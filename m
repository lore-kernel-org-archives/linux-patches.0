Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033113;
	b=jnhBGF920mXyBhJZ63MPUApS5OWx/1fav/pAT9x6ZKQUs/6gDyOlOl0cz6ZexGKv7C2U
	 c+qRyXvYyMX8O3qp8I8BISTUfXXfu8Ln/02cRxIKApo3mHHHlDeXnlYYZCHwqqCJXqMnk
	 q770iujH9uDtWQ6Cz8pPnUZniBcx4o87rGw+HKd+aB0l83ruzn06/xquHicV80SqepT41
	 buQbfqLWBiVBxv1N0BfIqzUd+dLlO/EwCVWc65Daw2BEDiq0UHWvdPs1Y8mTKxGP9tyQZ
	 aRNN6OepB4WeiNEyv6i77wNituloJbR+jiolCD3I2oNg4odP2mRyEDC8LC/oq4VufVg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033113;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mhxfhljHtzqi6XtqajdAs/C0HDynbfBvKySHWEJZXLs=;
	b=papYaqxnST0BDJ6YAI31885p7tvdC808TxHTrNQiBS0PiYBAQGavv34t1rhlqoPU+JTw
	 2Xiwl/qNGwxm0kAOsMB3eSY/ehqVD1r5cZzNDhNlg2sAewC0WmFCsyNlAQ3CrO18AareW
	 05I1l2WA/WbrXVV4fALfTOXo7PkcW+vB/v3jYFa2SJxalxPrNUj6nCOSz5odVGUzlfSVy
	 PnQeTP/CsMzug6gUrtK5ZHDVZJAVXRU8Z43J1UHOMg03zhrcSWM9mIW+nN2tnpz4Jv/dU
	 Jhs+HhgRL5nd4l1G1ocYLbUPC9uQTNgVlKrbOmTm+4OrS0w0UwsbBw0j3Df3yvmsfjQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pcBkh1pB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9820A606A325;
	Wed, 18 Nov 2026 20:18:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pcBkh1pB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFD2F1F000C4;
	Wed, 18 Nov 2026 20:18:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033113;
	bh=mhxfhljHtzqi6XtqajdAs/C0HDynbfBvKySHWEJZXLs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pcBkh1pBl7KGO8AzIiIj+o6iLdwns/sqGaPxb6KDmBrzg86MHBCRBCvaJ+U7tV0IR
	 7kDq46GwiZLDgJTGgr4GPPSELD3RRgPnMcF/voPO0qUYbL+cAFfyk9SJAQxhBE+DQ2
	 TY+VV47qwrDvy3bUr2dcRf5OiuUsd3RP4mlm1kD0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1645/1756] blk-throttle: make blkio.reset_stats reset I/O counts
Date: Wed, 18 Nov 2026 16:02:52 +0100
Message-ID: <20261118150115.240732437@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit ac81a07a0bd5e75e8edc0eb5be563be1b2d56554 ]

blkio.throttle.io_service_bytes and io_serviced were reset by
blkcg_reset_stats() while the counters were part of the blkg. Now that
they live in the throtl_grp, add a pd_reset_stats_fn for them.

Fixes: 7ca464383aec ("blk-throtl: stop using blkg->stat_bytes and ->stat_ios")
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Acked-by: Tejun Heo <tj@kernel.org>
Link: https://patch.msgid.link/20261028164415.1262013-27-axboe@kernel.dk
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-throttle.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 75326b8d4868a..35b35b34cad5f 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -1574,6 +1574,14 @@ static void throtl_pd_offline(struct blkg_policy_data *pd)
 	}
 }
 
+static void throtl_pd_reset_stats(struct blkg_policy_data *pd)
+{
+	struct throtl_grp *tg = pd_to_tg(pd);
+
+	blkg_rwstat_reset(&tg->stat_bytes);
+	blkg_rwstat_reset(&tg->stat_ios);
+}
+
 struct blkcg_policy blkcg_policy_throtl = {
 	.dfl_cftypes		= throtl_files,
 	.legacy_cftypes		= throtl_legacy_files,
@@ -1583,6 +1591,7 @@ struct blkcg_policy blkcg_policy_throtl = {
 	.pd_online_fn		= throtl_pd_online,
 	.pd_offline_fn		= throtl_pd_offline,
 	.pd_free_fn		= throtl_pd_free,
+	.pd_reset_stats_fn	= throtl_pd_reset_stats,
 };
 
 void blk_throtl_cancel_bios(struct gendisk *disk)
-- 
2.53.0



