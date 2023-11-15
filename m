Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F181B3A8F3
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:50:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eEQAzEk6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1766C433C7;
	Wed, 15 Nov 2023 19:50:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077831;
	bh=T65deNt+a3YpCeac5Dk69u0igzVuqECLBdgkiFLxnRo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eEQAzEk6HrgIWMqzpdZan5iHVcMKGI+RfExmGhpuS3YJMsh0q5NcU6WI+81SxVk+C
	 n9rqMVWY3quCLKGlmlZ1duFUPrAq3xuGTE5fyH8P+hx3frKSmkmYSd+3fK01Zp3pKb
	 NcX0hwgyRHPc66QBoMTIsULaJyfbNjzKvCleOiEU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Bharat Bhushan <bbhushan2@marvell.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Wim Van Sebroeck <wim@linux-watchdog.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 539/603] watchdog: marvell_gti_wdt: Fix error code in probe()
Date: Wed, 15 Nov 2023 14:18:04 -0500
Message-ID: <20231115191649.124204854@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 4b2b39f9395bc66c616d8d5a83642950fc3719b1 ]

This error path accidentally returns success.  Return -EINVAL instead.

Fixes: ef9e7fe2c890 ("Watchdog: Add marvell GTI watchdog driver")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Bharat Bhushan <bbhushan2@marvell.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/af326fd7-ac71-43a1-b7de-81779b61d242@moroto.mountain
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/marvell_gti_wdt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/watchdog/marvell_gti_wdt.c b/drivers/watchdog/marvell_gti_wdt.c
index d7eb8286e11ec..1ec1e014ba831 100644
--- a/drivers/watchdog/marvell_gti_wdt.c
+++ b/drivers/watchdog/marvell_gti_wdt.c
@@ -271,7 +271,7 @@ static int gti_wdt_probe(struct platform_device *pdev)
 				   &wdt_idx);
 	if (!err) {
 		if (wdt_idx >= priv->data->gti_num_timers)
-			return dev_err_probe(&pdev->dev, err,
+			return dev_err_probe(&pdev->dev, -EINVAL,
 				"GTI wdog timer index not valid");
 
 		priv->wdt_timer_idx = wdt_idx;
-- 
2.42.0



