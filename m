Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65B1C42A8B;
	Mon,  4 Aug 2025 00:33:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754267629; cv=none; b=BMF9jMATH5YSV6BCJjiW7Fq7kBD4EKiR/uP4jANb1zPbi8ynfPz8d+QqIrXOCR4L5afebIdLntXW9iBEggFD8mg67KtNqn/+LG5a07BFvolqOOaf9rwGhQM68gqDZF53ygMy6S/hRXXzOwVAgi/i8I6JZTQQitElh1SSkhoWGkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754267629; c=relaxed/simple;
	bh=LLFYyJFuqp7hu3TZqJ6tl1Ccy4wRKO/b0BqGtZFrxLI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sjiig1jFmYy1m+bOhza+IGmLgqjCv8jyEfEKnI432VexYnVQXaiHKBJu/YTHwdzcdeNFCP5hlekyzhOxeR1c+rneeCwOGdNzRosomf9LYQAGaGcT86MNp7e4nNrTgv6jKKM1uMJUGUNUeAIg7QbUGm/0vbxXJ/I7aTMihz7uZto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MU9tuX7I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MU9tuX7I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C092AC4CEF0;
	Mon,  4 Aug 2025 00:33:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754267629;
	bh=LLFYyJFuqp7hu3TZqJ6tl1Ccy4wRKO/b0BqGtZFrxLI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MU9tuX7IhlKNOM7NQImjksMnPEiuhXt1ZrpxxgVfiKQMJocw+X5ltGE5QH4jR0p6J
	 R4b8ZtxooyWBuvN13clgiLdOSCNcM7I1x1jg6v7EZUBhf0QbR2epmia1i9vEDZhFJy
	 yJgqGsbI5r6Iu6BYJY4xaZAPZ6zxiLhwF+mS2YSJCz4ouri01TSSZOel7q/8r5i5v4
	 iZdjw0yv+2zyEgiU42ogMlqYCGisy3Ff5osHdvxQxWQ6RJK7OPZujGPqY4mvPXr342
	 BLijlLsB4R/uhilUaF4VnUAR67KB/ZAlK/UmBSYR79UcC+oBSsroCsVAM/5KsgZqeA
	 TtrXl8I7+8IBg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Krzysztof=20Ha=C5=82asa?= <khalasa@piap.pl>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>,
	shawnguo@kernel.org,
	peng.fan@nxp.com,
	imx@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 6.12 60/69] imx8m-blk-ctrl: set ISI panic write hurry level
Date: Sun,  3 Aug 2025 20:31:10 -0400
Message-Id: <20250804003119.3620476-60-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250804003119.3620476-1-sashal@kernel.org>
References: <20250804003119.3620476-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.12.41
Content-Transfer-Encoding: 8bit

From: Krzysztof Hałasa <khalasa@piap.pl>

[ Upstream commit c01fba0b4869cada5403fffff416cd1675dba078 ]

Apparently, ISI needs cache settings similar to LCDIF.
Otherwise we get artefacts in the image.
Tested on i.MX8MP.

Signed-off-by: Krzysztof Hałasa <khalasa@piap.pl>
Link: https://lore.kernel.org/r/m3ldr69lsw.fsf@t19.piap.pl
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Based on my analysis of the commit and the surrounding code:

**Backport Status: YES**

This commit should be backported to stable kernel trees for the
following reasons:

1. **Fixes a real user-visible bug**: The commit fixes image artifacts
   in the ISI (Image Sensor Interface) on i.MX8MP. This is a functional
   bug that affects users of camera/image capture functionality.

2. **Small and contained change**: The fix adds only 10 lines of code
   that set ISI panic write hurry levels in the
   `imx8mp_media_power_notifier` function. It's a minimal change
   confined to the i.MX8MP media block controller.

3. **Follows established pattern**: The fix mirrors the existing LCDIF
   panic read hurry level fix (commit 06a9a229b159) that was already
   applied for display FIFO underflow issues. The ISI needs similar
   cache settings to prevent artifacts.

4. **Hardware-specific fix**: The change only affects i.MX8MP hardware
   and is guarded by the platform-specific power notifier function,
   minimizing risk to other platforms.

5. **Clear problem and solution**: The commit message clearly states the
   problem (image artifacts) and the solution (setting ISI panic write
   hurry levels similar to LCDIF), making it a straightforward hardware
   configuration fix.

6. **No architectural changes**: This is purely a hardware register
   configuration change during power-on sequences, not introducing new
   features or changing kernel architecture.

The fix addresses a hardware-specific issue where the ISI (Image Sensor
Interface) needs proper cache/priority settings to avoid image
artifacts, similar to how the LCDIF (display interface) needs such
settings to avoid display FIFO underflow. This is an important fix for
anyone using camera functionality on i.MX8MP platforms.

 drivers/pmdomain/imx/imx8m-blk-ctrl.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/pmdomain/imx/imx8m-blk-ctrl.c b/drivers/pmdomain/imx/imx8m-blk-ctrl.c
index ca942d7929c2..8b7b175f5896 100644
--- a/drivers/pmdomain/imx/imx8m-blk-ctrl.c
+++ b/drivers/pmdomain/imx/imx8m-blk-ctrl.c
@@ -665,6 +665,11 @@ static const struct imx8m_blk_ctrl_data imx8mn_disp_blk_ctl_dev_data = {
 #define  LCDIF_1_RD_HURRY	GENMASK(15, 13)
 #define  LCDIF_0_RD_HURRY	GENMASK(12, 10)
 
+#define ISI_CACHE_CTRL		0x50
+#define  ISI_V_WR_HURRY		GENMASK(28, 26)
+#define  ISI_U_WR_HURRY		GENMASK(25, 23)
+#define  ISI_Y_WR_HURRY		GENMASK(22, 20)
+
 static int imx8mp_media_power_notifier(struct notifier_block *nb,
 				unsigned long action, void *data)
 {
@@ -694,6 +699,11 @@ static int imx8mp_media_power_notifier(struct notifier_block *nb,
 		regmap_set_bits(bc->regmap, LCDIF_ARCACHE_CTRL,
 				FIELD_PREP(LCDIF_1_RD_HURRY, 7) |
 				FIELD_PREP(LCDIF_0_RD_HURRY, 7));
+		/* Same here for ISI */
+		regmap_set_bits(bc->regmap, ISI_CACHE_CTRL,
+				FIELD_PREP(ISI_V_WR_HURRY, 7) |
+				FIELD_PREP(ISI_U_WR_HURRY, 7) |
+				FIELD_PREP(ISI_Y_WR_HURRY, 7));
 	}
 
 	return NOTIFY_OK;
-- 
2.39.5

