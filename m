Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA93417C77;
	Mon, 14 Oct 2024 14:32:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916348; cv=none; b=b341QETBodaLnHKqetPiDupc3/tQD1OTFDds8dYfk1R0x5fmgEp6MGaZEp952maGqup9o+L6eEIobIQFw+wO8VVX2t5rdwgx6Amm4UG6dG2rChLn5M+JVotxEP/eJQNv5mhJLceZ6XZMJROf9DQoixCEIwjCxxJvca+5LbiQcwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916348; c=relaxed/simple;
	bh=UuEnRSQ4wwdJsufWOu9FS+riZgpuzwTBmSMbbqlVroE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SF9ThapS/2IPjZ6P1LPDMmY6xPG3eZV2mYCfuNASWBg4dHLHDhM7omjKTGzkrbLAVLZ4EDwsOjiQ8KGCG90EVj/UaZJGp1g0YDLN+ZaVwahfjkMx+U1XB1r77U02sv8CPWvLj7sLYIz5WhHxLB6l9t/epFp1rHjyPWwlY1+vZIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VyDqhYsb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VyDqhYsb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2ADEC4CED0;
	Mon, 14 Oct 2024 14:32:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916348;
	bh=UuEnRSQ4wwdJsufWOu9FS+riZgpuzwTBmSMbbqlVroE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VyDqhYsbvpLVzt5GWJ5E7Lx12YvScOJuQc5gDfX4MoEAtcqis1aCadyTffWOK4W9d
	 voAELZVug5t93g4OHymJtSsIHTL7GIf+gA/RSSqljagbYuOoYMxAZt8ginj+I0xIz9
	 iloc7PMK2sgD9D6LIjflIo1JtMFLw7XG5HSltKbo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 156/214] hwmon: (adm9240) Add missing dependency on REGMAP_I2C
Date: Mon, 14 Oct 2024 16:20:19 +0200
Message-ID: <20241014141051.075966554@linuxfoundation.org>
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

[ Upstream commit 14849a2ec175bb8a2280ce20efe002bb19f1e274 ]

This driver requires REGMAP_I2C to be selected in order to get access to
regmap_config and devm_regmap_init_i2c. Add the missing dependency.

Fixes: df885d912f67 ("hwmon: (adm9240) Convert to regmap")
Signed-off-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Message-ID: <20241002-hwmon-select-regmap-v1-1-548d03268934@gmail.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
index d9799d1b7d3c6..75d7797a5b943 100644
--- a/drivers/hwmon/Kconfig
+++ b/drivers/hwmon/Kconfig
@@ -162,6 +162,7 @@ config SENSORS_ADM9240
 	tristate "Analog Devices ADM9240 and compatibles"
 	depends on I2C
 	select HWMON_VID
+	select REGMAP_I2C
 	help
 	  If you say yes here you get support for Analog Devices ADM9240,
 	  Dallas DS1780, National Semiconductor LM81 sensor chips.
-- 
2.43.0



