Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047128;
	b=g4eCSoskSVJvKXZjJpwn60EXY/UiaHKaX6HCNM/ipbShza80xVlelXRUooXDOW+KNGyB
	 xttQBCRxHvZ4WqYaSntwbjxDpISwareLBYrra64Zztu9WHabt+pTy/t3tTBYeFaVm7mU2
	 z0S8zax//KkF7rtQ4zOvJTInKVvcVp24X4aeZa9Zwj1G86HXFyp91uqhvwnTMOVVRwTZi
	 Iz6GYQBL9DkZbuoqXIENeh5I86XVWbpjHr39QpgkVb9rsdEOChlh5iIgYN1LDSWpX4zQa
	 YdAu6I/xHAtfx8vj3cE4uB+2DFMKS6EGnAg/5xGVObURBVdy/T6D9XZ1l5wWB63WO1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047128;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=wMgrbmw56w0DFRLZv/G9u70/6jtO0WsePohaNRwSW3I=;
	b=S2X9nuRgriPkpANbi2+C7r7oMQjZRJbiGZ2Q9ChZAkKAxnw1RaT88poV1akzU0RUCMJc
	 NTnwqYWZ7ur5srZ7YXiPYHYtv6ZzDRChBkSqzhVQsMeDDq4cqJz+Dg74AgUcIZZfsv2MI
	 FICToWl1ABpwgoIGmh9+nL9mOI29IQxOr2IZWvprOVmPLjWyCqsrCyHpxK9W7jf1g/Jef
	 6c0xqYhAYZHLvILLcZDQ7yssaIcx5MzJ7jPnqFC6b1ull5EWgrKCSEbVIFKhQEfDKKdpy
	 MXp6/NhPVkPlB7TkKeVzgZiRvJdGHD2laJ/9RCUw8Ky/9IspkcRuQjaIv5jdpoDNgBQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S6ZS38aN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4E8E606A31C;
	Thu, 19 Nov 2026 00:12:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S6ZS38aN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1930C1F000C4;
	Thu, 19 Nov 2026 00:12:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047128;
	bh=wMgrbmw56w0DFRLZv/G9u70/6jtO0WsePohaNRwSW3I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S6ZS38aNCMK6GZbJRV/gUQwgUqBbL2XG/D2ldrhHjCMpJANGoxmyPrVPdR24+N/tp
	 GL/gbwVytq4owb5qNSIUFBaI1tKMO4RMtjCVH2vaX5u3DkHUB5gCYb+zRaHKF1glZ6
	 K4LT4rDDVMr3Q6YFwRkaAIiyhnMji14Z1MHy/YGk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1528/2857] platform/x86: simatic-ipc: fix platform device leak on registration failure
Date: Wed, 18 Nov 2026 15:42:42 +0100
Message-ID: <20261118150256.339397782@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guangshuo Li <lgs201920130244@gmail.com>

[ Upstream commit 9523698252fd583d6987582b9c34ec6500d10986 ]

register_platform_devices() registers the battery, LED, and watchdog
platform devices in sequence. If LED registration fails, the battery
device remains registered. If watchdog registration fails, the LED and
battery devices remain registered.

These failure paths leave successful platform_device_register_data()
calls without the matching platform_device_unregister() calls.

Add an unwind ladder to unregister previously registered platform
devices in reverse order before returning the registration error.

The issue was identified by a static analysis tool I developed and
confirmed by manual review.

Fixes: dd123e62bded ("platform/x86: simatic-ipc: add main driver for Siemens devices")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Link: https://patch.msgid.link/20260924115617.1578309-1-lgs201920130244@gmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
[ sashal: omitted battery-device cleanup because the driver lacks battery-monitoring support ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/simatic-ipc.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/simatic-ipc.c b/drivers/platform/x86/simatic-ipc.c
index b3622419cd1a4..10060959e5aff 100644
--- a/drivers/platform/x86/simatic-ipc.c
+++ b/drivers/platform/x86/simatic-ipc.c
@@ -55,6 +55,7 @@ static int register_platform_devices(u32 station_id)
 	u8 ledmode = SIMATIC_IPC_DEVICE_NONE;
 	u8 wdtmode = SIMATIC_IPC_DEVICE_NONE;
 	char *pdevname = KBUILD_MODNAME "_leds";
+	int ret;
 	int i;
 
 	platform_data.devmode = SIMATIC_IPC_DEVICE_NONE;
@@ -96,8 +97,10 @@ static int register_platform_devices(u32 station_id)
 				KBUILD_MODNAME "_wdt", PLATFORM_DEVID_NONE,
 				&platform_data,
 				sizeof(struct simatic_ipc_platform));
-		if (IS_ERR(ipc_wdt_platform_device))
-			return PTR_ERR(ipc_wdt_platform_device);
+		if (IS_ERR(ipc_wdt_platform_device)) {
+			ret = PTR_ERR(ipc_wdt_platform_device);
+			goto err_unregister_led;
+		}
 
 		pr_debug("device=%s created\n",
 			 ipc_wdt_platform_device->name);
@@ -111,6 +114,11 @@ static int register_platform_devices(u32 station_id)
 	}
 
 	return 0;
+
+err_unregister_led:
+	if (ledmode != SIMATIC_IPC_DEVICE_NONE)
+		platform_device_unregister(ipc_led_platform_device);
+	return ret;
 }
 
 static int __init simatic_ipc_init_module(void)
-- 
2.53.0



