Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061406;
	b=bP5HWf2h9OIcXYPprcEJVhKhzqfE0CeoZ7i+Wg5jYrGd1H3rdIeLJqegGrN9KYMsFRDC
	 +prLAqovBCuhdRA9krxYWzRzJNlCJDL/DI2IvWxhN+Msfk0ViEf6W/3DHCRYiBxOa+tMl
	 kIhvYJV8/dYPFx6xvNpVs0qYfXXseKccHw/mT97qhDldBcTd19qh/XGtHheocrrjcEEtc
	 sYpqli6tPKJJjPC2Y3i3/m0ReuUDkZFInwQAoDtvxZEnKReyn389TkB6xH9WOOjbqdy6c
	 tz+C26VdzYyhJHscB/sryGH/c6/PejU7klDPIWQ7eUfHSLS6pJQEbgOTtYmT9/ChwhQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061406;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Re0iO9/8tPHV7etPxUWHd6Hgq0hxkn7NCX+I4Uzi5LI=;
	b=uAxkw64z7fDFWIwJ9i+oWCogoUsA76ovlsT298FglWh2Ak+3jHKQVgV7nDZ026q5p9C8
	 MPlHilZPKMx6KcUHhEPqOhzQwhFbhCf8MfOq4oMHKW7wKxVMV29UsvtYJulM7OtnpRvVO
	 8obX0TIZurVq9r2CMUe3PNVBKQV7Z6yQF0ZfxJyu1FUo9RMJTMcdCRnS9PW4wGkmmni/s
	 To/19ZR/iDIM2E1Sdo0632Po+0Rs3ep96jsykIkYljcMMEL9r8/GNDwpl1fPVisNwSatf
	 K5RAHL+PLGmqGKHZJJUxviU4IE346W+MyhF7/FnDHljDpr21QlpuyZBHENZjcspT2dw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nDv2IrAN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6669B606A332;
	Sat,  7 Nov 2026 14:23:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nDv2IrAN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10FDC1F0089F;
	Sat,  7 Nov 2026 14:23:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061406;
	bh=Re0iO9/8tPHV7etPxUWHd6Hgq0hxkn7NCX+I4Uzi5LI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nDv2IrAN2/1ylrIYw9BKzjGBX0p7kf4YQiN+/zCqywrQkGudhZUrGsKTcYKD5AKlW
	 M0Ehkz+6WB03N5lQDIz/yR8iVVUlyb3h9am6Qj5poTMkVpSV6HZ28c2Pz2ROQpbUJw
	 7bexq49WvF/+trnuBil/Onk6vHKGjE3MazMpKYq4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0523/1536] watchdog: rzv2h: Avoid division by zero
Date: Sat,  7 Nov 2026 08:42:19 -0500
Message-ID: <20261107135012.115519729@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

From: Tzung-Bi Shih <tzungbi@kernel.org>

[ Upstream commit 6274281c41efa8dd1aa5234c59ad904ff89d7af4 ]

clk_get_rate() could return 0.  Avoid a division by zero panic.

Fixes: f6febd0a30b6 ("watchdog: Add Watchdog Timer driver for RZ/V2H(P)")
Cc: stable@vger.kernel.org
Signed-off-by: Tzung-Bi Shih <tzungbi@kernel.org>
Link: https://patch.msgid.link/20260913064851.8239-4-tzungbi@kernel.org
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/rzv2h_wdt.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/watchdog/rzv2h_wdt.c b/drivers/watchdog/rzv2h_wdt.c
index 7df8b8e392410..c29c94f0b6295 100644
--- a/drivers/watchdog/rzv2h_wdt.c
+++ b/drivers/watchdog/rzv2h_wdt.c
@@ -221,6 +221,7 @@ static int rzv2h_wdt_probe(struct platform_device *pdev)
 	struct device *dev = &pdev->dev;
 	struct rzv2h_wdt_priv *priv;
 	struct clk *count_clk;
+	unsigned long rate;
 	int ret;
 
 	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
@@ -257,8 +258,12 @@ static int rzv2h_wdt_probe(struct platform_device *pdev)
 		return dev_err_probe(dev, -EINVAL, "Invalid count source\n");
 	}
 
+	rate = clk_get_rate(count_clk);
+	if (!rate)
+		return dev_err_probe(dev, -EINVAL, "Invalid clock rate\n");
+
 	priv->wdev.max_hw_heartbeat_ms = (MILLI * priv->of_data->timeout_cycles *
-					  priv->of_data->cks_div) / clk_get_rate(count_clk);
+					  priv->of_data->cks_div) / rate;
 	dev_dbg(dev, "max hw timeout of %dms\n", priv->wdev.max_hw_heartbeat_ms);
 
 	ret = devm_pm_runtime_enable(&pdev->dev);
-- 
2.53.0



