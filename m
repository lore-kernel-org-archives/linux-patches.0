Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6E988F74
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:06:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38C2FC433C7;
	Sun, 16 Jul 2023 20:06:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689537969;
	bh=z8kwRQZ7sdjt/ZWQbOtlmoM3zCtX0VgOEGU94+qZ6z0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=axytC+6ePpL0kHbK2Hnw/K4goHlnNNZrqB0qA8y2xiJXnou06mgstDAlLdAqNXMrH
	 /w8U8RCtYZjqqpKy0yK6mXT4H47vznrbmG/pM5osLsqJw4YfgsKe8bOwzreGQ1KrGq
	 cgLy1Mhec9g5BiHyli1ar4OS9xJCCUtCsyVki1eM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Janusz Krzysztofik <jmkrzyszt@gmail.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 286/800] ARM: omap1: Drop header on AMS Delta
Date: Sun, 16 Jul 2023 21:42:19 +0200
Message-ID: <20230716194955.730230551@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
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
index 9108c871d129a..ac47ab9fe0964 100644
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



