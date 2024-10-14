Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F459610B;
	Mon, 14 Oct 2024 14:32:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916345; cv=none; b=T2Nu6cXWkkKKQLkU+GMdmnbo+S8fpYzajiCknphoThBZttqtUGQkkgvqhvGJL/eTl/WaAIkJvGboa5Fb23908G2LHjZk09XqKBa6GgLgoUJQvdVZfWserGbMR4qiAP02AFoZScrRqNXDXP0iFn/63DkhQogwRTDeDvMuKvrZKSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916345; c=relaxed/simple;
	bh=QhQjyP2fEj0FDj4CrzdDgB2WUn7PkEp1LvGB/FRH1Hw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hio+aIo8znFo0zc0Mw3rojvMVFVj0fdgzZwLjlcO7jiRJvilmH7/bfzyc/xMHeBo7jlGOtPDGQMSYg5I0OMSkObNAJNscEiIPJXeCxnRsIwx5l1RhBplg9L/q78SPXZIR5u0O/A+JR7Orc2W5/A2P23Tg1nu8Opt7audQkskGTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o1UCf9So; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o1UCf9So"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96CA7C4CEC3;
	Mon, 14 Oct 2024 14:32:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916345;
	bh=QhQjyP2fEj0FDj4CrzdDgB2WUn7PkEp1LvGB/FRH1Hw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o1UCf9SorJXxTTB/XZre5gzdBP+bC+jailvgzh6nWY+6ldEwP0TakAHfN2flksS22
	 kE/N/ZZ6/qE9Q2TliUnv8616w7gMd483mbgU1GXloPIEBoO7TnbsnwGPuEozUb3caC
	 ny9oYJM0aP3TYeepcRDyzcgdCkG2l7sjXJHGsxcI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 155/214] hwmon: (mc34vr500) Add missing dependency on REGMAP_I2C
Date: Mon, 14 Oct 2024 16:20:18 +0200
Message-ID: <20241014141051.037590774@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141044.974962104@linuxfoundation.org>
References: <20241014141044.974962104@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Javier Carrasco <javier.carrasco.cruz@gmail.com>

[ Upstream commit 56c77c0f4a7c9043e7d1d94e0aace264361e6717 ]

This driver requires REGMAP_I2C to be selected in order to get access to
regmap_config and devm_regmap_init_i2c. Add the missing dependency.

Fixes: 07830d9ab34c ("hwmon: add initial NXP MC34VR500 PMIC monitoring support")
Signed-off-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Message-ID: <20241002-mc34vr500-select-regmap_i2c-v1-1-a01875d0a2e5@gmail.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
index 543c40630d67e..d9799d1b7d3c6 100644
--- a/drivers/hwmon/Kconfig
+++ b/drivers/hwmon/Kconfig
@@ -1275,6 +1275,7 @@ config SENSORS_MAX31790
 config SENSORS_MC34VR500
 	tristate "NXP MC34VR500 hardware monitoring driver"
 	depends on I2C
+	select REGMAP_I2C
 	help
 	  If you say yes here you get support for the temperature and input
 	  voltage sensors of the NXP MC34VR500.
-- 
2.43.0



