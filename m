Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C521B6774B;
	Tue, 23 Jan 2024 01:01:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971695; cv=none; b=qI3oqtxg2kw5krIiTZk8u1my3RP1DUK5dvFcbR+05W7AH6wsOfO3Rras/pNggn47zEWP4d5VJ31lH5qb+YIBwglQbVIdQxtzp5RRtl2PJ5fCpCyZGYLOMk7rxGGdceFAGFq+xlM8EhJuB935Dtyp8YUicbhpSlXjw7vODTuOL/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971695; c=relaxed/simple;
	bh=AJFY02ZOzJgBYb1kQoRXe66eagICcX47pYjbIUv44Cw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=usV4jdHyrGH7rwxAqN2j16AnvuHsAFvdu82psRwmOPJuEbUxN3nDfibS/7Isf6DRTbuLK9ydDbMbKZ/GnN6asnOU4aiBngD2rS17jxVQDDWfkn08zd0gAOuOKKb6576BOmeV5As37wlWuODHmXniwhe/NuCyWtgXOStJq+cG9uo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lV81161H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lV81161H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D3E0C43394;
	Tue, 23 Jan 2024 01:01:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971695;
	bh=AJFY02ZOzJgBYb1kQoRXe66eagICcX47pYjbIUv44Cw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lV81161HKJkiuOkqysZRA8x/sS6y5DOjRcTKzKNTuZFx9/AOX51s2VR/RLgCay4T8
	 +bNq9yzvY4l3DOJFodlyAHbND8QXDGWp1pK0s3yRw52UEeZrNCfEIphYMuc+7rcYk/
	 N3duc6AY2PCY6gd8hefMCS4sOstn+euw+T0EXsiM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Song Liu <song@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	kernel test robot <lkp@intel.com>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 6.1 300/417] md/raid1: Use blk_opf_t for read and write operations
Date: Mon, 22 Jan 2024 15:57:48 -0800
Message-ID: <20240122235802.221325213@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bart Van Assche <bvanassche@acm.org>

commit 7dab24554dedd4e6f408af8eb2d25c89997a6a1f upstream.

Use the type blk_opf_t for read and write operations instead of int. This
patch does not affect the generated code but fixes the following sparse
warning:

drivers/md/raid1.c:1993:60: sparse: sparse: incorrect type in argument 5 (different base types)
     expected restricted blk_opf_t [usertype] opf
     got int rw

Cc: Song Liu <song@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Fixes: 3c5e514db58f ("md/raid1: Use the new blk_opf_t type")
Cc: stable@vger.kernel.org # v6.0+
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202401080657.UjFnvQgX-lkp@intel.com/
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Song Liu <song@kernel.org>
Link: https://lore.kernel.org/r/20240108001223.23835-1-bvanassche@acm.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/raid1.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1972,12 +1972,12 @@ static void end_sync_write(struct bio *b
 }
 
 static int r1_sync_page_io(struct md_rdev *rdev, sector_t sector,
-			   int sectors, struct page *page, int rw)
+			   int sectors, struct page *page, blk_opf_t rw)
 {
 	if (sync_page_io(rdev, sector, sectors << 9, page, rw, false))
 		/* success */
 		return 1;
-	if (rw == WRITE) {
+	if (rw == REQ_OP_WRITE) {
 		set_bit(WriteErrorSeen, &rdev->flags);
 		if (!test_and_set_bit(WantReplacement,
 				      &rdev->flags))
@@ -2094,7 +2094,7 @@ static int fix_sync_read_error(struct r1
 			rdev = conf->mirrors[d].rdev;
 			if (r1_sync_page_io(rdev, sect, s,
 					    pages[idx],
-					    WRITE) == 0) {
+					    REQ_OP_WRITE) == 0) {
 				r1_bio->bios[d]->bi_end_io = NULL;
 				rdev_dec_pending(rdev, mddev);
 			}
@@ -2109,7 +2109,7 @@ static int fix_sync_read_error(struct r1
 			rdev = conf->mirrors[d].rdev;
 			if (r1_sync_page_io(rdev, sect, s,
 					    pages[idx],
-					    READ) != 0)
+					    REQ_OP_READ) != 0)
 				atomic_add(s, &rdev->corrected_errors);
 		}
 		sectors -= s;
@@ -2321,7 +2321,7 @@ static void fix_read_error(struct r1conf
 				atomic_inc(&rdev->nr_pending);
 				rcu_read_unlock();
 				r1_sync_page_io(rdev, sect, s,
-						conf->tmppage, WRITE);
+						conf->tmppage, REQ_OP_WRITE);
 				rdev_dec_pending(rdev, mddev);
 			} else
 				rcu_read_unlock();
@@ -2338,7 +2338,7 @@ static void fix_read_error(struct r1conf
 				atomic_inc(&rdev->nr_pending);
 				rcu_read_unlock();
 				if (r1_sync_page_io(rdev, sect, s,
-						    conf->tmppage, READ)) {
+						conf->tmppage, REQ_OP_READ)) {
 					atomic_add(s, &rdev->corrected_errors);
 					pr_info("md/raid1:%s: read error corrected (%d sectors at %llu on %pg)\n",
 						mdname(mddev), s,


