Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032582;
	b=oHDrLbeUT6nQU03xki98UcOPtWkGq/NhY5WsvLFAAL+7EwcsO1n58TY4QVKlBGlI0bgp
	 isS3Tgay5WhuLf7OC7d7o+BYJYb2NRcQyCbgWCnWwoiI+lx6cRYflFdG16WWrK8Tdgwu2
	 IV3V6c+B70SdUD1WewPVYmKH7iYhJXr0QuevlPKVLvc3ng9GYjZtXeIZTo8NzcMMf/qf2
	 CB1AaST7IC2sh+l7U0U2xHnRSMhKMENRwniio/WipggUD30Z868kB1ZfGAghZ0cmlJ2ce
	 f7v19EH/MOvkxuHCbKPWFX+jdYAKIvcOx/vHls1DA8PfVI29R/SNo5Oe9jncIKNdZXQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032582;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=Pp/vUgNhm/v765pmW+HzMU90Cd2y/EtP6PzPUW98x0k=;
	b=zM6Pm/gDfKEXXoDBZxFVnINy/tm4DPBCTZ4R+lOKV/doPGZ8gULP9WInIBoftW+Y+yk7
	 v3Cb1R1bil9idpEhdemVJpZaSc2jcQwvib7S+dnfS8d6CO2yOqXJ8BbxG/DeTbqVzKsnu
	 C5wmar28lTX1Cl7OwAIsx6UcCTBPeCrY0Q3m+Ml6Vax1k4ZNpchBO3GQEtl47Ax2SP0lu
	 KEqHDoJQIAhvdnR8vxeiveGRKF1ZXFCxHSExUbCZ5bsdAMT6ZHHOL3sHokxFb8DXKkOUy
	 NBSUPXFw3JbWc19uV/3fajMXN/HsnHNv3r4v7lkfpDB8zB0v0H2BdOwNosLz7k4Yjfw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Vritzfhq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19FDE606A31C;
	Wed, 18 Nov 2026 20:09:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Vritzfhq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A6251F000C4;
	Wed, 18 Nov 2026 20:09:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032581;
	bh=Pp/vUgNhm/v765pmW+HzMU90Cd2y/EtP6PzPUW98x0k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VritzfhqpflylxHqXnvzTSvIGfVpDnhEvd6bUZRmvXCUfTJkTgtgPS8N/l3hvA5z9
	 2xAlMx3Hwuit/vmwfMooQ9F9UXAnDX9qrt4spmwLVm+e5UpXN0qLfALRQllu7qBeeU
	 vM1SgsE5LgaBiYVCOWEcDclScgcHst7XipPxoZr0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1460/1756] platform/x86: gpd pocket fan: Cancel work before releasing GPIOs
Date: Wed, 18 Nov 2026 15:59:47 +0100
Message-ID: <20261118150107.184946023@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Myeonghun Pak <mhun512@gmail.com>

[ Upstream commit 9962770049c715fc30a7b3274d8f245167c0a410 ]

The fan worker changes the direction of both GPIOs and schedules its
next run. Its managed cancellation action is registered before the GPIOs
are acquired, so devres releases the GPIOs before cancelling the work. A
running worker can therefore change a GPIO after the driver has released
it.

Register the work cancellation action after both GPIO acquisitions. This
makes devres cancel and drain the worker before releasing either GPIO.
No work has been queued yet if GPIO acquisition or action registration
fails.

This issue was identified as part of our ongoing research while
reviewing kernel code.

Fixes: b82a7b018b93 ("platform/x86: gpd pocket fan: Clean-up by using managed work init")
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Link: https://patch.msgid.link/179229442299.3956787.17526066623947466315.gpd-pocket-fan@gmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/gpd-pocket-fan.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/platform/x86/gpd-pocket-fan.c b/drivers/platform/x86/gpd-pocket-fan.c
index 7a20f68ae2061..01f9676fc0f43 100644
--- a/drivers/platform/x86/gpd-pocket-fan.c
+++ b/drivers/platform/x86/gpd-pocket-fan.c
@@ -153,10 +153,6 @@ static int gpd_pocket_fan_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	fan->dev = &pdev->dev;
-	ret = devm_delayed_work_autocancel(&pdev->dev, &fan->work,
-					   gpd_pocket_fan_worker);
-	if (ret)
-		return ret;
 
 	/* Note this returns a "weak" reference which we don't need to free */
 	fan->dts0 = thermal_zone_get_zone_by_name("soc_dts0");
@@ -175,6 +171,11 @@ static int gpd_pocket_fan_probe(struct platform_device *pdev)
 	if (IS_ERR(fan->gpio1))
 		return PTR_ERR(fan->gpio1);
 
+	ret = devm_delayed_work_autocancel(&pdev->dev, &fan->work,
+					   gpd_pocket_fan_worker);
+	if (ret)
+		return ret;
+
 	gpd_pocket_fan_force_update(fan);
 
 	platform_set_drvdata(pdev, fan);
-- 
2.53.0



