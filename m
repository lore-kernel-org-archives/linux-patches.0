Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B85DF74E37;
	Mon, 15 Apr 2024 14:33:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191586; cv=none; b=B1v6lCMXaYuAsVoLpYNXQ5X2aYgoHFMYHbWQimw3SZlIv/2e3//+TaAuIlWSFh7DJDqtjaG7aGTq6XHgAhuGUEx1Mikxe+Zq8rn1eJUJ6GpLByiURHgzQTctl/7n0iGg2XD6W9kb3xHe+gyUPH45C9QUtw7q+GxnYzjoyPxMcdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191586; c=relaxed/simple;
	bh=7a+a/hJf3p1qi3r4rJiBnoTlfbvjZnpFrQdMA20pf/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XImkgg1XSGnHcOKQo1v8Ionxk5GbxK+hFlfxZfrytPEegzyVTnrUc0HKCmSa8BVr8I7OpiPGja8TdNs3PeFIh+VDtV2DYbI6FTh6bnyfTGB/yS3N9sbCENUuS2uJReVUsKL0uO1JKIO9cPghAUVLRqVpWWNF6GV52vS2LrUARzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QDGlZzJn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QDGlZzJn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C815C113CC;
	Mon, 15 Apr 2024 14:33:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191586;
	bh=7a+a/hJf3p1qi3r4rJiBnoTlfbvjZnpFrQdMA20pf/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QDGlZzJnimB/KWQ7IQ22Pouq7QkP6DuaSErR3H7Q2ylcH87wEI/5myXRcRSrF5WML
	 V1EJMqw+4TXRF3DaUhDrVoTVPLTQjy2Ye9qy6lji8XmreBKKzQTcEYyIBAxI3D18ro
	 rCjQwNOpgpKiKVVMFlZEpfBVbD923JQz2i+j9sks=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaro Koskinen <aaro.koskinen@iki.fi>,
	Linus Walleij <linus.walleij@linaro.org>,
	Tony Lindgren <tony@atomide.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 020/122] ARM: OMAP2+: fix USB regression on Nokia N8x0
Date: Mon, 15 Apr 2024 16:19:45 +0200
Message-ID: <20240415141953.981124271@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141953.365222063@linuxfoundation.org>
References: <20240415141953.365222063@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aaro Koskinen <aaro.koskinen@iki.fi>

[ Upstream commit 4421405e3634a3189b541cf1e34598e44260720d ]

GPIO chip labels are wrong for OMAP2, so the USB does not work. Fix.

Fixes: 8e0285ab95a9 ("ARM/musb: omap2: Remove global GPIO numbers from TUSB6010")
Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Message-ID: <20240223181656.1099845-1-aaro.koskinen@iki.fi>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-omap2/board-n8x0.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/arm/mach-omap2/board-n8x0.c b/arch/arm/mach-omap2/board-n8x0.c
index c5b2e1e79698d..b45a3879eb344 100644
--- a/arch/arm/mach-omap2/board-n8x0.c
+++ b/arch/arm/mach-omap2/board-n8x0.c
@@ -79,10 +79,8 @@ static struct musb_hdrc_platform_data tusb_data = {
 static struct gpiod_lookup_table tusb_gpio_table = {
 	.dev_id = "musb-tusb",
 	.table = {
-		GPIO_LOOKUP("gpio-0-15", 0, "enable",
-			    GPIO_ACTIVE_HIGH),
-		GPIO_LOOKUP("gpio-48-63", 10, "int",
-			    GPIO_ACTIVE_HIGH),
+		GPIO_LOOKUP("gpio-0-31", 0, "enable", GPIO_ACTIVE_HIGH),
+		GPIO_LOOKUP("gpio-32-63", 26, "int", GPIO_ACTIVE_HIGH),
 		{ }
 	},
 };
-- 
2.43.0



