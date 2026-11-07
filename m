Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063851;
	b=4quky1QnW1goD0FRsq+9TKUbXQQIRMLqrVQ+12AQEwgMf27oo4O+eqo6SXXyYGgvOtaT
	 yp0sDa2fTF7vZ8qyROARsZRJ/BikGz+O7IvcY3wH/RDUC7aiCd+5SJWkBnf8eX1PG6NTX
	 /pTJZN46dx6VGznwNEdmGZ3ELQyVsMIeH/++YTbjsOI+0CuE8bY1baBV1IL1UBKMv9Xhh
	 vo7rXEwnYkD3rzaaqqkHSfQKte1rH/nj6EP2eGiJW1Fj7gfkrqbMfYIIfGGGmu7tnDU3W
	 F3FVCbJwKzMciM7CuThwf9XA6xE7MVoV2lAUjLaftg8Kprrw9o6KpOPHuiAy/BoYtPA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063851;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=q7AncIuv2aTF9efxI4uC4XcMAEGa9qMs/9IrNUUmbqs=;
	b=1Q+5amVKytKUeIci4aigiUv0U7zDSbytL6mC8rkAnF+RE0EIPlh1yIqrqi2rto++gi0L
	 pJaCVkvH0QLK8C9csr6wgXte2GBteGqlu0hR/gNPPidtLwJ1K36ssS3MvrF/DyEiMCCnc
	 TCx0M+TYOxZR/7jn4KvyIGM2XzwnKoTZ7aMlUTS1iDkh6lfWCQcCx+U3PPV9sPeM5yiR7
	 sjdzd3H+qxf1XTx6SfDL8uyT1b6jnJDpcFYcvDXXeTeodQxaUrWUmQYqiZqfJorLD69V0
	 tyJ6RjE8tvXdA21lbDpnLRONqAONMcpt1Iajyt1f0YiicPoJ+9wENBzly+frz8QbFyw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I7IHvbyE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B3AA606A9EE;
	Sat,  7 Nov 2026 15:04:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I7IHvbyE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E06601F008A1;
	Sat,  7 Nov 2026 15:04:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063851;
	bh=q7AncIuv2aTF9efxI4uC4XcMAEGa9qMs/9IrNUUmbqs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I7IHvbyEb3wX+r4S2Ec7b9d2cfgNdnQ9eOXksnnvqiAPic2sD0o8oJwgT+wgc5FNY
	 RyVDwiaag60okG0VG/AzNnBp7yTTWPa7rabdSbgD526JOxlknduLc19ITB6LNTRlXJ
	 Iag5c/r55vOnJZv+HdG6X3FbXyUTd0az/U8yfZG0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Alexander <opensource@inspiredexperts.com>,
	Hans de Goede <johannes.goede@oss.qualcomm.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0061/1257] platform/x86: int3472: Increase handshake GPIO delay to 200 ms
Date: Sat,  7 Nov 2026 08:39:17 -0500
Message-ID: <20261107134941.086207273@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: Hans de Goede <johannes.goede@oss.qualcomm.com>

[ Upstream commit 844982d3b99340c21dd2125f44e1ad04ace6a38e ]

There have been several reports of the sensor not properly powering on,
on laptops where an INT3472 handshake GPIO is used. Both with ov08x40 and
hi556 sensors.

Testing has shown that a delay of 200 ms is necessary in some cases.
The handshake GPIO is typically used to signal an extra bridge or other IC
with that IC running the full sensor power sequence based on the handshake
signal and also possible controlling I2C pass-through.

It seems that in some cases that extra IC takes up to 200 ms to before
the sensor is fully powered up and ready for I2C communication.

With the default handshake signal delay increased to 200 ms the quirk to
increase it to 45 ms for the ov08x40 is no longer necessary and is actually
undesirable since some ov08x40 setups also need the longer delay, drop it.

Fixes: 30359c239ba8 ("platform/x86: int3472: Increase ov08x40 handshake GPIO delay to 45 ms")
Closes: https://lore.kernel.org/platform-driver-x86/20260816204247.2844986-1-opensource@inspiredexperts.com/
Reported-by: James Alexander <opensource@inspiredexperts.com>
Closes: https://bugzilla.redhat.com/show_bug.cgi?id=2333331
Closes: https://bugzilla.redhat.com/show_bug.cgi?id=2333647
Cc: stable@vger.kernel.org
Signed-off-by: Hans de Goede <johannes.goede@oss.qualcomm.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel/int3472/discrete.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/platform/x86/intel/int3472/discrete.c b/drivers/platform/x86/intel/int3472/discrete.c
index 9cd4f78875abf..6bc0ab3e8d1f4 100644
--- a/drivers/platform/x86/intel/int3472/discrete.c
+++ b/drivers/platform/x86/intel/int3472/discrete.c
@@ -15,6 +15,7 @@
 #include <linux/platform_data/x86/int3472.h>
 #include <linux/platform_device.h>
 #include <linux/string_choices.h>
+#include <linux/time64.h>
 #include <linux/uuid.h>
 
 /*
@@ -178,13 +179,6 @@ static const struct int3472_gpio_map int3472_gpio_map[] = {
 		.type_to = INT3472_GPIO_TYPE_RESET,
 		.con_id = "enable",
 	},
-	{	/* ov08x40's handshake pin needs a 45 ms delay on some HP laptops */
-		.hids = (const char * const[]) { "OVTI08F4", NULL },
-		.type_from = INT3472_GPIO_TYPE_HANDSHAKE,
-		.type_to = INT3472_GPIO_TYPE_HANDSHAKE,
-		.con_id = "dvdd",
-		.enable_time_us = 45 * USEC_PER_MSEC,
-	},
 	{	/* Sensors which expect "vana" as con_id for power enable */
 		.hids = power_enable_hids_vana,
 		.type_from = INT3472_GPIO_TYPE_POWER_ENABLE,
@@ -273,8 +267,8 @@ static void int3472_get_con_id_and_polarity(struct int3472_discrete_device *int3
 	case INT3472_GPIO_TYPE_HANDSHAKE:
 		*con_id = "dvdd";
 		*gpio_flags = GPIO_ACTIVE_HIGH;
-		/* Setups using a handshake pin need 25 ms enable delay */
-		*enable_time_us = 25 * USEC_PER_MSEC;
+		/* Powering up the sensor through the handshake pin takes up to 200 ms */
+		*enable_time_us = 200 * USEC_PER_MSEC;
 		break;
 	default:
 		*con_id = "unknown";
-- 
2.53.0



