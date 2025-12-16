Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D59D5326926;
	Tue, 16 Dec 2025 11:27:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884433; cv=none; b=Ub/NXp9k2fherTwZ6s8OJuYP+wO99fLJ/r7U5pU7ujwUN7ktso6D3Izmx4vs9lsqrlVDcPZXfWBMjxqzh6yMoRnrqOTxp0g0+aFPY79CeCk4cr/OYznrCD0b9IReMC0ofMhd8C5Wa6eJZOQiexy3f3cj+S+TpL3kWMfx7z7PbNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884433; c=relaxed/simple;
	bh=JJjmVDT/1DZ26GIdeUEqfEdI0kGOzKAgGT+WeiP+sHc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e06G7L0wezRHc8KpALZg4TJxlTb/FigrhIF43/X9//IGV12Bu0F0Ps/ecxo4OpMFmo2YPWo/4Ucb9G2Ov1bPKO2uWr05A1p8wWrn2yvD5N+U1UCQg9CGtG5XYOkfLhjB9bmjHw14S1zo5ZMMR6G/is1cchZRVv6q+NKeTpaFTBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LTtD+nkX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LTtD+nkX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60DFDC19422;
	Tue, 16 Dec 2025 11:27:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884433;
	bh=JJjmVDT/1DZ26GIdeUEqfEdI0kGOzKAgGT+WeiP+sHc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LTtD+nkXu+lgrLknf7HEia6Mc5hriZ3V7oLtWL9DSnc2tCeC9BBIV2qw5xICSXJ1e
	 Bcts1UHMqaVGJdUkmO8sXTsglD9hL8er7QIZQ2rP93wec9eUBOycHWhSFjZJ2CilaJ
	 2Ccr5fcqRz1upuaI9uSXWwGpmIqPpPmfcYvto4B8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fenglin Wu <fenglin.wu@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 192/354] leds: rgb: leds-qcom-lpg: Dont enable TRILED when configuring PWM
Date: Tue, 16 Dec 2025 12:12:39 +0100
Message-ID: <20251216111327.868439057@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fenglin Wu <fenglin.wu@oss.qualcomm.com>

[ Upstream commit 072cd5f458d76b9e15d89ebdaea8b5cb1312eeef ]

The PWM signal from the LPG channel can be routed to PMIC GPIOs with
proper GPIO configuration, and it is not necessary to enable the
TRILED channel in that case. This also applies to the LPG channels
that mapped to TRILED channels. Additionally, enabling the TRILED
channel unnecessarily would cause a voltage increase in its power
supply. Hence remove it.

Fixes: 24e2d05d1b68 ("leds: Add driver for Qualcomm LPG")
Signed-off-by: Fenglin Wu <fenglin.wu@oss.qualcomm.com>
Reviewed-by: Bjorn Andersson <andersson@kernel.org>
Link: https://patch.msgid.link/20251119-lpg_triled_fix-v3-2-84b6dbdc774a@oss.qualcomm.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/rgb/leds-qcom-lpg.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/leds/rgb/leds-qcom-lpg.c b/drivers/leds/rgb/leds-qcom-lpg.c
index 5d8e27e2e7ae7..84e02867f3b43 100644
--- a/drivers/leds/rgb/leds-qcom-lpg.c
+++ b/drivers/leds/rgb/leds-qcom-lpg.c
@@ -2,7 +2,7 @@
 /*
  * Copyright (c) 2017-2022 Linaro Ltd
  * Copyright (c) 2010-2012, The Linux Foundation. All rights reserved.
- * Copyright (c) 2023-2024, Qualcomm Innovation Center, Inc. All rights reserved.
+ * Copyright (c) Qualcomm Technologies, Inc. and/or its subsidiaries.
  */
 #include <linux/bits.h>
 #include <linux/bitfield.h>
@@ -1246,8 +1246,6 @@ static int lpg_pwm_apply(struct pwm_chip *chip, struct pwm_device *pwm,
 
 	lpg_apply(chan);
 
-	triled_set(lpg, chan->triled_mask, chan->enabled ? chan->triled_mask : 0);
-
 out_unlock:
 	mutex_unlock(&lpg->lock);
 
-- 
2.51.0



