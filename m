Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 818E032274C;
	Tue,  2 Sep 2025 13:45:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756820758; cv=none; b=n9ud53Y/xJ8eU3JIcmv48ncHyW4M8jhRMyw813diggmQ9q4GwgsWUvhFK12a9E8h2uyMLn4u7++LpgCE86yT6Wy+YTjYjS/IZ7QMwijiuP8oHrERiAy0gRdFqMBFmIOElqM/cNUxlEazejqKs6j1d6/Xg4ymv7vkCMX0CK8L0RE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756820758; c=relaxed/simple;
	bh=4mWZnsDaZxpL2djgzVhJDuvI0ncUMsii0mxJueMaXvs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aIjNmGAsOSpEu3jGfmcSyiALDHFPTyrwCwEufTbaS6CpAO+zdZVQbp9Ir8Q5PSKBj/Mz0H24nQ4EC+MZLy+/lU41PeBB6WlW9wkH4Q88pVF4y+ws+TlZFMop2VYv8isgjir7IqK/hK2vgeLyiEjGS4wiosYMPJni/YgYkCZClkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PbYrBMas; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PbYrBMas"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 094BCC4CEED;
	Tue,  2 Sep 2025 13:45:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756820758;
	bh=4mWZnsDaZxpL2djgzVhJDuvI0ncUMsii0mxJueMaXvs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PbYrBMasJMTHALbuBKoJSMxY8Tki9Zg/zeYJPGm0so7rXAovIW7bY6Xhzb0rMKQf3
	 FBt3D4jNkgDMVnBoLbIgecm70L+yleNxLDhWy92pKOOVubPD7WtDgCSDE4fTRZipG6
	 Sz33jaaxiCMZJXhlwZ0tisT22wFCW8ej6ZK5DKFY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 01/23] pinctrl: STMFX: add missing HAS_IOMEM dependency
Date: Tue,  2 Sep 2025 15:21:47 +0200
Message-ID: <20250902131924.782528094@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131924.720400762@linuxfoundation.org>
References: <20250902131924.720400762@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index b372419d61f26..57426dc52f9f0 100644
--- a/drivers/pinctrl/Kconfig
+++ b/drivers/pinctrl/Kconfig
@@ -278,6 +278,7 @@ config PINCTRL_STMFX
 	tristate "STMicroelectronics STMFX GPIO expander pinctrl driver"
 	depends on I2C
 	depends on OF_GPIO
+	depends on HAS_IOMEM
 	select GENERIC_PINCONF
 	select GPIOLIB_IRQCHIP
 	select MFD_STMFX
-- 
2.50.1



