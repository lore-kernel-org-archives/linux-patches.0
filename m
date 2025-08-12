Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF46D291C1F;
	Tue, 12 Aug 2025 18:47:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024441; cv=none; b=FPj7ZJ1CwYVLJNIai+5vfbWNZY6jzDkWy5NkqBvsANjoyR+nxZxbVkqfsmiHB2ZJvtaPbw+zln/NKq4xCybt10NAL7m9tHBV2/8Rfaa6szv4SGuPPqz5+4UBw5GKCGLukm07b40tgi02bDTKsnxF6odfjutpvQ+Pg5GXBS3EWxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024441; c=relaxed/simple;
	bh=SivwWfug9CQZ32SAzFw5rATmgN1o16Vnu6tzU6inqBY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ot66B0/TyKJjD1IT+0bxJyXVHsDcD5nWURe+RZggZUAkvVIMzjUgM7s3s9GKwMvcfcJJ/tvyzvzfm51mfUOKiM5nG2sOFPij2F4eB9VeQhMOBhATh6Bw6gj2FfUUr/Bybf6v3tYFML0nJI8qBY4FL8N8z9tXeSR7HCiED0/EqOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YhtDCKxz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YhtDCKxz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C87CEC4CEF0;
	Tue, 12 Aug 2025 18:47:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024441;
	bh=SivwWfug9CQZ32SAzFw5rATmgN1o16Vnu6tzU6inqBY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YhtDCKxzUbkcsHVlGoLCbe8h4/SLWKa/GuWztmbs8yMy1NFj9JXGrgC2baJILdyKd
	 7lSuQpxHJydeo8Ca5w8hcbGJVjGSKxtA5aUd0s//FMC0hwpAWeuBWi9j8otZ6Yz6kp
	 3wUWUzt+y84fQeGouutebDQB5YuVVziQ+OL3ahd4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Randy Dunlap <rdunlap@infradead.org>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 347/627] leds: tps6131x: Add V4L2_FLASH_LED_CLASS dependency
Date: Tue, 12 Aug 2025 19:30:42 +0200
Message-ID: <20250812173432.489461716@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit c3c38e80016548685e439b23999b4f0bd0ad7e05 ]

This driver can optionally use the v4l2_flash infrastructure, but fails to
link built=in if that is in a loadable module:

ld.lld-21: error: undefined symbol: v4l2_flash_release
>>> referenced by leds-tps6131x.c:792 (drivers/leds/flash/leds-tps6131x.c:792)

Add the usual Kconfig dependency for it, still allowing it to be built when
CONFIG_V4L2_FLASH_LED_CLASS is disabled.

Fixes: b338a2ae9b31 ("leds: tps6131x: Add support for Texas Instruments TPS6131X flash LED driver")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Randy Dunlap <rdunlap@infradead.org>
Tested-by: Randy Dunlap <rdunlap@infradead.org>
Link: https://lore.kernel.org/r/20250620114440.4080938-1-arnd@kernel.org
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/flash/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/leds/flash/Kconfig b/drivers/leds/flash/Kconfig
index 55ca663ca506..5e08102a6784 100644
--- a/drivers/leds/flash/Kconfig
+++ b/drivers/leds/flash/Kconfig
@@ -136,6 +136,7 @@ config LEDS_TPS6131X
 	tristate "LED support for TI TPS6131x flash LED driver"
 	depends on I2C && OF
 	depends on GPIOLIB
+	depends on V4L2_FLASH_LED_CLASS || !V4L2_FLASH_LED_CLASS
 	select REGMAP_I2C
 	help
 	  This option enables support for Texas Instruments TPS61310/TPS61311
-- 
2.39.5



