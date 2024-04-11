Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 741ED13F452;
	Thu, 11 Apr 2024 10:16:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830590; cv=none; b=jz12mRq5L+TRznqiHgAJa9uf0iKwyl5Mz1o9MdoDgXo3doX/LFV9rNyaNPOMYXchMSKDXBaAj5myU7qLxvBD5uc+pBsbYSEu4UQH+IYX5rmGFkT6hQbtaylq7ck95lZE+Z01W93aFQZEVBLWkR+37jf66Mzp9qPLqymNFXpqI28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830590; c=relaxed/simple;
	bh=NJXwEbQn6Mr3tqLU6mwMpSRTqigbd7Kfav77pSy2ax4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lAmRAwqlJt0ah9q+v21T6dzszQ+kSeDIytCWqDRQp9X5Id8sgdAJ7+W1GpzE6z2AflIOsaDfYfTTzyq5o+u0TGsZYbgr8v0PmltC9iNx4LIsptbrORhJf6zyHgwutLDSCI6BmDoPFepp1kwU4IZMVTCyC0lV1t8JtuGvTmYFRYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qNpHDMvK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qNpHDMvK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9EA6C433F1;
	Thu, 11 Apr 2024 10:16:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830590;
	bh=NJXwEbQn6Mr3tqLU6mwMpSRTqigbd7Kfav77pSy2ax4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qNpHDMvK8Zhf8KWk5vR5tX5xjqvcp5kds7Ucq6ND1CVtkmr0gfu2p9IY+abjDLXIr
	 oe2qwQLuJ8qEHHqxciCEtiXC3LDHNPyxmmlEBbqAfsEJlyRFTBLBq9PAHU2Ut0g2Ff
	 bvIlpT+1UtTTH6A8XikDQeVSKqm9X+q4gF6bRBR4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Moulding <dan@danm.net>,
	Junxiao Bi <junxiao.bi@oracle.com>,
	Yu Kuai <yukuai3@huawei.com>,
	Song Liu <song@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 051/215] Revert "Revert "md/raid5: Wait for MD_SB_CHANGE_PENDING in raid5d""
Date: Thu, 11 Apr 2024 11:54:20 +0200
Message-ID: <20240411095426.427145773@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095424.875421572@linuxfoundation.org>
References: <20240411095424.875421572@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 0bea103f63d55..f3d60c4b34b8c 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -36,6 +36,7 @@
  */
 
 #include <linux/blkdev.h>
+#include <linux/delay.h>
 #include <linux/kthread.h>
 #include <linux/raid/pq.h>
 #include <linux/async_tx.h>
@@ -6334,7 +6335,18 @@ static void raid5d(struct md_thread *thread)
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



