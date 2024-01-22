Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57D984F5EB;
	Tue, 23 Jan 2024 00:31:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969885; cv=none; b=ipUMxBwMi/pcmOgxWobicqvEDYdDs7jb8bqGzCjWyoBS9x5dx8HqrqBRJuDP6wVj7UKhN+GdSnjUrQod/8cGodYNBruDaJrtqGM/jITGBASGGGS0jzy3txwgzhY1ohRR3u5zkasDo+Kt/3dw2cqiNzekecHVqkIHB11lqDCMWK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969885; c=relaxed/simple;
	bh=fffo6dKiNSqsMzI2ffgAW2bhoDRlTngWPUfdwUxxDI8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C8fZwBEnjKZhj4E1tyqbNgZvp5XEoEdVCSzbM64pEWm2JXNr2oELA5RgJJMSwJ6kuVXFsgonkig644LATPxiuzFcjXVBefmNr/2hEJM9fGIhdyIm3IUby4ob3WmsEmR/2bAq+ve6BL3GJ/GAbEc9Ep9E/6l0DXD2t1a/uhu7Cf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UYkDfyfa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UYkDfyfa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD2C0C433C7;
	Tue, 23 Jan 2024 00:31:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969883;
	bh=fffo6dKiNSqsMzI2ffgAW2bhoDRlTngWPUfdwUxxDI8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UYkDfyfag3K+5ZQIlx6ZnSt8CIWCNISuDIcKnE6yV/b2wqTjdfni45020f4XZ0tIn
	 VYn7njT+8ht63lfTdACB5h0rojg+2WxVgwQS6CFCmLzAsy6Mn9T+NeyNnwHM6A7ew+
	 V6XD1jgL/vEZJ4Znm9q+v2AyoLQkIN4u94HkkZhA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	kernel test robot <lkp@intel.com>,
	Bartosz Golaszewski <brgl@bgdev.pl>,
	Arnd Bergmann <arnd@arndb.de>,
	linux-arm-kernel@lists.infradead.org,
	patches@armlinux.org.uk,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 481/641] ARM: 9330/1: davinci: also select PINCTRL
Date: Mon, 22 Jan 2024 15:56:25 -0800
Message-ID: <20240122235833.119778255@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit f54e8634d1366926c807e2af6125b33cff555fa7 ]

kconfig warns when PINCTRL_SINGLE is selected but PINCTRL is not
set, so also set PINCTRL for ARCH_DAVINCI. This prevents a
kconfig/build warning:

   WARNING: unmet direct dependencies detected for PINCTRL_SINGLE
     Depends on [n]: PINCTRL [=n] && OF [=y] && HAS_IOMEM [=y]
     Selected by [y]:
     - ARCH_DAVINCI [=y] && ARCH_MULTI_V5 [=y]

Closes: lore.kernel.org/r/202311070548.0f6XfBrh-lkp@intel.com

Fixes: f962396ce292 ("ARM: davinci: support multiplatform build for ARM v5")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: kernel test robot <lkp@intel.com>
Cc: Bartosz Golaszewski <brgl@bgdev.pl>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org
Cc: patches@armlinux.org.uk
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-davinci/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/mach-davinci/Kconfig b/arch/arm/mach-davinci/Kconfig
index 59de137c6f53..2a8a9fe46586 100644
--- a/arch/arm/mach-davinci/Kconfig
+++ b/arch/arm/mach-davinci/Kconfig
@@ -11,6 +11,7 @@ menuconfig ARCH_DAVINCI
 	select PM_GENERIC_DOMAINS_OF if PM && OF
 	select REGMAP_MMIO
 	select RESET_CONTROLLER
+	select PINCTRL
 	select PINCTRL_SINGLE
 
 if ARCH_DAVINCI
-- 
2.43.0



