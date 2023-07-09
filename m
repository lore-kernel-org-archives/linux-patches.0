Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0AF2522E
	for <patches@lists.linux.dev>; Sun,  9 Jul 2023 11:27:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53CCEC433C8;
	Sun,  9 Jul 2023 11:27:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1688902069;
	bh=j39QYzgOA1f/CsMaT9Gj0xPRV3dyg97ZRajnSOtPo4w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VkS6cY4aNgn3ei+NqG8Cx3Q4i4tkauOgFe3riDMh4looJk/dp6CYA8TFV9oqvyhDs
	 NJJ9rN0sm8/qqLTXaPdwTHroLZnT77oVuXrMpq4rYBRpW9Fm+MUBThAIOciZDcgsg0
	 htctIFuXkVy2r6gGBir9STUAdlf9pm10kd9/5Rxs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Janusz Krzysztofik <jmkrzyszt@gmail.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 216/431] ARM: omap1: Drop header on AMS Delta
Date: Sun,  9 Jul 2023 13:12:44 +0200
Message-ID: <20230709111456.226821979@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230709111451.101012554@linuxfoundation.org>
References: <20230709111451.101012554@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Linus Walleij <linus.walleij@linaro.org>

[ Upstream commit fa1ae0cd897b089b5cc05ab471518ad13db2d567 ]

The AMS Delta board uses GPIO descriptors exclusively and
does not have any dependencies on the legacy <linux/gpio.h>
header, so just drop it.

Acked-by: Janusz Krzysztofik <jmkrzyszt@gmail.com>
Fixes: 92bf78b33b0b ("gpio: omap: use dynamic allocation of base")
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-omap1/board-ams-delta.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm/mach-omap1/board-ams-delta.c b/arch/arm/mach-omap1/board-ams-delta.c
index 0f67ac4c6fd25..d9d2fef1b74a7 100644
--- a/arch/arm/mach-omap1/board-ams-delta.c
+++ b/arch/arm/mach-omap1/board-ams-delta.c
@@ -11,7 +11,6 @@
 #include <linux/gpio/driver.h>
 #include <linux/gpio/machine.h>
 #include <linux/gpio/consumer.h>
-#include <linux/gpio.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/input.h>
-- 
2.39.2



