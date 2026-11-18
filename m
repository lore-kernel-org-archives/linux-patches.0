Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022559;
	b=aMgi4gpuZbgbbSlyanOmgi7BG/iN7XTruVIn5JgVBygwyh7H5igsQA6LvLzdnkamSJqC
	 p72T+IW3qQa/92Il/3DUMJWvYkuVxlFCAVZ2tFeO4YSCs2bBu8rfPBhryvhVBVdcg/1cV
	 pPwH5pPb1LQdF8dKfjlhPrIncEbZNWrc8jnDOtXJS29xuASsuTnX2675VS34V1SVgfsRc
	 sXZkeCHHt+DME4UYCIc7JbKfWPND41Q5We9VyWfqDGPlDHHziV6mG2AT6I274xV83mpVM
	 IsRaOvdPRCMS1ZWEUHyR8U52LefRk7xsSJISMer/jKR2aC3rPoei28agDk3cXQcAd1g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022559;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=s56iqmQ4BMa9RXjKI4o8bDUtrxgR26natePJgAUPyqQ=;
	b=hw26yiFnCsE+6PMVEBz5ROA8RiCyeo/HY0JDlD+JUqXJMeVhOdd4aTpP8HneJ/p35ZUg
	 7V5dWqXTH5pPVj9YpaZe4aDWdBWIDyRchvphz0ngVPr27IL1riTdKqxu/UgD+Mqc64E/2
	 U7/WY/qLJzaanMzWpMHVgQuemWTTUHi6ViZ+ShgXBZ5CR2FsUJttusckT8LD47/yvFQSh
	 UCOv9EHuzXLLUD4GNLm0BkVPdg0CpE1sxFB1Khb+lWfrDvveMDqcjUdXkHVu5/vj7+4JS
	 cQIukFfWh29WELTz9r1+ZOv3XhFbqFLSwQjJRKmLiC+NPGRj3iIJyNZkr9D6TkVnONw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DUS6fakO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18726606A320;
	Wed, 18 Nov 2026 17:22:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DUS6fakO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71F491F000C4;
	Wed, 18 Nov 2026 17:22:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022559;
	bh=s56iqmQ4BMa9RXjKI4o8bDUtrxgR26natePJgAUPyqQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DUS6fakOSLil+NUQS4CeXi1dA3z2MPy+3Rbfm2PnizDUXc9Dn5DfBeJtqKBXhs28N
	 ZmcDeknlxoAe0zHqgSzh0MtAz4grONQpZI1sPd2RWohl8WevgS/j8HwdeWCdMoJS2l
	 80Iw0KlxZwNiQ18GPbcSki/61MJ8fTv0QU1Y8YAo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pan Chuang <panchuang@vivo.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0057/2151] hwmon: (sht15) Remove redundant dev_err()
Date: Wed, 18 Nov 2026 15:29:52 +0100
Message-ID: <20261118150123.825102529@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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



