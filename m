Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66E581F55FA;
	Sun,  3 Aug 2025 21:20:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754256005; cv=none; b=YBUEzgeld59YiwCh3poAT29HeF6pvjsjbhYmTdjRGowZvixpmrtGm0KKbyez5p3zBrtJptLqdyrPygh5l9WcXEjDQ+CcVXGCQiOrvTmREq4iXchhxyPUVAonA4um6myQ1wVOXPwE0ltBCYO7bt7BwHFiB6KZRnftoiIF6BR48CU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754256005; c=relaxed/simple;
	bh=j3cmZv+0oCkOIwV1waj8AjYk2uVm7daeqbRWH4TOook=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=MNKbYK++1CiL37UcinInCVE94taG9FFKNygGFPmsv6g5uToAjvUJDSZ9Zf/3O2SP0NMZuYPFrvbYAS5iAOTYpsOm/OjhisQIY17wop1tYPemlJsx4B6W9IBwO6ZXpfPKJGQsGO4aae2eaVW3XtdayUPpO1dBUpodaYKHfGXnzOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AS1byLVb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AS1byLVb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E9FCC4CEF9;
	Sun,  3 Aug 2025 21:20:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754256005;
	bh=j3cmZv+0oCkOIwV1waj8AjYk2uVm7daeqbRWH4TOook=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AS1byLVb9iQdMsXUwB8UJE3FSMKSKNw7ZhafRlGtn10Gg7mZlBomiozXNXKwhBj7s
	 rMAFLX6C71hkENCBUDrp4JXsWfS8d9nAfc6tnPvWJgkMML6R8KyH57UWnEn0orR8fM
	 WNS8werLilw39iVl+3jV/ab1l/y3qfyJrPka5sTQ0JzvO3eCKECU59dGFDD6xS2RdF
	 0bKL2sQYQv2YB19yDq1Ap/bIk9/19jhYYYHc8gQpCgyRsc5MWmOPTxanP8Xa/MEjgH
	 FPSfZ/+zC6Q+WYBhitaq+5r6OVqNgzq4HytCRcl0uiNFf6xOqRGrbTntODM+yp08E3
	 yFrFSLgiWEDiw==
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
Subject: [PATCH AUTOSEL 6.12 11/31] md/raid10: set chunk_sectors limit
Date: Sun,  3 Aug 2025 17:19:14 -0400
Message-Id: <20250803211935.3547048-11-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250803211935.3547048-1-sashal@kernel.org>
References: <20250803211935.3547048-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.12.41
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
index 5cdc599fcad3..7515a98001ca 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -3968,6 +3968,7 @@ static int raid10_set_queue_limits(struct mddev *mddev)
 	md_init_stacking_limits(&lim);
 	lim.max_write_zeroes_sectors = 0;
 	lim.io_min = mddev->chunk_sectors << 9;
+	lim.chunk_sectors = mddev->chunk_sectors;
 	lim.io_opt = lim.io_min * raid10_nr_stripes(conf);
 	err = mddev_stack_rdev_limits(mddev, &lim, MDDEV_STACK_INTEGRITY);
 	if (err)
-- 
2.39.5

