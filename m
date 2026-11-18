Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020087;
	b=Annn5hRDi9fMQhOUmbixPFsmFxJbD2KEdvBBON+tD7jlZqWbJ+ufruL5NYQTLsEQN07a
	 Gaa9BOo7DC8/C+or41eAQZctWrK2Uk4A8gQQGS48eRhAKYzrbpsQbRrmOva2rGNDl6OQ5
	 QJiDCx0OcDpC5FtePk8CtNvwmcUsZ1j0k4lhXwJ6AW7gshFcHIClE9mWH1r2RL914XahN
	 byUz43cXelzirHygDSl+VvDy4lmJm38IyFlIW5kI9z4ldCufBc+ZOM12F9uqV3EtADbtw
	 goZNupNXCT3/hRJgEFeVhakPzNc7MQotq4rjGoeT+Ec6bYhvjSgrqPGVDFuLFV4FmdA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020087;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=R1PAXBrWLRDzIzWgbkEC0P82XVKrlP+tYOskUmKq1X4=;
	b=vOaaVLqY3BTnaAF8ZoRVNTo2UMyDSnIdlYOv4mig602lRLOGr5tRXAmEoqsnMPtuzjN9
	 xPKiWjN8/iFDBfkqXhDT2ty1bpOGTBzgp6CJZj9xxcW+ABQSd3Uiiem7uE4LaN5JHUR1r
	 yKMqPqlocftz3GuY41/RBvC0+RYXhjMTDFNYiSGp1UsMLXwS/51hw1cNSgFXo10JAML+B
	 kuzjHK3qGMhEEESkoNoOrFMu795ljZEGCBUOzumtCFheGTqZGiHYwAVqO8KdOKbJVDc4D
	 8+Yez3oncKQYB5cEfI90WZwfpHXFzlHzF8DdAvfVwNpXCtflcUgKJ40KisXjFejooKQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aEN3+2Fs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6F47606A320;
	Wed, 18 Nov 2026 16:41:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aEN3+2Fs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11DAD1F000C4;
	Wed, 18 Nov 2026 16:41:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020087;
	bh=R1PAXBrWLRDzIzWgbkEC0P82XVKrlP+tYOskUmKq1X4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aEN3+2FsP/p/K6MevYvmvEjMZJml3gzotkhObx0TSTHBtNXRl3Le3bOmefprQ02Kd
	 2p8iC0CNeaKU3Hvf1E42+ucarPBHgfm0Zmxs3a7es286auuqTKqIxeOgom+KWrYuYD
	 DMVL3nn5BSGIMM6zHlIhEtgi+COIww4mBIMA157A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vitaliy Sochnev <sochnev.v.74@gmail.com>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1826/2651] thermal/drivers/airoha: Fix AN7583 ADC mux field mapping
Date: Wed, 18 Nov 2026 15:51:06 +0100
Message-ID: <20261118150352.887099888@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Vitaliy Sochnev <sochnev.v.74@gmail.com>

[ Upstream commit 4a0f3193c68eb41882ccf7c298f5cd0b17efb8ab ]

On AN7583, bits 3:1 of 0x2e4 select the sensor (0 bandgap, 5 GbE, 6 CPU)
and bits 3:2 of 0x2a0 select the diode (0 D0, 1 ZERO, 2 D1). The driver
names them the other way round: MUX_TADC is 0x2e4, MUX_SENSOR is 0x2a0.

v5 of the AN7583 series swapped the airoha_set_thermal_mux() arguments
to match these names. The diode index now goes to the sensor selector,
so the zone reads mux positions 1, 0 and 2 (PAD_AVS, bandgap, core
voltage) instead of the bandgap diodes. On a Nokia XG-040G-MF the result
crosses the critical trip and the board powers off during boot.

Swap the field definitions. MUX_TADC then selects the diode, as on
EN7581, and the existing call order is correct.

Fixes: b20d9782756a ("thermal/drivers/airoha: Add support for AN7583 Thermal Sensor")
Signed-off-by: Vitaliy Sochnev <sochnev.v.74@gmail.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@kernel.org>
Link: https://patch.msgid.link/20260929165209.69669-2-sochnev.v.74@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/airoha_thermal.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/thermal/airoha_thermal.c b/drivers/thermal/airoha_thermal.c
index ea3e2649c280c..1b187c41baeac 100644
--- a/drivers/thermal/airoha_thermal.c
+++ b/drivers/thermal/airoha_thermal.c
@@ -18,10 +18,10 @@
 #define EN7581_DOUT_TADC			0x2f8
 #define   EN7581_DOUT_TADC_MASK			GENMASK(15, 0)
 
-#define AN7583_MUX_SENSOR			0x2a0
+#define AN7583_MUX_TADC				0x2a0
 #define   AN7583_LOAD_ADJ			GENMASK(3, 2)
-#define AN7583_MUX_TADC				0x2e4
-#define   AN7583_MUX_TADC_MASK			GENMASK(3, 1)
+#define AN7583_MUX_SENSOR			0x2e4
+#define   AN7583_MUX_SENSOR_MASK		GENMASK(3, 1)
 #define AN7583_DOUT_TADC			0x2f0
 
 /* PTP_THERMAL regs */
@@ -636,8 +636,8 @@ static const struct thermal_zone_device_ops an7583_tz_ops = {
 
 static const struct reg_field an7583_chip_scu_fields[AIROHA_THERMAL_FIELD_MAX] = {
 	[AIROHA_THERMAL_DOUT_TADC] = REG_FIELD(AN7583_DOUT_TADC, 0, 31),
-	[AIROHA_THERMAL_MUX_TADC] = REG_FIELD(AN7583_MUX_TADC, 1, 3),
-	[AIROHA_THERMAL_MUX_SENSOR] = REG_FIELD(AN7583_MUX_SENSOR, 2, 3),
+	[AIROHA_THERMAL_MUX_TADC] = REG_FIELD(AN7583_MUX_TADC, 2, 3),
+	[AIROHA_THERMAL_MUX_SENSOR] = REG_FIELD(AN7583_MUX_SENSOR, 1, 3),
 };
 
 static int an7583_thermal_probe(struct platform_device *pdev,
-- 
2.53.0



