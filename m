Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D94D35502A;
	Tue, 16 Dec 2025 11:52:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885932; cv=none; b=JdSvdF1J4J8vyEnNr7GWCzGDw3/I2gOoy8g2UN7TkZgqhl46V94F+8PZB3Oco7vXTiLOD1niYqmtvWuch4nYUTt8Sog/IeYtvjR5MR6M/3vRrIzhTHLcFnke6gzghOaDYtQboR9jQPDlIxjOzsl59nslA9mtewp+UxU5FwQZzBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885932; c=relaxed/simple;
	bh=A0k3qKXZhMV4LhBNueyRYdk1eCw/AP2SRjLGgP4Vo+I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sJQib717X6rgyaTJUX9e2o0SYBCH6HcbgAb+5MtZuvfGCoGNhzpeMW0KB+9goW1a8HgfGHb81rOsJ3uECNdJ5DS87zMjMH3SFp2Y2pbbusO+4V9Q6nttFJARwlN8DBqZ+1g9u8+F2F41Vz9d3e2NhtKJDXDm6Qj1XkA27Nd6e/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WzhahL1D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WzhahL1D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10B2EC4CEF1;
	Tue, 16 Dec 2025 11:52:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885932;
	bh=A0k3qKXZhMV4LhBNueyRYdk1eCw/AP2SRjLGgP4Vo+I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WzhahL1D5RK5u/1SQTRGM4FONVnh98oTEYkXbrOntx4VLnfBS+qjCckyZHEuq5kvH
	 gfxh4bTfCGD0KCXdGx5+rRfzprbcWvNx4j/bbTAmzrjgXcxX+J8ID2Rf8/+fIcisn2
	 P44DFW53P/Ejjo7L8u3IksRfoAjSy3GPJC9w8Dcs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fenglin Wu <fenglin.wu@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 288/507] leds: rgb: leds-qcom-lpg: Dont enable TRILED when configuring PWM
Date: Tue, 16 Dec 2025 12:12:09 +0100
Message-ID: <20251216111355.910339281@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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



