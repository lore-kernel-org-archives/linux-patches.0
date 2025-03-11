Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8ABB25DB0D;
	Tue, 11 Mar 2025 15:10:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741705829; cv=none; b=Mv5s5T3prm3WSZ+QBsToTATkuKm1jUJORLn4sWmjkw4QNz6saAuP1LLwwikep8sIDr7aAUqSO2vrkqgV73cpusjrBIOdsNjOac0uawXKHE9KhWaneNAa0axcpE8Cl6Ybw8vZZd1GCxUqzdat0EixruPMMaEyrzptalWwL4XIXHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741705829; c=relaxed/simple;
	bh=x+OiVJCv/XGs32VGxp+UX95FhKNMAo64KiZuyRd9ZQo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ud6YO7ucD7L1pj5VgT4sVk19q7ekFWan7RR/TCuycxNbjSC/e7IPHIhgE8+Z0zH1/25PisGsws/+OrzJcEo4E4igh3gve70JMsMLir+3onm2+9kV075jj8r3MBytn/I4GS6Q3DPs64Pr+ddUJoit8eXoFwRLijH7+oOsQvnKoJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VXAC2EIS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VXAC2EIS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E8D3C4CEEA;
	Tue, 11 Mar 2025 15:10:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741705828;
	bh=x+OiVJCv/XGs32VGxp+UX95FhKNMAo64KiZuyRd9ZQo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VXAC2EIS8jb2z9stqxzRnk9FMe7OZloyRI4j8oozSx873rvi2yy3oW29U4ymjoA+f
	 qCPi1UhnmOG9BOt9EeAxGz2zQLXziaE/vohz922Ubk3/2TIapbXZzQTh+1V0T8J2Lj
	 InAu/Pyob7IHYZXHarf7hiQUkpdDqStd32hCGnME=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Markus Mayer <mmayer@broadcom.com>,
	Artur Weber <aweber.kernel@gmail.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 169/328] gpio: bcm-kona: Add missing newline to dev_err format string
Date: Tue, 11 Mar 2025 15:58:59 +0100
Message-ID: <20250311145721.621875117@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
References: <20250311145714.865727435@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Artur Weber <aweber.kernel@gmail.com>

[ Upstream commit 615279db222c3ac56d5c93716efd72b843295c1f ]

Add a missing newline to the format string of the "Couldn't get IRQ
for bank..." error message.

Fixes: 757651e3d60e ("gpio: bcm281xx: Add GPIO driver")
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Reviewed-by: Markus Mayer <mmayer@broadcom.com>
Signed-off-by: Artur Weber <aweber.kernel@gmail.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://lore.kernel.org/r/20250206-kona-gpio-fixes-v2-3-409135eab780@gmail.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-bcm-kona.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-bcm-kona.c b/drivers/gpio/gpio-bcm-kona.c
index aad1d5af6382b..35bf2ecc71b49 100644
--- a/drivers/gpio/gpio-bcm-kona.c
+++ b/drivers/gpio/gpio-bcm-kona.c
@@ -674,7 +674,7 @@ static int bcm_kona_gpio_probe(struct platform_device *pdev)
 		bank->irq = platform_get_irq(pdev, i);
 		bank->kona_gpio = kona_gpio;
 		if (bank->irq < 0) {
-			dev_err(dev, "Couldn't get IRQ for bank %d", i);
+			dev_err(dev, "Couldn't get IRQ for bank %d\n", i);
 			ret = -ENOENT;
 			goto err_irq_domain;
 		}
-- 
2.39.5



