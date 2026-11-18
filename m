Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051101;
	b=z0bOpUIha/Eey4wNEaQWKqNdTgN+Yb6zDaBbIW43Mn3c+/wUcDy7kd6Bypof1dtcYajz
	 x0rDkXA3+f15rKo2mnkIyn1kKHXT9mkz1c+DSnIMP73BqaVikmYCq85vPKTZcM763cif4
	 +rFxr3iI9ILIiiGfi7c5jMg+zgSc6JFmos+4MjoOxDpZ5pU4f+omXld0VVODyOPF/wEOT
	 nojLlO/Eq5CotqVXnlN6S2ttMyeS2z7DhF34615ov3oqOYto/O4UKLas/ayeOQaksqE+Z
	 dM1LIr6u9iknww2H44kmQ7cd6EqzFcdvmG9i8By/k3AXgODsSf0DSDqsmY/cY1JjBvw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051101;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lMDqHJ+RQQeQzP4o2aDzvlxLXqnkIKaEik6fXEPxn9I=;
	b=P4zFVEbmmnklUALUFJ+2unzZxU7iGETCB3gINT920BH25XjVjDh4GU+XIUn9MZFv9UY7
	 XLhSmDvWrbV/58y7LCuodFBWmCahsU1aPDumoqBqFa+wjIN/v1KBf5aPikkPDaX8/IcfS
	 8vieKlVPL97oyHSOMG2Tt2M6mmRgiAKHqZrPOFg0EkzFfcpQQiMPGUcL/ArcW7TtRtqz3
	 KqiSU4wBbFlKKZb8KhvQbLNLCHE3iG3c/p/Dns3wIzuHuOXNEveNJG3+RpmwwJkKB1cTT
	 Du7Ry83560uR/aPJVthqGJ5QlM2sD53xz3/0tCwJ0rzVCKNOYaPfcRCCMR2JYz2WkgQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dnZNiqSY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1DC2606A320;
	Thu, 19 Nov 2026 01:18:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dnZNiqSY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E5321F000C4;
	Thu, 19 Nov 2026 01:18:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051101;
	bh=lMDqHJ+RQQeQzP4o2aDzvlxLXqnkIKaEik6fXEPxn9I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dnZNiqSYF2T9cXEFpFas8j8EHc+xnrkHePPta2fK4dBOkE7fU2aU72qcXFrpxQivE
	 Sd6+V8ccpicUr5zu6H+s/2xeNzCir2uFjNvcR+hvT77Qye5wD9yotaqdbdtAxR8ZNN
	 BM8wYliT/SfX0WRtIaA3oJSXomBmGIW8jw7JmTjs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abhijeeth Babu <babu.jeeth@gmail.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0038/2214] i2c: acpi: Force ELAN1300 touchpads to 100 kHz
Date: Wed, 18 Nov 2026 15:28:34 +0100
Message-ID: <20261118150011.594905708@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 3fabf4b1f6fd4..93bd78137ea67 100644
--- a/drivers/i2c/i2c-core-acpi.c
+++ b/drivers/i2c/i2c-core-acpi.c
@@ -344,6 +344,7 @@ static const struct acpi_device_id i2c_acpi_force_100khz_device_ids[] = {
 	 */
 	{ "DLL0945", 0 },
 	{ "ELAN06FA", 0 },
+	{ "ELAN1300", 0 },
 	{}
 };
 
-- 
2.53.0



