Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064682;
	b=sMKolf2hcQp97fjmIfAqe+ifNDSF9vmgJV2CC3JTfbJw8ucwRygH3R8zW0OUW3kObkwY
	 9T8kbS+g4+QhDRS0eO7bEMkvHHm5uTJh+e0ahXL+Ryu3kUqtq4gf7dJxPcmuk79A5/gd2
	 Ao+T+ba/+Sg+m9eO8Z6vc4iFK2v0ppEFGkHd+0byiAd40exCiZ+hIm3FYmU5qzrof3+/M
	 58H3PivuHQR+wcYfv6lu4ZU4J21ucjT/2ps0m93GBU0DNHbj99hvHNp8dX8+nG29JCOeI
	 OP2MmDNBHe5H5Cqxc6bcgqBO0KiIU2fW4aLVeRYNAuEttN6oE2flB0johIA3HmtSReg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064682;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=NrO833E0MFzkNHI1jH/yC+1FKU+LU0fKnetC9dKTOZk=;
	b=WqTu7NAwBhmRrtzNukiVTV7K1qIzADJd3M7S68MBjG2iZYxGB5Msqn7lNor9vpWnxbIl
	 ZyhFZ/t1+7V4fr1cVUQpfiKXzXmFBCdnKpO4Qufety1mheSdphSDYQhjTIjVBqtKmlFJK
	 0hhnOighjLdbAUcBM8DLSoiUUNLFymEkksuVGP0HgizRi/+V67VTE7jHNZSCPmBAkc5zS
	 +2fGY9n2YvUdLALyfYfEyHqMUePF2Zh1aJWG+RNIGdqaCdQCuHmFuD7lyrqOQQM62JGJ9
	 2yCqFz2mLOvtXakdoDt7u82gcKQ/8IepJV/K06I6uRsetv9/rYCFZ8ZmPPvYV88Db+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HfCZz3g3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E5F1606A33F;
	Sat,  7 Nov 2026 15:18:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HfCZz3g3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 760911F008A2;
	Sat,  7 Nov 2026 15:18:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064681;
	bh=NrO833E0MFzkNHI1jH/yC+1FKU+LU0fKnetC9dKTOZk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HfCZz3g3r5zFcVlq1VLTEN3hIK78cmnyLDG9ko9Ce062VaJrACvGouryVKyu0ADi5
	 EE863VazkyB4wojFfq1Jm7KMvk3+HFBi/hWyCPzBKDB+wnOj5XEnERjHaMfGtEaBGT
	 TJHGxI8M4tK5HvpqjoeN5mA3CCjzRHBNN0Z5vdPo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0677/1257] platform/x86: simatic-ipc: fix platform device leak on registration failure
Date: Sat,  7 Nov 2026 08:49:33 -0500
Message-ID: <20261107134957.959233623@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

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



