Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029906;
	b=c1Ygh0NIin9ON17Q+QtvViAGp2/XAz5OYF1mNyxoL1p+EMwklzfsHPZyR1PXBlprsvxQ
	 yiRC3shUCzEAaMR51rGOEYB8UjhBJTHALn2AI8RI/dQ1XlpsbzLTyWFwIWNn17f60Mzcw
	 o0Tj9cJUW060lCev2rmTjo4NXZGqDkUwAAI9dooWAT9lsLuk/RXeLuDTaKghq4CHQ6WkH
	 6Q15YNy9U1SWaS+IdjhpNNLHeDxhPAhDHK982zWBS1buDrV9TPzkt/ysZi4c+evfl7SoO
	 pvReEkORg6xR9GR1gWX9oRevaWvO2myHki1vzPoaAd1+qgQgpz7seeHr92eZSFAXVcA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029906;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AHkXydKfLbIR6W1xX/5jGhHMuYbA/8uo5A26pAo2830=;
	b=zqBu98RT+qY72TQA2W+btgSTcxkxeG9k2QEclSXN2QSpu9FzKgDT9Xv16pvTwQLDUq8S
	 0XOw5fxkj3iIO4jSm9KA0Rb+oZnPQ4nk/ZuL82zSlxZ2TB6ldXEKi20DlKe7XYnmsiEQD
	 9d7RzQ4NT7X6ts+3BYIo7IwSZK/og4Nus9OgMoc7KHPoPQtUq9Db2trKSSgjFg90q4mnu
	 fJLpCw9OaK95FTMjWiSLVv2LnrGwaJAPfLWh1nAU7/4tgwhJrBmV+QPkJom42KJcNvYaj
	 z7uPoinFLGoXCvNG3gzFZn3aNm7lNOcXueNKZnmNjH8wFYsfQ1Vc0F5mQNsoWlsHd2Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=R8MHqdFz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D25F960A383A;
	Wed, 18 Nov 2026 19:25:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=R8MHqdFz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9BA11F000D3;
	Wed, 18 Nov 2026 19:25:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029906;
	bh=AHkXydKfLbIR6W1xX/5jGhHMuYbA/8uo5A26pAo2830=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R8MHqdFzzlfo8ER4BYqjHq2+FJXxeQ6hAhbrVZkguhe5eL+gvcuBqhSqXwa5D3PbR
	 dGK/7XweoXM9zWp1gCSZTvpNo5kOZtj8kLK3NQ4dlXGGBc8wDVR1/UMUMeMXvNrsor
	 3two94yEWSB554IwbjxS2Xc/eY4EPaaJsfvX8/9g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Gaylard <ag@ffroot.co.za>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0474/1756] pinctrl: fix PINCTRL_SPPCTL=m
Date: Wed, 18 Nov 2026 15:43:21 +0100
Message-ID: <20261118150027.743299002@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



