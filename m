Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2639F2B9B7;
	Tue,  5 Aug 2025 13:09:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754399389; cv=none; b=ZRKjokesOs0HBI44tF1QSGgZ+RXRdEJ/SuI9KJZ2gO6gqs4tM92KRhqHJz4EdZXWed2JQTLk8ATiDGBdgpC8I64coqf1tV0IGu6mt9K4UwnKeRGnydlfyvlZAe0YDiI9QLq2YOOmgVqrw3nErWBrl96il4jFZU1WRVIpm9d+24Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754399389; c=relaxed/simple;
	bh=MqDN7xUWTd4Ww+dv13mq9KzDQ9G6fwr4yZInmW0+5rM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=SvAAwsQFKMYMJRbr+1sn4HgQ6UJi4UKKtAOzFtJKjB+X5T6vVGQvwHeY+IArQWHFFJm6aTUc2igCIfk/TDf1FqaZjWku02/q0tyfquZq5kJ/qMcHu1uhzplPGbT7/xr3meixsveQNra77COnDx2I583jBUpXoZOqx8dd99JWRO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FBxgtV10; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FBxgtV10"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A30B3C4CEF0;
	Tue,  5 Aug 2025 13:09:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754399388;
	bh=MqDN7xUWTd4Ww+dv13mq9KzDQ9G6fwr4yZInmW0+5rM=;
	h=From:To:Cc:Subject:Date:From;
	b=FBxgtV10qzcPYTL8syXlyw/QS0y6CfT69/+CT6iab1En79k8eQFham00oYVbw+mLi
	 q0wVikflsks34hxVRvn803O2FUCKXzu9CFmHPNiJqra9ZjQnxB5W97o3/mO3uJD4wp
	 mVswq3lKN2lliGP91kucyB+IfDiyD70h9HyK+9BgWIjMTFvyOciuKupvRvuHpTuj4I
	 /fwAzKsiPhvd2tIRwzMllCTMFg8X5mudv9o4r3Q6n5XKiAzm7d/eC83k8XYxHA9dNQ
	 PtUvJkJ2gzB/yjJy/uDnHm4tWB9r9tZiXB7niZLQWD2t7GDR3IU4QBPJVUk//icjD1
	 jSPSv6ADpgVzw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Chen-Yu Tsai <wens@csie.org>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.16-6.6] mfd: axp20x: Set explicit ID for AXP313 regulator
Date: Tue,  5 Aug 2025 09:08:36 -0400
Message-Id: <20250805130945.471732-1-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
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

From: Chen-Yu Tsai <wens@csie.org>

[ Upstream commit 88828c7e940dd45d139ad4a39d702b23840a37c5 ]

On newer boards featuring the A523 SoC, the AXP323 (related to the
AXP313) is paired with the AXP717 and serves as a secondary PMIC
providing additional regulator outputs. However the MFD cells are all
registered with PLATFORM_DEVID_NONE, which causes the regulator cells
to conflict with each other.

Commit e37ec3218870 ("mfd: axp20x: Allow multiple regulators") attempted
to fix this by switching to PLATFORM_DEVID_AUTO so that the device names
would all be different, however that broke IIO channel mapping, which is
also tied to the device names. As a result the change was later reverted.

Instead, here we attempt to make sure the AXP313/AXP323 regulator cell
does not conflict by explicitly giving it an ID number. This was
previously done for the AXP809+AXP806 pair used with the A80 SoC.

Signed-off-by: Chen-Yu Tsai <wens@csie.org>
Link: https://lore.kernel.org/r/20250619173207.3367126-1-wens@kernel.org
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Based on my analysis, here's my assessment:

**Backport Status: YES**

This commit is suitable for backporting to stable kernel trees for the
following reasons:

1. **Fixes a real bug**: The commit addresses a device naming conflict
   issue when using AXP313/AXP323 PMICs alongside AXP717 as a secondary
   PMIC. Without this fix, the kernel produces a sysfs duplicate
   filename error and fails to properly register the secondary regulator
   device.

2. **Small and contained change**: The fix is minimal - it only changes
   one line of code from `MFD_CELL_NAME("axp20x-regulator")` to
   `MFD_CELL_BASIC("axp20x-regulator", NULL, NULL, 0, 1)`, which
   explicitly sets an ID of 1 for the AXP313 regulator cell.

3. **Follows established pattern**: The commit follows an existing
   pattern already used in the same driver for the AXP806 PMIC (lines
   1173-1174 in axp806_cells), which also sets an explicit ID (2) to
   avoid conflicts when paired with AXP809.

4. **Minimal risk of regression**: The change only affects AXP313/AXP323
   devices and doesn't touch other PMIC configurations. The explicit ID
   assignment is a safe approach that doesn't break existing IIO channel
   mappings (which was the problem with the previous PLATFORM_DEVID_AUTO
   approach mentioned in the commit message).

5. **Clear problem and solution**: The commit message clearly explains
   the issue (sysfs duplicate filename error) and references the history
   of previous attempts to fix similar issues (commit e37ec3218870 and
   its revert). The solution is targeted and doesn't introduce
   architectural changes.

6. **Hardware enablement fix**: This fix enables proper functioning of
   boards with the A523 SoC that use dual PMIC configurations (AXP323 +
   AXP717), which would otherwise fail to initialize properly.

The commit meets the stable tree criteria of being an important bugfix
with minimal risk and contained scope. It fixes a specific hardware
configuration issue without introducing new features or making broad
architectural changes.

 drivers/mfd/axp20x.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/mfd/axp20x.c b/drivers/mfd/axp20x.c
index e9914e8a29a3..25c639b348cd 100644
--- a/drivers/mfd/axp20x.c
+++ b/drivers/mfd/axp20x.c
@@ -1053,7 +1053,8 @@ static const struct mfd_cell axp152_cells[] = {
 };
 
 static struct mfd_cell axp313a_cells[] = {
-	MFD_CELL_NAME("axp20x-regulator"),
+	/* AXP323 is sometimes paired with AXP717 as sub-PMIC */
+	MFD_CELL_BASIC("axp20x-regulator", NULL, NULL, 0, 1),
 	MFD_CELL_RES("axp313a-pek", axp313a_pek_resources),
 };
 
-- 
2.39.5

