Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 633C67604F;
	Mon, 15 Apr 2024 14:24:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191076; cv=none; b=bk16NjG/+cSLeLd1EEPC9Kn/QQuYEpEQ0bV+jSIqRo/8LGUjcgIhd7ha0XHbi6wLdPKO3yOxvimeOga4m5U2/AZAaBAi2vj6MhgzTx2gtWZlEA9SyCvGurQe9MeS3nPPfL54jslflreGx1dGq/D8SqgEjWArc9f1Fr/pEprsJqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191076; c=relaxed/simple;
	bh=kydZ8jr/vxpMm1A0dB/qoMUCzXsvCLuAz3D6DLi6HOc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gFl4/VBLCxoKGUWe9i7tEjF3AYFZooSiQZNLq6I1ou/WvLvu0f6UuybwdCpEjY2MOxutTjmzOgQyAbXN0k3txtBVS0E7DhLm4cC+SYdtZ+nkrxwhc/gQYHf2nzDBfJmtBlT+VN1hPZD78ARxeInNZoMajzJv0BzO4bamWAi/i4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WHyNL1e1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WHyNL1e1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF535C113CC;
	Mon, 15 Apr 2024 14:24:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191076;
	bh=kydZ8jr/vxpMm1A0dB/qoMUCzXsvCLuAz3D6DLi6HOc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WHyNL1e1HfGHlVfH8Oe03wjBrGVofNyLTUak7QU8SEMIjsj4Y8l1xx53UhVd1/g+j
	 b2H4l1bM5VaZdFpr01R4kBOntdrQLv6jRpZAKdIDimt0CSeGjmT8YcEOnRa04k0rto
	 LCQVKKElcmD+44quSV6VOiwG4S4oEhprZVG7E7FY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaro Koskinen <aaro.koskinen@iki.fi>,
	Linus Walleij <linus.walleij@linaro.org>,
	Tony Lindgren <tony@atomide.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 025/172] ARM: OMAP2+: fix USB regression on Nokia N8x0
Date: Mon, 15 Apr 2024 16:18:44 +0200
Message-ID: <20240415142001.114858526@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141959.976094777@linuxfoundation.org>
References: <20240415141959.976094777@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
index c933a91751e4f..ff2a4a4d82204 100644
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



