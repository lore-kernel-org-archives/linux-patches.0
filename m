Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78B568C0D
	for <patches@lists.linux.dev>; Tue, 11 Apr 2023 14:18:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99E5FC433D2;
	Tue, 11 Apr 2023 14:18:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681222684;
	bh=phQbiTUMckwrc/2j8y2Y4Lzr+S5bXXke7Mem0FZ1I1c=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=EQ6kEUS887tn38L6Sk8gToVqEAh32Rx42Izy2rbZ3EvXckSQgCRSXGJM2w90aBCZ/
	 ERuJb4MCaXGYkLmHZxqVbkON1YvetEFyBgyPKx2bFBku+75F2HW3OVNHCX9ZEfFA8b
	 zbYgUgo2flNkXr7yVIQmveXpFp8F+EAi4KmnZgwQ=
Subject: Patch "Revert "media: ti: cal: fix possible memory leak in cal_ctx_create()"" has been added to the 5.10-stable tree
To: bparrot@ti.com,cuigaosheng1@huawei.com,gregkh@linuxfoundation.org,laurent.pinchart@ideasonboard.com,mchehab@kernel.org,patches@lists.linux.dev,sashal@kernel.org
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Tue, 11 Apr 2023 16:17:53 +0200
In-Reply-To: <20230404012502.3061129-1-cuigaosheng1@huawei.com>
Message-ID: <2023041153-malformed-streak-6073@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore 


This is a note to let you know that I've just added the patch titled

    Revert "media: ti: cal: fix possible memory leak in cal_ctx_create()"

to the 5.10-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     revert-media-ti-cal-fix-possible-memory-leak-in-cal_ctx_create.patch
and it can be found in the queue-5.10 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From cuigaosheng1@huawei.com  Tue Apr 11 16:17:00 2023
From: Gaosheng Cui <cuigaosheng1@huawei.com>
Date: Tue, 4 Apr 2023 09:25:02 +0800
Subject: Revert "media: ti: cal: fix possible memory leak in cal_ctx_create()"
To: <stable@vger.kernel.org>, <cuigaosheng1@huawei.com>
Cc: <bparrot@ti.com>, <mchehab@kernel.org>, <sashal@kernel.org>, <laurent.pinchart@ideasonboard.com>, <gregkh@linuxfoundation.org>, <patches@lists.linux.dev>
Message-ID: <20230404012502.3061129-1-cuigaosheng1@huawei.com>

From: Gaosheng Cui <cuigaosheng1@huawei.com>

This reverts commit c7a218cbf67fffcd99b76ae3b5e9c2e8bef17c8c.

The memory of ctx is allocated by devm_kzalloc in cal_ctx_create,
it should not be freed by kfree when cal_ctx_v4l2_init() fails,
otherwise kfree() will cause double free, so revert this patch.

The memory of ctx is allocated by kzalloc since commit
9e67f24e4d9 ("media: ti-vpe: cal: fix ctx uninitialization"),
so the fixes tag of patch c7a218cbf67fis not entirely accurate,
mainline should merge this patch, but it should not be merged
into 5.10, so we just revert this patch for this branch.

Fixes: c7a218cbf67f ("media: ti: cal: fix possible memory leak in cal_ctx_create()")
Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/ti-vpe/cal.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/media/platform/ti-vpe/cal.c
+++ b/drivers/media/platform/ti-vpe/cal.c
@@ -624,10 +624,8 @@ static struct cal_ctx *cal_ctx_create(st
 	ctx->cport = inst;
 
 	ret = cal_ctx_v4l2_init(ctx);
-	if (ret) {
-		kfree(ctx);
+	if (ret)
 		return NULL;
-	}
 
 	return ctx;
 }


Patches currently in stable-queue which might be from cuigaosheng1@huawei.com are

queue-5.10/revert-media-ti-cal-fix-possible-memory-leak-in-cal_ctx_create.patch
