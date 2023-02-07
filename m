Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CAE92C9C
	for <patches@lists.linux.dev>; Tue,  7 Feb 2023 13:10:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E228C433A7;
	Tue,  7 Feb 2023 13:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675775407;
	bh=BV6wM9wZIkVjDb50eajiVvWxg4ZcjQfWJyGF1j3vUBI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RbdnKdLDBsEHfRd66fDCkhQrwqZJWUgB6QoQe2WEN0sy9r+GqHXkmB2GkYcZGj+uJ
	 gHW1QM/y5r2hnnXGTx5m6UI5CSbspsQa28uk9c0CMOTu/b/lrAbZ2rVh6cNtZVUXpc
	 KgQ2G1KJGl61qx9icj78DyxMoC8C0uddQlMDA1qo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	NeilBrown <neilb@suse.de>,
	Jens Axboe <axboe@kernel.dk>,
	Anna Schumaker <Anna.Schumaker@Netapp.com>,
	Chao Yu <chao@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Ilya Dryomov <idryomov@gmail.com>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Jeff Layton <jlayton@kernel.org>,
	Lars Ellenberg <lars.ellenberg@linbit.com>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Paolo Valente <paolo.valente@linaro.org>,
	Philipp Reisner <philipp.reisner@linbit.com>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Wu Fengguang <fengguang.wu@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 029/120] block/bfq-iosched.c: use "false" rather than "BLK_RW_ASYNC"
Date: Tue,  7 Feb 2023 13:56:40 +0100
Message-Id: <20230207125620.030595305@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125618.699726054@linuxfoundation.org>
References: <20230207125618.699726054@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: NeilBrown <neilb@suse.de>

[ Upstream commit f6bad159f5d5e5b33531aba3d9b860ad8618afe0 ]

bfq_get_queue() expects a "bool" for the third arg, so pass "false"
rather than "BLK_RW_ASYNC" which will soon be removed.

Link: https://lkml.kernel.org/r/164549983746.9187.7949730109246767909.stgit@noble.brown
Signed-off-by: NeilBrown <neilb@suse.de>
Acked-by: Jens Axboe <axboe@kernel.dk>
Cc: Anna Schumaker <Anna.Schumaker@Netapp.com>
Cc: Chao Yu <chao@kernel.org>
Cc: Darrick J. Wong <djwong@kernel.org>
Cc: Ilya Dryomov <idryomov@gmail.com>
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Jeff Layton <jlayton@kernel.org>
Cc: Lars Ellenberg <lars.ellenberg@linbit.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Paolo Valente <paolo.valente@linaro.org>
Cc: Philipp Reisner <philipp.reisner@linbit.com>
Cc: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: Trond Myklebust <trond.myklebust@hammerspace.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Stable-dep-of: b600de2d7d3a ("block, bfq: fix uaf for bfqq in bic_set_bfqq()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/bfq-iosched.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index 85120d7b5cf0..87555dc42651 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -5360,7 +5360,7 @@ static void bfq_check_ioprio_change(struct bfq_io_cq *bic, struct bio *bio)
 	bfqq = bic_to_bfqq(bic, false);
 	if (bfqq) {
 		bfq_release_process_ref(bfqd, bfqq);
-		bfqq = bfq_get_queue(bfqd, bio, BLK_RW_ASYNC, bic, true);
+		bfqq = bfq_get_queue(bfqd, bio, false, bic, true);
 		bic_set_bfqq(bic, bfqq, false);
 	}
 
-- 
2.39.0



