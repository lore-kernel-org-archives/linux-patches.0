Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590553;
	b=Q9c+KtZq/Oyz7ry60F9N9YOueVCc3j2B1oyaCBD6LgQsJ2uuR4/eDUIF52nclfJSNx7l
	 fwMC2NtfmziBaCo9Em5XtxW+d92w9nHOtN/RYGCtJMJWO+hK29/q8uzWVczwgOUWvt1YF
	 KBPZGh0vqFJiAlFwJuvC91sp5M/vvkp7PYemccdPkRozhhul0z/NWIvQbFiVQCqPpoWk7
	 frNOhxQkwhXEXeAx6IHJUCVYiCUyaQQmpYz5C6Ndd0dEPb9jiSvWZzCF9GOkg6WqCxuXS
	 hsH7mi1oRArvHEuIXEl2KkYGJPQ5HbqvLD2Zn5MCwb6OIn+n5NQ5tRgVnFVw8YretaQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590553;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2iM0FgaWpgZ5ixmupriCWi36TdB0oUhgVhibyN9E2Hw=;
	b=0ThdUIP/RMk0lpK+VoSMJCxTkQ0aNg/M3gHqwBXZBGYMm/BwXHSR6/VvcsyP1BIixajV
	 bmbZRESZ9iaCzVanEWLNHkJO17YMlKSDl4iI7Uo4QHOcu5yXByDUfkexgRxeoQ5g2MACs
	 XlUytraEDPHD2C3Bt3KcQFWAOWO0v1c6pBTn+J/nXpybr1lntcT4mFaLwShC1TBleqYPJ
	 M/dVR9ZyDAws1nXW4NnHhE8OKFoe+Xc6yK1yIUJ863oQt0DTAL8RGq8dmntLDSYtA9b++
	 nP9sFwrYupsDJfs+lpjA4uIpZDWSwOa6DWSpO2VD3QyZA7bwoVh0VToJlAv8QGMPK0A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="ufF/dMj7";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DCDF6084356;
	Fri, 13 Nov 2026 17:22:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ufF/dMj7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19F0C1F000CD;
	Fri, 13 Nov 2026 17:22:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590553;
	bh=2iM0FgaWpgZ5ixmupriCWi36TdB0oUhgVhibyN9E2Hw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ufF/dMj7u0N4KR+4yPWsce1Q4IAZkAvchKDeEBVqx935PqkCXL5rA70Z4JVJOO6Bk
	 7IA6DcpyAMp6QTls0xjJdZW51K28GPjAC+EqQfzxfgYQ+PE0+VOcZpxVFjGYPiIe8C
	 Vd4wQFBUsldU9eXSkoGuFVHpkOkLCUIozKkIN+/A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Alexander <opensource@inspiredexperts.com>,
	Hans de Goede <johannes.goede@oss.qualcomm.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 490/686] platform/x86: int3472: Increase handshake GPIO delay to 200 ms
Date: Fri, 13 Nov 2026 10:50:23 -0500
Message-ID: <20261113153837.546496386@linuxfoundation.org>
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
index a4c24f1cd0a4d..6ebfaa141a42d 100644
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
@@ -259,8 +253,8 @@ static void int3472_get_con_id_and_polarity(struct int3472_discrete_device *int3
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



