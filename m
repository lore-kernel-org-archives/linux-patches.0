Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24E2C745D6;
	Tue, 23 Jan 2024 02:04:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975451; cv=none; b=Zmt9WgNK5pnPt6oz6FCxCpnmrbG0Xwl8Yrso6TwBuci7XJY5pW14B8pM5pvFHwOu7riVEd8nvzUx1vZInmDYx7f4hAMwUUDQRZ1Hl5mAbjgB+/a5a2ZTnIn6oWHgpkYu8QM2HkYVKpKfiQBPCffZJrRmIxsZ+oVe42NaMCsdAa0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975451; c=relaxed/simple;
	bh=HG4d6VYL8mboTzAD3d7PfRGJ5csbWhf5wuyaWUVtD0k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WQDmldxsJjC5bT6Eve0WzpGBlu67SkLne0w9x1m6qd3dbXmgvEqid0tQ2vKwuHxX1uiozFuIU6UcM4VLSBDSrvFdbvQTA2LJ1CfSBUx00cBkI35mp86wU0KDEkhfttaAZcQGAwDgepGQ6UUgsnady2rBfrxUUnivk8fB45ywUts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hNmUhfL5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hNmUhfL5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEE27C433F1;
	Tue, 23 Jan 2024 02:04:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975451;
	bh=HG4d6VYL8mboTzAD3d7PfRGJ5csbWhf5wuyaWUVtD0k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hNmUhfL5TWPlF3eexanbvJ29zRg8AAUxr5BqrGus5dKw6hfF3iVYgdL/UQzeZHtrV
	 RVg4/SjF6gMR+7GjNn8WpPD0P55nlytNr8Gvm7SrEcwke/OSCBhZbWXePGhyy7JK5h
	 iGnUxL7sZZKEJMCYtqDPV5StpGzoeNQV6BZNeox4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Song Liu <song@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	kernel test robot <lkp@intel.com>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 6.6 407/583] md/raid1: Use blk_opf_t for read and write operations
Date: Mon, 22 Jan 2024 15:57:38 -0800
Message-ID: <20240122235824.432440352@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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
@@ -1983,12 +1983,12 @@ static void end_sync_write(struct bio *b
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
@@ -2105,7 +2105,7 @@ static int fix_sync_read_error(struct r1
 			rdev = conf->mirrors[d].rdev;
 			if (r1_sync_page_io(rdev, sect, s,
 					    pages[idx],
-					    WRITE) == 0) {
+					    REQ_OP_WRITE) == 0) {
 				r1_bio->bios[d]->bi_end_io = NULL;
 				rdev_dec_pending(rdev, mddev);
 			}
@@ -2120,7 +2120,7 @@ static int fix_sync_read_error(struct r1
 			rdev = conf->mirrors[d].rdev;
 			if (r1_sync_page_io(rdev, sect, s,
 					    pages[idx],
-					    READ) != 0)
+					    REQ_OP_READ) != 0)
 				atomic_add(s, &rdev->corrected_errors);
 		}
 		sectors -= s;
@@ -2332,7 +2332,7 @@ static void fix_read_error(struct r1conf
 				atomic_inc(&rdev->nr_pending);
 				rcu_read_unlock();
 				r1_sync_page_io(rdev, sect, s,
-						conf->tmppage, WRITE);
+						conf->tmppage, REQ_OP_WRITE);
 				rdev_dec_pending(rdev, mddev);
 			} else
 				rcu_read_unlock();
@@ -2349,7 +2349,7 @@ static void fix_read_error(struct r1conf
 				atomic_inc(&rdev->nr_pending);
 				rcu_read_unlock();
 				if (r1_sync_page_io(rdev, sect, s,
-						    conf->tmppage, READ)) {
+						conf->tmppage, REQ_OP_READ)) {
 					atomic_add(s, &rdev->corrected_errors);
 					pr_info("md/raid1:%s: read error corrected (%d sectors at %llu on %pg)\n",
 						mdname(mddev), s,


