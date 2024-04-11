Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C64E140E3C;
	Thu, 11 Apr 2024 10:35:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831724; cv=none; b=WrjnlIjuYZ8PyzdBBDU64HUVUPkvBYAq7egNdI/NdTVVJpceF9uYB7JUYaPwScAbtN3riExaEHTchN1nMKX86Ni6ir+ZbuSJXpgk6Dy8l+jD6V4OjIPd+nuCwTyXVJofia6jY8D6s64rkpddC+byh0vTOfIjxrjjTVTdcqjsqnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831724; c=relaxed/simple;
	bh=Qjo2Kwd7SjclfXISnwG0Nu5DD566RlvnRykFTPIWcxY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JrqMAWdUE9GRPrmRDNsBiV6Ap0l2sZxPXXNidNhFhMo9WUsnyQv1mIM3BGjx3WYTDVxxzGiLNZUsz84QsO37Ep1oyr1gdc7iOqEdViyxhkCRa2dVUzY3zg3Tsg4VUiK+ScrAJ4RZCis3RRKEm+SxZZudTYZhQdZFwZlRCpsThNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IAXGkii4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IAXGkii4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3927C433C7;
	Thu, 11 Apr 2024 10:35:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831724;
	bh=Qjo2Kwd7SjclfXISnwG0Nu5DD566RlvnRykFTPIWcxY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IAXGkii4I3yjJtab6LLq522Xn2ICwEBxSH1UtPmiZowQ65yxzwQsvB5TGU3ObvGsg
	 X4OzpJzaHB6vOwNb7GMDXRoGdcrLN5PkoongRM9aUv05I5fGO3nU063KV2Os2iaTrf
	 rQTCzKi3OVOHQOog/OkNmVXc7FxkIJHwkczlZaDw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Moulding <dan@danm.net>,
	Junxiao Bi <junxiao.bi@oracle.com>,
	Yu Kuai <yukuai3@huawei.com>,
	Song Liu <song@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 067/294] Revert "Revert "md/raid5: Wait for MD_SB_CHANGE_PENDING in raid5d""
Date: Thu, 11 Apr 2024 11:53:50 +0200
Message-ID: <20240411095437.704925128@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095435.633465671@linuxfoundation.org>
References: <20240411095435.633465671@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Song Liu <song@kernel.org>

[ Upstream commit 3445139e3a594be77eff48bc17eff67cf983daed ]

This reverts commit bed9e27baf52a09b7ba2a3714f1e24e17ced386d.

The original set [1][2] was expected to undo a suboptimal fix in [2], and
replace it with a better fix [1]. However, as reported by Dan Moulding [2]
causes an issue with raid5 with journal device.

Revert [2] for now to close the issue. We will follow up on another issue
reported by Juxiao Bi, as [2] is expected to fix it. We believe this is a
good trade-off, because the latter issue happens less freqently.

In the meanwhile, we will NOT revert [1], as it contains the right logic.

[1] commit d6e035aad6c0 ("md: bypass block throttle for superblock update")
[2] commit bed9e27baf52 ("Revert "md/raid5: Wait for MD_SB_CHANGE_PENDING in raid5d"")

Reported-by: Dan Moulding <dan@danm.net>
Closes: https://lore.kernel.org/linux-raid/20240123005700.9302-1-dan@danm.net/
Fixes: bed9e27baf52 ("Revert "md/raid5: Wait for MD_SB_CHANGE_PENDING in raid5d"")
Cc: stable@vger.kernel.org # v5.19+
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Song Liu <song@kernel.org>
Reviewed-by: Yu Kuai <yukuai3@huawei.com>
Link: https://lore.kernel.org/r/20240125082131.788600-1-song@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/raid5.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 00995e60d46b1..9f114b9d8dc6b 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -36,6 +36,7 @@
  */
 
 #include <linux/blkdev.h>
+#include <linux/delay.h>
 #include <linux/kthread.h>
 #include <linux/raid/pq.h>
 #include <linux/async_tx.h>
@@ -6519,7 +6520,18 @@ static void raid5d(struct md_thread *thread)
 			spin_unlock_irq(&conf->device_lock);
 			md_check_recovery(mddev);
 			spin_lock_irq(&conf->device_lock);
+
+			/*
+			 * Waiting on MD_SB_CHANGE_PENDING below may deadlock
+			 * seeing md_check_recovery() is needed to clear
+			 * the flag when using mdmon.
+			 */
+			continue;
 		}
+
+		wait_event_lock_irq(mddev->sb_wait,
+			!test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags),
+			conf->device_lock);
 	}
 	pr_debug("%d stripes handled\n", handled);
 
-- 
2.43.0



