Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 389D3224AEF;
	Tue, 16 Dec 2025 12:23:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887809; cv=none; b=OjOzMKMzSY9GIxPIxyoelqdHCqlMnERl+LJ+erP/EJXyrZPpW7lUP+h4LszWUTZl8SdrX0+G0SSVa4uYsksQ4etqpF3Hhc2Y+tTYdvShvK1iw4u3hHKXWw07mbVSuTkgVILzlT9dHlRA779huZq7qeVuYyTZJ83TRwpwnrrnUzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887809; c=relaxed/simple;
	bh=OApnHE5Na44vkZKouZFLzQSOnehEj7XaSQmGy9fRtA0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dmOZHOFhXNWDQ9IXu+vScKMz/XZe26lczZv5R1mev5nf/4wmgPeDdOqBdtaIGTu58KaMekl8R2/mAzz+nziRIy05m0/mtokv7/ZKsUMLkTHV0Cv3ved3yC2f7pOD2j5kvkZ3YMxX8uKXDJ8MWhx/fvqzB0MU2dHwNcEa2SwHiNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ea1Y5wyX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ea1Y5wyX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9796BC4CEF1;
	Tue, 16 Dec 2025 12:23:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887809;
	bh=OApnHE5Na44vkZKouZFLzQSOnehEj7XaSQmGy9fRtA0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ea1Y5wyXdJ9KdYnDIhbRGy2JAiLa3oUC6WNuVUroIl+iBZ8xfBqhQ0h4/JDTh6Mi2
	 4bzeyZPEa9PGlW6Hc3UMhZAPFpz8uajh6Taxc4/kkNEJMAdpcQpo+GLtZg1jSw6xK4
	 69DULZPWOO4sKgPzZYeX74Sj/9Et+qWGTBJJr5+s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fenglin Wu <fenglin.wu@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 343/614] leds: rgb: leds-qcom-lpg: Dont enable TRILED when configuring PWM
Date: Tue, 16 Dec 2025 12:11:50 +0100
Message-ID: <20251216111413.791212903@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 4f2a178e3d265..e197f548cddb0 100644
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
@@ -1247,8 +1247,6 @@ static int lpg_pwm_apply(struct pwm_chip *chip, struct pwm_device *pwm,
 
 	lpg_apply(chan);
 
-	triled_set(lpg, chan->triled_mask, chan->enabled ? chan->triled_mask : 0);
-
 out_unlock:
 	mutex_unlock(&lpg->lock);
 
-- 
2.51.0



