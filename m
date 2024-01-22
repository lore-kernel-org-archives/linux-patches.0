Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0BCE768F6;
	Tue, 23 Jan 2024 02:05:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975520; cv=none; b=sad1hGZcfqrosGmnzrUBMhjJkQ7pffZj2X+r2FqfG3xeMpYqkrLevYio0qr3ymcneMsxGRi1RkPCf/lqSdeZsUcsEA+MySx08VAYwkhB8GJju2mh9iB3TcN/Xtw6eW4zggATAQ21Bsj7NbOS3uTNemRojFwKS8wAEkYAEZNyXOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975520; c=relaxed/simple;
	bh=xX/3b4lWu1XIKVmIVSY0uMBSXU7x1PLXM1lYl+KQ9x0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hFup1N5y7kxONnzu9E8ffYfQiSLdW0/unA0yLcTzG+DafbWO9+vW0G6pB2F2jw8gKn0t4qQTdt8FosFxFpChuCKYLOiQyNXUE5hFbDbnD7Z5fwMuYHNe7wfhmvijynsPhDUGNhEzgfvL3BA3P80FIp3LFPr3BA/fPKfKGO9wcwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g5jFdYln; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g5jFdYln"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9363DC43399;
	Tue, 23 Jan 2024 02:05:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975520;
	bh=xX/3b4lWu1XIKVmIVSY0uMBSXU7x1PLXM1lYl+KQ9x0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g5jFdYlnjTdTbYJsPAVF9Z1bHHt7Vnym8/p8baDK1BRnnsSbcD4HslsA/MjkcXIj9
	 ii4kE3FN2L2mQrk1103gF/dDVh2MzT7DXh6iayf3GYfySTRESdZY+smynn/rdZmlp6
	 /5PXHYUMglw2vkotQx8y18N/i1WJ/IwyEF8S7RIY=
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
Subject: [PATCH 6.6 437/583] ARM: 9330/1: davinci: also select PINCTRL
Date: Mon, 22 Jan 2024 15:58:08 -0800
Message-ID: <20240122235825.350820535@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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



