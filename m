Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FF144A3F
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 19:40:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E1B7C433C8;
	Sun, 17 Sep 2023 19:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694979612;
	bh=23EOOYz7xIrjWi0AlS3Y4pc9MbdPAd7VSVfQWxczvYw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PXsiwrWTn5apKfZoMyDdPePKcIHAvPSHvxyxF9D9hFczPJddFjtSiSo42+M6j3D24
	 7BmZKRx1UCBRHfOj8Fa6h5IHLliW+E6QVaZx8xbINqwK6Z/knyzz50XgiRE9US2/JP
	 oXzNmuPPRJlR24z9LdPX/IH2D+Iplq7IfMVTDXm4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raag Jadav <raag.jadav@intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Wim Van Sebroeck <wim@linux-watchdog.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 339/406] watchdog: intel-mid_wdt: add MODULE_ALIAS() to allow auto-load
Date: Sun, 17 Sep 2023 21:13:13 +0200
Message-ID: <20230917191110.233970413@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191101.035638219@linuxfoundation.org>
References: <20230917191101.035638219@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Raag Jadav <raag.jadav@intel.com>

[ Upstream commit cf38e7691c85f1b09973b22a0b89bf1e1228d2f9 ]

When built with CONFIG_INTEL_MID_WATCHDOG=m, currently the driver
needs to be loaded manually, for the lack of module alias.
This causes unintended resets in cases where watchdog timer is
set-up by bootloader and the driver is not explicitly loaded.
Add MODULE_ALIAS() to load the driver automatically at boot and
avoid this issue.

Fixes: 87a1ef8058d9 ("watchdog: add Intel MID watchdog driver support")
Signed-off-by: Raag Jadav <raag.jadav@intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/20230811120220.31578-1-raag.jadav@intel.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/intel-mid_wdt.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/watchdog/intel-mid_wdt.c b/drivers/watchdog/intel-mid_wdt.c
index 9b2173f765c8c..fb7fae750181b 100644
--- a/drivers/watchdog/intel-mid_wdt.c
+++ b/drivers/watchdog/intel-mid_wdt.c
@@ -203,3 +203,4 @@ module_platform_driver(mid_wdt_driver);
 MODULE_AUTHOR("David Cohen <david.a.cohen@linux.intel.com>");
 MODULE_DESCRIPTION("Watchdog Driver for Intel MID platform");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:intel_mid_wdt");
-- 
2.40.1



