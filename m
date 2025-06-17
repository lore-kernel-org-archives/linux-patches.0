Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1560118E025;
	Tue, 17 Jun 2025 16:05:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176325; cv=none; b=e6PJ2I9mqEmXLHOxfq7pnNQ2pIJm0P64KwPZeqOVyixzXFbIlAPrrkGHSjxBGCUOxlnwMRDR0Nt1Sfn59c7AgecsZv2Ql60j/tq7rkb1/CXrERnfTjiDgNjzJZ5AlrtRu/8fbRVR0FLQaGG7RoMmfo0MWpdUddfkMn1HFg1Ci3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176325; c=relaxed/simple;
	bh=rk+3b9lWcAwdnOc8Z2Z+WSM/M3fxXp4R5FsUmjVo0XM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q79F58Z1m98LJTmeLOEPRTiibVLQAlwUwrgvcCG5gJxFD4MQ2SSNzHGgCp0/qfOjpP5MLjfKO4ClPr/J5hWZaP9FBr1Maks+eL9f9xIqj/cWPYw7EwEm/Jk/YApyHssef8PybDB5nbiP3DlaoZk2QJitovAvpy8ij9BhidLGUHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o1GuNw5s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o1GuNw5s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F2ECC4CEE3;
	Tue, 17 Jun 2025 16:05:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176324;
	bh=rk+3b9lWcAwdnOc8Z2Z+WSM/M3fxXp4R5FsUmjVo0XM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o1GuNw5s9JtGoJT//qCnVGMzf49F8eNpBUxxKxZ/l6SaDjpfQ0fyuLyTxuwh0PZMH
	 8pRZmxQ3wt/Pu5APggNUwjauZ+OtsJd4sn7CmbebAhPUl08843lM9KkVhespnthq2o
	 bS/4xdClcRjdyymgaSZ6D7lYjkriYvQqNqJXQ5OE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Golle <daniel@makrotopia.org>,
	Andrew Lunn <andrew@lunn.ch>,
	Christian Marangi <ansuelsmth@gmail.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 175/780] net: phy: mediatek: permit to compile test GE SOC PHY driver
Date: Tue, 17 Jun 2025 17:18:03 +0200
Message-ID: <20250617152458.607006437@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Marangi <ansuelsmth@gmail.com>

[ Upstream commit e5566162af8b9690e096d2e6089e4ed955a0d13d ]

When commit 462a3daad679 ("net: phy: mediatek: fix compile-test
dependencies") fixed the dependency, it should have also introduced
an or on COMPILE_TEST to permit this driver to be compile-tested even if
NVMEM_MTK_EFUSE wasn't selected. The driver makes use of NVMEM API that
are always compiled (return error) so the driver can actually be
compiled even without that config.

Fix and simplify the dependency condition of this kernel config.

Fixes: 462a3daad679 ("net: phy: mediatek: fix compile-test dependencies")
Acked-by: Daniel Golle <daniel@makrotopia.org>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Link: https://patch.msgid.link/20250410100410.348-1-ansuelsmth@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/mediatek/Kconfig | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/phy/mediatek/Kconfig b/drivers/net/phy/mediatek/Kconfig
index 2a8ac5aed0f89..6a4c2b328c418 100644
--- a/drivers/net/phy/mediatek/Kconfig
+++ b/drivers/net/phy/mediatek/Kconfig
@@ -15,8 +15,7 @@ config MEDIATEK_GE_PHY
 
 config MEDIATEK_GE_SOC_PHY
 	tristate "MediaTek SoC Ethernet PHYs"
-	depends on (ARM64 && ARCH_MEDIATEK) || COMPILE_TEST
-	depends on NVMEM_MTK_EFUSE
+	depends on (ARM64 && ARCH_MEDIATEK && NVMEM_MTK_EFUSE) || COMPILE_TEST
 	select MTK_NET_PHYLIB
 	help
 	  Supports MediaTek SoC built-in Gigabit Ethernet PHYs.
-- 
2.39.5



