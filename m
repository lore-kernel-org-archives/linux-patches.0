Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 696326FA3
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 17:09:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E14EBC433EF;
	Mon, 16 Jan 2023 17:09:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673888977;
	bh=Ht7cdwsRPXgReCjo2UQWPUSgcd/eywq+EhO/wnh12+Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pLLKcyEJqorHaQVZX4WXIrzQ9uY3qS6gUtZlWqyuczV1FLiNQ9l9TvJ35TaeqAbu2
	 cpUllZKagMBA5AHqKHE1oWAfFdCjn+KS1USPrp6XpDAVgPFqxAKlQTOCTERRzSQ6ek
	 P+SDBtXUkTpNupRh933MCnSQv2o/NgsRHRTuJ5Gc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 181/338] fbdev: ssd1307fb: Drop optional dependency
Date: Mon, 16 Jan 2023 16:50:54 +0100
Message-Id: <20230116154828.808461122@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154820.689115727@linuxfoundation.org>
References: <20230116154820.689115727@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 025e3b507a3a8e1ee96a3112bb67495c77d6cdb6 ]

Only a single out of three devices need a PWM, so from driver it's
optional. Moreover it's a single driver in the entire kernel that
currently selects PWM. Unfortunately this selection is a root cause
of the circular dependencies when we want to enable optional PWM
for some other drivers that select GPIOLIB.

Fixes: a2ed00da5047 ("drivers/video: add support for the Solomon SSD1307 OLED Controller")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/video/fbdev/Kconfig b/drivers/video/fbdev/Kconfig
index d00588d9b025..a7e8db955ef6 100644
--- a/drivers/video/fbdev/Kconfig
+++ b/drivers/video/fbdev/Kconfig
@@ -2477,7 +2477,6 @@ config FB_SSD1307
 	select FB_SYS_COPYAREA
 	select FB_SYS_IMAGEBLIT
 	select FB_DEFERRED_IO
-	select PWM
 	select FB_BACKLIGHT
 	help
 	  This driver implements support for the Solomon SSD1307
-- 
2.35.1



