Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5491D1DDC1D;
	Mon,  4 Aug 2025 00:30:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754267402; cv=none; b=d29bMY3rqFR9sdb/rgWEefiJ08ukHd1wcE//hDDmlZCDI8xASpHrDquVhgBrgdkW0JixYKvcMYNqpKPX13oWpaFi9Q4Qj+QbBu70wRqUXiZROpQr+lL9W6xK6NZV3JbNp5S0gRjOE4qbCo7MrzgSeNKY+dyhViU3GKssr/+VJN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754267402; c=relaxed/simple;
	bh=+Vu/ISKK0pkIljVtVCsO9Ao40my3jz4q3TyinfSq8+U=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=pnAR/n3CPRcDjQqC2gSf5Jtv7aiwLO7DLoTZ/tRprIsdyaJ5qGke2LN4kuw2N4uQkblRbsx310mchdhQct2l4434dmwWWUrjcOilCg2MZ16jUcM9QpBuLgpNk3rJbNmsj2swg/7nMiVoQuDralHBNdCJo5MwPAlAXRm1r3NTfK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vKVMogfD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vKVMogfD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DF77C4CEF0;
	Mon,  4 Aug 2025 00:30:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754267402;
	bh=+Vu/ISKK0pkIljVtVCsO9Ao40my3jz4q3TyinfSq8+U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vKVMogfDjrfl0bxeTRaG22rQS3t6/XYG5Kctmv6l12excmIr8rLNfwGejwzG/Szq6
	 rMEARzdnUstHcIr7Ha6YgqqCx+6W2VeBoEZnnGxzVKnBmCAd2dre6ofWXIAp0o6McJ
	 AihiODgDBGnYtet6yYsLSYtqmZGuuuGnTz6SWnXkxlX8y54ncXG2q6IBanWY7J62oQ
	 XSOl6R3xPVDuoQ3BtGpHQv6waKt1ENpz9x3MD5IxbUNHtoycFlPRW7FNZCwTyZqq1D
	 AS3r3wLKlggYlFHPYTmoTAPr0htPUcxNMtmbLxSJ1FiCYyE4XQNPRTy+sYf7BwzerH
	 +orTk1grM9NtA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Charles Keepax <ckeepax@opensource.cirrus.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	mstrozek@opensource.cirrus.com,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	patches@opensource.cirrus.com
Subject: [PATCH AUTOSEL 6.15 52/80] ASoC: SDCA: Add flag for unused IRQs
Date: Sun,  3 Aug 2025 20:27:19 -0400
Message-Id: <20250804002747.3617039-52-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250804002747.3617039-1-sashal@kernel.org>
References: <20250804002747.3617039-1-sashal@kernel.org>
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

From: Charles Keepax <ckeepax@opensource.cirrus.com>

[ Upstream commit 775f5729b47d8737f4f98e0141f61b3358245398 ]

Zero is a valid SDCA IRQ interrupt position so add a special value to
indicate that the IRQ is not used.

Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>
Link: https://patch.msgid.link/20250624122844.2761627-6-ckeepax@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have a complete picture of the issue. Let me provide my analysis:

**Backport Status: YES**

This commit fixes a subtle but important bug in the SDCA (Smart Digital
Class-D Amplifier) subsystem's interrupt handling. Here's why this
should be backported:

1. **It fixes a real bug**: Without this change, when the `mipi-sdca-
   control-interrupt-position` property is missing from the device
   tree/ACPI, the `control->interrupt_position` field remains
   uninitialized (even though memory is zero-initialized with
   `devm_kcalloc`, it's still 0). Since 0 is a valid interrupt position
   in SDCA, this causes the code to incorrectly treat controls without
   interrupts as having interrupt position 0.

2. **The bug has functional impact**: Looking at the interrupt handling
   code in `sdca_irq_populate()` (added in commit b126394d9ec6), it
   checks:
  ```c
  if (irq == SDCA_NO_INTERRUPT) {
  continue;
  }
  ```
  Without this fix, controls that should have no interrupt (property
  missing) would be incorrectly processed as having interrupt position
  0, potentially causing:
   - Incorrect interrupt registration
   - Conflicts with legitimate interrupt position 0 handlers
   - Runtime errors when the interrupt framework tries to handle non-
     existent interrupts

3. **The fix is minimal and safe**: The change simply adds:
  ```c
  else
  control->interrupt_position = SDCA_NO_INTERRUPT;
  ```
  This ensures that when the interrupt position property is missing, the
  field is explicitly set to -1 (SDCA_NO_INTERRUPT) instead of remaining
  0.

4. **It follows stable tree rules**:
   - Fixes a clear bug (uninitialized/incorrectly initialized field)
   - Small, contained change (2 lines added)
   - No architectural changes or new features
   - Low risk of regression
   - Only affects SDCA subsystem

5. **The bug exists in stable kernels**: The interrupt handling code
   that depends on this distinction was added in commit b126394d9ec6
   ("ASoC: SDCA: Generic interrupt support"), so any stable kernel that
   includes that commit needs this fix.

The commit message clearly states the problem: "Zero is a valid SDCA IRQ
interrupt position so add a special value to indicate that the IRQ is
not used." This is a classic initialization bug where the absence of a
value (property not present) needs to be distinguished from a valid zero
value.

 include/sound/sdca_function.h   | 2 ++
 sound/soc/sdca/sdca_functions.c | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/include/sound/sdca_function.h b/include/sound/sdca_function.h
index 253654568a41..1403a9f46976 100644
--- a/include/sound/sdca_function.h
+++ b/include/sound/sdca_function.h
@@ -16,6 +16,8 @@ struct device;
 struct sdca_entity;
 struct sdca_function_desc;
 
+#define SDCA_NO_INTERRUPT -1
+
 /*
  * The addressing space for SDCA relies on 7 bits for Entities, so a
  * maximum of 128 Entities per function can be represented.
diff --git a/sound/soc/sdca/sdca_functions.c b/sound/soc/sdca/sdca_functions.c
index 493f390f087a..42005e9dc882 100644
--- a/sound/soc/sdca/sdca_functions.c
+++ b/sound/soc/sdca/sdca_functions.c
@@ -911,6 +911,8 @@ static int find_sdca_entity_control(struct device *dev, struct sdca_entity *enti
 				       &tmp);
 	if (!ret)
 		control->interrupt_position = tmp;
+	else
+		control->interrupt_position = SDCA_NO_INTERRUPT;
 
 	control->label = find_sdca_control_label(dev, entity, control);
 	if (!control->label)
-- 
2.39.5

