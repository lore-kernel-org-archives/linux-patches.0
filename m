Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CC5E1C82FB;
	Mon, 14 Oct 2024 14:47:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917238; cv=none; b=omOfG/Curdx6sCzdEzVMqHjb0ohIia3Ki8klMkeMYVtVPA4rSJr5EioVzuD3Kgo0V/CysHcnfZcx6Unk4EhiDp7858V6IRSz8UT7bYmc+dl5ROFP1CtCDSMMZpI701OTlLZh4Qq1cICBa8dHswJs6Pss22xZuRwBFk7GtTjekKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917238; c=relaxed/simple;
	bh=tJyqG4AmNascUd2rxiAk2blCsLp/9l71rczjt0C29+M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c9gBLwvDuEiHBTpw5Wt5brEGu1YWcRK6KF003xMmbCPv/qnyWIdp1Wh4HnPF6TBfwCmOyWXI/V0IrDdzvoJJu0tCvTxTsEnziIcrcOBOwzmYpr1v/T5x5agUUKa4DjozTXeyHk6EpsXLl2Wind6/QoEEfjJ28VkcTWHJlyX3atc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AqNrlgi/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AqNrlgi/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FF44C4CEC3;
	Mon, 14 Oct 2024 14:47:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917238;
	bh=tJyqG4AmNascUd2rxiAk2blCsLp/9l71rczjt0C29+M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AqNrlgi/T0tnpaDhUhid1I64QoPM37OUYpJatyIkbtsCiUb47FEp07ahVFZtgGZrv
	 vDx7t08TEDSi6CaMPEKiZsqlLjojnIUYzQy97s3wPOCxBDR1UGrTolcHYR0i/GM93D
	 l2gfIxxS1HbFGeDf5OGHACUO065Wo0kNkgFhssBU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Eric Tremblay <etremblay@distech-controls.com>,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 175/213] hwmon: (tmp513) Add missing dependency on REGMAP_I2C
Date: Mon, 14 Oct 2024 16:21:21 +0200
Message-ID: <20241014141049.796462535@linuxfoundation.org>
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

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit 193bc02c664999581a1f38c152f379fce91afc0c ]

0-day reports:

drivers/hwmon/tmp513.c:162:21: error:
	variable 'tmp51x_regmap_config' has initializer but incomplete type
162 | static const struct regmap_config tmp51x_regmap_config = {
    |                     ^

struct regmap_config is only available if REGMAP is enabled.
Add the missing Kconfig dependency to fix the problem.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202410020246.2cTDDx0X-lkp@intel.com/
Fixes: 59dfa75e5d82 ("hwmon: Add driver for Texas Instruments TMP512/513 sensor chips.")
Cc: Eric Tremblay <etremblay@distech-controls.com>
Reviewed-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
index ec38c88921589..b46c85e2197c0 100644
--- a/drivers/hwmon/Kconfig
+++ b/drivers/hwmon/Kconfig
@@ -2137,6 +2137,7 @@ config SENSORS_TMP464
 config SENSORS_TMP513
 	tristate "Texas Instruments TMP513 and compatibles"
 	depends on I2C
+	select REGMAP_I2C
 	help
 	  If you say yes here you get support for Texas Instruments TMP512,
 	  and TMP513 temperature and power supply sensor chips.
-- 
2.43.0



