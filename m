Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022126;
	b=v7pCTI8d/GAP88Ib/HILOtIE+XY8uyutFE4k0tRX12V0o2bQCE6gCIfr6jkTf+nYqXDa
	 yMXbzbVcsWasojA6/OLEsHljBYUxFrgSgi+J/EBdRJnmxQ0Kl0/GR4p70fScWs/nL+iuc
	 1IgZs7PPBJ04HmAS9FqL9Vo1WC5Nd4wNgRheR09l08FhTIV2tDyUrKlDxjZNdJ5+Y85EM
	 vfsZQXWwawMnBJZRz/Dt5DrthOFJXh9jaElQ8dhULrZ/1SC42uY8KuE5irbKbBS1uQqvq
	 +wOIX7MmdsuW5GW8uyFFUzTK4sIZbPY4Bi0zbyG7iQNpjJxkXT3TXOW/vTa7kp6MeDw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022126;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YQxxJZmjxlwTZJVxhe4IjAUug3diF8xtGVPUt/j+Deo=;
	b=MyowC89UXVj5j3wtEYLaXzgtFAMoPLJjapKrgxaOriCpVhgbQQLNObSVxNX1NJB36RJu
	 p1ZuwVtKdL8dFc9oPSXRtTaJEMc9cX80kfaEsH2hhrCGypX+iQinqB84Mk3D0ONt+hrI5
	 JESjy5XiskjxGPdoQf2a6OaIwvy+7Ta14qhJ8hmxAglmlHDpse4TjFJmkJy7tjFbrj5Bb
	 +1sx7Jg25fPvRqKDIcIGISN3Wh3AmqvqihdrajgVoSHyGkecfoKLGe+hADaJ1lP+mHKac
	 MaXessIV3S2DKOdmotPFMB6JETKrWsvuUZ1P3Fn0yLaDtiqriS51ANa5KjIXsae4FgA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0g27l2a8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6427B606A320;
	Wed, 18 Nov 2026 17:15:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0g27l2a8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBD651F000C4;
	Wed, 18 Nov 2026 17:15:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022126;
	bh=YQxxJZmjxlwTZJVxhe4IjAUug3diF8xtGVPUt/j+Deo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0g27l2a82tRyLZsALlH5TVypSgDoFgoEZYdKNTJRzvPg6LiL5gDsV2f3QxHJNKuqe
	 V00D7/yv+v8+o4AKPOS/4lHXJUf9up2mpTQxIVN1a44j7HPiIv3YK0k9CzLWGKFZk8
	 CNiF7ccag4HH8FVwLBd8jYssopZHSg0Tx0tU/2Wg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2552/2651] blk-throttle: make blkio.reset_stats reset I/O counts
Date: Wed, 18 Nov 2026 16:03:12 +0100
Message-ID: <20261118150416.372799685@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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
index 80a5e4b2872f9..c46807a0faaba 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -1684,6 +1684,14 @@ static void throtl_pd_offline(struct blkg_policy_data *pd)
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
@@ -1693,6 +1701,7 @@ struct blkcg_policy blkcg_policy_throtl = {
 	.pd_online_fn		= throtl_pd_online,
 	.pd_offline_fn		= throtl_pd_offline,
 	.pd_free_fn		= throtl_pd_free,
+	.pd_reset_stats_fn	= throtl_pd_reset_stats,
 };
 
 static void tg_cancel_writeback_bios(struct throtl_grp *tg,
-- 
2.53.0



