Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042938;
	b=lqgkk5afsP+9n3glf6DrH0ZlzkhydDKQUp43cLUbGWuBLrgTEeYYWB/J4kL34Zl0c8fq
	 QI+qF8HjUI6aCjF8IKM/gxmFpQhFIWjCk6Gw/uFcMCt/e/XwtjmHkQe3jWuxvIaIezF+H
	 hNOQUFYSBDgRWWPDuSlntzlj5C2GKnGQ2sSl60SbqWpzPRK6e37pTido8Jj975Xm51xNl
	 am290Y8dprTSKpHR7A9AJfBWpOc/sG02fzXAfTy7FkpCUUFIJfUlXkytdduQMQMog/vd5
	 avfo7PXUtj4bL6dGTOj6SxYlhzRVdDEKcsdYByrppR11mJFMwwPJE1LnW+zW2jXnVjg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042938;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oAgSdzmIZAA6TxL+ezTo1lGvIb9tVbzXG4V1LRV/1/k=;
	b=LybRT+r7eAgb+cXEEo6gSJsWqa4Ogzuet4lMBZgzwTsTD8vBWqJuNgl12yEkK70hZy2T
	 6aGyKNRnRdmgYTdpmxTsblD0OKwEyMMaA+KvoZm0nQC8DiYD9P5l0Yl0MpIA3frdo+Jo6
	 4yrbAlU7H8tEFpWoJCoNSLO4rYriEOZAs9wiuLap2jIfFhZYuM6YpoFBWfzT1ZmSb0m8C
	 NCm3EHonCLgff4xRnoq8BwSq9wg5KBWteQyJvmqK1Hxe5cdU23ipCqQpnqUQn2AV5cOJe
	 U8Xa7Tfsl60g0ywVErG2tdFC+rVf6Q2I7wJz1XGw3UWIk9GCzt1mddvHmJTWI64ssOA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A1XAP8Zl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB2C7606A320;
	Wed, 18 Nov 2026 23:02:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A1XAP8Zl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C2471F000C4;
	Wed, 18 Nov 2026 23:02:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042938;
	bh=oAgSdzmIZAA6TxL+ezTo1lGvIb9tVbzXG4V1LRV/1/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A1XAP8ZlvcfM7t20XJrDYyr9GSlq94SsKerRSvpUTbtSlSCDaTDFtng7IXjzzs/O+
	 N10U0guTWOdlNvO0y0I3nNIvaZtwQnly5ugDZzkxvNbTKfw1Asto6vnPTFv18seG2z
	 4IealSsSE641vqaMzUjXIbo41cxb0rl7/KB+nkcI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abhijeeth Babu <babu.jeeth@gmail.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0033/2857] i2c: acpi: Force ELAN1300 touchpads to 100 kHz
Date: Wed, 18 Nov 2026 15:17:47 +0100
Message-ID: <20261118150202.534138738@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abhijeeth Babu <babu.jeeth@gmail.com>

[ Upstream commit 9e9762e578db7556bea644bb5a8a2435f63544d1 ]

The ELAN1300 touchpad with HID ID 04F3:3104 on the ASUS VivoBook
X513UA_KM513UA exhibits severe pointer jumps and erratic movement when
the I2C bus operates at 400 kHz.

The system DSDT describes the touchpad using an I2cSerialBusV2 resource
with a speed of 0x00061A80, corresponding to 400 kHz, on the
AMDI0010:03 controller.

At this speed, libinput repeatedly reports:

kernel bug: Touch jump detected and discarded

Add ELAN1300 to i2c_acpi_force_100khz_device_ids so that it operates at
100 kHz.

Before the change, nine touch-jump events were recorded, with additional
messages suppressed by libinput's rate limiter. With the bus forced to
100 kHz, no touch-jump events have been observed and the touchpad operates
normally.

The affected system uses BIOS X513UA.319 dated 2023-05-09.

Signed-off-by: Abhijeeth Babu <babu.jeeth@gmail.com>
Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://lore.kernel.org/r/20260617192611.125513-1-babu.jeeth@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/i2c-core-acpi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/i2c/i2c-core-acpi.c b/drivers/i2c/i2c-core-acpi.c
index f43067f6797e9..b74f41b9515ae 100644
--- a/drivers/i2c/i2c-core-acpi.c
+++ b/drivers/i2c/i2c-core-acpi.c
@@ -372,6 +372,7 @@ static const struct acpi_device_id i2c_acpi_force_100khz_device_ids[] = {
 	 */
 	{ "DLL0945", 0 },
 	{ "ELAN06FA", 0 },
+	{ "ELAN1300", 0 },
 	{}
 };
 
-- 
2.53.0



