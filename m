Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829332;
	b=tdhUCUZX/Bb2Y/j1X4itnKv5eOL2A0fOdzpqyUZDLDkVM6avb54AMMvytSs98RD+wLi7
	 Is7hQf0ZRCn0hsrcGOawFbOX0SqEsPo6+SvY26xln45c3WGw3Tqjxw6kiSufXSAY/aHcI
	 12YjF+PXt+FFRDzRLw3HCoTDuNdZwJrQAtkIVg2iG/VM0snizpUGfXouMe6Pi9/LS7Kcs
	 gkLh3UlGTaVkmPm0Hw+zq+ICwlEiDbGfcC4C34pAmxXLfsdomSASuCMM3+t9tGHqGZRUZ
	 P/Loh3cLQZORg1CFaqS2Bz3VL/SuWpn14W3XCVOHs/L+zZ1DUIgqV73F2ewgid3qDrQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829332;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xxLzd5qB0FKXCaNJixlGWG1KNV63pKuNmF6i+9srh+U=;
	b=PAhQN6Xa/yaJSC83NTUjYgK2OlcA0LSNhe4j8iBIk+Dv6a4wPPdbh5AvihiaQ/HBy14P
	 Bz5CP5Vd1gjbkMrGMNlHSsLYqS3f0KwMMQ6yP6r0Qbcfni30aSuTERQN046+sERPIH0a2
	 +IasEinDi2zpQPhPplfCP6Q9jxqn4jm5Gv734Z39PHSzcTW8WZCoFlcRnOtpL7fuPbCTo
	 j0RCGZ1Fcz3n+wPXRUU23iGcnRR+wG7rFvdWtXjqtLJacHiBJiuYLNpaRGFWTXCGBs3A0
	 db9Se4MybAfG98lx0dhcJYm/yGql4Fw3OVBq31hCTA7qGosXXpcbzMUvKES06k7v54g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lvldbfl5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7434A607491D;
	Wed,  4 Nov 2026 21:55:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lvldbfl5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 143881F000C1;
	Wed,  4 Nov 2026 21:55:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829332;
	bh=xxLzd5qB0FKXCaNJixlGWG1KNV63pKuNmF6i+9srh+U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lvldbfl5vu1mn4+uHdQr0b+eZA6YrLdjHP4HUQrLF1qWpzMR26OnXsVN7aqrqL1ln
	 +CYmde39GS3ZsVYf8kTag0gBO4QI51JUcd5hZxIYvqtMfmrOoMy8XzimMY5WG8LK3f
	 iCPr7ss59MrqTccRhhQZKT96nzgiYxLAihqYTRgo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abhijeeth Babu <babu.jeeth@gmail.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0060/1005] i2c: acpi: Force ELAN1300 touchpads to 100 kHz
Date: Wed,  4 Nov 2026 15:56:33 -0500
Message-ID: <20261104211045.276779838@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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
index ed90858a27b7b..98ebbc973f212 100644
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



