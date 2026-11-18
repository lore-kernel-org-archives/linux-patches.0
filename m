Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023946;
	b=MK36yYFG5EMo9+DUjWr4oXtRjjt5mh8+CoiGGdDmLn6hnjUYGhwfPDS5DMsRV9qHZO+G
	 9aCmkCugf50ZvbMQhE6stJABNlwC04HkwLppWKfpdDxvNBSWrbF/xKoVeHldEG8FWmZEW
	 B4U3QlqZYkBM7lNrMzNfYIZKSCXFmy4BBU/mvRxuGxbizQTVhFWx8N9dQLPBCX63CgIsa
	 ieVwpgOQTReDeNxwkC2tLq7utjqbQa2JrHM++ILQl+13ADXZBeCoMwt1NeOMF06oFVSyb
	 TjudF57OHC7CAvAZIIz3ctJj0Z+a7AnVdNLQbDMswhy18X94ymxXw8mN8fXcJbo32Cg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023946;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DdOFWU1x8LI20IHYm9M91mRWDCR5VkwZ5SemRExvdlM=;
	b=1m/3WC3eW3xM3GwnGLXljmbrbDeFHkL9IfDlMusNKAKgGhxnAzdsHu1/ydorEoJ/vDxq
	 ZGzf8So3K98MmjkCmIVW9LV4tNp8QgxUo8GVNJyA6PtRBSOYba2nXpKGxHRsgz2ZNHDKi
	 ZAWk4FChphL7prezf8YY5TkwrFiFp/W1oqUPxSzJq/bpPu1mDUC3ID0LGca03y4VVKcRV
	 zSCFcHssrfDT+HOMgmAzzfd3dH/ZPUW6jeeHh+lb3jiiZBWmkmSaRWx6C7CVlUs1D4G1n
	 6+gFDNgdsSMCOGY4QGlX6n9pVxsTzMDkiz0JdADh0gquYH7MmptfsZ19vs3QkGMMHoA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="mHHk/ktP";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95FF8606A320;
	Wed, 18 Nov 2026 17:45:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mHHk/ktP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7BFA1F000C4;
	Wed, 18 Nov 2026 17:45:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023946;
	bh=DdOFWU1x8LI20IHYm9M91mRWDCR5VkwZ5SemRExvdlM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mHHk/ktPt2VO4vRJ+dWxTMnjFmXKl/FkqdKyQqaCOBtPAWRwEFg2Y1LUDfsTlwj9m
	 5aMLt9/lXwFgoR2X1MZDoRwwCHe29D8FMg/nf0MfoYYcNZjQmLxcYLjnKKw4ecVclj
	 fo2f4hzmN+tr/gStzSCRuczNihXT2KLHTC0vYv/A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Gaylard <ag@ffroot.co.za>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0549/2151] pinctrl: fix PINCTRL_SPPCTL=m
Date: Wed, 18 Nov 2026 15:38:04 +0100
Message-ID: <20261118150141.965217487@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



