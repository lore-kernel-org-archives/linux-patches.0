Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585532;
	b=0x/tpy+v/SFrH4dpeht5GVemuSe51Km6kajR8yd5blxfOOHyJ3mPJcbC7iw3UwXdZiwk
	 cNJjzvJ7r6rC6XAlA7I0ffg9ZuhSYqmt1nDWMVQ4walWnsrADpHWhEoEuTdx9eumopyQR
	 caGfEgaQwH4ts7D4VHyvgW1pST9oAg5irmt761v5v8BoXjfCFZLaAO60zW+OMQo+Fj+I9
	 UhPceOltv74jA/wyiFhoM+XTjQzM9SqnUq7oS0iY99wHgVQiGj9kvSfAJR7epJqPX/WiV
	 /sFB7ZuYY40mTXmvLDcnWiposseEGNf3HXp6MdtiluL4YftUqsXpDMSUE/1Dv31EP2A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585532;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ozXu6uAhi2vc2ap+ACI0TCEyOYjF8OmEaqiV+RCvRrU=;
	b=MLuYk9b8lrREQSpLEVzw9MCENgR0tqeOrmF/Ot0nOq2Rk+Nk2JeIwGq9dR7rAC8XAFxk
	 cJcAnEaJxaIbodMc4PajG3gIAY9sIP5IJRi9fQt2v+FwLICgzRwOu5cyjDZKrP2YJmjLO
	 ydMCo+LUsWA5z1X0vOY7+amOlCQdShv/u92sZfPBoyp6igW3ErpYCzaJUfRz0kv7sphOY
	 0TcuWlo+t84NQ50kAqC5dY7tQ6rdMPWOhFPXzWf/uqi0iE+d8iZTlhGXrrlNYQf//IdA0
	 8Y1vzmOn+dC4iSeo2WQA94XZLCvAUZiv4rmqjHgV2vCAzw++Dho/PgNBJU/NAR2wIvA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pjtg6Vk7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 257D2606D450;
	Fri, 13 Nov 2026 15:58:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pjtg6Vk7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C51711F000C4;
	Fri, 13 Nov 2026 15:58:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585532;
	bh=ozXu6uAhi2vc2ap+ACI0TCEyOYjF8OmEaqiV+RCvRrU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pjtg6Vk75sZXSCMLkIlSz0QD2G4dl395/b0SQKIWW8PqXl/zXlbwmCQn/+p/ShutA
	 elsOVxD6APAhjrnG67AZj/x3kCdnO/DnGdemswTYH/hdlKhhX9yktDloU9zFhktJEc
	 e/h+yRHy434Mg9Is0GBkocKBubBkA0qruOugLJNQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexei Solcanu <alexei.solcanu@pm.me>,
	Antheas Kapenekakis <lkml@antheas.dev>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 172/507] hwmon: (gpd-fan) Reset both fans to automatic on duo boards
Date: Fri, 13 Nov 2026 10:47:56 -0500
Message-ID: <20261113153800.310833846@linuxfoundation.org>
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

From: Alexei Solcanu <alexei.solcanu@pm.me>

[ Upstream commit d1f60971fbf85c243ab6c78f6535fbc88fa640ce ]

On boards using gpd_duo_drvdata (GPD Duo, GPD Win 5), writing
pwm1_enable=2 only returns the first fan to EC control. The second fan
keeps its last manual duty cycle, e.g. full speed after pwm1=255, so a
fan control tool that exits leaves it running at that speed.

gpd_duo_write_pwm() writes both fan registers (pwm_write and
pwm_write + 1), but switching to automatic only clears pwm_write.
Also clear pwm_write + 1, so both fans return to EC control.

Tested on a GPD Win 5 (G1618-05). Not tested on the GPD Duo.

Fixes: 0ab88e239439 ("hwmon: add GPD devices sensor driver")
Cc: stable@vger.kernel.org
Signed-off-by: Alexei Solcanu <alexei.solcanu@pm.me>
Reviewed-by: Antheas Kapenekakis <lkml@antheas.dev>
Link: https://patch.msgid.link/20260926-gpd-fan-duo-auto-v2-1-0a2ea41ee3b5@pm.me
[groeck: Dropped obsolete 'Assisted-by: tag]
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/gpd-fan.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/hwmon/gpd-fan.c b/drivers/hwmon/gpd-fan.c
index ed212615b2fe9..b3b75f99f5883 100644
--- a/drivers/hwmon/gpd-fan.c
+++ b/drivers/hwmon/gpd-fan.c
@@ -444,6 +444,7 @@ static void gpd_duo_set_pwm_enable(struct gpd_fan_data *data, enum FAN_PWM_ENABL
 		break;
 	case AUTOMATIC:
 		gpd_ecram_write(data->drvdata, data->drvdata->pwm_write, 0);
+		gpd_ecram_write(data->drvdata, data->drvdata->pwm_write + 1, 0);
 		break;
 	}
 }
-- 
2.53.0



