Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028581;
	b=T435dNAsHYHv+L+T+ckbtTBPuvyykSZzgaOcK+tOnKeff4T8gU2yNwPnBHLapGp+L8uc
	 mRG7ueML+gkr+xEn4ExgjwYPvihm8iE3Woac8RL4awQYvM8ywVUzR8pPkY/FJvbuhwDlT
	 0UfuzQQdBLS/XyJDdKvRmTVSQQmWaOqVKfKtXQ5NGHEgOj5beRmmimGckxodqvPcHOkkI
	 xdDC1wpy0U7imVJ180orvVXWvus+wFGbKnPtUSmOM5Akv+mozhdFwMTbmpQxRn2S/nDZb
	 tHUWRppsUnfxVR7ZOjQU1IsfXD1nIPdp2Ar/iwqHYcm1KJ6Hdq9d3HQgKKZ/Txkef8w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028581;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3xniIg9/OX20pywZfvWs+hqDL8o3RQ48G3GjSOK0ibQ=;
	b=NPVbRNo3+J58NzVlYsNUhW09SVOqfFfUBdu8dF/l/LNQGleTiw8mBTDVc595B1eDJdZ8
	 nLia5SbJKLf8d0AAXEL9r3b8rgSHrUnTJ5YLavfcd9mFNHmjphpjB+ovVzUUyq8mYFVkw
	 50wcVKnm/sGSc1ARguThitkuUEuo6aegJ9lw/pJEOX14wawaWug3miRc8zVssJm2uI6xC
	 2B7bhDNPs0APKYXCyCnXcj153Ib2WJFuRb38bKKxFGghpoVTuppZKQ1NMSDhwi7HuKmNy
	 nMHFPufud4dINBQRS763ejGjcliRH64pRM69z2BlOZnJKpEE5X64t5G3+2TSidlpjTw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WDcrjIvh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26663606A31C;
	Wed, 18 Nov 2026 19:03:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WDcrjIvh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A22B61F000C4;
	Wed, 18 Nov 2026 19:03:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028581;
	bh=3xniIg9/OX20pywZfvWs+hqDL8o3RQ48G3GjSOK0ibQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WDcrjIvhipKH9qM4xEObxpF4cv2irDN0SSxNCgu3KhSa9h/tSaklJSPDT7/NhbxFP
	 jMpC92qidLKCFCrNc+EEMZojr50jGX2Em8RhfEatcK9sEAPGMsfDry+c7XTH3CdJBv
	 d34gc/vZiO8C+4w67a5DiPNMfl7EssZehnws4mrw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pan Chuang <panchuang@vivo.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0046/1756] hwmon: (sht15) Remove redundant dev_err()
Date: Wed, 18 Nov 2026 15:36:13 +0100
Message-ID: <20261118150009.932499861@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pan Chuang <panchuang@vivo.com>

[ Upstream commit b8ffbb950dffbcf810ba41e776516cf3438bbe25 ]

Since commit 55b48e23f5c4 ("genirq/devres: Add error handling in
devm_request_*_irq()"), devm_request_irq() automatically logs detailed
error messages on failure. Remove the now-redundant driver-specific
dev_err() call.

Signed-off-by: Pan Chuang <panchuang@vivo.com>
Link: https://lore.kernel.org/r/20260720063745.309331-7-panchuang@vivo.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Stable-dep-of: 5eab1e7f7ed1 ("hwmon: (sht15) Stop deferred work before releasing its resources")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/sht15.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/hwmon/sht15.c b/drivers/hwmon/sht15.c
index 3d55047e9baf9..48bcd362c4808 100644
--- a/drivers/hwmon/sht15.c
+++ b/drivers/hwmon/sht15.c
@@ -981,10 +981,8 @@ static int sht15_probe(struct platform_device *pdev)
 			       IRQF_TRIGGER_FALLING,
 			       "sht15 data",
 			       data);
-	if (ret) {
-		dev_err(&pdev->dev, "failed to get irq for data line\n");
+	if (ret)
 		goto err_release_reg;
-	}
 	disable_irq_nosync(gpiod_to_irq(data->data));
 	ret = sht15_connection_reset(data);
 	if (ret)
-- 
2.53.0



