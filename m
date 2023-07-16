Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 051048F55
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:40:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D8A5C433C8;
	Sun, 16 Jul 2023 20:40:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689540000;
	bh=hEd9Dl1BnV2HT2houBCfENnqi5F1sjUS3TpawDAVmOw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=otLROKen8dbx/uXz5FMaunuRPbv5YBpFK5oX9JY6emxFVSHsXpVrDe0BFCzkWBeaJ
	 GPJ51hAfmEFWANzmYCXbyJnasQKXqmGO4XsH728Xataoor5PDVgFyvrJRB8atJ3QqY
	 Wv3zSPX2HjQT5uYUfR4SJmnQR96WRDCf9/JKuQz4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Sverdlin <alexander.sverdlin@gmail.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 208/591] ARM: ep93xx: fix missing-prototype warnings
Date: Sun, 16 Jul 2023 21:45:47 +0200
Message-ID: <20230716194929.254422123@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194923.861634455@linuxfoundation.org>
References: <20230716194923.861634455@linuxfoundation.org>
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

[ Upstream commit 419013740ea1e4343d8ade535d999f59fa28e460 ]

ep93xx_clocksource_read() is only called from the file it is declared in,
while ep93xx_timer_init() is declared in a header that is not included here.

arch/arm/mach-ep93xx/timer-ep93xx.c:120:13: error: no previous prototype for 'ep93xx_timer_init'
arch/arm/mach-ep93xx/timer-ep93xx.c:63:5: error: no previous prototype for 'ep93xx_clocksource_read'

Fixes: 000bc17817bf ("ARM: ep93xx: switch to GENERIC_CLOCKEVENTS")
Acked-by: Alexander Sverdlin <alexander.sverdlin@gmail.com>
Link: https://lore.kernel.org/r/20230516153109.514251-3-arnd@kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-ep93xx/timer-ep93xx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-ep93xx/timer-ep93xx.c b/arch/arm/mach-ep93xx/timer-ep93xx.c
index dd4b164d18317..a9efa7bc2fa12 100644
--- a/arch/arm/mach-ep93xx/timer-ep93xx.c
+++ b/arch/arm/mach-ep93xx/timer-ep93xx.c
@@ -9,6 +9,7 @@
 #include <linux/io.h>
 #include <asm/mach/time.h>
 #include "soc.h"
+#include "platform.h"
 
 /*************************************************************************
  * Timer handling for EP93xx
@@ -60,7 +61,7 @@ static u64 notrace ep93xx_read_sched_clock(void)
 	return ret;
 }
 
-u64 ep93xx_clocksource_read(struct clocksource *c)
+static u64 ep93xx_clocksource_read(struct clocksource *c)
 {
 	u64 ret;
 
-- 
2.39.2



