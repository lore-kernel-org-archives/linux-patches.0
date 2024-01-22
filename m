Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B8B077638;
	Tue, 23 Jan 2024 02:05:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975515; cv=none; b=ILl3LbTwgtuZDQzVmAMBFWBXeyYhFDSR/VfxsjRG6x2pnY9gAJjd4FMCoQ/i4x83Exd/4QHEqNEZGaY3TSEaxlKXf/uDH5x5dWxDx9vVH1mOVTFbT5LopaHVcOxkIfD5uqldP8mE/qvV7MsgqS/m5YQMtn6E/h635vPTaf0X9wA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975515; c=relaxed/simple;
	bh=O4CVIj4YOzY5rbeixRXCB54cNQupyBOI9NWzOhWlkqQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ex0B2oE8NcXKDNtN4fODjznfLLXOdqxO0EcJEfFuhCxmVtD0FjCJVIAe2dYS8qOaRZpQsMMjT3SzX57WUj8vd+VcZDjKu0xLtt6Ik0Km/OoAzUgJybLnamHtgmhFyA+1aVVmRk4GL+C/guGY4ATK+OtqVy5UR/lGZsu+BDNp4Uw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W9LAkwjv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W9LAkwjv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CADD1C433C7;
	Tue, 23 Jan 2024 02:05:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975515;
	bh=O4CVIj4YOzY5rbeixRXCB54cNQupyBOI9NWzOhWlkqQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W9LAkwjvYEAVICR6+ZPK6woCvF4/QBfh2Z3gO1x6yPNKRApFkvVotg+Qv7YR22wDr
	 tHwVXV9Fdl7aiJAfS7SdRA//WXz488mymBvXsJPHfIOVbso3CnwmbBucrliZRyK0co
	 V9SYNiQMFhwKUQmVBab9DnWS3NdqypNRbOsehhyA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Kurbanov <mmkurbanov@salutedevices.com>,
	Dmitry Rokosov <ddrokosov@salutedevices.com>,
	Andy Shevchenko <andy.shevchenko@gmail.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 442/583] leds: aw200xx: Fix write to DIM parameter
Date: Mon, 22 Jan 2024 15:58:13 -0800
Message-ID: <20240122235825.503106749@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Martin Kurbanov <mmkurbanov@salutedevices.com>

[ Upstream commit adfd4621b78d0c02da91335da2b9ad847cb7b39e ]

If write only DIM value to the page 4, LED brightness will not be
updated, as both DIM and FADE need to be written to the page 4.
Therefore, write DIM to the page 1.

Fixes: 36a87f371b7a ("leds: Add AW20xx driver")
Signed-off-by: Martin Kurbanov <mmkurbanov@salutedevices.com>
Signed-off-by: Dmitry Rokosov <ddrokosov@salutedevices.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Link: https://lore.kernel.org/r/20231125200519.1750-2-ddrokosov@salutedevices.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/leds-aw200xx.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/leds/leds-aw200xx.c b/drivers/leds/leds-aw200xx.c
index 691a743cc9b0..5142efea2339 100644
--- a/drivers/leds/leds-aw200xx.c
+++ b/drivers/leds/leds-aw200xx.c
@@ -74,6 +74,10 @@
 #define AW200XX_LED2REG(x, columns) \
 	((x) + (((x) / (columns)) * (AW200XX_DSIZE_COLUMNS_MAX - (columns))))
 
+/* DIM current configuration register on page 1 */
+#define AW200XX_REG_DIM_PAGE1(x, columns) \
+	AW200XX_REG(AW200XX_PAGE1, AW200XX_LED2REG(x, columns))
+
 /*
  * DIM current configuration register (page 4).
  * The even address for current DIM configuration.
@@ -153,7 +157,8 @@ static ssize_t dim_store(struct device *dev, struct device_attribute *devattr,
 
 	if (dim >= 0) {
 		ret = regmap_write(chip->regmap,
-				   AW200XX_REG_DIM(led->num, columns), dim);
+				   AW200XX_REG_DIM_PAGE1(led->num, columns),
+				   dim);
 		if (ret)
 			goto out_unlock;
 	}
-- 
2.43.0



