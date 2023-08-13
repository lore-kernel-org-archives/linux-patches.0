Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 598109446
	for <patches@lists.linux.dev>; Sun, 13 Aug 2023 21:38:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1720C433C7;
	Sun, 13 Aug 2023 21:38:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691962708;
	bh=Dbj2Hx0+kdpjHVdqSZ5/XwpdvKqRVkjpWihUDD6EIkI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oFmxjqDDiW5t+MH0ULIhwVTbQQMGOPdO+ndQw9nezYFrSFYfrVPfdypPRPVbWvIMP
	 +Gl3K90Fk6LatifwMZeWFVouclU0RDp7rX1CFbGux1Eue1H1oENMKQVcEva1vMZbzt
	 BnnEtA0sl3D7QIayFEH1JVXbmuuK2bTl/e/OOgDQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 6.1 126/149] gpio: sim: mark the GPIO chip as a one that can sleep
Date: Sun, 13 Aug 2023 23:19:31 +0200
Message-ID: <20230813211722.494853297@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230813211718.757428827@linuxfoundation.org>
References: <20230813211718.757428827@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

commit 5a78d5db9c90c9dc84212f40a5f2687b7cafc8ec upstream.

Simulated chips use a mutex for synchronization in driver callbacks so
they must not be called from interrupt context. Set the can_sleep field
of the GPIO chip to true to force users to only use threaded irqs.

Fixes: cb8c474e79be ("gpio: sim: new testing module")
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpio-sim.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpio/gpio-sim.c
+++ b/drivers/gpio/gpio-sim.c
@@ -425,6 +425,7 @@ static int gpio_sim_add_bank(struct fwno
 	gc->set_config = gpio_sim_set_config;
 	gc->to_irq = gpio_sim_to_irq;
 	gc->free = gpio_sim_free;
+	gc->can_sleep = true;
 
 	ret = devm_gpiochip_add_data(dev, gc, chip);
 	if (ret)


