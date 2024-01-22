Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EBD7627E7;
	Tue, 23 Jan 2024 01:55:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974948; cv=none; b=NfbVuOnwkh3nUB3ss6EJ1EXyHipWNHQ3+TKJBvgIoYSCSzSetQLBTxjBkZRMXyqTUtS0KLX1hNsSLeajN4ed+HYPwPUFnF95J3K6pRCa4qneHpdhKAL276qiMua/KFOzIVa823T5RDjIhemuAS0mS9k1PgPQuDyvLcQZCLNyqX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974948; c=relaxed/simple;
	bh=4yoSgJYKhq7oSYl4B/kv9wKnaSgR34XM2/TO2b+NSTA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=caQ6/5rMEeYw5R/c8n6daHjv0Pf0TFG2YzjaBvzp92Nz5XnqtVXg6b3XEPdUkaR0xSy3HFlEMUmS9I4m9EzvF4S7FBcUSoKX+vfbHpuTGRIdFCvZwAEfydQ61ijWL6aXLgCLjvD72EPt32ab8Y9nCksI2WcjQrhQsWgfbfETaAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Va0c+wHx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Va0c+wHx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF0DFC43399;
	Tue, 23 Jan 2024 01:55:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974948;
	bh=4yoSgJYKhq7oSYl4B/kv9wKnaSgR34XM2/TO2b+NSTA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Va0c+wHxzwkVU57HCr9ptetTylQ/SpaC9/WyT3/KT9DcQJ4gSsqdys0ARF1ImOpmH
	 khv0EdfZbou1OaCjl54Ob/CT+gnNe494kLwgFAm2oNwNy8xZQh2VTRd9fldQixATTi
	 FiH4ZGLr81UkZf+kxu1QlFQqvKsZ2+Rur6uITfB4=
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
Subject: [PATCH 5.15 291/374] ARM: 9330/1: davinci: also select PINCTRL
Date: Mon, 22 Jan 2024 15:59:07 -0800
Message-ID: <20240122235754.911250742@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
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
index 01684347da9b..889f3b9255c7 100644
--- a/arch/arm/mach-davinci/Kconfig
+++ b/arch/arm/mach-davinci/Kconfig
@@ -10,6 +10,7 @@ menuconfig ARCH_DAVINCI
 	select PM_GENERIC_DOMAINS_OF if PM && OF
 	select REGMAP_MMIO
 	select RESET_CONTROLLER
+	select PINCTRL
 	select PINCTRL_SINGLE
 
 if ARCH_DAVINCI
-- 
2.43.0



