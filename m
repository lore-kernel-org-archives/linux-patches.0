Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E791DBA45
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:00:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59D93C433EF;
	Tue,  7 Mar 2023 18:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678212023;
	bh=2ffYa7ngcYvWXBLSNtP0ED0LaLQDrXtCWsa1G8c8Izc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gdP1WTodyvYC/WnQfwUOKeK5MmKE3cg4Mb1Zri4WeXiPNxqfWjXS8+U2a/XfQvu4W
	 /kNko3TNivjTcZo7U8XNK+A5XnPBX6dat4s/iY8hzh1dNBhn22qrfPsrJ22PzD4bmu
	 KjYNY4AhXH3u3W/Bx+w31DOWwwlDCIvjLJmLhLuo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hulk Robot <hulkci@huawei.com>,
	Yang Yingliang <yangyingliang@huawei.com>,
	Tony Lindgren <tony@atomide.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 045/885] ARM: OMAP1: call platform_device_put() in error case in omap1_dm_timer_init()
Date: Tue,  7 Mar 2023 17:49:39 +0100
Message-Id: <20230307170003.644353740@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
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
index f5cd4bbf7566d..81a912c1145a9 100644
--- a/arch/arm/mach-omap1/timer.c
+++ b/arch/arm/mach-omap1/timer.c
@@ -158,7 +158,7 @@ static int __init omap1_dm_timer_init(void)
 	kfree(pdata);
 
 err_free_pdev:
-	platform_device_unregister(pdev);
+	platform_device_put(pdev);
 
 	return ret;
 }
-- 
2.39.2



