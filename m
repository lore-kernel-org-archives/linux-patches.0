Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 547D48F5D
	for <patches@lists.linux.dev>; Thu, 31 Aug 2023 11:09:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C96A9C433C8;
	Thu, 31 Aug 2023 11:09:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693480195;
	bh=5TadUomiqk7fVpi2MJx42Ho6ckobVlotU+wrsWJtACw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XoDS4NvbMj23wWug5v/U+S9no2esS1boCjyQPkip6b2IvqOz77rNOEdGx/nNdYi//
	 h0bG6x7yQBTHofMHstBcsM9HIoDsFnRdofptJ0GYsRbTWZAKlEY1pR0LAmm1pVQAX8
	 HY/+VQgL2pIyr4MS8s93t5RXapm80h817m33KqG4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Alexander Sverdlin <alexander.sverdlin@gmail.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 2/2] Revert "ARM: ep93xx: fix missing-prototype warnings"
Date: Thu, 31 Aug 2023 13:09:43 +0200
Message-ID: <20230831110828.673811945@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230831110828.577111137@linuxfoundation.org>
References: <20230831110828.577111137@linuxfoundation.org>
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

4.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit 2e50d55578b05664b11538f0a280541c100caefe which is
commit 419013740ea1e4343d8ade535d999f59fa28e460 upstream.

It breaks the build, so should be reverted.

Reported-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/98dbc981-56fa-4919-afcc-fdf63e0a1c53@roeck-us.net
Cc: Alexander Sverdlin <alexander.sverdlin@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/mach-ep93xx/timer-ep93xx.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/arch/arm/mach-ep93xx/timer-ep93xx.c
+++ b/arch/arm/mach-ep93xx/timer-ep93xx.c
@@ -9,7 +9,6 @@
 #include <linux/io.h>
 #include <asm/mach/time.h>
 #include "soc.h"
-#include "platform.h"
 
 /*************************************************************************
  * Timer handling for EP93xx
@@ -61,7 +60,7 @@ static u64 notrace ep93xx_read_sched_clo
 	return ret;
 }
 
-static u64 ep93xx_clocksource_read(struct clocksource *c)
+u64 ep93xx_clocksource_read(struct clocksource *c)
 {
 	u64 ret;
 


