Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE845200A6
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 18:57:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B07FC433C9;
	Fri, 21 Jul 2023 18:57:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689965861;
	bh=DKwoDzISkE9wh3vvu2XI482adqoYiLokyx+1GWjJ6Ik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lp6j7/WwGv4UnAljcseTnQB1wmoHKpnDzzd/cXRe5mrHw6AHR09F2OuHQcxCOUWR8
	 Uf4V3A0FRzhXk76vqeoa4bAhqf3iPCoVnTKxcOgIlCb03a6V09NrC94O+8l/4EzjFx
	 eRWTzDZisOwEVZR2CBHMEA8xBnVSPlWWaHOJw8Fg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaro Koskinen <aaro.koskinen@iki.fi>,
	Arnd Bergmann <arnd@arndb.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 141/532] ARM: omap2: fix missing tick_broadcast() prototype
Date: Fri, 21 Jul 2023 18:00:45 +0200
Message-ID: <20230721160622.102997178@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160614.695323302@linuxfoundation.org>
References: <20230721160614.695323302@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 861bc1d2886d47bd57a2cbf2cda87fdbe3eb9d08 ]

omap2 contains a hack to define tick_broadcast() on non-SMP
configurations in place of the normal SMP definition. This one
causes a warning because of a missing prototype:

arch/arm/mach-omap2/board-generic.c:44:6: error: no previous prototype for 'tick_broadcast'

Make sure to always include the header with the declaration.

Fixes: d86ad463d670 ("ARM: OMAP2+: Fix regression for using local timer on non-SMP SoCs")
Acked-by: Aaro Koskinen <aaro.koskinen@iki.fi>
Link: https://lore.kernel.org/r/20230516153109.514251-9-arnd@kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-omap2/board-generic.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/mach-omap2/board-generic.c b/arch/arm/mach-omap2/board-generic.c
index 1610c567a6a3a..10d2f078e4a8e 100644
--- a/arch/arm/mach-omap2/board-generic.c
+++ b/arch/arm/mach-omap2/board-generic.c
@@ -13,6 +13,7 @@
 #include <linux/of_platform.h>
 #include <linux/irqdomain.h>
 #include <linux/clocksource.h>
+#include <linux/clockchips.h>
 
 #include <asm/setup.h>
 #include <asm/mach/arch.h>
-- 
2.39.2



