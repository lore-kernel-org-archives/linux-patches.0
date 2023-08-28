Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BB2711C83
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:23:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 844B8C433C7;
	Mon, 28 Aug 2023 10:23:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693218181;
	bh=tdv5TGuRL+8n5nKUeKtbC4R/n/IWpRuGMEHo8q1hMjc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iReSfxdiNdbLMAOGwSnHIC2zRGPeWjA+hgOdmR2D4LZ7tFh+asBoJntobLTAlFAsC
	 hanKRK269HCpoS2Ie0O5ffZeKwHZmVlzBCFUrNRsHM/rAhgMvIwFYwl3lvM6Gqhw0u
	 YTnn5CgRYs5eFFpWek5yenLlrnT6tFKC16CCeh7I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 124/129] gpio: sim: pass the GPIO devices software node to irq domain
Date: Mon, 28 Aug 2023 12:13:23 +0200
Message-ID: <20230828101201.542292696@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230828101157.383363777@linuxfoundation.org>
References: <20230828101157.383363777@linuxfoundation.org>
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

6.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

[ Upstream commit 6e39c1ac688161b4db3617aabbca589b395242bc ]

Associate the swnode of the GPIO device's (which is the interrupt
controller here) with the irq domain. Otherwise the interrupt-controller
device attribute is a no-op.

Fixes: cb8c474e79be ("gpio: sim: new testing module")
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-sim.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-sim.c b/drivers/gpio/gpio-sim.c
index 8fb11a5395eb8..533d815725794 100644
--- a/drivers/gpio/gpio-sim.c
+++ b/drivers/gpio/gpio-sim.c
@@ -411,7 +411,7 @@ static int gpio_sim_add_bank(struct fwnode_handle *swnode, struct device *dev)
 	if (!chip->pull_map)
 		return -ENOMEM;
 
-	chip->irq_sim = devm_irq_domain_create_sim(dev, NULL, num_lines);
+	chip->irq_sim = devm_irq_domain_create_sim(dev, swnode, num_lines);
 	if (IS_ERR(chip->irq_sim))
 		return PTR_ERR(chip->irq_sim);
 
-- 
2.40.1



