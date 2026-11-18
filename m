Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028171;
	b=skmdHz+Fe+AOqBc+C5MNIq3CQsKAUAQ9C5pMyDaJMaNaoWB4ifbV6Z6DfjbMWZcvOBWF
	 aqhqHkYi7dmsAq45jMGTRe7Cel9rx51DwQbIBn+EyVdp0zgyPs7kjtzLStThMP2aZPvrs
	 BnRNX6jXPsUJSEhhHss/DKwIeP+2EB7mOJ52FIDdbzLCxsOROPaWdFaGIsMU9Glyn6J9f
	 5mgVfoVLRNLdRJy2G4/1R/4Oihr3DuI7pk1fOtfTyzmD4jaeCbHjcAO98lQyc/jVwsjzA
	 AuT7UKAbUUVMo8wFG1M6OiGaVnonKmWE0qhbZvNJXw5br4heXIcnZlIeYGtzF0nGtdQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028171;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rulNhpIBRUxG797qfrxPsAUvYYVDyQJAA/+xHOCEf5Q=;
	b=ElFnq0TR9ZI27lyQg8gNyIWT7utX4h5vqUoMmy8/2yVV/foOgskD/dr3H6+8a/5w4QF6
	 IW+SOLQYMsJBjPhYjPMW+QDC/B9dBi2GqywFLOIWU2i0rcqEmAoiWxoJlhLIWRyhkMaU1
	 9mJ+rLyVji3CUimWhnVE8U7QcG/ddlcUU/UMCZ8czj+qH2VREXlmuLNEdqULOby1ukMGb
	 VACyCjXNYGFJdaJkQ1MyfQq9TcYnck608Lbly1TtE2pBvOqinenvF1FBHgAOMIKj+AKeG
	 yTfSWgQVhKYhGMAZBT+ZGLtH1HpCli0E0zQUmJ20H1wOc34snJN2m9ngfuD+MwTJhSg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DQwKFpJF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87A53606A320;
	Wed, 18 Nov 2026 18:56:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DQwKFpJF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E110C1F000C4;
	Wed, 18 Nov 2026 18:56:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028171;
	bh=rulNhpIBRUxG797qfrxPsAUvYYVDyQJAA/+xHOCEf5Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DQwKFpJFCs7/OK9suN+rGxwbicjrpfVP3rWItzZSTifxtBR5Si8h9jSREj4sxj/Vi
	 /WPOBfuLDtsPLwH2xQQFXiZ2Ut8Mw8UCGdUBUvR2Ggcpv6ihOX515q0GqI1u5y2B+b
	 NvB3V6mZARW9XBxbkL7Hj87rLMwQ7q6C99MAS9IQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 2043/2151] blk-throttle: make blkio.reset_stats reset I/O counts
Date: Wed, 18 Nov 2026 16:02:58 +0100
Message-ID: <20261118150236.147997104@linuxfoundation.org>
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
index 43d33adf21d69..36f8dc324d79f 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -1690,6 +1690,14 @@ static void throtl_pd_offline(struct blkg_policy_data *pd)
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
@@ -1699,6 +1707,7 @@ struct blkcg_policy blkcg_policy_throtl = {
 	.pd_online_fn		= throtl_pd_online,
 	.pd_offline_fn		= throtl_pd_offline,
 	.pd_free_fn		= throtl_pd_free,
+	.pd_reset_stats_fn	= throtl_pd_reset_stats,
 };
 
 void blk_throtl_cancel_bios(struct gendisk *disk)
-- 
2.53.0



