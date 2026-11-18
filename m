Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020235;
	b=rm4AuxP/tnyhA7XeowZGJPx49hxSQUHhfBkFjk+qI1EvumxvbDsYWjUJb2TTvZV7a7O9
	 rFp2Zdqot5bMiCc593b6//DxP4DfdJ7IPas8yv7h+ERwcCyWThAvdfC6zWplb1bgKfr1v
	 r2ul1bllFy8WuTNMfeApd9hfpG3IliAhMEyn9tL8rIeG7noe7SjQ3txy272CI6LcZUIhU
	 ZFZi6XoLstsKkuAedDdCE71D18H+yy4yp2kgEYAq7s0H5LvlQEtw7OprOZN9rwNw8ND4l
	 mBTNLJSXnmw1D7IHU5CJBcANmghZooY+gKJzWONC7NeS6y6yk/sKRlthA3DDIWuYlfg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020235;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=iYSEBxl0Utvif2YQN41PEz0D8lGR081EDY4qydmOYas=;
	b=auUUCSzI9Kr7H2+GVBXTdX7uZbBwebKko3Ef21y8XX1G5y1CQBcE+/SX+5ntfbZXyF9n
	 W2uXlIjGSaN7GgPHa+CMUMrDABayfAizaJJAEdfVHoD2BQ77rK5TZnqWsNqwN+TAcVWWC
	 q+7sW95diukm1Zbbl9Pxu/G9ynEZL6dcvmxlmT8FkxZqpUGkLe4shR7ogAlA41JZFXqAW
	 00QmO9WAuq0J5PM507/hE0h8T8hw+Gq+95/8ynZFe7fr6he1XSQl4OdlVq8/O9RXa8viP
	 WHqU7w7jzR2l9g7Jjeyk66UgejWwRyJdBv6wM7T0281LLMBYFRVXDgDdFHRqROs+w9w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="VLU/G8vX";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3504606A31C;
	Wed, 18 Nov 2026 16:43:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VLU/G8vX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3279A1F000C4;
	Wed, 18 Nov 2026 16:43:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020235;
	bh=iYSEBxl0Utvif2YQN41PEz0D8lGR081EDY4qydmOYas=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VLU/G8vXTXVmmR76P08pYJj5CAr3ZmkJ+Z58e23knwH0fzJRcnU6QlaeL0PSsOqVC
	 vzdE6Wql0fkLcp4HioYyNSAWyusOZuOLsVkDAUYJ64OEJ14VCnP9p7rwPQCTl15EQ8
	 1Itoeqx2YyXmd9TW0VqrszwZo4n/aLmLOMlWzaHo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Shang En Sim <sim@shangen.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1837/2651] platform/x86: hp-wmi: Fix hwmon keep-alive teardown
Date: Wed, 18 Nov 2026 15:51:17 +0100
Message-ID: <20261118150353.233000340@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shang En Sim <sim@shangen.org>

[ Upstream commit 574245e62cb09e159b4c37e1a9091c100448b5c3 ]

hp_wmi_hwmon_init() initialises keep_alive_dwork with INIT_DELAYED_WORK()
and relies on hp_wmi_bios_remove() to cancel it. Nothing cancels the work
if probe fails after hp_wmi_hwmon_init() has run, so the devm-managed
priv can be freed while the work is still pending.

The ordering is also wrong on both ends. The work is initialised only
after the hwmon device is registered, so a sysfs write to pwm1_enable
can schedule an uninitialised work item. On removal, the work is
cancelled in .remove(), before devres unregisters the hwmon device, so a
sysfs write can requeue it after the cancel.

Use devm_delayed_work_autocancel() and set it up before registering the
hwmon device. devres then cancels the work on every teardown path, after
the hwmon sysfs interface has been removed and before priv and its mutex
are released. Drop the now-unneeded cancel in hp_wmi_bios_remove() and
the platform drvdata that was only used for it.

Fixes: c203c59fb5de ("platform/x86: hp-wmi: implement fan keep-alive")
Suggested-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Shang En Sim <sim@shangen.org>
Link: https://patch.msgid.link/20261001031012.48473-2-sim@shangen.org
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/hp/hp-wmi.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/platform/x86/hp/hp-wmi.c b/drivers/platform/x86/hp/hp-wmi.c
index 022100d9d5503..5582feea3c365 100644
--- a/drivers/platform/x86/hp/hp-wmi.c
+++ b/drivers/platform/x86/hp/hp-wmi.c
@@ -18,6 +18,7 @@
 #include <linux/bits.h>
 #include <linux/cleanup.h>
 #include <linux/compiler_attributes.h>
+#include <linux/devm-helpers.h>
 #include <linux/dmi.h>
 #include <linux/fixp-arith.h>
 #include <linux/hwmon.h>
@@ -2549,7 +2550,6 @@ static int __init hp_wmi_bios_setup(struct platform_device *device)
 static void __exit hp_wmi_bios_remove(struct platform_device *device)
 {
 	int i;
-	struct hp_wmi_hwmon_priv *priv;
 
 	for (i = 0; i < rfkill2_count; i++) {
 		rfkill_unregister(rfkill2[i].rfkill);
@@ -2568,10 +2568,6 @@ static void __exit hp_wmi_bios_remove(struct platform_device *device)
 		rfkill_unregister(wwan_rfkill);
 		rfkill_destroy(wwan_rfkill);
 	}
-
-	priv = platform_get_drvdata(device);
-	if (priv)
-		cancel_delayed_work_sync(&priv->keep_alive_dwork);
 }
 
 static int hp_wmi_resume_handler(struct device *device)
@@ -2919,6 +2915,17 @@ static int hp_wmi_hwmon_init(void)
 	ret = hp_wmi_setup_fan_settings(priv);
 	if (ret)
 		return ret;
+
+	/*
+	 * Set up the work before registering hwmon so that, on teardown,
+	 * it is cancelled only after the sysfs writers that schedule it
+	 * are gone.
+	 */
+	ret = devm_delayed_work_autocancel(dev, &priv->keep_alive_dwork,
+					   hp_wmi_hwmon_keep_alive_handler);
+	if (ret)
+		return ret;
+
 	hwmon = devm_hwmon_device_register_with_info(dev, "hp", priv,
 						     &chip_info, NULL);
 
@@ -2927,8 +2934,6 @@ static int hp_wmi_hwmon_init(void)
 		return PTR_ERR(hwmon);
 	}
 
-	INIT_DELAYED_WORK(&priv->keep_alive_dwork, hp_wmi_hwmon_keep_alive_handler);
-	platform_set_drvdata(hp_wmi_platform_dev, priv);
 	ret = hp_wmi_apply_fan_settings(priv);
 	if (ret)
 		dev_warn(dev, "Failed to apply initial fan settings: %d\n", ret);
-- 
2.53.0



