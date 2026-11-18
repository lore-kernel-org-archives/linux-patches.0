Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059872;
	b=0kbyYH3BuOn+Vds4odENuZUs5n/+y0ke2B55umcDPeahQ8OMd6MQlRC06sWk2LRZv0b+
	 +uuuawpDi2rWEVv99GXEQkEObua/NewkP1UBiNkIIeZbn64jgTlZvaq1VUsazAXWNniDk
	 tIz3w15xWWaA8c4hVWc1j1PQ/H6Y1A/RTSvfatf+20V3/T2dVK5JH2pj6gAibpJzj8Rd2
	 1POecOmcrzX2dDK0tVBjOzLrBU8TK6lan5MucGdkvAMQZI2OTH80pHl8jbRI3qq1HbM0z
	 cyiJdJNY6vy6kL4EQ68HzaiirzB1lhS38+Epx0Hwb2bZruBS4uZF8e7ROd1hBd5vMfA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059872;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=q8CtGozR6Whyxi/JBNkTWnbF5RqQ7SliGuk5Ri/3Z+A=;
	b=i/OD5L8imP26dJakBesGf1P5zTWA0k6qG39g/dTuvwjyLrPuI77ESTq1Ihv5AwfcPzAV
	 GxQLo+DnKdEDAJEHBG+CkPVC9hO0Nkkv5b+hzjcWmrajU+NI/Zwr/fUHL/4l+aSWXscMK
	 Nq7L9xEnbg49LwrKulcJfqM6vPMr9EeQozQmR4TrPwd/igWkj8LkTrf+Lb2m2jVrstDr8
	 P64UT9QSREHALsP2pSAXDNUfNyKMpRi3PdUywm6+FUMgqfXSGhKJhnthxj7nwooj7bP9Y
	 2ZPqeETZzyMb7fxNUgOBsBB7V4TnvEl/ZestaJvzxp14YFZXMMispk754paYrU1cwtQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=g1L83l6B;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1BAC606A326;
	Thu, 19 Nov 2026 03:44:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=g1L83l6B
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 241141F000C4;
	Thu, 19 Nov 2026 03:44:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059872;
	bh=q8CtGozR6Whyxi/JBNkTWnbF5RqQ7SliGuk5Ri/3Z+A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g1L83l6B9VsEZ5pgdqZwNzTfDQAtL0qJzPaTqQkRwtEWo3cu6nuW7FVgB3MlyNDQx
	 /g6W8ZsKnjGwg6jqbF0/DIjn7ppROryQYl7Ea3roJf4oUTdsY2H2pJ71BeIuH2Sq09
	 QF7bdjMwD4Cf8qAOcApR3iiZDkUv6vJCtzJlgeKA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Douglas <me@timdoug.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0997/1848] power: supply: generic-adc-battery: fix status with no supplier
Date: Wed, 18 Nov 2026 15:50:35 +0100
Message-ID: <20261118145958.573647443@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Adapted the direct supplier check to a > 0 comparison in the existing is_plugged assignment. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/generic-adc-battery.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/power/supply/generic-adc-battery.c b/drivers/power/supply/generic-adc-battery.c
index 09bb4ff291cb0..8bf37e06e3f62 100644
--- a/drivers/power/supply/generic-adc-battery.c
+++ b/drivers/power/supply/generic-adc-battery.c
@@ -212,7 +212,7 @@ static void gab_work(struct work_struct *work)
 	adc_bat = container_of(delayed_work, struct gab, bat_work);
 	status = adc_bat->status;
 
-	is_plugged = power_supply_am_i_supplied(adc_bat->psy);
+	is_plugged = power_supply_am_i_supplied(adc_bat->psy) > 0;
 	adc_bat->cable_plugged = is_plugged;
 
 	if (!is_plugged)
-- 
2.53.0



