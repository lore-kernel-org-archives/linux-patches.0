Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFAA51F55FA;
	Sun,  3 Aug 2025 21:18:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754255889; cv=none; b=soxjmpDpKnwwDTjiOT+gdaG7QPPYM4xGacHqFChFAziV4cwo7hjn5vjyuoutiAgf5dvtz8qslc3BhpLy+OfYNtE36URU+F5uvWkjgC77SuFN+K9rWn8/sruDJ3hjPV9VTSeWhMlTOfV2FuaCUh82SVh+CgiT7AfcZTdbWgrNb08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754255889; c=relaxed/simple;
	bh=Qbbq3+g1EZe6nVZezWXBk+vWyWaAXozTFL4B2ag0EYw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ZrAeS/sWyxT3MQjTDrVqcaVxetY946B4n7iMbpTQ19CFYlq0G2eRVni1UjXZbJ6wPwJdPoAGdViUw7JBtSc0IK3JNnkeCbvnhocUYgMhjZ9++q7IpkdoFWXY0B46cUi6mcEK9DLPyw77SU/8WEe2ZZeXnUxa+J4NyfSVikon+H8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=evXShSK0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="evXShSK0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8144DC4CEF0;
	Sun,  3 Aug 2025 21:18:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754255889;
	bh=Qbbq3+g1EZe6nVZezWXBk+vWyWaAXozTFL4B2ag0EYw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=evXShSK0nkQJ5eWE2IU+/+F3RE1EXix1n3wo0ZwOIDRYKmpPvZe6E8F8AzNslbF5p
	 7lwWsGb0kZ4oVbDKxiDDkeMRwp/NAwp4NQ2lqgNAT68DlB6H25cakLukOv56WFig8P
	 zDEu5YKcsHmOiLro3U1/6RDTQjxpSGmqRFNVnMpqmTffi0aTAN6G7lZJfIoq2vdGm3
	 1FYYiCGTw1IUA2UGfwtfJDHBZ7OSuns5BIOLFF997RV11dW6Cdhmt6+eZs5ouR7V3r
	 H7Q4XjvdpIBIfGQJBGDLSdMwxRfUdLXBnYgwPn+NxGiUpRlUKiFDekGl3TDqOWjN6Y
	 9GZ4SG6zeEHiw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: John Garry <john.g.garry@oracle.com>,
	Nilay Shroff <nilay@linux.ibm.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>,
	agk@redhat.com,
	snitzer@kernel.org,
	dm-devel@lists.linux.dev
Subject: [PATCH AUTOSEL 6.16 13/35] dm-stripe: limit chunk_sectors to the stripe size
Date: Sun,  3 Aug 2025 17:17:13 -0400
Message-Id: <20250803211736.3545028-13-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250803211736.3545028-1-sashal@kernel.org>
References: <20250803211736.3545028-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.16
Content-Transfer-Encoding: 8bit

From: John Garry <john.g.garry@oracle.com>

[ Upstream commit 5fb9d4341b782a80eefa0dc1664d131ac3c8885d ]

Same as done for raid0, set chunk_sectors limit to appropriately set the
atomic write size limit.

Setting chunk_sectors limit in this way overrides the stacked limit
already calculated based on the bottom device limits. This is ok, as
when any bios are sent to the bottom devices, the block layer will still
respect the bottom device chunk_sectors.

Reviewed-by: Nilay Shroff <nilay@linux.ibm.com>
Reviewed-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: John Garry <john.g.garry@oracle.com>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Link: https://lore.kernel.org/r/20250711105258.3135198-6-john.g.garry@oracle.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Based on my analysis of the commit and the kernel repository context,
here is my assessment:

**Backport Status: YES**

This commit should be backported to stable kernel trees for the
following reasons:

1. **Bug Fix**: This commit fixes a correctness issue where dm-stripe
   was not properly setting the `chunk_sectors` limit. The commit
   message explains that this is needed to "appropriately set the atomic
   write size limit." Without this fix, atomic writes on dm-stripe
   devices may not work correctly or may have incorrect size limits.


3. **Small and Contained**: The change is minimal - just a single line
   addition:
  ```c
  limits->chunk_sectors = sc->chunk_size;
  ```
  This sets the chunk_sectors field in the io_hints function, which is a
  straightforward fix with minimal risk.

4. **Fixes Regression/Incorrect Behavior**: The block layer commit
   `add194b01e4a` shows that the stacking code now relies on
   `chunk_sectors` instead of `io_min` to determine atomic write limits.
   Without this dm-stripe fix, atomic writes would be incorrectly
   limited or potentially fail on dm-stripe devices because the
   chunk_sectors field would be unset.

5. **No New Features**: This doesn't add new functionality - it simply
   ensures that an existing feature (atomic writes, enabled by commit
   `30b88ed06f80`) works correctly by providing the required
   chunk_sectors information.

6. **Clear Dependencies**: The commit is self-contained and only depends
   on the atomic writes infrastructure already being present
   (DM_TARGET_ATOMIC_WRITES flag), which was added earlier.

The fix addresses a real issue where atomic write operations on dm-
stripe devices would have incorrect size limits because the block layer
stacking code expects chunk_sectors to be set but dm-stripe wasn't
providing this value. This is exactly the type of bug fix that stable
kernels should receive - it's small, fixes incorrect behavior, and has
minimal risk of introducing regressions.

 drivers/md/dm-stripe.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/dm-stripe.c b/drivers/md/dm-stripe.c
index a7dc04bd55e5..5bbbdf8fc1bd 100644
--- a/drivers/md/dm-stripe.c
+++ b/drivers/md/dm-stripe.c
@@ -458,6 +458,7 @@ static void stripe_io_hints(struct dm_target *ti,
 	struct stripe_c *sc = ti->private;
 	unsigned int chunk_size = sc->chunk_size << SECTOR_SHIFT;
 
+	limits->chunk_sectors = sc->chunk_size;
 	limits->io_min = chunk_size;
 	limits->io_opt = chunk_size * sc->stripes;
 }
-- 
2.39.5

