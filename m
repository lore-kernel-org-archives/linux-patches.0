Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060596;
	b=u7lsHk11fh6dz6EJi3UTQ8fYibp16saip22s0hNp5NAXT71KsGhDbE5GetAS7xbynT0M
	 miY29wKpX+QFmR0l4D/oSPsvIu9Hd6jg+p/H+r7evos45hVGYccpfGDlfTE+MMmYcFlWS
	 TqhmCJ2arp1LMLNdeSgDZjcniEELLvZo+VAUu1KchvHwrvw038EKYyRU2gXepj+H3ykfd
	 VJKE6d+XcRCCrlxXiGZcmBU8pNdpJznJRpFncblgrBtlloecFHNMhho0rCgxb0Qo6uhhS
	 l7Y9Z7yyXi6b6OFVQB/+1lCslgN+ASez5bNqr1kfhCUj3iUcA7Z2UScfJfWbUKN0yQw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060596;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OhOH591EYH3vH0d9Hx+B5VUQQo7aNJbm+xzWKi6gZ0I=;
	b=aqIi8ndDgvih3gsJsqFcb6Dq+7xOtk9C7v1EZtEwY4B4gdz7GPHCMJvVCcnYYHL9eeYI
	 w8pD8Ebe4AtOGZByajIGCv1S++jGjsVQa6RjNUtpPAUuh3xFp07RDWOgNh2mlMgLkmHaB
	 g9L4RThmHb4hBXcM1sB1X95RG21TkPxdvLsXuSBFzWdHSQTViQsgxVRkZpYwMCwdpag+7
	 cSrxvFiFHkYCMVHrBX7XnNgDC4SB4dMA3hLmxk3chZeRvCrQ3WpcqvU6G84ueSykKx9hM
	 Wj8MSg3w0kGsEOEw5XJ1eeY0eBZyCn3AP99T6Z97HPeGrtACOc2+4/rix39RiC2djng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bA87pC1M;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62DC6606A326;
	Sat,  7 Nov 2026 14:09:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bA87pC1M
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A2B01F0089F;
	Sat,  7 Nov 2026 14:09:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060596;
	bh=OhOH591EYH3vH0d9Hx+B5VUQQo7aNJbm+xzWKi6gZ0I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bA87pC1MEzLKrROq5MXu83jZwBeFP3y4Kpk7thd0Ko+A7nkhb734ZLaGZwf+5E8SV
	 ZaqW75BI/L4BMwlWBEy2JLQzrPDQprQA58SBrEbKP4asmuTfmSdIBFyiRO6zLlMVjx
	 vN2n1prCSpQcO1gLT1JhsUAwpaYbO469d5AYjfV8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abhijeeth Babu <babu.jeeth@gmail.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0052/1536] i2c: acpi: Force ELAN1300 touchpads to 100 kHz
Date: Sat,  7 Nov 2026 08:34:28 -0500
Message-ID: <20261107134959.120375163@linuxfoundation.org>
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



