Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 779EAAD23
	for <patches@lists.linux.dev>; Thu, 27 Oct 2022 17:05:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7F13C433D6;
	Thu, 27 Oct 2022 17:05:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1666890309;
	bh=rTHBVnBpcW68aeZKtLNTfyrFKp+Sym6n6PggK+rcHmU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O5mDpsckEjJ/+vzubuZgznwPVpswwfD4ylwsgVpJRiM0DRhv4JstGSPI63T0KMynW
	 7R/owwGkzG4M0i6dSaGjy0Uaqwx82ZHSTO2a/Yv46rERDPUhSvMWHSqXrSTCF94qzg
	 JYcSlpiG8c/rBXytSemWvN9snVBfMPavqAvgfiFE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lei Chen <lennychen@tencent.com>,
	Jens Axboe <axboe@kernel.dk>,
	Yu Kuai <yukuai3@huawei.com>
Subject: [PATCH 5.10 21/79] block: wbt: Remove unnecessary invoking of wbt_update_limits in wbt_init
Date: Thu, 27 Oct 2022 18:55:31 +0200
Message-Id: <20221027165055.112564156@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221027165054.270676357@linuxfoundation.org>
References: <20221027165054.270676357@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Lei Chen <lennychen@tencent.com>

commit 5a20d073ec54a72d9a732fa44bfe14954eb6332f upstream.

It's unnecessary to call wbt_update_limits explicitly within wbt_init,
because it will be called in the following function wbt_queue_depth_changed.

Signed-off-by: Lei Chen <lennychen@tencent.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/blk-wbt.c |    1 -
 1 file changed, 1 deletion(-)

--- a/block/blk-wbt.c
+++ b/block/blk-wbt.c
@@ -840,7 +840,6 @@ int wbt_init(struct request_queue *q)
 	rwb->enable_state = WBT_STATE_ON_DEFAULT;
 	rwb->wc = 1;
 	rwb->rq_depth.default_depth = RWB_DEF_DEPTH;
-	wbt_update_limits(rwb);
 
 	/*
 	 * Assign rwb and add the stats callback.


