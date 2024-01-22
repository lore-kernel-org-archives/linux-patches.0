Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22F491353EC;
	Tue, 23 Jan 2024 00:01:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968116; cv=none; b=LyrQc321VLRCqqn2AyXZ6RTtzLghP7+Z9YBc/zkundpT/9SZ15Ks2+XS3WPIL863vhN7SfW3JpguCMLe7iYThQBMc+LK8h3ghGGSUru61Ndn23dyT83X/qU44dJoyW2coDGti06/EEaUu+ZQjq+LMp7oasEUaqIxO5KbGOo2lEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968116; c=relaxed/simple;
	bh=t7gkXPMCo7zKHcONsBhjOi7DUZ0QEwjRCJ6hRhxR0IY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CqQwwuJVaLMTvQjrmjbCfv1e19AnPXAW43IXknm+Ex8vwZFETSubdy50KU8M9bIjSc2F+4BtiDsyX8lVszeHw5ETydEFeiVWaafDW9UrFvQzpq/0sH+7IxCB5Y/WQUTY+dN0mO40PfYgr08ifAiuynjPrKWULyO/QW/uA/JG+JI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YHFPW4TF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YHFPW4TF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68EFCC433C7;
	Tue, 23 Jan 2024 00:01:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705968116;
	bh=t7gkXPMCo7zKHcONsBhjOi7DUZ0QEwjRCJ6hRhxR0IY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YHFPW4TF4g2fKX1ZOdBbEl3bf60Fvd6ajp92aNEc/8Uz8504Ey9MkY3okTTjMiFHb
	 IaV0XQwzes0fGYgqhI/SpP6zdid2h0F9jdDb3F+0xxHiAqIC4LoDrz8/6jHCh8+pes
	 ygbG8jGnASCR7X15zqPmEnpX53wjXhFZetFlFsjc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 015/148] reset: hisilicon: hi6220: fix Wvoid-pointer-to-enum-cast warning
Date: Mon, 22 Jan 2024 15:56:11 -0800
Message-ID: <20240122235713.046758331@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235712.442097787@linuxfoundation.org>
References: <20240122235712.442097787@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit b5ec294472794ed9ecba0cb4b8208372842e7e0d ]

'type' is an enum, thus cast of pointer on 64-bit compile test with W=1
causes:

  hi6220_reset.c:166:9: error: cast to smaller integer type 'enum hi6220_reset_ctrl_type' from 'const void *' [-Werror,-Wvoid-pointer-to-enum-cast]

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20230810091300.70197-1-krzysztof.kozlowski@linaro.org
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/reset/hisilicon/hi6220_reset.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/reset/hisilicon/hi6220_reset.c b/drivers/reset/hisilicon/hi6220_reset.c
index d5e5229308f2..d77a7ad7e57a 100644
--- a/drivers/reset/hisilicon/hi6220_reset.c
+++ b/drivers/reset/hisilicon/hi6220_reset.c
@@ -107,7 +107,7 @@ static int hi6220_reset_probe(struct platform_device *pdev)
 	if (!data)
 		return -ENOMEM;
 
-	type = (enum hi6220_reset_ctrl_type)of_device_get_match_data(dev);
+	type = (uintptr_t)of_device_get_match_data(dev);
 
 	regmap = syscon_node_to_regmap(np);
 	if (IS_ERR(regmap)) {
-- 
2.43.0



