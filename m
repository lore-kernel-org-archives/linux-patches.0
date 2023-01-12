Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CA7079C9
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 14:19:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07747C433D2;
	Thu, 12 Jan 2023 14:19:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673533176;
	bh=fp+OnZwb3inWFOimz3us9jPCgWWbV34cMCe1NGGfSQE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p7XnuRAShQ/r331i8TvpKsRF5zzAqiAhzXAG3D4zg4sOh+x2C7tkSE0ZDDryvRJ6e
	 TEtY2SRUylIU8RMgQ5ZikM6V/gPU3dxO36WiFZOYaUBrE654AsCam1jyi51b3ZVUkN
	 T1soBXgAU1aCWsBj3W4gCxVIAbMzKzCzB27ppu/k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 394/783] fbdev: ssd1307fb: Drop optional dependency
Date: Thu, 12 Jan 2023 14:51:50 +0100
Message-Id: <20230112135542.578766645@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
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
index 4f02db65dede..3ac78db17e46 100644
--- a/drivers/video/fbdev/Kconfig
+++ b/drivers/video/fbdev/Kconfig
@@ -2216,7 +2216,6 @@ config FB_SSD1307
 	select FB_SYS_COPYAREA
 	select FB_SYS_IMAGEBLIT
 	select FB_DEFERRED_IO
-	select PWM
 	select FB_BACKLIGHT
 	help
 	  This driver implements support for the Solomon SSD1307
-- 
2.35.1



