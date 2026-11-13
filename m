Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585560;
	b=5DABWz/s9cxHFDCQNjS/cBNOmELJujZ6FiKYxLI+/D/T2EO46F5/cyvCLis0W+X9oe2W
	 Owrij4JngVIGGUD8/2EF/WoErZHmrBdhplcdTTZSu1fq86skK3f6Xf3yFk6uL8Tzf/O0x
	 f8EnvveuuDx/PVw8v7WygVuOJN1CtkwO+ZlZ9+lB57WBnCLzK0UKNz5sd1Es8v6KJJiY4
	 /eQ9Y0PXXb44wD+usT5IluzLJW7Q639lsCqo3kXJ7GHnx6VClY/NaoJdhQq/OTCajU2qs
	 E5MAzgyj6G3wcysWSgEuyc7Bwwx/l8CmOlsIx/qfo2QQagOkzL449wYYJQsd9dWth5Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585560;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bbTMlX/6RAUyOJFyUlchmIZwq47S56OOoEW/xHk2fWg=;
	b=APjXWQFdIShdtr1VgUxNOrTyGyQ020AuQnz9GFFCD2LsHt1rTih/CtCJoSkn4ERg2b0Y
	 U0YxD9+9Z2MejF/g/jIgT0jvOfQtWAel4wS8A9WYG8cshV0Zk1kaJRXbHRgzS4WWLrb/P
	 OjMctZO0upYABu2V8h6xffEIwqDsnvy7m2e5X9eqXmKDb1XdSYVHtPlAqJFr37GJ+I7Fd
	 Te3TxokdneXmdsNfxxhtD/NKb5YHGrZC4q2TP/fTsjZRdrjxNFpAPSdhsT7w1GbvPhqKK
	 d5X/lek48Wh/6kJvchA82lBKAOsmF6WIXSoT8je2nS1NYh942A0yr/xNJ3eqSQ9CTPw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZXqOQRRr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86042606C573;
	Fri, 13 Nov 2026 15:59:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZXqOQRRr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3162C1F000C4;
	Fri, 13 Nov 2026 15:59:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585560;
	bh=bbTMlX/6RAUyOJFyUlchmIZwq47S56OOoEW/xHk2fWg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZXqOQRRr4eOpRUHLGx7dTdMV1jTs0SSC26xArlIEvpIzqcnLfQW9FF3v5AuGazPhV
	 vjlwP41c3h9yHjnmr/g1yxDKTLkhlq2mZZHmsnMXWR6Ty9UHwi7CotcMgX3TkYzakL
	 icbcKg/6sgD2JYwmzzwJqrpb9R3GAXjx/bIRr7F8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Baek Kyu, Kim" <pocj8ur4in@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 197/507] hwmon: (gpio-fan) Update the speed cache before dropping the PM reference
Date: Fri, 13 Nov 2026 10:48:21 -0500
Message-ID: <20261113153801.163763198@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baek Kyu, Kim <pocj8ur4in@gmail.com>

[ Upstream commit f324179e6ccd05dfdc8e98fba2e9d50aea8e7ea2 ]

set_fan_speed() writes the GPIO control value before dropping the runtime
PM reference when stopping the fan. pm_runtime_put_sync() decrements the
usage count even when suspending the device fails, but the error return
currently leaves speed_index at the previous running speed.

A request for that same running speed then returns success without
changing the GPIOs or taking a runtime PM reference. Retrying the stop
instead drops a reference the driver no longer owns and can trigger a
runtime PM usage count underflow warning.

Update speed_index after writing the GPIOs and before dropping the PM
reference. The initial same-speed check already excludes a stopped fan,
so a zero target is sufficient to identify the transition that needs a
PM put. Preserve the PM error return and the CONFIG_PM=n exception.

This keeps the cached control state and PM reference ownership consistent
without restoring running GPIOs after a possibly partial supply failure.
It does not clear persistent runtime PM errors or claim that a failing
regulator has successfully powered off.

Fixes: 0d01110e6356 ("hwmon: (gpio-fan) Add regulator support")
Cc: stable@vger.kernel.org
Signed-off-by: Baek Kyu, Kim <pocj8ur4in@gmail.com>
Link: https://patch.msgid.link/20261031095039.11683-1-pocj8ur4in@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/gpio-fan.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/hwmon/gpio-fan.c b/drivers/hwmon/gpio-fan.c
index 3f78375eeb448..08b58b49be5b9 100644
--- a/drivers/hwmon/gpio-fan.c
+++ b/drivers/hwmon/gpio-fan.c
@@ -150,7 +150,10 @@ static int set_fan_speed(struct gpio_fan_data *fan_data, int speed_index)
 
 	__set_fan_ctrl(fan_data, fan_data->speed[speed_index].ctrl_val);
 
-	if (fan_data->speed_index > 0 && speed_index == 0) {
+	/* The GPIOs have changed, and a PM put drops the reference on error. */
+	fan_data->speed_index = speed_index;
+
+	if (speed_index == 0) {
 		int ret;
 
 		ret = pm_runtime_put_sync(fan_data->dev);
@@ -158,8 +161,6 @@ static int set_fan_speed(struct gpio_fan_data *fan_data, int speed_index)
 			return ret;
 	}
 
-	fan_data->speed_index = speed_index;
-
 	return 0;
 }
 
-- 
2.53.0



