Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4962826CE2B;
	Tue, 12 Aug 2025 18:46:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024362; cv=none; b=XA6OtAJiawjSaIGPdIM5Q8UMq4XVeY1YfkomxrFUDg5KA95DFqvaWg5daFUUF4ffxUgmTzw97bQ7LY7l8TveUyj7ai8U0msrXtjQR288hUQ/U6i/8+lSKsRk/ZFDH88hbJ0NHWRWO++GocoRQJKhIWBcFyRyiYG1pyb+BCHrwS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024362; c=relaxed/simple;
	bh=4hNvpuTc5UTnWKrqYE5nSZAQQwcuYOEZNDkcWc5ejI4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cm9NAleLgin3bbeOjikxRW0+BvuJRp9NSgO+ZjdKhtNEGZY4MH5dQ8IPM253qC7ctIWCU8mubB1AM+HkwaHcmIXrP6++0TMPi0nqYhIqIQ8b6fG3lXLdzw/G0muKr6E9fFqG7OR6MvooYEPhOFNwmjT3LDgnZSsNu80sXS3hVmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vSIMaABY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vSIMaABY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68F69C4CEF1;
	Tue, 12 Aug 2025 18:46:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024361;
	bh=4hNvpuTc5UTnWKrqYE5nSZAQQwcuYOEZNDkcWc5ejI4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vSIMaABY9ZJbFRSkABzXNhGpHBbY+FYFp7JPNlM50Ti/5TX0JJqX4Fy2liFsqgwWZ
	 Yhi6p9yh55PCIBXitDNfje/z96+nb50KvxWJi8waeCsDx9DQ7TMEsCMX0eqZjSgck2
	 Bxe8hV3X1fKwTjEhKqYlYRfldsDmc4AfsHfDciLU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 318/627] power: reset: POWER_RESET_TORADEX_EC should depend on ARCH_MXC
Date: Tue, 12 Aug 2025 19:30:13 +0200
Message-ID: <20250812173431.401652162@linuxfoundation.org>
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

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 22e4d29f081df8a10f1c062d3d952bb876eb9bdc ]

The Toradex Embedded Controller is currently only present on Toradex
SMARC iMX8MP and iMX95 SoMs.  Hence add a dependency on ARCH_MXC, to
prevent asking the user about this driver when configuring a kernel
without NXP i.MX SoC family support.

Fixes: 18672fe12367ed44 ("power: reset: add Toradex Embedded Controller")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/1ef0beb1e09bf914650f9f9885a33af06772540d.1746536287.git.geert+renesas@glider.be
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/reset/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/power/reset/Kconfig b/drivers/power/reset/Kconfig
index e71f0af4e378..95f140ee7077 100644
--- a/drivers/power/reset/Kconfig
+++ b/drivers/power/reset/Kconfig
@@ -218,6 +218,7 @@ config POWER_RESET_ST
 
 config POWER_RESET_TORADEX_EC
 	tristate "Toradex Embedded Controller power-off and reset driver"
+	depends on ARCH_MXC || COMPILE_TEST
 	depends on I2C
 	select REGMAP_I2C
 	help
-- 
2.39.5



