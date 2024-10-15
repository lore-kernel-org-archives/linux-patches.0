Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74B641AF0A3;
	Tue, 15 Oct 2024 13:22:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728998525; cv=none; b=RWMUrf44t4ku7OF6WkfSUvp3S8wXgapCHQlDNwr/kWmfvz30LXGI/xcYeP3Z7BW3b6z/sbU3A9B1h2MeHu/+waOCv5AsLtWYOWyRDmYVzYHFrIJo75HwT6o/Xzy6csn45SlozxYCnfFGlBjiHjWExJsF1Wf+rb1mO8jBu41iNDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728998525; c=relaxed/simple;
	bh=yZymVCWjFJic7671tHrlkwYStNJk1wxbI/9BhKOV0lo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BwhlRLqrT3Wi1qnm1KjnWtUUMN8A9p4/X3ZviALeZ+e1D7GI2BnEh6takACsI/19xMkvG8sG9LDRyB8Va08taoGUDQuh/1bZnEc4eE5L5E76Z1zz9i3RFhiQQ/Ymkket9cvmiCN0LBT/mulg1khh3Qwn6BBtXdT0Pd/k2EpzZLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VPnTiQuq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VPnTiQuq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D04E6C4CEC6;
	Tue, 15 Oct 2024 13:22:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728998525;
	bh=yZymVCWjFJic7671tHrlkwYStNJk1wxbI/9BhKOV0lo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VPnTiQuqCUlJpneS+YSXj9f9KSBYXIdttdTkiM5pahLQQ7AUKGdZC8LztlfUl4oAf
	 W3Ayl6iasbs8Z0xocu0jmVfgYeTj4DyZToQ8gS2tMF7pOz0o0k1HOn/IR14herqiB3
	 bHMx7o+dC8IaPhuJTVcfOBSik/4ug6Dstb4FaQvM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 501/518] hwmon: (adm9240) Add missing dependency on REGMAP_I2C
Date: Tue, 15 Oct 2024 14:46:45 +0200
Message-ID: <20241015123936.330111422@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index a762334084cf5..606cb865195fb 100644
--- a/drivers/hwmon/Kconfig
+++ b/drivers/hwmon/Kconfig
@@ -178,6 +178,7 @@ config SENSORS_ADM9240
 	tristate "Analog Devices ADM9240 and compatibles"
 	depends on I2C
 	select HWMON_VID
+	select REGMAP_I2C
 	help
 	  If you say yes here you get support for Analog Devices ADM9240,
 	  Dallas DS1780, National Semiconductor LM81 sensor chips.
-- 
2.43.0



