Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215524;
	b=BvV3x+rv/h2/gn/qHgZwYIAgFH28a+Py8BA0k23WyQ7ETlcYcN5vX0OOJuH7bmV1KedP
	 4W3nJosP6xU0Li0J9ifF9CSiyFVbJv/9UYQz4LsrcXWnFy5HXUa1L2sTKI/0OmgCUAXj3
	 WzU82fEPn/3i5t/MOxu8lQbasxerCm4geS8AiAx9H4PAev6HmS4ebN/PaF4DljJtzH3r6
	 MtCbcmIJu1xm44sdtIxWnGDdYvp0g/Sentvvum/kpYdhJcFF8I2l3GnRNmIIbz2EWo3pq
	 EZjXotPE3cW2SljoaatXwShl9n3xpVkTmMqM8wWJej/5AJ4W6VEpyHivGOei9cI+rag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215524;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JikQJhFjxPKsFj/DijcsuIipD35IZTpC7g5S0jXMyhw=;
	b=0ARVjA1/17AG5faj2t/1zZdpZygiQY+qIqomCTA3hoSUcGaiKeKuDcupxa8hKA7zC6Od
	 HWvTx4cFlXZ5I5df2zWc0p2SmRkZZsrUHQjPzs5O1ndjE0VaRGT0VDig49ecH+PVTtRoC
	 4BYaJE6FClYBmwMIUIy0K3/+xAq10oJaWOwi8gylLJKm2PVPo+AZwSCHgkZgF+dus5/Uj
	 Ha7N+ZMrE9aP/KK2yOPRxeMzb4catFWl+5JOlzR6W0vU7hdEPzeAOCSd1BRbFWnSUgkyq
	 4P7cA9DQwnqmMnX62ZmUFl85toWru3ZmGxvJq7BmEY3vnnCTriBUkemxnE7F1Pn001w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HAg1zu2Q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6CDA606A31C;
	Wed, 28 Oct 2026 19:25:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HAg1zu2Q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C02771F031E1;
	Wed, 28 Oct 2026 19:25:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215523;
	bh=JikQJhFjxPKsFj/DijcsuIipD35IZTpC7g5S0jXMyhw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HAg1zu2QDuSJVayXHfBHlajFuGTA2AMQzexE3GZaKDzjys6JXoB5l2GgcxvY+Cv15
	 vx3QbHNx+c8UX5siSvE6dKXdlakkueK/h+9/3PeUFfODFVYm/ShBDgAdLrfEooSiZB
	 PkuJCv8oZPnWXSpHDgR4hpnmBbCcO7SUPK2+okGY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Hannes Reinecke <hare@suse.de>,
	John Garry <john.g.garry@oracle.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1241/1887] md/raid10: Handle bio_split() errors
Date: Wed, 28 Oct 2026 17:55:37 +0100
Message-ID: <20261028170527.663536561@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Garry <john.g.garry@oracle.com>

[ Upstream commit 4cf58d9529097328b669e3c8693ed21e3a041903 ]

Add proper bio_split() error handling. For any error, call
raid_end_bio_io() and return. Except for discard, where we end the bio
directly.

Reviewed-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: John Garry <john.g.garry@oracle.com>
Link: https://lore.kernel.org/r/20241111112150.3756529-7-john.g.garry@oracle.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: e045d6ed33f8 ("md/raid10: fix writes_pending leak on write request failures")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/raid10.c | 47 ++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 46 insertions(+), 1 deletion(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index df93471de1e97..10d60030ac9d9 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1181,6 +1181,7 @@ static void raid10_read_request(struct mddev *mddev, struct bio *bio,
 	int slot = r10_bio->read_slot;
 	struct md_rdev *err_rdev = NULL;
 	gfp_t gfp = GFP_NOIO;
