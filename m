Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1881299A9E;
	Mon, 13 Oct 2025 15:37:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369821; cv=none; b=iAHIKSGkcA6fI53zz3t1lP8C75iOv33XTPq2RZphPXv8vxduLZcBXtxfv4wc+kWnAH5qLkYbllKOdoR7QjBSdGmgGpNYXDrgi5cGViRQIAWIHlhM+1AxQ7T0nGyqUBv6BZWwFw1LNZQfwZ4AbmHDvBUfXFZDWMV43FIVv1920NA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369821; c=relaxed/simple;
	bh=0QZ9e5AMM5XApRmISd1RLCJLfr2LTyQ4He8C+C9EqD8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=d5z8kULNbEQzc3vZFlVJNGjQa7xn4iXdQRwE4n+FiUuyl5RlvPJg/Xy0W0euKYvck/DrEk5g/aEGFT649C5KqiCKmVpo+MoeBG1569QmRAi4wX++FwKVqOePbWpg/9bTTryF/uCOqXNTiUuyCrnuXS7/1qEYw7wZPznV96e8zAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ypj3YKUS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ypj3YKUS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DE60C4CEE7;
	Mon, 13 Oct 2025 15:37:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369821;
	bh=0QZ9e5AMM5XApRmISd1RLCJLfr2LTyQ4He8C+C9EqD8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ypj3YKUSmRTgb0V0rmrWzoWwK64sGC7mmg+f8ddqucGWfrqGEev5pjCW4gmMu69Kl
	 DPqZEbRNTOtNATb4CQBsM4GBRz5bqNzEVOw3LukdNC4sYhJYNY0qUlYh+ak4gGaIZh
	 x6qBkA31KhNLDM5LQI1JG8wXpD/yKzUKaKN3JdQ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Petar=20Kuli=C4=87?= <cooleech@gmail.com>,
	Diogo Ivo <diogo.ivo@siemens.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Wim Van Sebroeck <wim@linux-watchdog.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 348/563] watchdog: intel_oc_wdt: Do not try to write into const memory
Date: Mon, 13 Oct 2025 16:43:29 +0200
Message-ID: <20251013144423.876787352@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit bdbb4a2d2aeae3d115bbdc402adac72aec071492 ]

The code tries to update the intel_oc_wdt_info data structure if the
watchdog is locked. That data structure is marked as const and can not
be written into. Copy it into struct intel_oc_wdt and modify it there
to fix the problem.

Reported-by: Petar Kulić <cooleech@gmail.com>
Cc: Diogo Ivo <diogo.ivo@siemens.com>
Fixes: 535d1784d8a9 ("watchdog: Add driver for Intel OC WDT")
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Reviewed-by: Diogo Ivo <diogo.ivo@siemens.com>
Tested-by: Diogo Ivo <diogo.ivo@siemens.com>
Link: https://lore.kernel.org/linux-watchdog/20250818031838.3359-1-diogo.ivo@tecnico.ulisboa.pt/T/#t
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/intel_oc_wdt.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/watchdog/intel_oc_wdt.c b/drivers/watchdog/intel_oc_wdt.c
index 7c0551106981b..a39892c10770e 100644
--- a/drivers/watchdog/intel_oc_wdt.c
+++ b/drivers/watchdog/intel_oc_wdt.c
@@ -41,6 +41,7 @@
 struct intel_oc_wdt {
 	struct watchdog_device wdd;
 	struct resource *ctrl_res;
+	struct watchdog_info info;
 	bool locked;
 };
 
@@ -115,7 +116,6 @@ static const struct watchdog_ops intel_oc_wdt_ops = {
 
 static int intel_oc_wdt_setup(struct intel_oc_wdt *oc_wdt)
 {
-	struct watchdog_info *info;
 	unsigned long val;
 
 	val = inl(INTEL_OC_WDT_CTRL_REG(oc_wdt));
@@ -134,7 +134,6 @@ static int intel_oc_wdt_setup(struct intel_oc_wdt *oc_wdt)
 		set_bit(WDOG_HW_RUNNING, &oc_wdt->wdd.status);
 
 		if (oc_wdt->locked) {
-			info = (struct watchdog_info *)&intel_oc_wdt_info;
 			/*
 			 * Set nowayout unconditionally as we cannot stop
 			 * the watchdog.
@@ -145,7 +144,7 @@ static int intel_oc_wdt_setup(struct intel_oc_wdt *oc_wdt)
 			 * and inform the core we can't change it.
 			 */
 			oc_wdt->wdd.timeout = (val & INTEL_OC_WDT_TOV) + 1;
-			info->options &= ~WDIOF_SETTIMEOUT;
+			oc_wdt->info.options &= ~WDIOF_SETTIMEOUT;
 
 			dev_info(oc_wdt->wdd.parent,
 				 "Register access locked, heartbeat fixed at: %u s\n",
@@ -193,7 +192,8 @@ static int intel_oc_wdt_probe(struct platform_device *pdev)
 	wdd->min_timeout = INTEL_OC_WDT_MIN_TOV;
 	wdd->max_timeout = INTEL_OC_WDT_MAX_TOV;
 	wdd->timeout = INTEL_OC_WDT_DEF_TOV;
-	wdd->info = &intel_oc_wdt_info;
+	oc_wdt->info = intel_oc_wdt_info;
+	wdd->info = &oc_wdt->info;
 	wdd->ops = &intel_oc_wdt_ops;
 	wdd->parent = dev;
 
-- 
2.51.0



