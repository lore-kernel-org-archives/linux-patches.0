Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21A4230DD12;
	Tue,  2 Sep 2025 13:44:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756820645; cv=none; b=riTHUyv761mKIYBknq5E1AwxPOQQ3Z7WBDURKDQbjgmHw/83JrOt0vaDr1vfp797/otwTSC0nNJZX9QvUkQlsYuKAXsj44QZR1KtFZcSGEA5ULJdC1K2OYZnSLHIO/tRWT6e7ziOPxrvmjkGI/XUPWg0u9OhBgSUhfz70rW91VE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756820645; c=relaxed/simple;
	bh=/vLxRZHLtt0TXP72WY3i02MWDi5+Pp2bX61YQsKlQVU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XKcboZNKYGtaFaVqKJpxGURZsVRtLpovC1HpSfTaamWLEB2rOIaB3TY6e0WpxGzD5+0dY4ydca3th/8uFRQLQTC1VZBDIhUSiX04C95jpSKT5k1lwmsTc5h0yb6Zs3nqDdPCKpnvA1bpRnPlAUyddVCNyFnQuur7lqqzQQy6XDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZC3J8DJT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZC3J8DJT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39849C4CEED;
	Tue,  2 Sep 2025 13:44:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756820643;
	bh=/vLxRZHLtt0TXP72WY3i02MWDi5+Pp2bX61YQsKlQVU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZC3J8DJTzIhGtXaNTylUTRVFVMR70VHlLEQvZTj/bCVnDijN9IdbLwHH/hOF2RZhT
	 UggW+EbB4klCErg05BkVDuqNEshNDYp+zgl24CjPpQMrrtaQQ23wWSBkQ/z147zwan
	 MBNmgvaicapNNza1dayAqjg5U2629x5MwaAz+hO8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 01/34] pinctrl: STMFX: add missing HAS_IOMEM dependency
Date: Tue,  2 Sep 2025 15:21:27 +0200
Message-ID: <20250902131926.670583534@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131926.607219059@linuxfoundation.org>
References: <20250902131926.607219059@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 815095326e2d6..72c27181a4270 100644
--- a/drivers/pinctrl/Kconfig
+++ b/drivers/pinctrl/Kconfig
@@ -268,6 +268,7 @@ config PINCTRL_STMFX
 	tristate "STMicroelectronics STMFX GPIO expander pinctrl driver"
 	depends on I2C
 	depends on OF_GPIO
+	depends on HAS_IOMEM
 	select GENERIC_PINCONF
 	select GPIOLIB_IRQCHIP
 	select MFD_STMFX
-- 
2.50.1



