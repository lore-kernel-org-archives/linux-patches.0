Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FCCC4446F0;
	Thu, 30 Jul 2026 15:22:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424940; cv=none; b=MptADyYNX+w2DsvVxkrd/KzMCMpzeMKx/4DcLU2mV//6Ws8Hbp9bAhnxHlzzGUkP34YzbnsFgk/2bF9V9bAxlJRiCdANJdxyQgYqe/atkUk5WJA2j2O3u6k5CcA0U0kRaVq9CHuDkB1HK/aplY5C0pZB5lA1F8h5iU/doDqCuGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424940; c=relaxed/simple;
	bh=1cgq7HIPDWncOcb4Hy0rF9Zfo1aZ6CVA4OwXq85PK54=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RdH5/BmN6rmJ6TMk1z+zzL/kkZIjuFWhOHvSBhicheYkg8hfYV/t1ajczLgshz8CTGxnVR5hS/elUYH6FUXW85u+ZN7WpvStngBenyEH4xqc1FzQJF24/53yrL7qk43P8+95ppuXDqtyUF+N/Ow+4yHE0TUt3NFvo6/K/3cW+mA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T1hwksDP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T1hwksDP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF8331F00AC4;
	Thu, 30 Jul 2026 15:22:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424937;
	bh=YBBBfwNSd3kSyW0oW8jfrJ/hpMQRDrWOtuo3SO8h6dY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T1hwksDPny5uP4VjhydkfE2OI7Fz/3fNwTOPdy1qwZWkXJxYJ+4G94gvGWDLdzJbd
	 iB73QDaJjG8N6OJq4Z5q08q0ok0C32v6wByFH2ApeTUA6Nzm78IqOlS8Sa8wybatQY
	 ITFfDcALXQoit/gDFv2sTs+w4zFta0A2gcAYBceA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ethan Nelson-Moore <enelsonmoore@gmail.com>,
	Daniel Lezcano <daniel.lezcano@oss.qualcomm.com>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.18 569/675] watchdog: s32g_wdt: remove incorrect options in watchdog_info struct
Date: Thu, 30 Jul 2026 16:14:59 +0200
Message-ID: <20260730141457.226719227@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ethan Nelson-Moore <enelsonmoore@gmail.com>

commit 2b37415618bfc6a83d4aceb00fd8d6491096f2ed upstream.

The s32g_wdt driver uses two incorrect constants in the options field
of its watchdog_info struct. This bit mask should contain WDIOF_*
constants, but the driver uses two WDIOC_* ioctl constants (in addition
to correct WDIOF_* constants). This causes many incorrect bits to be
set in the bit mask. The functionality indicated by these ioctl
constants is supported by all drivers using the watchdog framework, so
this patch simply removes them.

Fixes: bd3f54ec559b ("watchdog: Add the Watchdog Timer for the NXP S32 platform")
Cc: stable@vger.kernel.org # 6.18+
Signed-off-by: Ethan Nelson-Moore <enelsonmoore@gmail.com>
Acked-by: Daniel Lezcano <daniel.lezcano@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260505024409.60301-1-enelsonmoore@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/watchdog/s32g_wdt.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/watchdog/s32g_wdt.c b/drivers/watchdog/s32g_wdt.c
index ad55063060af..6422a694fc65 100644
--- a/drivers/watchdog/s32g_wdt.c
+++ b/drivers/watchdog/s32g_wdt.c
@@ -56,8 +56,7 @@ MODULE_PARM_DESC(early_enable,
 
 static const struct watchdog_info s32g_wdt_info = {
 	.identity = "s32g watchdog",
-	.options = WDIOF_KEEPALIVEPING | WDIOF_SETTIMEOUT | WDIOF_MAGICCLOSE |
-	WDIOC_GETTIMEOUT | WDIOC_GETTIMELEFT,
+	.options = WDIOF_KEEPALIVEPING | WDIOF_SETTIMEOUT | WDIOF_MAGICCLOSE,
 };
 
 static struct s32g_wdt_device *wdd_to_s32g_wdt(struct watchdog_device *wdd)
-- 
2.55.0



