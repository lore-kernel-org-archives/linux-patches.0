Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47BEC6FCC
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 19:53:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59741C433C7;
	Sun, 17 Sep 2023 19:53:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694980384;
	bh=8dcxKrxmmbiPZX6GyIouZLs3qeGhYNu0Dw5B0hQX2B4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lUNU7XbjGYe6mh/8LHwoNP0WXlQ1sRQCj1wuTSio2fi+dh8srtaP2G0wrUfc3VeNN
	 XdhBbAAGqNn/oQZmccNoupC73U7t8pHsl7jwzpz7QHkkPp2f5OGkQ0em6xMS1XZ9FF
	 vGtvDqh0AP+NAlnwp8ViVg6Zajy0tGLcxzLP/I7c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florent CARLI <fcarli@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Wim Van Sebroeck <wim@linux-watchdog.org>,
	Yoann Congal <yoann.congal@smile.fr>
Subject: [PATCH 6.5 177/285] watchdog: advantech_ec_wdt: fix Kconfig dependencies
Date: Sun, 17 Sep 2023 21:12:57 +0200
Message-ID: <20230917191057.754704578@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191051.639202302@linuxfoundation.org>
References: <20230917191051.639202302@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florent CARLI <fcarli@gmail.com>

commit 6eb28a38f6478a650c7e76b2d6910669615d8a62 upstream.

This driver uses the WATCHDOG_CORE framework and ISA_BUS_API.
This commit has these dependencies correctly selected.

Signed-off-by: Florent CARLI <fcarli@gmail.com>
Co-authored-by: Yoann Congal <yoann.congal@smile.fr>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/20230721081347.52069-1-fcarli@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Cc: Yoann Congal <yoann.congal@smile.fr>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/watchdog/Kconfig |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -1075,6 +1075,8 @@ config ADVANTECH_WDT
 config ADVANTECH_EC_WDT
 	tristate "Advantech Embedded Controller Watchdog Timer"
 	depends on X86
+	select ISA_BUS_API
+	select WATCHDOG_CORE
 	help
 		This driver supports Advantech products with ITE based Embedded Controller.
 		It does not support Advantech products with other ECs or without EC.


