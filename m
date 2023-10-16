Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AD671A585
	for <patches@lists.linux.dev>; Mon, 16 Oct 2023 08:59:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0q+TLek3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C381C433C7;
	Mon, 16 Oct 2023 08:59:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1697446778;
	bh=3kKt03rbLuEZRlvvLfdqeJoSA9R3ua4gQm+AOaPgMOQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0q+TLek36kfA2AupJoD1gsImIu7jpfEq/szJwVyGddJ0dwWWCihF72HxDDX/QkmYJ
	 VRPCKzpNl8ocvEZkVDqU5iYvJI/QSbrsTmbDxxdxCFMMYj8GuyczIkbDRJsKoeIS3S
	 CUsBQtJS+PLzskOYCZL9UWuPP6qFXrQ4bKa/Yr/Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	John Watts <contact@jookia.org>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 044/131] can: sun4i_can: Only show Kconfig if ARCH_SUNXI is set
Date: Mon, 16 Oct 2023 10:40:27 +0200
Message-ID: <20231016084001.167746381@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231016084000.050926073@linuxfoundation.org>
References: <20231016084000.050926073@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Watts <contact@jookia.org>

[ Upstream commit 1f223208ebdef84f21c15e9958c005a93c871aa2 ]

When adding the RISCV option I didn't gate it behind ARCH_SUNXI.
As a result this option shows up with Allwinner support isn't enabled.
Fix that by requiring ARCH_SUNXI to be set if RISCV is set.

Fixes: 8abb95250ae6 ("can: sun4i_can: Add support for the Allwinner D1")
Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Closes: https://lore.kernel.org/linux-sunxi/CAMuHMdV2m54UAH0X2dG7stEg=grFihrdsz4+o7=_DpBMhjTbkw@mail.gmail.com/
Signed-off-by: John Watts <contact@jookia.org>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/all/20230905231342.2042759-2-contact@jookia.org
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/can/Kconfig b/drivers/net/can/Kconfig
index 8236aabebb394..e45b95a13157b 100644
--- a/drivers/net/can/Kconfig
+++ b/drivers/net/can/Kconfig
@@ -174,7 +174,7 @@ config CAN_SLCAN
 
 config CAN_SUN4I
 	tristate "Allwinner A10 CAN controller"
-	depends on MACH_SUN4I || MACH_SUN7I || RISCV || COMPILE_TEST
+	depends on MACH_SUN4I || MACH_SUN7I || (RISCV && ARCH_SUNXI) || COMPILE_TEST
 	help
 	  Say Y here if you want to use CAN controller found on Allwinner
 	  A10/A20/D1 SoCs.
-- 
2.40.1



