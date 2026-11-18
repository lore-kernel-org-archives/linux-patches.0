Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043895;
	b=UFPMov8fpHA6QN7oqiLvGXFqcvwpZWfG8aQPOPbRIpbJRtFhIW+hrzrgad2IQ/xio+Rm
	 garfAZ9IMjkppvF3hV+txlSYILRWy+WaYsD1jFXhJul/pNUmiqQs26U1bKVSTr3i9y531
	 P4UDuuu+KYZqYjBrEX3Z7HiBESMIk1jOo3/vZp77vMJLBnYk1GX2wp10krb+UpP5c7pq3
	 Wm69rcdmb60J2th0bl8bEtBF2/H3vaBwWC8ZCOJJ4FgKroATdsYNQZOSsOit4Ypf0bjwF
	 C00JCfVb6fqzYH7/JYLwIJUpccng9KEW5pgNJ9TdvqzigRlLH6sCHh7LbWbZz2xNDHg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043895;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BmGL++dQUfm4jlNEsuus2iKDhmKEcko4WyUbrRioli0=;
	b=4YTgACzPY3UcmBo0DZfj7E4Tdu2TSNydHkTYJvGX8kN6xQYQcu18MtR83g49ukqsnRBN
	 nfEhA1HsaSjsAJ6VRSHxNAqaj0CEQgC42v75IYxx1UaujXytO1+gIBhx7Rv3uPJv3/yA2
	 PAGSDzoFVg9grB100MWiMv8spEqEAaHe2HziSNedxx1OrizVJ34G5iJo6Ds1Eq07cMD9P
	 SBJYDINl2QDg7CnM62dxRy5qYcCPkwnmoIpoZyr6URJAXlUHMZ/XDS9UkFiK/pP0AgHbQ
	 w96jrey8xL9VOspg9kUlKyEY0dofA92R4k83H9Rgq7MOoC90NoEaqZ4hwhV1tSA+IGA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pH3YDRix;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7D45606A31C;
	Wed, 18 Nov 2026 23:18:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pH3YDRix
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 147E71F000C4;
	Wed, 18 Nov 2026 23:18:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043895;
	bh=BmGL++dQUfm4jlNEsuus2iKDhmKEcko4WyUbrRioli0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pH3YDRixTPm7OzM3hOa3KuW0DvX9Lg5t8nhcDEWh2mKaKcLOrr6cCT07oPZD7EStx
	 M3wnKD2aNHyxwp+w0miX2WrqNf/hi3sh7IuW4lUiE14ByfmMycRgD9Sw20h5x5AC6a
	 Qt9IrIvyX5Oyqajh8LQmK/V3L+GNbtVUdgzR16t4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>,
	Loic Poulain <loic.poulain@oss.qualcomm.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0375/2857] i2c: qcom-cci: fix autosuspend cleanup
Date: Wed, 18 Nov 2026 15:23:29 +0100
Message-ID: <20261118150214.913878568@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guangshuo Li <lgs201920130244@gmail.com>

[ Upstream commit f98d4986482151a835b521a734722fe8dc5ca37d ]

cci_probe() calls pm_runtime_use_autosuspend(), but the remove path
does not call the matching pm_runtime_dont_use_autosuspend() before
disabling runtime PM.

If the autosuspend delay is set to a negative value while autosuspend
is enabled, the runtime PM core increments usage_count to prevent
runtime suspend. Without undoing the autosuspend setting during
teardown, this reference is not dropped and usage_count remains
unbalanced.

Use devm_pm_runtime_set_active_enabled() to manage the runtime PM
state. Its managed cleanup disables autosuspend and runtime PM and
restores the suspended state on probe failure and driver removal.
Remove the now redundant manual runtime PM cleanup.

This issue was found by manual code inspection.

Fixes: e517526195de ("i2c: Add Qualcomm CCI I2C driver")
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Cc: <stable@vger.kernel.org> # v5.8+
Reviewed-by: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
Reviewed-by: Loic Poulain <loic.poulain@oss.qualcomm.com>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://patch.msgid.link/20260812094425.3515179-1-lgs201920130244@gmail.com
[ sashal: Rewrote the error_i2c probe path to unwind adapters and disable the IRQ, calling cci_disable_clocks() only when CONFIG_PM is off, and adapted cci_remove() and probe labels to the older context. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-qcom-cci.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/i2c/busses/i2c-qcom-cci.c b/drivers/i2c/busses/i2c-qcom-cci.c
index f64622e725d5c..6c7e4eb95efcc 100644
--- a/drivers/i2c/busses/i2c-qcom-cci.c
+++ b/drivers/i2c/busses/i2c-qcom-cci.c
@@ -640,9 +640,11 @@ static int cci_probe(struct platform_device *pdev)
 		goto error;
 
 	pm_runtime_set_autosuspend_delay(dev, MSEC_PER_SEC);
+	ret = devm_pm_runtime_set_active_enabled(dev);
+	if (ret)
+		goto disable_clocks;
+
 	pm_runtime_use_autosuspend(dev);
-	pm_runtime_set_active(dev);
-	pm_runtime_enable(dev);
 
 	for (i = 0; i < cci->data->num_masters; i++) {
 		if (!cci->master[i].cci)
@@ -658,8 +660,6 @@ static int cci_probe(struct platform_device *pdev)
 	return 0;
 
 error_i2c:
-	pm_runtime_disable(dev);
-	pm_runtime_dont_use_autosuspend(dev);
 
 	for (--i ; i >= 0; i--) {
 		if (cci->master[i].cci) {
@@ -667,6 +667,13 @@ static int cci_probe(struct platform_device *pdev)
 			of_node_put(cci->master[i].adap.dev.of_node);
 		}
 	}
+
+	disable_irq(cci->irq);
+	if (!IS_ENABLED(CONFIG_PM))
+		cci_disable_clocks(cci);
+
+	return ret;
+
 error:
 	disable_irq(cci->irq);
 disable_clocks:
@@ -689,8 +696,6 @@ static int cci_remove(struct platform_device *pdev)
 	}
 
 	disable_irq(cci->irq);
-	pm_runtime_disable(&pdev->dev);
-	pm_runtime_set_suspended(&pdev->dev);
 
 	return 0;
 }
-- 
2.53.0