+	int error;
 
 	if (slot >= 0 && r10_bio->devs[slot].rdev) {
 		/*
@@ -1233,6 +1234,10 @@ static void raid10_read_request(struct mddev *mddev, struct bio *bio,
 	if (max_sectors < bio_sectors(bio)) {
 		struct bio *split = bio_split(bio, max_sectors,
 					      gfp, &conf->bio_split);
+		if (IS_ERR(split)) {
+			error = PTR_ERR(split);
+			goto err_handle;
+		}
 		bio_chain(split, bio);
 		allow_barrier(conf);
 		submit_bio_noacct(bio);
@@ -1265,6 +1270,11 @@ static void raid10_read_request(struct mddev *mddev, struct bio *bio,
 	                              r10_bio->sector);
 	submit_bio_noacct(read_bio);
 	return;
+err_handle:
+	atomic_dec(&rdev->nr_pending);
+	bio->bi_status = errno_to_blk_status(error);
+	set_bit(R10BIO_Uptodate, &r10_bio->state);
+	raid_end_bio_io(r10_bio);
 }
 
 static void raid10_write_one_disk(struct mddev *mddev, struct r10bio *r10_bio,
@@ -1409,9 +1419,10 @@ static void raid10_write_request(struct mddev *mddev, struct bio *bio,
 				 struct r10bio *r10_bio)
 {
 	struct r10conf *conf = mddev->private;
-	int i;
+	int i, k;
 	sector_t sectors;
 	int max_sectors;
+	int error;
 
 	if ((mddev_is_clustered(mddev) &&
 	     md_cluster_ops->area_resyncing(mddev, WRITE,
@@ -1547,6 +1558,10 @@ static void raid10_write_request(struct mddev *mddev, struct bio *bio,
 	if (r10_bio->sectors < bio_sectors(bio)) {
 		struct bio *split = bio_split(bio, r10_bio->sectors,
 					      GFP_NOIO, &conf->bio_split);
+		if (IS_ERR(split)) {
+			error = PTR_ERR(split);
+			goto err_handle;
+		}
 		bio_chain(split, bio);
 		allow_barrier(conf);
 		submit_bio_noacct(bio);
@@ -1567,6 +1582,26 @@ static void raid10_write_request(struct mddev *mddev, struct bio *bio,
 			raid10_write_one_disk(mddev, r10_bio, bio, true, i);
 	}
 	one_write_done(r10_bio);
+	return;
+err_handle:
+	for (k = 0;  k < i; k++) {
+		int d = r10_bio->devs[k].devnum;
+		struct md_rdev *rdev = conf->mirrors[d].rdev;
+		struct md_rdev *rrdev = conf->mirrors[d].replacement;
+
+		if (r10_bio->devs[k].bio) {
+			rdev_dec_pending(rdev, mddev);
+			r10_bio->devs[k].bio = NULL;
+		}
+		if (r10_bio->devs[k].repl_bio) {
+			rdev_dec_pending(rrdev, mddev);
+			r10_bio->devs[k].repl_bio = NULL;
+		}
+	}
+
+	bio->bi_status = errno_to_blk_status(error);
+	set_bit(R10BIO_Uptodate, &r10_bio->state);
+	raid_end_bio_io(r10_bio);
 }
 
 static void __make_request(struct mddev *mddev, struct bio *bio, int sectors)
@@ -1718,6 +1753,11 @@ static int raid10_handle_discard(struct mddev *mddev, struct bio *bio)
 	if (remainder) {
 		split_size = stripe_size - remainder;
 		split = bio_split(bio, split_size, GFP_NOIO, &conf->bio_split);
+		if (IS_ERR(split)) {
+			bio->bi_status = errno_to_blk_status(PTR_ERR(split));
+			bio_endio(bio);
+			return 0;
+		}
 		bio_chain(split, bio);
 		allow_barrier(conf);
 		/* Resend the fist split part */
@@ -1728,6 +1768,11 @@ static int raid10_handle_discard(struct mddev *mddev, struct bio *bio)
 	if (remainder) {
 		split_size = bio_sectors(bio) - remainder;
 		split = bio_split(bio, split_size, GFP_NOIO, &conf->bio_split);
+		if (IS_ERR(split)) {
+			bio->bi_status = errno_to_blk_status(PTR_ERR(split));
+			bio_endio(bio);
+			return 0;
+		}
 		bio_chain(split, bio);
 		allow_barrier(conf);
 		/* Resend the second split part */
-- 
2.53.0



