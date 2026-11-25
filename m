Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625818;
	b=q/cWBRyU3QNZuggpOUkqHbhVF6Y2TncNuP1zSEL+HDjEeZz/QixXeIOjwgnUHsbdUt/P
	 /D5SNQpBdzjgVKxsz5NVBuDjluU88DuCpcNDpuHgDMZ7SUPSbspFqyIjGRKeJ1NWrBgx4
	 6lyhQ1bblRBkgwu3owb4oNLqo8XdR+RwZXN3EBbHXJif5bPwXc4tNL1sF0S81Z4nKKwFs
	 qjjQTckHnt0gKKQK3m/Epl2dKM0+AeyLoe7qZep58vXMQFwJgOv1m4NLiZ4rjtYl5qixX
	 YzEcSgLm8cXU6RlpL37vfDw08QDb7sIZ/QgzlSIUM7jIVQd85zK+wfIwEHDj6yYDHvA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625818;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ByqOF28Dj7Nm6xdD2F61Ai71wNGVo1HTCMLM0Et2KW4=;
	b=inc30EzK8c/aDllhbheDMvDr0+R9zQ7qUKY+nf6ZvWo+8d04bUzXqwpH/OYehSgeZioP
	 pbjQSmXFFEvsvN20nLJV0Qx15bmRlMW4KA9tD/8OC1JuVZSg66PwvLQXVLbzbw6j2uNj8
	 7x0NJajjuXz6WDyNoZj/OadOwhR48kvxSYa6q2u15K70yZAlIrxlGTDvL5FK79cvj3+kZ
	 H4I2Ezzsas3RLNpkQTQMfqddc/F3i8EekyTKWL5eSjX8LpYunL6QVAVAqghY/TYvvstCb
	 CStHPxmCpAnvxR/4iaYyyLAXaUIAcTLZ2YxOE9yBTOMLngafLeK4OZuFUHAGdwwK6UA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0pgcXIW9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50880606A31E;
	Wed, 25 Nov 2026 16:56:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0pgcXIW9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2FDE1F000E0;
	Wed, 25 Nov 2026 16:56:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625818;
	bh=ByqOF28Dj7Nm6xdD2F61Ai71wNGVo1HTCMLM0Et2KW4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0pgcXIW9QbOqJTI/4t3OezLVnCBIYVTznH+BhuWkwmD34lcmvCOI1CKmiikjxsjMO
	 zCWIFtFmraIdvTooeIaIZYp1bAlWh9kUsehSpwmWCJKnZEEjO9Rr6vzxPufEL2BDU0
	 6ylRVUquFkqzP7C5ODrxIyB6CZT8d0HbT6KZ9vO8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stanislav Aleksandrov <lightofmysoul@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.12 640/816] hwmon: (max31760) Leave standby mode at probe
Date: Wed, 25 Nov 2026 15:36:28 +0100
Message-ID: <20261125143903.998490895@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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
 


