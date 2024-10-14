Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99BAB80027;
	Mon, 14 Oct 2024 14:47:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917275; cv=none; b=PL6dR2Whv0c8AXBuGVibkjsNOy8eP7YCOWuR2F+SHBLw8COrGgzz318o+3m82TOu4jNBiMHv3Pw1MGFKMi2SN35KJ0wvWf72leIJw2DDGVz8DkCvH+dLp/fq7BHg0/q1ZPO+FWlwSvql57xZazcVWtfN1OYgHJq3AvqmXToTBss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917275; c=relaxed/simple;
	bh=Rs+IKpkC58X/Lnc1QwyaapxWtkrCs1RNvPs9y13L4Zo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f2LHhx96zYllfTdIdxLfOY/3phlhwpH+3Zz95wHXeqWDQ8oQ2UFyMjA7aT6ugg2ZbT9R6tnHpKI9QP0U4mhWoRj/bynm7w9QZKGCYWjaHysoJR4Qo+NBXSPZJSZ+f0m+/6cs/JjqTcx+4w3dDU/AgVLXK7Po7nhueaCAp0JZBgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xjPO2Gs7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xjPO2Gs7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9971C4CEC3;
	Mon, 14 Oct 2024 14:47:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917275;
	bh=Rs+IKpkC58X/Lnc1QwyaapxWtkrCs1RNvPs9y13L4Zo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xjPO2Gs7nVoxFN6NVhsqL5ehF7+SHwVgp5lcimZkxzX3Z2cA10WPPhyo/KX+5AIXX
	 teXWS6ukbKv02woBdy4fN7RFya0LAQ+hOvikpgjaBEQWEV7kdqNe5yKkRJEofAJf8x
	 XkPhousDTUuTAIS04yl5O3Tk25IQJo/39lzjNFJw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 176/213] hwmon: (mc34vr500) Add missing dependency on REGMAP_I2C
Date: Mon, 14 Oct 2024 16:21:22 +0200
Message-ID: <20241014141049.834562687@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141042.954319779@linuxfoundation.org>
References: <20241014141042.954319779@linuxfoundation.org>
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
index b46c85e2197c0..393ac124012ec 100644
--- a/drivers/hwmon/Kconfig
+++ b/drivers/hwmon/Kconfig
@@ -1200,6 +1200,7 @@ config SENSORS_MAX31790
 config SENSORS_MC34VR500
 	tristate "NXP MC34VR500 hardware monitoring driver"
 	depends on I2C
+	select REGMAP_I2C
 	help
 	  If you say yes here you get support for the temperature and input
 	  voltage sensors of the NXP MC34VR500.
-- 
2.43.0



