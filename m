Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591550;
	b=AK5A1PXPU4+mNXyfOj2ZP3Vdwg+8pxCxqFdqCOz2MM8QvEB5nsqZVUnWxeSDmUAJX9D/
	 QmkM9KiEbGIKuigEmIz7BIUpj1Z6iqBECfDbI1WmOGDDu+ysPxbl/MhF4KrlhEXTer0P+
	 F7ySBgpVgxulAfyGcEXhHwj5FVGPzgQ5DA7rBlbdnu83O2pdZutxICG5vZBeFTLqFZaGl
	 HQI9ekDDELfrIlEcuHHFbLrfkbLiEi+2NlMzvqtlxsc+gfRSEPqzD5Japx1b0btZVUAHG
	 pBp5CuOnNPOH/svNXiQZx/fD+UZrhJt1064Kpk4A7K/3BLNobZTUSHbgF9eZzBEPRIA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591550;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NmlKdKhabARo28oUtu+CZ3Y4FhgTFcopvWV4gd8iobk=;
	b=yl4KOn7dZW5uxVpLIogvGRSfULBXJg30vBTzdoCjyuhDw7k4h33MD0fLGqJGrrOppNti
	 hh+WmyaVSK1+1LYsqPYjp5PDjO2Sr7Vp/dHu0GYH6n/DJaCGxARP0Q3Koq6cH/PewyabL
	 iL4Q7Y4MOSAOBAFHtAHoHx3XvhOBSlltNn3tTAxt034WFfDuGkwVliGebTBpfZg5zxMw3
	 AtncFAzg/6EB98MkwRYZy+AMFGeiu2Eqs9Frzy88UlL8+lrDlhziCcfMTCBcLG80e4URo
	 PIyCr1OKWgSb3eCX1VfjJfZRGPzIlUEZ8A2gJ2LzsPELockIj+e/eeHMIwkkMIPWQ9A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pF5BdP2Z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9386A606D4BF;
	Fri, 13 Nov 2026 17:39:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pF5BdP2Z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FF5E1F000C9;
	Fri, 13 Nov 2026 17:39:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591550;
	bh=NmlKdKhabARo28oUtu+CZ3Y4FhgTFcopvWV4gd8iobk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pF5BdP2ZqArAF+tz6LdE0U5lPgd8a2YBObvGef0gvaxSR8Pj8inZmyEh32j5aIvl9
	 WUlWTPE/YfYG9ZCYua8KmA6r15Jk2qPHMVapmkkFO/UZUVQq+Ddivj5397g9BhoJwC
	 H3G7Qoj8uRzXilQYH7pX4kiLWhJJqeHRVZ6NUDAk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Song Li <songl@zju.edu.cn>,
	Fan Wu <fanwu01@zju.edu.cn>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 601/670] power: supply: bq27xxx: Ensure poll work is cancelled on remove
Date: Fri, 13 Nov 2026 10:52:45 -0500
Message-ID: <20261113153832.193986116@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fan Wu <fanwu01@zju.edu.cn>

[ Upstream commit db560f4b1c5253853f978385db066220e0c218dc ]

The di->work poll work is queued from the poll callback itself and from
bq27xxx_external_power_changed(). The cancel_delayed_work_sync() in
bq27xxx_battery_teardown() runs while the power_supply is still
registered, so external_power_changed() can re-arm the work after the
cancel, and it runs after the driver data has been freed.

Register a devm_delayed_work_autocancel() before
devm_power_supply_register(), so on unwind the power_supply is
unregistered first, after which no new external_power_changed()
callback can be dispatched, and the poll work is cancelled only then.
Drop the now-redundant cancel from bq27xxx_battery_teardown().

This issue was found by an in-house static analysis tool.

Fixes: 740b755a3b34 ("bq27x00: Poll battery state")
Cc: stable@vger.kernel.org
Assisted-by: Codex:gpt-5.6
Co-developed-by: Song Li <songl@zju.edu.cn>
Signed-off-by: Song Li <songl@zju.edu.cn>
Signed-off-by: Fan Wu <fanwu01@zju.edu.cn>
Link: https://patch.msgid.link/20260903081312.225535-1-fanwu01@zju.edu.cn
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/bq27xxx_battery.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/power/supply/bq27xxx_battery.c b/drivers/power/supply/bq27xxx_battery.c
index b0dec20fb37e8..59d9e2d99c3f3 100644
--- a/drivers/power/supply/bq27xxx_battery.c
+++ b/drivers/power/supply/bq27xxx_battery.c
@@ -43,6 +43,7 @@
  */
 
 #include <linux/device.h>
+#include <linux/devm-helpers.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
 #include <linux/param.h>
@@ -2160,7 +2161,6 @@ int bq27xxx_battery_setup(struct bq27xxx_device_info *di)
 	};
 	int ret;
 
-	INIT_DELAYED_WORK(&di->work, bq27xxx_battery_poll);
 	ret = devm_mutex_init(di->dev, &di->lock);
 	if (ret)
 		return ret;
@@ -2181,6 +2181,12 @@ int bq27xxx_battery_setup(struct bq27xxx_device_info *di)
 	psy_desc->get_property = bq27xxx_battery_get_property;
 	psy_desc->external_power_changed = bq27xxx_external_power_changed;
 
+	/* Cancel the poll work after the power_supply is unregistered. */
+	ret = devm_delayed_work_autocancel(di->dev, &di->work,
+					   bq27xxx_battery_poll);
+	if (ret)
+		return ret;
+
 	di->bat = devm_power_supply_register(di->dev, psy_desc, &psy_cfg);
 	if (IS_ERR(di->bat))
 		return dev_err_probe(di->dev, PTR_ERR(di->bat),
@@ -2207,8 +2213,6 @@ void bq27xxx_battery_teardown(struct bq27xxx_device_info *di)
 	mutex_lock(&di->lock);
 	di->removed = true;
 	mutex_unlock(&di->lock);
-
-	cancel_delayed_work_sync(&di->work);
 }
 EXPORT_SYMBOL_GPL(bq27xxx_battery_teardown);
 
-- 
2.53.0



