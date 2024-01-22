Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1A7712FF73;
	Tue, 23 Jan 2024 01:03:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971808; cv=none; b=rOfu+gPSCKj5W5wsFnGAPRroik/wXfKeBrp0p4II9YIXyoz9/djQRPcY+X/onS1yrqOp0QqhRX9qtuIKDpibDl8GBKXkHijRZIT5aCTj9/kHH3IH/qK7rDr7PetjmM+lvuWFKj+JzlHw8lFssNmv1hjn/k2UNBqjuz2NhmtsU1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971808; c=relaxed/simple;
	bh=yNKa5JBHgZbrf9m7AGNaxrlE1FPEUxpFtVfp8R9CCDY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=raAQt7RcE4534KQJSfsThuBK6S0PgqzTiB7qa3OX2SmfodgSg/T62MqsdDnUN/OX0mtsw/WprCSAkdslpLwpxOOySyUtycrm1I168rGzgkExU1yqoSzqJeAVPsqCF/zJ1IlPu49d3yiKG1Ral7X44Ny+Hbqe0SGhkctlxxFIZLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eXNwC4ET; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eXNwC4ET"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 710A6C433C7;
	Tue, 23 Jan 2024 01:03:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971808;
	bh=yNKa5JBHgZbrf9m7AGNaxrlE1FPEUxpFtVfp8R9CCDY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eXNwC4ETqMVvjmkpofwcXtM7YUbY0RSxcPy7KzpPeBXYCvp5tmFOrM04nSS33M2gu
	 lQ8gwBIkk4xjrqgPakD+8ZM6qw0x1OON1oC+ci1lrmUkrGnTX5lWCKPbJqfz9fp5Xr
	 HAyHq24uZxd5rWz2M7LBhNKqHEnK8qOpEFd8q2a4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dang Huynh <danct12@riseup.net>,
	Nikita Travkin <nikita@trvn.ru>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 325/417] leds: aw2013: Select missing dependency REGMAP_I2C
Date: Mon, 22 Jan 2024 15:58:13 -0800
Message-ID: <20240122235803.061365871@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 2378cfb7443e..509d03eb3e8d 100644
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



