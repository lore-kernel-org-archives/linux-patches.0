Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4F23627F5;
	Tue, 23 Jan 2024 01:55:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974951; cv=none; b=ofAcROuMJU+KUH5ynzJJGVGKR1WmFtlkA7wwdmXf0yvpVNciNDxr+vGKnXkhu4GQzOWc7l9UuDFNtumTMlfcx7GnUi34B5aMX7OaFn8WNmclCb8GV56NOnAEVUBnfYHzV+O+p8dpYUBN6L5z/BaHESYoKPh3IOXnbseq9ZIGSBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974951; c=relaxed/simple;
	bh=Dzd6FGYfCCb+StyYpg9RqgaG8rkAuccp2iLqiPcc9ig=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rQIQvWCuCfshQ4UpAGcVfR9PcmyRW+bqEfwTkG2VYqCDYujc3tEKdPaM1SNLsHeukMZJv2nuf7VkFwQe7gNuXqTI2WLy1ET+Dd4TgjXiSRCq9jAg5alLdX3+HNCKQRJn+qW3WdB98hjQDC8GVvFx0I40B81v1MGrig9ai2n1jcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2BMAxkwx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2BMAxkwx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89FF9C433C7;
	Tue, 23 Jan 2024 01:55:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974951;
	bh=Dzd6FGYfCCb+StyYpg9RqgaG8rkAuccp2iLqiPcc9ig=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2BMAxkwxqrfOzhXmP2b1DD9GQuuQ05HeCrTcke3dDwjS/dSOsvpf7P1CD0BWnZohl
	 wfgkbm/nPOmamw2ab71Fls2Ijms+pneGfvTKVTCB0cfPkNFMUJ00nxRO5lWid0ILUS
	 CEYxv/AY3J5ucYtiE7HDfzAqjxFgqCl4p8ToGm1Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dang Huynh <danct12@riseup.net>,
	Nikita Travkin <nikita@trvn.ru>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 293/374] leds: aw2013: Select missing dependency REGMAP_I2C
Date: Mon, 22 Jan 2024 15:59:09 -0800
Message-ID: <20240122235754.981567445@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dang Huynh <danct12@riseup.net>

[ Upstream commit 75469bb0537ad2ab0fc1fb6e534a79cfc03f3b3f ]

The AW2013 driver uses devm_regmap_init_i2c, so REGMAP_I2C needs to
be selected.

Otherwise build process may fail with:
  ld: drivers/leds/leds-aw2013.o: in function `aw2013_probe':
    leds-aw2013.c:345: undefined reference to `__devm_regmap_init_i2c'

Signed-off-by: Dang Huynh <danct12@riseup.net>
Acked-by: Nikita Travkin <nikita@trvn.ru>
Fixes: 59ea3c9faf32 ("leds: add aw2013 driver")
Link: https://lore.kernel.org/r/20231103114203.1108922-1-danct12@riseup.net
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
index 8bf545100fb0..fdfc41535c8a 100644
--- a/drivers/leds/Kconfig
+++ b/drivers/leds/Kconfig
@@ -97,6 +97,7 @@ config LEDS_ARIEL
 config LEDS_AW2013
 	tristate "LED support for Awinic AW2013"
 	depends on LEDS_CLASS && I2C && OF
+	select REGMAP_I2C
 	help
 	  This option enables support for the AW2013 3-channel
 	  LED driver.
-- 
2.43.0



