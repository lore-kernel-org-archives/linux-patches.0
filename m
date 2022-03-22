Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90B796453
	for <patches@lists.linux.dev>; Tue, 22 Mar 2022 21:39:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A8B1C340EC;
	Tue, 22 Mar 2022 21:39:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1647985157;
	bh=MYvmPK/aNmj5i4GoFiNTXCOIpY4oArXSx1tzkhuqs0o=;
	h=Date:To:From:In-Reply-To:Subject:From;
	b=MkSC30XRPIwmNytv1XgJVeiyI1CCAPsRbRyjcKwtMzTBLv7WxkdH2H1cj4qhDAhFj
	 SNcHU82DPxGWsL28y9hg0GI5LHtPkX4ABCHX/ltklmZt07pxNuDJWyjiROsLaLK9Nt
	 OfuY88JDZxF4OAoZM8q/pEZjDkgpXg4W6kCXM9i0=
Date: Tue, 22 Mar 2022 14:39:16 -0700
To: trond.myklebust@hammerspace.com,philipp.reisner@linbit.com,paolo.valente@linaro.org,miklos@szeredi.hu,lars.ellenberg@linbit.com,konishi.ryusuke@gmail.com,jlayton@kernel.org,jaegeuk@kernel.org,jack@suse.cz,idryomov@gmail.com,fengguang.wu@intel.com,djwong@kernel.org,chao@kernel.org,axboe@kernel.dk,Anna.Schumaker@Netapp.com,neilb@suse.de,akpm@linux-foundation.org,patches@lists.linux.dev,linux-mm@kvack.org,mm-commits@vger.kernel.org,torvalds@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 015/227] block/bfq-iosched.c: use "false" rather than "BLK_RW_ASYNC"
Message-Id: <20220322213917.5A8B1C340EC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

From: NeilBrown <neilb@suse.de>
Subject: block/bfq-iosched.c: use "false" rather than "BLK_RW_ASYNC"

bfq_get_queue() expects a "bool" for the third arg, so pass "false" rather
than "BLK_RW_ASYNC" which will soon be removed.

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
---

 block/bfq-iosched.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/block/bfq-iosched.c~block-bfq-ioschedc-use-false-rather-than-blk_rw_async
+++ a/block/bfq-iosched.c
@@ -5448,7 +5448,7 @@ static void bfq_check_ioprio_change(stru
 	bfqq = bic_to_bfqq(bic, false);
 	if (bfqq) {
 		bfq_release_process_ref(bfqd, bfqq);
-		bfqq = bfq_get_queue(bfqd, bio, BLK_RW_ASYNC, bic, true);
+		bfqq = bfq_get_queue(bfqd, bio, false, bic, true);
 		bic_set_bfqq(bic, bfqq, false);
 	}
 
_
