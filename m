Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042185;
	b=KXpaELjZt3SIXUK/Apo+wTQ+su4/tuTahViWmMfH8DEnul17l/dUsiEfz6g0d65bDje8
	 rFgVvP7jW/v1GAXZlUq2T9rProJiukbebXZZZwA++13X6QVVkAWbnQBT4IrRKShCFhMco
	 eBTwQIXt8hP430ilRhBJeFR2nRjbszeOlQF2LkTJ6nfFVR9/6zSFbyTThUYJSTikMmWzX
	 Q8N0dgIo5JBv3TfaqqS6hD9LagkqdZvkYSMOZg9sCOhAYxt78gHGLXfNhzuhNN5Ihz7dU
	 AaOFjaDrk61Kq000UjrwzR8LUrO6YjZ/p1JsOm9dOcs1/+wpdd7M9+Jy4YorHd3Sflw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042185;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=PKDmCj93cTLe/HDsu1tYu6XkO3hSh6vAQp2on2FElrw=;
	b=YdT3FYCAILMKx/K8D/7ervKW2aBsualTBae9ULQmmxDwWGPESt2Wb60hDh8wMpYdicPZ
	 //71ySEYCNC3GTgRkuVzPNTUVGs8fXBKSJwuBZRdl6SZKhV229sv2VeZtKSPxSFbmFoEP
	 F2uyCH7P6joxZSUMgkdSdlBiQnIMQ4nr5p3bk7D+ELTsCvPbAqFp612RdyUDS9j2ZEXpF
	 qq2ldicF09b85wMzdG/Q1sIsi8fTvve8qOqafPcEZLlP7HjENvTlIlngLltT1MlrQ6/ri
	 Bnpv2HfLZVNSFWWyTVv+Qye12sAR27bjn89zcsuTLeGKtPvzP1ldmlVkNiO93P4asPA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zCGI5YzV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DFDE606A32A;
	Wed, 18 Nov 2026 22:49:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zCGI5YzV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0C931F000C4;
	Wed, 18 Nov 2026 22:49:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042185;
	bh=PKDmCj93cTLe/HDsu1tYu6XkO3hSh6vAQp2on2FElrw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zCGI5YzVtYcQRTtTSw/xWBIl7/d7CckyrZEI+zjZ4V7JQvvhIiFcWes3eAnF5eZwB
	 JUSMS83kRWjcJn1cDfS1zm8+QCNwXGrWT+v1JGN5OWy8oAMrsEarO/7Ot/VT2c0ygd
	 bgNzduoDLokKG4mVuP3TCI74+GOvyIBmMsZDhoTk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3081/3318] platform/x86: gpd pocket fan: Cancel work before releasing GPIOs
Date: Wed, 18 Nov 2026 16:01:43 +0100
Message-ID: <20261118150452.499076079@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



