Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A9691EDA3A;
	Sun,  3 Aug 2025 21:19:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754255951; cv=none; b=GQXk4I7QE1En1DhZAWcZIqv8t9hXMQAuZJCxW1m+0ARKNHeX/Mn2RW7rZlBqVK2kIVWjgMyYkorWoTPScrGrSlqwpCzmLlhuYvIcmDuZuIE+9sUGxdwzDLj8xjihx9XqfTcLlh5gtL8jc+k+juLVf6NwRNPqCBty1CD+pmElWQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754255951; c=relaxed/simple;
	bh=ZtJ4MVvve5KmVXBeKkdCKrHnKHy/2catN6/KMNxQwqY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=VLI0UbQIwnCa4CEE1ZEu4YAmRnbQ0mLUQzY4/C3XViGku2X+AmHbycArhy/dlcOgxayltBlbv2dWLbcp/tzVOHAQdR7kQhq9uC7dftS+5nArrllhopxXTi/pNzlKadOvoUVtaskUZQl+b+J+vrl73SU0bqn6uafuvYtOAL+naVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZrZRYgVP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZrZRYgVP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90881C4CEEB;
	Sun,  3 Aug 2025 21:19:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754255949;
	bh=ZtJ4MVvve5KmVXBeKkdCKrHnKHy/2catN6/KMNxQwqY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZrZRYgVPuuOgj4k5RmjWRSvUXBAWUXf8qibWjXL3IlDIjtq7Pxt2JEOtbHFrm/3WT
	 skreTDNsHsrisdDZDEa7bc/qTF7csC26of1uSRvm9xnp8QTxuOiUIaKPVDl9irPNN/
	 6v0K3pmTbgVQx4AvOv25GUJC9pvn5jM9mTK2rc9kVjtCdjoVYyT+atZiruIY2amEs+
	 bQMc68/bUfBZLRwnpXlHHvfEaFTWCe4K81fHm0mV5dFFyixw3C0Wy2A2520jRnZhYk
	 n3NPUYIZ/5OkIjJNcgdiGqzW6mV7WebDuFxrmJxmVuTjhZKePcXmm/Zo4jrL/DF0h0
	 EpV/jDJOkQ2Xg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: John Garry <john.g.garry@oracle.com>,
	Nilay Shroff <nilay@linux.ibm.com>,
	Yu Kuai <yukuai3@huawei.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>,
	song@kernel.org,
	linux-raid@vger.kernel.org
Subject: [PATCH AUTOSEL 6.15 13/34] md/raid10: set chunk_sectors limit
Date: Sun,  3 Aug 2025 17:18:15 -0400
Message-Id: <20250803211836.3546094-13-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250803211836.3546094-1-sashal@kernel.org>
References: <20250803211836.3546094-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.15.9
Content-Transfer-Encoding: 8bit

From: John Garry <john.g.garry@oracle.com>

[ Upstream commit 7ef50c4c6a9c36fa3ea6f1681a80c0bf9a797345 ]

Same as done for raid0, set chunk_sectors limit to appropriately set the
atomic write size limit.

Reviewed-by: Nilay Shroff <nilay@linux.ibm.com>
Reviewed-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: John Garry <john.g.garry@oracle.com>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Link: https://lore.kernel.org/r/20250711105258.3135198-5-john.g.garry@oracle.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Based on my analysis, here's my assessment:

**Backport Status: YES**

This commit should be backported to stable kernel trees for the
following reasons:

1. **Bug Fix for Correctness**: The commit fixes a missing configuration
   that causes incorrect atomic write size limits in RAID10. The code
   shows that `lim.chunk_sectors` needs to be set properly for the
   atomic writes feature to work correctly. Without this, the
   `blk_stack_atomic_writes_chunk_sectors()` function in block/blk-
   settings.c won't have the correct chunk size information, leading to
   incorrect atomic write size calculations.


3. **Small and Contained Change**: The fix is a single line addition:
  ```c
  lim.chunk_sectors = mddev->chunk_sectors;
  ```
  This is a minimal change that only affects the RAID10 queue limits
  setup.

4. **No Architectural Changes**: The change doesn't introduce new
   features or modify existing architecture. It simply ensures an
   existing field is properly initialized with the correct value that's
   already available (`mddev->chunk_sectors`).

5. **Prevents Data Corruption Risk**: Without proper chunk_sectors
   limits, atomic writes may not work correctly on RAID10 arrays. This
   could lead to writes that are supposed to be atomic being split
   incorrectly, potentially causing data integrity issues.

6. **Affects Users**: Any system using RAID10 with applications that
   rely on atomic writes (databases, filesystems) would be affected by
   this missing configuration. The fix ensures that atomic write
   guarantees are properly honored.

7. **Low Risk**: The change has minimal risk of regression as it only
   sets a field that was previously uninitialized. The value being set
   (`mddev->chunk_sectors`) is already validated and used elsewhere in
   the RAID10 code.

The commit is clearly a bug fix that corrects an oversight where RAID10
wasn't setting the chunk_sectors limit while RAID0 was already fixed for
the same issue. This makes it an excellent candidate for stable
backporting.

 drivers/md/raid10.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 6a55374a6ba3..e946abe62084 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -4019,6 +4019,7 @@ static int raid10_set_queue_limits(struct mddev *mddev)
 	md_init_stacking_limits(&lim);
 	lim.max_write_zeroes_sectors = 0;
 	lim.io_min = mddev->chunk_sectors << 9;
+	lim.chunk_sectors = mddev->chunk_sectors;
 	lim.io_opt = lim.io_min * raid10_nr_stripes(conf);
 	lim.features |= BLK_FEAT_ATOMIC_WRITES;
 	err = mddev_stack_rdev_limits(mddev, &lim, MDDEV_STACK_INTEGRITY);
-- 
2.39.5

