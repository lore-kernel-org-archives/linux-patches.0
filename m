Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057176;
	b=I/tr/RhNNP8+wVFhzIgTAfTmvOBzdFQjmt9j/hZNU/73Ilv7HDWGIw/9U/3Hqf1sabIT
	 7USuQ+xx8K9Iu+lU2ltjDTKKRXYwILnVg2xsvXPFmjKVmbJU1K7bI+b3hroMwr4H/H0ef
	 wNZaF55PKAA8/7poK/4isxxseT99Kcxi61K4WdB8lDj85HZ7b/lBSg74eJq1J+vmjGS0b
	 RjGh/h+N6Hl+4j8OJoJ7iifgI9ejm7tFc9yRiI9ifZWJN3jOq69kV8ydsO2scp48LZ0bj
	 AU6qFXbNhEGIBSfuR+64PIYmjaRnj5VSXt3umPIZBL3iqnM02txkInlJ/SVRYcdH7YQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057176;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+PcQeZT9suhufvhlwulkcvV4hsx8XdMhFBGQ5j2MyIA=;
	b=uQ4iqeTV+0HPlIrnU0qOB9PK0sZg5iNGD7Ukcmj2VBOR3p11jMb+CbUQR2zH9737JnzC
	 bWtYTv9yRuvApyTVv2XQd40CPka/R9FK15POtia+SBe1xzAw9XPVAwcbyFjK8aANdC3hN
	 CMcNS8YXGKSeANldLxN55F8i6vDZQCeqakf0kvdOs2IfLdQuaRo7IX2oAn6kjPKKjee6R
	 PxTMdsz2Rkcc86VOIqbz/jDWYF32YrB/7vFrJBLqhmGIzDRiL/CLqzsl+XWMtBxBUoBt2
	 1as22e3iU9i9L/sLtfmld0RQ2yzJ1Jk54u3wu+QRjy4fpnDqbE0BAei2efsncVo+vew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zyyaLSYs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ACE4606A320;
	Thu, 19 Nov 2026 02:59:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zyyaLSYs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEE5F1F000C5;
	Thu, 19 Nov 2026 02:59:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057176;
	bh=+PcQeZT9suhufvhlwulkcvV4hsx8XdMhFBGQ5j2MyIA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zyyaLSYsfT7hHrwjmqZF9RR0DtyxiExtXSi9TLpN6ZpnGI5Ymw7HMe7J/QCE+a211
	 g8Rx9MkJCzRyI+2mtmyQmh62unbN/Niz2fYl5GrcvqPlSAqbsnm+dBn5MW6NPfQuvu
	 EALHEzeNPWTolBeo4U3vwZIPzUsOzvjkwJyk4zvQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abhijeeth Babu <babu.jeeth@gmail.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0037/1848] i2c: acpi: Force ELAN1300 touchpads to 100 kHz
Date: Wed, 18 Nov 2026 15:34:35 +0100
Message-ID: <20261118145912.680211121@linuxfoundation.org>
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
index 197b89f0b3e09..2f180862dbec9 100644
--- a/drivers/i2c/i2c-core-acpi.c
+++ b/drivers/i2c/i2c-core-acpi.c
@@ -316,6 +316,7 @@ static const struct acpi_device_id i2c_acpi_force_100khz_device_ids[] = {
 	 */
 	{ "DLL0945", 0 },
 	{ "ELAN06FA", 0 },
+	{ "ELAN1300", 0 },
 	{}
 };
 
-- 
2.53.0



