Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619928;
	b=JfQ5f29Rk1rZrRk9wTr1bxl6OlT1vH0Nb2IA3wa8oJoGkuyRwTB9dWkl6DufeDKADSuC
	 3/5W0kqHxO07BT9kMLMWaI8wFQH5LimdAp4MV8HhGiLCu5DnPvBXkqoMGgXvR2AdnUggy
	 1LgUFZ5coYC4FOjIJrdH0D9r/dtOPjQpZePiEfDIaOUBTiRgaE2+c6ezxOEvVjQhleocj
	 8nxzC0bK2NQi0P186VGFPzK4BzVx4ScpWQZVHjFaCOTgreo1lUCl2pZ45fY++tL/HFyEl
	 cxCsUntkSs4X6JORVCUVY4j4HeYfQLBem4qu9HkHXVTtL96yknvzuIiwNG0m30HzIbw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619928;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CuOI+qEpiFNno75q7hZyV7+0PQxdX1ssJHnqszoRfVQ=;
	b=YAiizYBwbBx0xN3b0Rs/C1FBVts44e5/ukYd0cQeCjX8OdcQrrSUrW94hxG6gSThGs69
	 cC129weaFB8LrMhXPCBUGrkpVKTdqv1WvchnW68R2C2A+UBowAZ4Vf0QysnqRfHf22khJ
	 FIbVsqivT0OS0BMTz6oNwtWy+5NUREtczIllyPyXbfPh6sd7zX6jBimkr9Q/RgGVV7BwF
	 ZhVyIz34Qku4odHQ6W45bdeLxor+oXxnSFLKsZZfCglBjLZY1OPSVbbJqOYwwviqAXKx4
	 ZMAkM6K7ubnM3hoCe4yin1CNJWjBjj4aj74rxFac5I81xuGQDV5nwE2G26t9Ugn5GHA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dOmQtqqB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58936606A31E;
	Wed, 25 Nov 2026 15:18:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dOmQtqqB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A43DA1F000CF;
	Wed, 25 Nov 2026 15:18:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619928;
	bh=CuOI+qEpiFNno75q7hZyV7+0PQxdX1ssJHnqszoRfVQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dOmQtqqB0unNmVOhOd9G6kFuLyuWbXQDi2mY6/NF7JUAKW2Jh7TSoLAuGDs/LmEHu
	 nnruKI+8qW2jxgJ4OyRUVJIWT89PyNEn74I2fLDGOm4imwul6SBm6NZ46LRVzivzaY
	 m8uqiDhBxhVsTky6Ty7N03sPSO86YIRxnn6T4vWs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stanislav Aleksandrov <lightofmysoul@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 7.3 0753/1005] hwmon: (max31760) Leave standby mode at probe
Date: Wed, 25 Nov 2026 15:34:51 +0100
Message-ID: <20261125143839.386036872@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Stanislav Aleksandrov <lightofmysoul@gmail.com>

commit 95bddc5252a4c0a2ed9d62e7e53a3461265d9603 upstream.

The driver never clears the standby bit (CR2_STBY) during probe.
While max31760_resume() clears this bit on resume, probe only
configured CR2_ALERTS.

If the chip was left in standby (for example, by boot firmware or a
previously running OS before a warm reboot), it remains in standby:
temperature sensing, fan speed counting, and PWM output are halted.
This occurs on the Samsung Galaxy XR, where the bootloader places the
chip in standby during boot.

Clear CR2_STBY alongside setting CR2_ALERTS in probe.

Fixes: 38b04ad02d0d ("drivers: hwmon: Add max31760 fan speed controller driver")
Cc: stable@vger.kernel.org
Signed-off-by: Stanislav Aleksandrov <lightofmysoul@gmail.com>
Link: https://patch.msgid.link/20261108-max31760-fixes-v1-2-a61450463059@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwmon/max31760.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/hwmon/max31760.c
+++ b/drivers/hwmon/max31760.c
@@ -533,8 +533,9 @@ static int max31760_probe(struct i2c_cli
 
 	dev_set_drvdata(dev, state);
 
-	/* Set alert output to comparator mode */
-	ret = regmap_set_bits(state->regmap, REG_CR2, CR2_ALERTS);
+	/* Leave standby mode, set alert output to comparator mode */
+	ret = regmap_update_bits(state->regmap, REG_CR2, CR2_STBY | CR2_ALERTS,
+				 CR2_ALERTS);
 	if (ret)
 		return dev_err_probe(dev, ret, "cannot write register\n");
 


