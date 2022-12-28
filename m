Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BEAC1C08
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:31:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14DF0C433F2;
	Wed, 28 Dec 2022 16:31:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672245077;
	bh=i3rRHJpelpK4X9bMAF/uRbTY5W3rREeReKQxBhgnHDU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J0uDfhF0etIGGzXbdVbIgW8gSES1VFg+uT70DeX/NwOfZHV/vwPIR/O22J2bmoJ8J
	 jyV79b8Gcl3ksS/Hw6yjO61jo2IecYIbLKGoWxLZlX+qJ6/LcOSNI6uhkHrL8tdmu9
	 xNVJrpeS7DVz0X2m21J2aKq/m8sKhVyb8aaAXqMA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0829/1073] mfd: bd957x: Fix Kconfig dependency on REGMAP_IRQ
Date: Wed, 28 Dec 2022 15:40:17 +0100
Message-Id: <20221228144350.532954750@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>

[ Upstream commit 85842c46fd47fa6bd78681c154223bed27d5fd19 ]

The BD957x driver uses REGMAP_IRQ but does not 'select' to depend on
it. This can cause build failures.  Select REGMAP_IRQ for BD957X.

Fixes: 0e9692607f94 ("mfd: bd9576: Add IRQ support")
Signed-off-by: Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>
Signed-off-by: Lee Jones <lee@kernel.org>
Link: https://lore.kernel.org/r/Y3SdCWkRr1L64SWK@dc75zzyyyyyyyyyyyyydt-3.rev.dnainternet.fi
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index abb58ab1a1a4..3e8becef3cb0 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -1968,6 +1968,7 @@ config MFD_ROHM_BD957XMUF
 	depends on I2C=y
 	depends on OF
 	select REGMAP_I2C
+	select REGMAP_IRQ
 	select MFD_CORE
 	help
 	  Select this option to get support for the ROHM BD9576MUF and
-- 
2.35.1



