Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063469;
	b=o2MLSA3jpnJgabsXXmsr/6AxwaI46xBqkDzeJmPHqhxonYu5gw47tVboiRypgz+KqyLq
	 lHuDKNS7cOBUTzqGH3Cg8L6Xiup5WHYNg5Ulo+tL3hN355KJkua7Z6a+PZw2oxK8kKdOt
	 t3jhsYICcS5yu1ARWh8pVEfMbHy+1wvSs1tOvTrb1XYN1WUKHnV/5QLZOi2GznRlYC990
	 pMqcn8QHs+fKzQQHNmpKP3vWc4kEY7FZP+CtUh6TkQY6KOeNIwKFTvQ6zPLkaY6Kgxaog
	 zTn+nIK9w1tOb8xgD18z36TwsYt6DRyIRMw/eYXTPkM1Rnf5XuH07N9GXyYdy2h/uYg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063469;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=M3Www+6OIhvRGxPe0Ug+bMfbW0LAqawwiA4IRXdXsUA=;
	b=SaFFfi8SEg6CaNbhPEE6Lve5iXgPpS7AqGlB23qNOrre+EICaG5D/RC7X+XTg9gw5roM
	 u6KnBdU5fBMrlTdK7B04CA6MRNuTlJhzcPFpg30l/AFi7W7QVh4WhS+ci7yWYI5LQ5tzp
	 ssupHMWvD1AhcAWPQt56oF3m9+ipEUn6zjYBJHp2KYudAEb/k7io7eExED9acBDuSjA0H
	 KTOMCsTV015OM/hXvozKJkNiNWFuQx5+9034+SYEMUgkn3TwlehGwf+paVf3tbS0zHeMD
	 bRthF3dZgURUmk56aa4xtLbVw4K4gmmRy8Pm7tnTNWAYOHLgXNGDeO9e2OEzZds1+UA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X9ZaapIi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEC04606D821;
	Sat,  7 Nov 2026 14:57:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X9ZaapIi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E71F1F008A2;
	Sat,  7 Nov 2026 14:57:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063468;
	bh=M3Www+6OIhvRGxPe0Ug+bMfbW0LAqawwiA4IRXdXsUA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X9ZaapIi4PjA8e3QKbriehYuvXBzfOoK1w9gnGBgt2X7NOP3krCFjY3OTuJWcdImx
	 c7ti05q/9/KibXQ7kyQQM0gkRg7ZoU5PVvQGHUgaOU+YS/UitbOO5KicBxiZL95n3+
	 HFCwUaH0r0XbPIscYx84G6FGOesTKvEUYHBS/Dyk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Douglas <me@timdoug.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 622/869] power: supply: generic-adc-battery: fix status with no supplier
Date: Sat,  7 Nov 2026 08:55:04 -0500
Message-ID: <20261107134914.109234090@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tim Douglas <me@timdoug.com>

[ Upstream commit 8ae5a3f40045ff486826ed6b6a83e39a0f380073 ]

power_supply_am_i_supplied() returns -ENODEV when no registered power
supply supplies the battery. generic-adc-battery's gab_work() tests this
return value as a boolean, so -ENODEV takes the supplied branch and
reports CHARGING, or NOT_CHARGING if the charge-finished GPIO is asserted,
instead of DISCHARGING.

This was noticed while bringing up an out-of-tree Linux port to the
WikiReader: the driver reported CHARGING on a device powered by two AAA
batteries with no charging hardware.

Only a positive return value indicates an online supplier, so treat zero
and negative returns as discharging.

Fixes: 46cecd130d55 ("power: supply: Fix power_supply_am_i_supplied to return -ENODEV when apropriate")
Cc: stable@vger.kernel.org
Signed-off-by: Tim Douglas <me@timdoug.com>
Link: https://patch.msgid.link/20261013022153.6707-1-me@timdoug.com
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/generic-adc-battery.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/power/supply/generic-adc-battery.c b/drivers/power/supply/generic-adc-battery.c
index c69c9b9fa0eba..df5f91bc1d0f6 100644
--- a/drivers/power/supply/generic-adc-battery.c
+++ b/drivers/power/supply/generic-adc-battery.c
@@ -135,7 +135,7 @@ static void gab_work(struct work_struct *work)
 	adc_bat = container_of(delayed_work, struct gab, bat_work);
 	status = adc_bat->status;
 
-	if (!power_supply_am_i_supplied(adc_bat->psy))
+	if (power_supply_am_i_supplied(adc_bat->psy) <= 0)
 		adc_bat->status =  POWER_SUPPLY_STATUS_DISCHARGING;
 	else if (gab_charge_finished(adc_bat))
 		adc_bat->status = POWER_SUPPLY_STATUS_NOT_CHARGING;
-- 
2.53.0



