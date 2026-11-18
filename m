Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048395;
	b=0I6IO1M93IEaQsxE9ZYx/pSvkLl8PbPoGfUnQHbwsrsxf3lBDbW5ptH4qq2Bqb81BOUW
	 nlhlNp3F3/Ofigj6h3kLnTukkl8JIjZZ1Ggq6udNk1CRG27sdczGLM9nvlEGcAGvu9dDu
	 FzTdQv756QgZO5514eoaV5Y++vz2hvHjYMy0RwNG6cD6gnTvSZb8MXTGg535Gbav0PdcU
	 Iso31XbvXoFTiQB1vQXy/1f8N5WxzBhO3vQguSPmQ8RM3N2hrADJ7rGtrJQ0mWlstB5gO
	 QzkMKQTBlTc7wlO1jXCMB73wbfOlqhGvK0llBBNOnbIWgBwrPOYImORWNU4TRn9tE3g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048395;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=W09a56seXU3+J0XW3Sxbly8Ur6XpSK368oK4hb3RNcM=;
	b=IXGAdSjhp3QXzWMBihzXWLmPlvNi+BiaNi4/soadJ3gIk1jOcIgEpTT6Khtt9YP0Zd+C
	 bkZOa1rL2uEC4DqM76bS4ykxKf3/YBLYZFAFY8ekUXGy8gkJ5bEds2zp5bkYIkPnirK/W
	 wgyXwKAK+bQhUiy/ch3ZTVbUIWFyrXn7zalU0XyYCbpPQ1TGdy6J1c32XC5rAj+JzG7tx
	 1gxiYayRDJWympUiEz2mmgFog8cG+9euGeb/vwuLohDIig5OMXHlQULYQPa+nj7MPf003
	 pcn4Vzuk48frpqds6p+17pEjr/7cUp3fjTo6zFa5Da4gH/56yMGu0zE1W6ozBgDhVSA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=icuVko4S;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FA6760A2600;
	Thu, 19 Nov 2026 00:33:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=icuVko4S
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A69E41F000C4;
	Thu, 19 Nov 2026 00:33:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048395;
	bh=W09a56seXU3+J0XW3Sxbly8Ur6XpSK368oK4hb3RNcM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=icuVko4SLGhoDJ5Bt84NWyUhhGC9BqbpLxYR8hqxahmcY9S26CofeYSCe1Ce3IU6D
	 3SC6gYroMctWQCqC1YkWzTXKZrYhj96nC7L8NydxO6GJ3JR9ra9JL/WhOK8iQ+KjAV
	 vnONkiL8FIRBO07+8AqWRAIL2ycoMCaWZlr7qjYE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Gaylard <ag@ffroot.co.za>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1978/2857] pinctrl: fix PINCTRL_SPPCTL=m
Date: Wed, 18 Nov 2026 15:50:12 +0100
Message-ID: <20261118150312.604950941@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrew Gaylard <ag@ffroot.co.za>

[ Upstream commit 7dcf87d2dbbe8c9c1efb69fe9be728a3dfd51d3d ]

The PINCTRL_SPPCTL option is defined as a tristate in Kconfig, and the
help text suggests that the user can build it as a module by setting to
'm'.

However, it cannot currently be set to 'm', because SOC_SP7021, the only
platform that supports it, is a bool option that uses 'select' on it.
Also, the SP7021 requires this driver to be built in, in order to boot.

Change the tristate to bool and fix the help text.

Tested on linux-next-2026-09-14 on a LTPP3G2 board.

This impossible tristate was detected by kconfirm, a static analysis tool
for Kconfig, by Julian Braha <julianbraha@gmail.com>.

Fixes: aa74c44be19c ("pinctrl: Add driver for Sunplus SP7021")
Signed-off-by: Andrew Gaylard <ag@ffroot.co.za>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/sunplus/Kconfig | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/pinctrl/sunplus/Kconfig b/drivers/pinctrl/sunplus/Kconfig
index 4b5c47c193d97..a359fdbda1b3a 100644
--- a/drivers/pinctrl/sunplus/Kconfig
+++ b/drivers/pinctrl/sunplus/Kconfig
@@ -4,8 +4,8 @@
 #
 
 config PINCTRL_SPPCTL
-	tristate "Sunplus SP7021 PinMux and GPIO driver"
-	depends on SOC_SP7021
+	bool "Sunplus SP7021 PinMux and GPIO driver"
+	depends on SOC_SP7021 || COMPILE_TEST
 	depends on OF && HAS_IOMEM
 	select GENERIC_PINCTRL_GROUPS
 	select GENERIC_PINMUX_FUNCTIONS
@@ -17,6 +17,4 @@ config PINCTRL_SPPCTL
 	help
 	  Say Y here to support Sunplus SP7021 pinmux controller.
 	  This driver requires the pinctrl framework.
-	  GPIO is provided by the same driver.
-	  To compile this driver as a module, choose M here.
-	  The module will be called sppinctrl.
+	  This driver also provides GPIO.
-- 
2.53.0



