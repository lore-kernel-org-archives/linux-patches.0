Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E41FF28134C;
	Sat, 14 Feb 2026 21:25:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771104314; cv=none; b=K4Ky8zBVVe/SUWP5gQLx5F0Pg8RCSJNTq2bYSXfYoO5GjS2TB1LsEANllhWhvOvqILoOxI+bqlSL/wbAi84Cs2j8RiP9G5nlOSCd3V3maIzoc12QKxwHchG9FFRXToIJvAZeV5XJhLNqTAJ5+ZrxXqabBxMOfpZX3kvSJeoZBTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771104314; c=relaxed/simple;
	bh=ZXiXZ6YevPbHW0L7SHmCvA7cUwD3rOnV9lujM+zgwHo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=R7LraREDfQ7L/3xlqpQUCxqI4Q27fO+BlAWnPj5xYmzNy5N+tga2eAkTlm2+rClZxvGYOy4xB8/hM8ULjcEMNQ4Sz1Hy+NNgE9EKpvxdrzMZVAMMC3tTuCTIk4z6rKtu4SbY1AErveQDYMkaBayRhwK1NDwMhTeMmHJZcLRSb68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rf8IJTgd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rf8IJTgd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40AE7C16AAE;
	Sat, 14 Feb 2026 21:25:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771104313;
	bh=ZXiXZ6YevPbHW0L7SHmCvA7cUwD3rOnV9lujM+zgwHo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rf8IJTgd53HCo3LXHI3DIrDaBa/btuju6vrxlkfPRIC/UWVbpdlhA+hxB83eYJ8yO
	 kHM8l4SoWw++WlepoR2q6hc4UpczaN4bL+SS/rqVPQY4CYV8zCM+HJZE0i0CxYdI0A
	 z5iUrQn9zWUXykKl6/pHxblSZ6SuYa9QKDsqioDzWTlytQo71Z9QYKXjvz1auVUVQW
	 INs3mG6pflwzkElEH7V2Twz72A849S1LRY7ESMub0GClNFyeQfOXo169ct5Yhwej6g
	 63LBEbQdM4CHOi5L6V7BVGg/k0D12cz/6L/hA3Jfn14YC/0ugsiYEW19oiAFE3JlSc
	 rBA588i7FNSMw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jijie Shao <shaojijie@huawei.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	neil.armstrong@linaro.org,
	kuba@kernel.org,
	yelangyan@huaqin.corp-partner.google.com,
	horms@kernel.org,
	shenjian15@huawei.com,
	wangpeiyang1@huawei.com,
	liuyonglong@huawei.com,
	vadim.fedorenko@linux.dev
Subject: [PATCH AUTOSEL 6.19-5.15] net: hns3: extend HCLGE_FD_AD_QID to 11 bits
Date: Sat, 14 Feb 2026 16:22:34 -0500
Message-ID: <20260214212452.782265-9-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260214212452.782265-1-sashal@kernel.org>
References: <20260214212452.782265-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jijie Shao <shaojijie@huawei.com>

[ Upstream commit 878406d4d6ef85c37fab52074771cc916e532c16 ]

Currently, HCLGE_FD_AD_QID has only 10 bits and supports a
maximum of 1023 queues. However, there are actually scenarios
where the queue_id exceeds 1023.

This patch adds an additional bit to HCLGE_FD_AD_QID to ensure
that queue_id greater than 1023 are supported.

Signed-off-by: Jijie Shao <shaojijie@huawei.com>
Link: https://patch.msgid.link/20260123094756.3718516-2-shaojijie@huawei.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Wait — the code I'm reading is the **pre-patch** state (the commit
hasn't been applied yet on this branch). Let me look at the diff more
carefully.

### 3. Detailed Diff Analysis

The patch makes these changes:

**In `hclge_cmd.h`:**
- Renames `HCLGE_FD_AD_QID_S/M` to `HCLGE_FD_AD_QID_L_S/M` (the lower 10
  bits remain the same: GENMASK(11, 2))
- Adds a new `HCLGE_FD_AD_QID_H_B` at bit 21 in the upper 32 bits of
  ad_data

**In `hclge_main.c`:**
- Before the `ad_data <<= 32` shift, adds the high bit: sets bit 21 of
  the upper word when `queue_id >= 1024`
- After the shift, uses the renamed `_L_` macros for the lower 10 bits
  (same as before)

**The bug:** When queue_id >= 1024 (e.g., queue 1024–2047), only the
lower 10 bits were written to the hardware register. This means:
- queue_id = 1024 (0x400) → only bits 9:0 = 0x000 → hardware sees queue
  0
- queue_id = 1025 (0x401) → only bits 9:0 = 0x001 → hardware sees queue
  1
- etc.

This causes **traffic misdirection** — flow director rules that target
queues >= 1024 silently send packets to the wrong queue. This is a data-
plane correctness bug.

### 4. Classification

This is a **bug fix** — it fixes incorrect hardware register programming
that causes silent traffic misdirection. While the commit message says
"extend" (which sounds like a feature), the reality is:
- The hardware already supports 11-bit queue IDs (the bit position
  exists)
- The driver was already allocating queues >= 1024 (as evidenced by
  `HCLGE_TQP_MAX_SIZE_DEV_V2 = 1024` and the extended register offset
  support)
- The validation code already allows queue_id values up to `num_tqps`
  which can exceed 1024
