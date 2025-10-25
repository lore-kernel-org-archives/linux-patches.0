Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A764E2580F2;
	Sat, 25 Oct 2025 16:17:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409031; cv=none; b=jxLYrFTKcshRdbJKf569jOvCHl/DGuN19ZfwjgQnh7ArJgxjfWCr1sH01KCTa+VHqfO2wRIl94ht/EREhXBxihtF3HbAC2R91ts0noxylayrQRe1w8SQT4YmA8Y448No0D7GPn5hNnnq99IVNkSztN/AbHtTtZEZfBDvQ64AeoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409031; c=relaxed/simple;
	bh=bsvbG9dLqg+qAvdA5HwP2X+E8jus+zRuRiICPdAvgd8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PeYM++fcx84SzR/6b8omh/5EGMLeCT2wu5xqUv1vKsV0cXzuBC1qqBvs7ycDdjEqODoP6P39zXGxTtHzoWjbEox+Oo0maZ32cxGqSYH32hnhCR+bdv6G000ERvVui/RWgdBK7CQLnlzxpMxqRHxXfr9LLOnX59FkRQqI3kAVlUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jpSj6+xe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jpSj6+xe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F087C4CEF5;
	Sat, 25 Oct 2025 16:17:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409031;
	bh=bsvbG9dLqg+qAvdA5HwP2X+E8jus+zRuRiICPdAvgd8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jpSj6+xeLhK1VfY3RWyr5yQyTw8TcQoDXnMoCmuZRQzNLgqMWvOb/LLQFdMVISWzn
	 DOnLPEA2dwZ6n5coTzVT/bpgk82G9l1eVz3npCf/Sg/mn08YSxlWZRbrSi9cA1o9b8
	 bxxdp2HX33UEN1Qfa/EpLVg3OvBEe1qx0gGVs0FZH2Lgde+FHJJYqzlBpftrnIf7Bq
	 VopMYixGXKI+HC37sMaOIXQ6UpQ8pIIA+K5FwFfF9S+Eb4vsHSJbNDUkADb9jUszKq
	 o2O8gbRglK/MHwXvSRmKnWiqrkPJgcy7ftG3SZgWc09m0rnbh0kKW867WOjQLPf9mI
	 A1X8pabXTlgfw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	agk@redhat.com,
	snitzer@kernel.org,
	dm-devel@lists.linux.dev
Subject: [PATCH AUTOSEL 6.17-6.12] dm error: mark as DM_TARGET_PASSES_INTEGRITY
Date: Sat, 25 Oct 2025 11:56:48 -0400
Message-ID: <20251025160905.3857885-177-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 499cbe0f2fb0641cf07a1a8ac9f7317674295fea ]

Mark dm error as DM_TARGET_PASSES_INTEGRITY so that it can be stacked on
top of PI capable devices.  The claim is strictly speaking as lie as dm
error fails all I/O and doesn't pass anything on, but doing the same for
integrity I/O work just fine :)

This helps to make about two dozen xfstests test cases pass on PI capable
devices.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

- What changes: The patch adds `DM_TARGET_PASSES_INTEGRITY` to the error
  target’s feature bits, so the `error` target advertises that it
  “passes integrity” (even though it kills all I/O). In the upstream
  diff this is the sole functional change: `drivers/md/dm-target.c`
  updates `.features` to include `DM_TARGET_PASSES_INTEGRITY` alongside
  existing flags.
  - Upstream change site: drivers/md/dm-target.c (error target
    `.features` line).
  - In stable trees like v5.4, the analogous site is `drivers/md/dm-
    target.c:150`, where `.features = DM_TARGET_WILDCARD` currently
    lacks the integrity pass-through bit.

- Why it matters: Device-mapper only allows integrity-enabled I/O to be
  cloned/mapped through a target if it either implements integrity
  itself or passes integrity through:
  - Clone-path gate: drivers/md/dm.c:1369–1376. If a bio has integrity
    and the target does not have `DM_TARGET_INTEGRITY` or
    `DM_TARGET_PASSES_INTEGRITY`, `clone_bio()` returns `-EIO`, failing
    the I/O.
  - Table registration gate: drivers/md/dm-table.c:1207 requires all
    targets in the table to pass integrity for the DM device to register
    an integrity profile; otherwise integrity stacking is disabled for
    the mapped device.
  - As a result, today stacking `dm-error` atop a PI-capable device can
    fail or silently disable integrity, which breaks real workloads and,
    as the commit notes, about two dozen xfstests on PI devices.

- Correctness and safety: Marking the `error` target as “passes
  integrity” unblocks the two integrity gates above without changing the
  target’s behavior for data:
  - `io_err_map()` still returns `DM_MAPIO_KILL` (drivers/md/dm-
    target.c), so the request never reaches lower devices.
  - When integrity is present, the DM core will clone the integrity
    payload (drivers/md/dm.c:1369–1398) and then, because the target
    kills the I/O, `free_tio()` will `bio_put()` the clone, freeing the
    integrity payload (drivers/md/dm.c:633–647). No leaks, no functional
    change in outcomes (I/O still fails with error), only removal of
    spurious integrity gating.
  - Other simple pass-through targets already set this flag (e.g., `dm-
    linear`, `dm-mpath`, `dm-stripe`, `dm-delay`): drivers/md/dm-
    linear.c:220, drivers/md/dm-mpath.c:2009, drivers/md/dm-
    stripe.c:490, drivers/md/dm-delay.c:362. Aligning `dm-error`
    improves consistency.

- Scope and risk:
  - Minimal, single-bit feature change, confined to the `dm-error`
    target.
  - No architectural changes; no user-visible behavior change except
    allowing integrity-enabled stacking where it previously errored or
    disabled integrity.
  - Security neutral; performance impact negligible (a short-lived
    integrity clone that is immediately freed on kill).

- Backport notes:
  - The feature bit `DM_TARGET_PASSES_INTEGRITY` exists in stable series
    (include/linux/device-mapper.h:241–242), and the `error` target
    currently lacks it (drivers/md/dm-target.c:150 in v5.4).
  - Upstream diff also shows a `.version` bump and additional callbacks
    in newer kernels; for stable backports you can keep the version as-
    is and only add the feature bit. The functional fix is just the
    feature addition.
  - No dependencies on other recent changes.

Given it fixes real failures with PI-capable devices, is tiny and self-
contained, and aligns `dm-error` with other DM targets’ integrity
behavior, this is a good candidate for stable backport.

 drivers/md/dm-target.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-target.c b/drivers/md/dm-target.c
index 2af5a9514c05e..8fede41adec00 100644
--- a/drivers/md/dm-target.c
+++ b/drivers/md/dm-target.c
@@ -263,7 +263,8 @@ static long io_err_dax_direct_access(struct dm_target *ti, pgoff_t pgoff,
 static struct target_type error_target = {
 	.name = "error",
 	.version = {1, 7, 0},
-	.features = DM_TARGET_WILDCARD | DM_TARGET_ZONED_HM,
+	.features = DM_TARGET_WILDCARD | DM_TARGET_ZONED_HM |
+		DM_TARGET_PASSES_INTEGRITY,
 	.ctr  = io_err_ctr,
 	.dtr  = io_err_dtr,
 	.map  = io_err_map,
-- 
2.51.0

