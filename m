Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA0CA156E7
	for <patches@lists.linux.dev>; Mon, 16 Oct 2023 08:45:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K+V1fl2X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 093F6C433C8;
	Mon, 16 Oct 2023 08:45:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1697445927;
	bh=ld/Bj85i6O8OPRXIPxDWNKczASZfh/4jfEhUqxFFIAM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K+V1fl2XvYREhRgaK8Cst9NM44E3sjom1bdorkhu9Vn4hNHN6/YmuCa7roq57/7+N
	 W+1JcrrGeyCi22X9DkQMX15qt54GLShhU7OcI8LYDeUJ3ahOU1YlqsmolM3fU9lIvd
	 A1hEWiuI3yi9XXIOHrcCPtuNik4rRJMjbUpFhapQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ralph Siemsen <ralph.siemsen@linaro.org>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 039/102] pinctrl: renesas: rzn1: Enable missing PINMUX
Date: Mon, 16 Oct 2023 10:40:38 +0200
Message-ID: <20231016083954.743552596@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231016083953.689300946@linuxfoundation.org>
References: <20231016083953.689300946@linuxfoundation.org>
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

From: Ralph Siemsen <ralph.siemsen@linaro.org>

[ Upstream commit f055ff23c331f28aa4ace4b72dc56f63b9a726c8 ]

Enable pin muxing (eg. programmable function), so that the RZ/N1 GPIO
pins will be configured as specified by the pinmux in the DTS.

This used to be enabled implicitly via CONFIG_GENERIC_PINMUX_FUNCTIONS,
however that was removed, since the RZ/N1 driver does not call any of
the generic pinmux functions.

Fixes: 1308fb4e4eae14e6 ("pinctrl: rzn1: Do not select GENERIC_PIN{CTRL_GROUPS,MUX_FUNCTIONS}")
Signed-off-by: Ralph Siemsen <ralph.siemsen@linaro.org>
Reviewed-by: Miquel Raynal <miquel.raynal@bootlin.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/20231004200008.1306798-1-ralph.siemsen@linaro.org
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/renesas/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pinctrl/renesas/Kconfig b/drivers/pinctrl/renesas/Kconfig
index 9a72999084b36..ba7224a4c352d 100644
--- a/drivers/pinctrl/renesas/Kconfig
+++ b/drivers/pinctrl/renesas/Kconfig
@@ -228,6 +228,7 @@ config PINCTRL_RZN1
 	depends on OF
 	depends on ARCH_RZN1 || COMPILE_TEST
 	select GENERIC_PINCONF
+	select PINMUX
 	help
 	  This selects pinctrl driver for Renesas RZ/N1 devices.
 
-- 
2.40.1



