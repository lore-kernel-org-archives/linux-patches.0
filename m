Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022691;
	b=WFaL68ERdJuPessvqM0NJkD4OKx99NKXLjD2kSI3VlNc+cRLAFeAJFmN4CmvVnlmD5bP
	 RGvu305Vvr60cRniUHIF/QNEfXb1FKQx4+Eudn0fM/0tkZnSyrECThNU9yqaEZFBlkUZn
	 5nl7cSZYEyiz6So7xJuX7PcDjM9q6gIXdeAREkyPMp2XeiS78/qBWFwcTKlSa7bdtYYrV
	 sJmnx7NCqaoHz2BkcKIt1J5y1useioOyRQE4nd23GGSKa15Aa7IJmZ2kZR4/9Ij86mRkd
	 EZB+Fc1wDb5JOdv3pBaOm1WBpJw2Fr1QNu7J8g3kLCi5u4Ejv8aFlUCgavJ0P7Bw6Pw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022691;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NkiNVwHGeet4OLXIu0kFe2k2NSTZcEga44O9phUD3Cs=;
	b=NJInan79nFJzUExzs3sygKmm12jd7j2K3ZcY34IcX/LSpi5jvNyjl/E07fL0vvcWi/x2
	 CSt4iDNiRQeepBD+vwe1ZB7vAcmGl+xHLXsBt8UOYlPxhbVcB6F3NG8by6YCS9+go3PyV
	 QOrCBd/Pwtq7e9GB4VzGL6m6JhRrqBivH1ymiH1iVpvWYzbclSBB1YpwTwS8SUde3kl8O
	 Rz6txYs5LwMOdLHtHdg+ezq9pWDsXov3e81Uj/ZrIoUtECbkHAl5xQl5bmKyx6x3tFlcc
	 NH58nvtcEQ+hVMFUd5InJkFjZovPQiyvU33sQgNjuvFSjespjlYkxW8H/x17q+icmaw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eMkumDtA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 846FA60A2606;
	Wed, 18 Nov 2026 17:24:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eMkumDtA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8A7D1F000C4;
	Wed, 18 Nov 2026 17:24:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022691;
	bh=NkiNVwHGeet4OLXIu0kFe2k2NSTZcEga44O9phUD3Cs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eMkumDtA3a7KYJRYgRBkTqMr4HqiaUH+5XaHX3REjBGRWGwSvGLHLjon4m73epBa1
	 Ta9iqOUI/u9Br5NczTO+AU52h+MH7J02YNWvtkatnbBnoEVBkT0r4/zMGaAecele8E
	 HdK71RpkbG9/0OCOkO/TwEYrLvjeGkzp6Mw+d0VY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexei Solcanu <alexei.solcanu@pm.me>,
	Antheas Kapenekakis <lkml@antheas.dev>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0104/2151] hwmon: (gpd-fan) Reset both fans to automatic on duo boards
Date: Wed, 18 Nov 2026 15:30:39 +0100
Message-ID: <20261118150125.589971460@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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
[ sashal: adapted gpd_ecram_write() to the two-argument interface using global gpd_driver_priv.drvdata instead of per-device state ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/gpd-fan.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/hwmon/gpd-fan.c b/drivers/hwmon/gpd-fan.c
index f81c3bc422f4c..310f461e1d633 100644
--- a/drivers/hwmon/gpd-fan.c
+++ b/drivers/hwmon/gpd-fan.c
@@ -412,6 +412,7 @@ static void gpd_duo_set_pwm_enable(enum FAN_PWM_ENABLE pwm_enable)
 		break;
 	case AUTOMATIC:
 		gpd_ecram_write(gpd_driver_priv.drvdata->pwm_write, 0);
+		gpd_ecram_write(gpd_driver_priv.drvdata->pwm_write + 1, 0);
 		break;
 	}
 }
-- 
2.53.0



