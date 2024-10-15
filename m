Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77A281D2B21;
	Tue, 15 Oct 2024 12:11:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728994292; cv=none; b=XVc9efxWozSbUrvcmr+rDkTt8XUnDPSRU5UmDwjYZKRFJXsLRVq4HUIZy1eNBKnuuqfOfEfkRiZvejqP7mXs/sUamh65B0XnZ26Xpwkz3+hji5JQy2foPDiUhaqYxE0TAnFi7GCPcwWOdvMb+nivtunos56D4I5gYtp4wUy3f5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728994292; c=relaxed/simple;
	bh=aUZHah498GHNX6FT47Kxzw8XgTOAwMWfdR1Tg9jPWbk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cMpwAJ1Qkjpe/8zskgJyBZj+9ZSLTSA2FWhHvrALCbi2E3CVLQXZfRDNFITcQ0qln1ub2PuqhMZwNOk3CsRHQozN2nyHJ40ubCg+AY0GxMqrNK/soo2hUi/x4NxWHyNmtMnMgziToWH2xJ8T6B5bFOuQMwvzQMs9Ozb9Y+Tw8CA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2ZOharJC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2ZOharJC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8A4CC4CEC6;
	Tue, 15 Oct 2024 12:11:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728994292;
	bh=aUZHah498GHNX6FT47Kxzw8XgTOAwMWfdR1Tg9jPWbk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2ZOharJC8hqIiIWkpyn+iqKpRzwAzqipnqc849vx3tJH+LSKcSCa0hQEiBFEgX6Y+
	 ffpA6vplZqN60TsZUkRbt45ilh/V17SrPz7MiESAbnPkK9KZqm52NKOgiUvpReqrhY
	 i4hAQcPPl3wQijjrNfq450RcVgg1iZqqIRnAkDO4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 663/691] hwmon: (adt7470) Add missing dependency on REGMAP_I2C
Date: Tue, 15 Oct 2024 13:30:11 +0200
Message-ID: <20241015112506.641252102@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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
index f73a4ae2022e9..d651564b10447 100644
--- a/drivers/hwmon/Kconfig
+++ b/drivers/hwmon/Kconfig
@@ -226,6 +226,7 @@ config SENSORS_ADT7462
 config SENSORS_ADT7470
 	tristate "Analog Devices ADT7470"
 	depends on I2C
+	select REGMAP_I2C
 	help
 	  If you say yes here you get support for the Analog Devices
 	  ADT7470 temperature monitoring chips.
-- 
2.43.0



