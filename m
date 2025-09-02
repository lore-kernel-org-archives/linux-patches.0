Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9B3E30505F;
	Tue,  2 Sep 2025 13:23:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756819425; cv=none; b=S/APWHXffUub3/aGdIypYQB5JNvgBcMfWUDbhHtbmmwXqHQLLUA1lZ+8q3owLtIwEMnL8GHs0gfpJ+nUpbuN8OHUfGI1Di88bBHrHawKVqF1WwfoM3W51f4eipl3/T/MpIONpcXEOKWHBsEWRYWwC9KTPcrVuJ5LW5bmChkCUV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756819425; c=relaxed/simple;
	bh=1vKVJo5+7+iw+LSSzBqfcR6PbNyasKjdxYhSU+p0oUI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RNT1/H1b7t/NiiRUrHZ5FpboqMh5tZ6O/47u25v9pp9/2LPeAx5bUltMrvOOP8wQY94vDPo7gTX+N8oskKTVqvV8bomoPiF9d7uKzGoLUBxTKRrRbd7WeIn6hLXPPlpTmFxZA6yVtWuE+NgPAjB8xRqnvbqIjE/C2rCIwjIIQjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CdEDMg4N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CdEDMg4N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE304C4CEED;
	Tue,  2 Sep 2025 13:23:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756819425;
	bh=1vKVJo5+7+iw+LSSzBqfcR6PbNyasKjdxYhSU+p0oUI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CdEDMg4NccZWDgbK5iIft4eKeEAuCmfL1w2kyvGmYdvmMzE+hIZ/tsRkjMPM6Q7ER
	 BsNg4+NbUiAsE56crjgYtkz6QaEZe664l91sQMyCy10qyucz584/SfFNtZzzFAxamR
	 Gc3RN8lscqzI/e6PzShiTiwRNl0oFwpeKBAilMg0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 007/142] pinctrl: STMFX: add missing HAS_IOMEM dependency
Date: Tue,  2 Sep 2025 15:18:29 +0200
Message-ID: <20250902131948.438454087@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131948.154194162@linuxfoundation.org>
References: <20250902131948.154194162@linuxfoundation.org>
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

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit a12946bef0407cf2db0899c83d42c47c00af3fbc ]

When building on ARCH=um (which does not set HAS_IOMEM), kconfig
reports an unmet dependency caused by PINCTRL_STMFX. It selects
MFD_STMFX, which depends on HAS_IOMEM. To stop this warning,
PINCTRL_STMFX should also depend on HAS_IOMEM.

kconfig warning:
WARNING: unmet direct dependencies detected for MFD_STMFX
  Depends on [n]: HAS_IOMEM [=n] && I2C [=y] && OF [=y]
  Selected by [y]:
  - PINCTRL_STMFX [=y] && PINCTRL [=y] && I2C [=y] && OF_GPIO [=y]

Fixes: 1490d9f841b1 ("pinctrl: Add STMFX GPIO expander Pinctrl/GPIO driver")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Link: https://lore.kernel.org/20250815022721.1650885-1-rdunlap@infradead.org
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pinctrl/Kconfig b/drivers/pinctrl/Kconfig
index 33db9104df178..3952f77081a35 100644
--- a/drivers/pinctrl/Kconfig
+++ b/drivers/pinctrl/Kconfig
@@ -527,6 +527,7 @@ config PINCTRL_STMFX
 	tristate "STMicroelectronics STMFX GPIO expander pinctrl driver"
 	depends on I2C
 	depends on OF_GPIO
+	depends on HAS_IOMEM
 	select GENERIC_PINCONF
 	select GPIOLIB_IRQCHIP
 	select MFD_STMFX
-- 
2.50.1