- Only the flow director action data encoding was missing the high bit

So this is fixing a **truncation bug** where the driver silently drops
the MSB of the queue ID when programming flow director rules, causing
packets to go to the wrong queue.

### 5. Scope and Risk Assessment

- **Files changed:** 2 files
- **Lines changed:** ~10 lines of actual code change
- **Risk:** LOW — the change only affects HNS3 driver (Hisilicon network
  hardware), and only the flow director action configuration path. It
  doesn't affect the common code path for non-FD traffic.
- **The change is additive:** For queue_id < 1024, behavior is identical
  (the high bit is set to 0, the low 10 bits are written the same way).
  Only queue_id >= 1024 gets the extra bit set.

### 6. User Impact

- **Who is affected:** Users of HNS3 network cards (common in
  Huawei/Hisilicon servers) who have more than 1024 queues and use flow
  director rules
- **Severity:** MEDIUM-HIGH — traffic misdirection can cause:
  - Performance degradation (packets not going to expected CPU/queue)
  - Application-level issues (RSS/flow director used for specific CPU
    affinity)
  - Potential packet processing errors if queue 0 is not expecting this
    traffic
- **Frequency:** Only triggers when queue_id >= 1024 AND flow director
  is used

### 7. Stability Assessment

- Small, contained change to a single driver
- Clear one-to-one mapping between the bug (truncation) and the fix (add
  high bit)
- No risk of regression for queue_id < 1024 (identical behavior)
- The fix uses existing hardware register bits — this is matching the
  driver to hardware reality

### 8. Concerns

- **No Fixes: tag** — expected for manual review candidates
- **Could be seen as a feature** — but it's really fixing a truncation
  bug in existing functionality
- **Dependency check:** The `HCLGE_TQP_MAX_SIZE_DEV_V2` constant exists
  in stable trees (it was part of original extended queue support), so
  this fix applies cleanly to the relevant context

### Final Assessment

This commit fixes a real bug where the HNS3 flow director silently
truncates queue IDs >= 1024, causing traffic to be directed to the wrong
queue. The fix is small (adding one bit to the hardware register
encoding), contained to the HNS3 driver, and has zero regression risk
for the common case (queue_id < 1024). While the commit message frames
it as "extending" the field, the underlying issue is a correctness bug
in the driver's hardware register programming that causes silent traffic
misdirection.

The fix meets stable criteria: it's obviously correct, fixes a real bug
(traffic misdirection), is small and contained, and doesn't introduce
new features (the hardware already supported 11-bit queue IDs).

**YES**

 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h  | 5 +++--
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c | 4 +++-
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
index 416e02e7b995f..bc333d8710ac1 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
@@ -727,8 +727,8 @@ struct hclge_fd_tcam_config_3_cmd {
 
 #define HCLGE_FD_AD_DROP_B		0
 #define HCLGE_FD_AD_DIRECT_QID_B	1
-#define HCLGE_FD_AD_QID_S		2
-#define HCLGE_FD_AD_QID_M		GENMASK(11, 2)
+#define HCLGE_FD_AD_QID_L_S		2
+#define HCLGE_FD_AD_QID_L_M		GENMASK(11, 2)
 #define HCLGE_FD_AD_USE_COUNTER_B	12
 #define HCLGE_FD_AD_COUNTER_NUM_S	13
 #define HCLGE_FD_AD_COUNTER_NUM_M	GENMASK(19, 13)
@@ -741,6 +741,7 @@ struct hclge_fd_tcam_config_3_cmd {
 #define HCLGE_FD_AD_TC_OVRD_B		16
 #define HCLGE_FD_AD_TC_SIZE_S		17
 #define HCLGE_FD_AD_TC_SIZE_M		GENMASK(20, 17)
+#define HCLGE_FD_AD_QID_H_B		21
 
 struct hclge_fd_ad_config_cmd {
 	u8 stage;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index b8e2aa19f9e61..a90f1a91f9973 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -5679,11 +5679,13 @@ static int hclge_fd_ad_config(struct hclge_dev *hdev, u8 stage, int loc,
 		hnae3_set_field(ad_data, HCLGE_FD_AD_TC_SIZE_M,
 				HCLGE_FD_AD_TC_SIZE_S, (u32)action->tc_size);
 	}
+	hnae3_set_bit(ad_data, HCLGE_FD_AD_QID_H_B,
+		      action->queue_id >= HCLGE_TQP_MAX_SIZE_DEV_V2 ? 1 : 0);
 	ad_data <<= 32;
 	hnae3_set_bit(ad_data, HCLGE_FD_AD_DROP_B, action->drop_packet);
 	hnae3_set_bit(ad_data, HCLGE_FD_AD_DIRECT_QID_B,
 		      action->forward_to_direct_queue);
-	hnae3_set_field(ad_data, HCLGE_FD_AD_QID_M, HCLGE_FD_AD_QID_S,
+	hnae3_set_field(ad_data, HCLGE_FD_AD_QID_L_M, HCLGE_FD_AD_QID_L_S,
 			action->queue_id);
 	hnae3_set_bit(ad_data, HCLGE_FD_AD_USE_COUNTER_B, action->use_counter);
 	hnae3_set_field(ad_data, HCLGE_FD_AD_COUNTER_NUM_M,
-- 
2.51.0

