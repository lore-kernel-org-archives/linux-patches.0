Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B54F6FA1
	for <patches@lists.linux.dev>; Mon,  3 Apr 2023 14:24:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E547BC433A0;
	Mon,  3 Apr 2023 14:24:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680531855;
	bh=FLUznkIVW0cj8YbRf8FpepXYKZ5WumxYnYK0ldiUr10=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b+CohO58Jsm9chKTFM1dXolM8vA5YKxUmC2LPwQalgXqPhT3kl06sgUbnymTHTpaG
	 zzSFl0JiLRMazs7JjZC1inD/nqTBOi//Bf8/cAtCpjSGmqUtKJ87GchwKIh5xTAGDA
	 PAa3i0iM4PYUeP3JoQOc03BU1mJzF57v0N0eD0B8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeremy Kerr <jk@ozlabs.org>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 015/173] serial: 8250: SERIAL_8250_ASPEED_VUART should depend on ARCH_ASPEED
Date: Mon,  3 Apr 2023 16:07:10 +0200
Message-Id: <20230403140414.792448476@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140414.174516815@linuxfoundation.org>
References: <20230403140414.174516815@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 806a449725cbd679a7f52c394d3c87b451d66bd5 ]

The Aspeed Virtual UART is only present on Aspeed BMC platforms.  Hence
add a dependency on ARCH_ASPEED, to prevent asking the user about this
driver when configuring a kernel without Aspeed BMC support.

Reviewed-by: Jeremy Kerr <jk@ozlabs.org>
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/259138c372d433005b4871789ef9ee8d15320307.1657528861.git.geert+renesas@glider.be
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: f8086d1a65ac ("serial: 8250: ASPEED_VUART: select REGMAP instead of depending on it")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/8250/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/tty/serial/8250/Kconfig b/drivers/tty/serial/8250/Kconfig
index 136f2b1460f91..dcf89db183df9 100644
--- a/drivers/tty/serial/8250/Kconfig
+++ b/drivers/tty/serial/8250/Kconfig
@@ -255,6 +255,7 @@ config SERIAL_8250_ASPEED_VUART
 	depends on SERIAL_8250
 	depends on OF
 	depends on REGMAP && MFD_SYSCON
+	depends on ARCH_ASPEED || COMPILE_TEST
 	help
 	  If you want to use the virtual UART (VUART) device on Aspeed
 	  BMC platforms, enable this option. This enables the 16550A-
-- 
2.39.2



