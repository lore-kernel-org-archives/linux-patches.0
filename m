Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D832848D
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:26:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0F89C433EF;
	Fri, 10 Mar 2023 14:26:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678458391;
	bh=FnEjlfM+HJPaL9Ti65gx3wHrSUMMCljaV2xMvVKQTEM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vNxzMb5Axz47mZhSCEW/sfQeC4tbT2oTHomipWZOBqPY4pr2ZI6/nTEmDnChXbUaL
	 kxBIcjJ+sWHTOayU3RIsjUEuVjqjCAJO+XaBHKihUwQthf3ZX27UG/Jhplaq73YDGu
	 pWDyFu+5ym+CQIwWXW6a3iW7euOZ+wvk50noSfh8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hulk Robot <hulkci@huawei.com>,
	Yang Yingliang <yangyingliang@huawei.com>,
	Tony Lindgren <tony@atomide.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 011/357] ARM: OMAP1: call platform_device_put() in error case in omap1_dm_timer_init()
Date: Fri, 10 Mar 2023 14:35:00 +0100
Message-Id: <20230310133734.482340885@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133733.973883071@linuxfoundation.org>
References: <20230310133733.973883071@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 0414a100d6ab32721efa70ab55524540fdfe0ede ]

If platform_device_add() is not called or failed, it should call
platform_device_put() in error case.

Fixes: 97933d6ced60 ("ARM: OMAP1: dmtimer: conversion to platform devices")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Message-Id: <20220701094602.2365099-1-yangyingliang@huawei.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-omap1/timer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-omap1/timer.c b/arch/arm/mach-omap1/timer.c
index 4447210c9b0d8..291bc376d30e8 100644
--- a/arch/arm/mach-omap1/timer.c
+++ b/arch/arm/mach-omap1/timer.c
@@ -165,7 +165,7 @@ static int __init omap1_dm_timer_init(void)
 	kfree(pdata);
 
 err_free_pdev:
-	platform_device_unregister(pdev);
+	platform_device_put(pdev);
 
 	return ret;
 }
-- 
2.39.2



