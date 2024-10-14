Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE31219F43B;
	Mon, 14 Oct 2024 15:35:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728920120; cv=none; b=SDsCaJzRO6qV0/CFX6zMO32IBfatZg5Zaz0wISLB9slW+r/nkfNRDS5f5wXRD41+YVsfOTEk8gt1oy7oGAU1t8bDWNLyxu9Enly+i9AnVgLynw2/R2hQyKtmt7QLnEkNZgYHgAr/58v+RHcOkDwv5l+jlw3Z/DbwceE88z1Af/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728920120; c=relaxed/simple;
	bh=n+V8aXO94VgAWkGjFRb7kHnxL89gAIACiay19gz/C9o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MjXJKfg+bLYv+8EQz+GC6KaaBBRLhr3rYqdQjoCrHp5r21lbATlffVxr44rYnJZtvWdjID1i0i1Y2CIb6nBEj1roJ9XaJE/3gL0bxRFyj+PLvn6LgahJYDsosFRyUoUVuYY0MucLmHRryVw2/A60vb62Kt/h6PKzx4PIQ4fVW3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BJ6wcbaC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BJ6wcbaC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48AABC4CEC3;
	Mon, 14 Oct 2024 15:35:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728920120;
	bh=n+V8aXO94VgAWkGjFRb7kHnxL89gAIACiay19gz/C9o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BJ6wcbaCBCPxLKSaklVYnDo40drzwB2UcXEwjg4gE/ozqzacSazIIRROISEPxwQkX
	 yGWD23ZLCl2c1l1AzA/v8PHrax+z3no89iPFWGXO+OkKfMcsyYoKSiTEDc5TLPss/Y
	 bs7vhDywoJE9GTqiHoOtfOdkfociLrCUtPFpi7EU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 771/798] hwmon: (adt7470) Add missing dependency on REGMAP_I2C
Date: Mon, 14 Oct 2024 16:22:05 +0200
Message-ID: <20241014141248.352348551@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

From: Javier Carrasco <javier.carrasco.cruz@gmail.com>

[ Upstream commit b6abcc19566509ab4812bd5ae5df46515d0c1d70 ]

This driver requires REGMAP_I2C to be selected in order to get access to
regmap_config and devm_regmap_init_i2c. Add the missing dependency.

Fixes: ef67959c4253 ("hwmon: (adt7470) Convert to use regmap")
Signed-off-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Message-ID: <20241002-hwmon-select-regmap-v1-2-548d03268934@gmail.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
index 054ceca18e20c..7884fcb95c3e5 100644
--- a/drivers/hwmon/Kconfig
+++ b/drivers/hwmon/Kconfig
@@ -228,6 +228,7 @@ config SENSORS_ADT7462
 config SENSORS_ADT7470
 	tristate "Analog Devices ADT7470"
 	depends on I2C
+	select REGMAP_I2C
 	help
 	  If you say yes here you get support for the Analog Devices
 	  ADT7470 temperature monitoring chips.
-- 
2.43.0



