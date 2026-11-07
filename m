Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063307;
	b=ot9vPk8gSaO4+i8WwihjuC5OK+ff6cuPbmkC3EEe9co/b75SoMZNvNQWsozR6cteQ4JZ
	 rCcO/5Zl+2VCBgBE8dLSPhZP3DQl339WYprffH/SPTtJXeRP1M9WvrmE85WIhzMYpWfLS
	 DQZ71itfrtPtbIn4oPc/EZwmbqNo8MFgrzr26y6s7Z/mTzCk3sdw0JNOnDDtdNTyaRyxs
	 KC9e0xZfOl5o9eQwIAZqZurm1LwQlBV3LGxm1tfHcmd5DxtPEh5NC91z15TwPoVT2eYTJ
	 JNnhQuDcTQUOcrhyMBhsLr6aNzWKkRl/LDUP1OoNYCQ8aOlQXrzVMuCddybijElZ6DQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063307;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=r4K2+eUMZO6z6HtWDF0e+AUGDdlm3ZNjd8ktG5gWDVQ=;
	b=fHD6bD7aQ0uMMGePESNEu+7KdLOJzpvQ/eJw5DRHLOdtnTqQsrme+IC7U9w6pexqDqwm
	 wbRt2IqXN3NBHOhkNor5X1ylAwB91CfMmJaN3uNhzyJ+TNDyFf8ZyWMKT+HyyS95uS1Ys
	 Tj17WJRu4l7gO5zc3nnYWc5RKOIWT74fXlql+ZalW5bNIH56VEaCZoCA3OGSyEPr7aHuV
	 k9OUJsQoNDnZsad40M3NRd+Ph8tCfS6iYrqPnPaFagdBRioA5TDXOXv2REB14oN2On1XG
	 C4b7TxflGYMQt1X3Ehu2lKDxGmlwtuUN+h/cKVXtXG7ZjiqqlgC/A9P2MCTFNBpL02w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AGmAXT4i;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BD28606EEB9;
	Sat,  7 Nov 2026 14:55:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AGmAXT4i
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E231F1F008A1;
	Sat,  7 Nov 2026 14:55:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063307;
	bh=r4K2+eUMZO6z6HtWDF0e+AUGDdlm3ZNjd8ktG5gWDVQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AGmAXT4iBvGyNBEK4toTwu9zg3Qn8bLHWg7hfQ+b++Rv5Y6qbdFNAcOAtd+naDWEq
	 j7CWCpwaXdRFgnE5BIj0Wt/p7t/KKoUQMyzk8jblbYFx3iJuyHcr+nNIFtgV3quQn1
	 oU5JeAs1Kh9rDm1hWSHzDBIWuCiNNlO+65uQzhJI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 496/869] platform/x86: simatic-ipc: fix platform device leak on registration failure
Date: Sat,  7 Nov 2026 08:52:58 -0500
Message-ID: <20261107134910.351724215@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/siemens/simatic-ipc.c | 21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff --git a/drivers/platform/x86/siemens/simatic-ipc.c b/drivers/platform/x86/siemens/simatic-ipc.c
index 7039874d8f112..4a4509fc9263e 100644
--- a/drivers/platform/x86/siemens/simatic-ipc.c
+++ b/drivers/platform/x86/siemens/simatic-ipc.c
@@ -92,6 +92,7 @@ static int register_platform_devices(u32 station_id)
 	u8 wdtmode = SIMATIC_IPC_DEVICE_NONE;
 	u8 battmode = SIMATIC_IPC_DEVICE_NONE;
 	char *pdevname;
+	int ret;
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(device_modes); i++) {
@@ -139,8 +140,10 @@ static int register_platform_devices(u32 station_id)
 				pdevname, PLATFORM_DEVID_NONE,
 				&platform_data,
 				sizeof(struct simatic_ipc_platform));
-		if (IS_ERR(ipc_led_platform_device))
-			return PTR_ERR(ipc_led_platform_device);
+		if (IS_ERR(ipc_led_platform_device)) {
+			ret = PTR_ERR(ipc_led_platform_device);
+			goto err_unregister_batt;
+		}
 
 		pr_debug("device=%s created\n",
 			 ipc_led_platform_device->name);
@@ -153,8 +156,10 @@ static int register_platform_devices(u32 station_id)
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
@@ -169,6 +174,14 @@ static int register_platform_devices(u32 station_id)
 	}
 
 	return 0;
+
+err_unregister_led:
+	if (ledmode != SIMATIC_IPC_DEVICE_NONE)
+		platform_device_unregister(ipc_led_platform_device);
+err_unregister_batt:
+	if (battmode != SIMATIC_IPC_DEVICE_NONE)
+		platform_device_unregister(ipc_batt_platform_device);
+	return ret;
 }
 
 static void request_additional_modules(u32 station_id)
-- 
2.53.0



