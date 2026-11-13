Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590800;
	b=0P+IEoEfpuZz52nNtEWqhipOHdVMxa0uNTcaV8aksMNWTsuZVc/SeA/dqydQzqG0jfOY
	 I7sOLaiia+ndLIXHnwwk2C/K8HN3SDb6fEPNHt+p086eZMqq7EDdjxdz4yyA4NIM384ak
	 /QOcmpvDu8AzXaSQtpyPSU3KmaU+9I+zb0Ux/RGEvZRvBMJJ2i9eAYB1pENbo+hEHliOX
	 bM5s4eUUoxQ6yP6x2K/iaMrRqJ7TVn0OGhcSM1LYM2t0+rLEMmFi9xewVLjneBAlj2uUj
	 1jd03xAly9Iay92SE3mDwslmFG9w9zqdf6dw8D7Ju6HX3UiadtVU6e/DLN1U/Dowi+g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590800;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4R3c6XpFCR7mSGl1goq6e/IY2Rzh0Qf8ABBxhjWgtR4=;
	b=pIhgdchKVB68hvGZlj7AdKaiDgEYNcft9dwSfGzXr46Z2UYB0kypcKfk42OTZjka5y8i
	 Hdw3NEDHlqkQxBnccBiA5rvTf1hObwfZJTGA6qNbe+dPH6Dtw+uhsO3EuRGtGtjHZP8JT
	 VmAeju8xzIke8HTzt/A6IJT97SfRJcZxZ1Knhy4QFBlwR0YehBgy5DnUqBvvlYk4X2HA3
	 hl7DPuhCpNdVymO6OoIzMIFq+Z3xVtTo6mug67k9FkNun5LYGPu5QBMaq+lupQo5skoHv
	 IzhQs0OJ2EZSsJbGcNMw7TRPMRPnCMiZRTTwWkyD5OlbRdUVdfewfljNJw7ndewT7Zw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DPqv8beQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0294E607D2F4;
	Fri, 13 Nov 2026 17:26:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DPqv8beQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2B8D1F000C5;
	Fri, 13 Nov 2026 17:26:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590799;
	bh=4R3c6XpFCR7mSGl1goq6e/IY2Rzh0Qf8ABBxhjWgtR4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DPqv8beQRNC8fkdTTcPyTyHlbhKcZ0T33q6WQl4T2QRtMPHiI/MyAsWTzwuyoiRr0
	 8etOyLXj3OavqENDiFCMmXMnS5QY4sbgVmCa9g1jolXD/z2RkxsbJWHdfrOIfOPIGY
	 krVx3MmlZUAhav7yPCqBkPxEgyg8p7+K3dU36pcA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steve Wahl <steve.wahl@hpe.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 652/686] watchdog/hpwdt: Refine hpwdt message for UV platform
Date: Fri, 13 Nov 2026 10:53:05 -0500
Message-ID: <20261113153843.852240545@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

From: Steve Wahl <steve.wahl@hpe.com>

[ Upstream commit d8207d1e9a36b1a8a461581b2d4073ea28335603 ]

The watchdog hardware the hpwdt driver uses was added to the UV
platform for UV_5, but the logging mentioned by this driver was not
added to the BIOS.  When the watchdog fires, the printed message had
the administrators and developers looking for non-existent log files,
and confused about whether a watchdog actually tripped.

Change the message that prints on UV platforms so it doesn't send the
user looking for non-existent logs.

To aid in any future debugging, include all 8 bits of the NMISTAT
register in the output, not just the two bits being used to determine
this was "mynmi".  And provide names to the bits in NMISTAT so the
code is easier to understand.

Signed-off-by: Steve Wahl <steve.wahl@hpe.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/20260318155005.90271-1-steve.wahl@hpe.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Stable-dep-of: ed9e4c1ff15d ("panic: restore variable arguments to nmi_panic()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/hpwdt.c | 22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

diff --git a/drivers/watchdog/hpwdt.c b/drivers/watchdog/hpwdt.c
index ae30e394d176e..ba08189937ec6 100644
--- a/drivers/watchdog/hpwdt.c
+++ b/drivers/watchdog/hpwdt.c
@@ -22,6 +22,7 @@
 #include <linux/watchdog.h>
 #ifdef CONFIG_HPWDT_NMI_DECODING
 #include <asm/nmi.h>
+#include <asm/uv/uv.h>
 #endif
 #include <linux/crash_dump.h>
 
@@ -158,24 +159,31 @@ static int hpwdt_set_pretimeout(struct watchdog_device *wdd, unsigned int req)
 	return 0;
 }
 
-static int hpwdt_my_nmi(void)
-{
-	return ioread8(hpwdt_nmistat) & 0x6;
-}
+#define NMISTAT_EASR	BIT(0)
+#define NMISTAT_EWDOG	BIT(1)
+#define NMISTAT_RTRAP	BIT(2)
+#define NMISTAT_DBELL	BIT(3)
+#define NMISTAT_EMSWDG	BIT(4)
+#define NMISTAT_GPI	BIT(5)
+#define NMISTAT_NMIOUT	BIT(7)
 
 /*
  *	NMI Handler
  */
 static int hpwdt_pretimeout(unsigned int ulReason, struct pt_regs *regs)
 {
-	unsigned int mynmi = hpwdt_my_nmi();
-	static char panic_msg[] =
+	u8 nmistat = ioread8(hpwdt_nmistat);
+	bool mynmi = (nmistat & (NMISTAT_EWDOG | NMISTAT_RTRAP)) != 0;
+	static char panic_msg_default[] =
 		"00: An NMI occurred. Depending on your system the reason "
 		"for the NMI is logged in any one of the following resources:\n"
 		"1. Integrated Management Log (IML)\n"
 		"2. OA Syslog\n"
 		"3. OA Forward Progress Log\n"
 		"4. iLO Event Log";
+	static char panic_msg_uv[] =
+		"00: A watchdog NMI occurred.";
+	char *panic_msg = is_uv_system() ? panic_msg_uv : panic_msg_default;
 
 	if (ulReason == NMI_UNKNOWN && !mynmi)
 		return NMI_DONE;
@@ -189,7 +197,7 @@ static int hpwdt_pretimeout(unsigned int ulReason, struct pt_regs *regs)
 		hpwdt_ping_ticks(SECS_TO_TICKS(val));
 	}
 
-	hex_byte_pack(panic_msg, mynmi);
+	hex_byte_pack(panic_msg, nmistat);
 	nmi_panic(regs, panic_msg);
 
 	return NMI_HANDLED;
-- 
2.53.0



