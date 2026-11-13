Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591111;
	b=rkGoeyghYaDo8YSQpBwkmYGQ+OWRhpwRL0Yup3+ewp3JY7J0cGUbDzlcin0Hd8YCNZok
	 PxPzxkr7udYhtA7ZJ1z6cfVXkFYMjR2w3tjXT56+qcrWQZzXIHMtUEcmo9eVUvq0J6kCu
	 WAYbX9UDpPcJ0MmSstkCzK5p4ZwX1tCbDYX6IsQfDS2dpS4mi/iUoysi/0iV0lozz5CbB
	 UZZ5GWUbYxqVnQTQPGxTnH3UUpiz0QbESm3PTpZM1x07Je6dV+Cjsnwi+V9WkVqgWa44G
	 bmVu50EKpA1T2OG2YLm/P6p9m+YSEAxsQRQMMMKbR1+YmbWKfZ+uAxOVTuCc11EgL2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591111;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CFHnIlVyQRtRZ0MXse3lH5cXQ7D41qkvP/TrWdR4bjA=;
	b=fkm1EhLO60celTG5IBOo37zGW5QUMDjoMIxhgCk7MrpHPjf5GO0sBbol2wWQAa6GMMWL
	 x7s1+kuXnrS2/Yx/7CjapgAEqWq7tcvah8Zi0e9vXk1eX+OOGDftxB4DPzU88xifhT9xa
	 sckKckGzoJk/4fkxtLRILLMAjDITGXNtHfLqNCXOJr4GFlcdu/ME2Qp10LxsbEiD9Mk5+
	 U4XPchz+wwlAYoUCWKwyTZqs27SMe/sIhoxRaNI7W91ndx/1IUCMxNHVfb3Si32W11d8Q
	 g1/CU6opwLbmcAUf620EleISwcWGCYgT4zr4c/H57TvF6tbjdNd2k2E3EKCDz8rhyqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2auFMOo6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C2006074B34;
	Fri, 13 Nov 2026 17:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2auFMOo6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC17E1F000C4;
	Fri, 13 Nov 2026 17:31:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591111;
	bh=CFHnIlVyQRtRZ0MXse3lH5cXQ7D41qkvP/TrWdR4bjA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2auFMOo6gzeNp7B4vKA8Ddy9ydxRIYlswboWJu6DroYEGmN5O1bby5M7jluJudz3L
	 Hn+Ki8c16J+oGBJj68evWrc9oBdNoB/0wDSVkIwLq67DrnRAIdfd+yWUOtazr4p5J3
	 D9UVoSMT0tWHXXheoF6dWckPgMVNkWjjhuZP0I+g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 263/670] hwmon: (pmbus) Fix return value check from thermal zone registration
Date: Fri, 13 Nov 2026 10:47:07 -0500
Message-ID: <20261113153820.745176088@linuxfoundation.org>
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

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit 4fc79634af8cdf734e0a633923ba4817e30d29ad ]

The PMBus core used to call devm_thermal_zone_of_sensor_register()
to register thermal zones. Commit 613ed3f676092 ("hwmon: pm_bus: core:
Switch to new of thermal API") changed this to call
devm_thermal_of_zone_register() instead. The code subsequently checks if
the call failed because the thermal subsystem is not configured.
devm_thermal_zone_of_sensor_register() used to return -ENODEV in this
case. devm_thermal_of_zone_register() returns -ENOTSUPP. The code currently
still checks for -ENOVEV. This results in driver instantiation failures if
the thermal subsystem is disabled.

Check for -ENOTSUPP to fix the problem. Keep checking for -ENODEV because
this indicates that no thermal zone is configured for the sensor, which is
acceptable for the driver and must not cause a registration failure.

Fixes: 613ed3f676092 ("hwmon: pm_bus: core: Switch to new of thermal API")
Cc: stable@vger.kernel.org
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/pmbus/pmbus_core.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/hwmon/pmbus/pmbus_core.c b/drivers/hwmon/pmbus/pmbus_core.c
index d56173c00ada9..596b7fd568bf4 100644
--- a/drivers/hwmon/pmbus/pmbus_core.c
+++ b/drivers/hwmon/pmbus/pmbus_core.c
@@ -1420,10 +1420,11 @@ static int pmbus_thermal_add_sensor(struct pmbus_data *pmbus_data,
 	tzd = devm_thermal_of_zone_register(dev, index, tdata,
 					    &pmbus_thermal_ops);
 	/*
-	 * If CONFIG_THERMAL_OF is disabled, this returns -ENODEV,
-	 * so ignore that error but forward any other error.
+	 * If CONFIG_THERMAL_OF is disabled, devm_thermal_of_zone_register()
+	 * returns -ENOTSUPP. If no thermal zone is configured for the sensor,
+	 * it returns -ENODEV. Ignore those errors but forward any other error.
 	 */
-	if (IS_ERR(tzd) && (PTR_ERR(tzd) != -ENODEV)) {
+	if (IS_ERR(tzd) && PTR_ERR(tzd) !=  -ENODEV && PTR_ERR(tzd) != -ENOTSUPP) {
 		devm_kfree(dev, tdata);
 		return PTR_ERR(tzd);
 	}
-- 
2.53.0



