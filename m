Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059403;
	b=TW8qRoPG6t6Oq3qfkjLO/sSni5ekgmxjOy6RgdmyTjgnIo4NrNxjx3jsUelZJuYEym67
	 1fgiY6IzDNeaBz+G/0KGuqJPlyXmr7axYLvjRs+WgC+aVB0nJNeyXfGdi45aAr7YE5VSF
	 NaPPoXnXDN8KBzznGixdjmgkp2FPQim2mqO2t8H1yBhY1NhhCLJ6SMuZaW/VEe4cIefzJ
	 sAvSunSaxjBboJx4RwmgnNt+uNo0WJeZj5Z95g3TNh1N1SzYJeKrV5rtAYh9rudNFdjQI
	 VMfLq2c2sU6ENGXAFP4E3aMyKsHk98HbyGNxBMzQYyzie4zWogDAjQ2By7fnMKsCE+Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059403;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=alm5brNJa122WibiK0Vovnh7WxW01KBRG92QKg5eByE=;
	b=QO7Kfy32da8vWQiWFeG3/I8iz/irQRLJHEiYyFqdKJR2jPz8OCdIxon6cge0ofVL9ct+
	 lX+zKeqauBIn9cbFZehYTh9tcEFY+4bPtNFrXuzVdJbBvNEkNln//UOeKlWyxvb+dTMr6
	 7a6f00CAGXi5zel4W+eTqn2VgA4UmsVdSc0Ls+1bCPqA1R6ntV17Hzx8uomibiYmJ+Z2B
	 SyGL4jH1tjsj6+2ALsnUh7u0KFLTnFm744ji/cnBBZQqjy0eMIeDbt8cc/D2FyD3fLawd
	 Y544Ok7fCckark3OlEyhEkA9sI2sHMqrmPmDUrRGwzLcGlrmJeZbbR0FIJwvVPEWdJg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i15wzkll;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1876A606A31C;
	Thu, 19 Nov 2026 03:36:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i15wzkll
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F0941F000C4;
	Thu, 19 Nov 2026 03:36:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059403;
	bh=alm5brNJa122WibiK0Vovnh7WxW01KBRG92QKg5eByE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i15wzkllrt/uZ9IAxzXRpE+f+gJaK/J23uoCXAceQ2k41ss9Ft47I6ZfvKnjUa5VA
	 0jW4gpuMLlgY5Z0hddqr5tLYBhdJ3ya0buRb85evM23vrSDDyfTEvW3tb1P445up0C
	 ohtHufRziu4u583oVHzolqbT7lLlc1tGzTEMz/oc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Punnay Sharma <punnaysharma805@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0828/1848] staging: media: av7110: fix sp8870 initialization failure state
Date: Wed, 18 Nov 2026 15:47:46 +0100
Message-ID: <20261118145951.378410775@linuxfoundation.org>
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

From: Punnay Sharma <punnaysharma805@gmail.com>

[ Upstream commit 30684fa98394bc0eb4362282908612aab7d4dad9 ]

The SP8870 DVB frontend driver prematurely flags the device as
initialized at the very beginning of the sp8870_init() routine, prior
to requesting the firmware (dvb-fe-sp8870.fw) and executing the I2C
upload sequence.

If request_firmware() times out or sp8870_firmware_upload() encounters
an I2C bus error, the function aborts and returns -EIO. However,
because `state->initialised` is already set to 1, all subsequent
invocations of `fe->ops.init()` by the DVB core will immediately return
0 (success) without attempting to load the firmware again. This leaves
the demodulator microcontroller halted and the frontend permanently dead
until the module is forcibly reloaded.

Relocate the `state->initialised = 1` assignment to the end of
sp8870_init(), ensuring the flag is only set after the firmware is
successfully uploaded and the system controller is actually restarted.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Punnay Sharma <punnaysharma805@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
[ sashal: Adjusted the patch for the driver's older location and surrounding source context. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/dvb-frontends/sp8870.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/sp8870.c b/drivers/media/dvb-frontends/sp8870.c
index f68479e75e462..3e05ef983fafb 100644
--- a/drivers/media/dvb-frontends/sp8870.c
+++ b/drivers/media/dvb-frontends/sp8870.c
@@ -297,7 +297,6 @@ static int sp8870_init (struct dvb_frontend* fe)
 
 	sp8870_wake_up(state);
 	if (state->initialised) return 0;
-	state->initialised = 1;
 
 	dprintk ("%s\n", __func__);
 
@@ -336,6 +335,8 @@ static int sp8870_init (struct dvb_frontend* fe)
 	sp8870_writereg(state, 0x0D00, 0x010);
 	sp8870_writereg(state, 0x0D01, 0x000);
 
+	state->initialised = 1;
+
 	return 0;
 }
 
-- 
2.53.0



