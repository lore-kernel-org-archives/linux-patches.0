Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6CC82593
	for <patches@lists.linux.dev>; Mon, 12 Dec 2022 13:31:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2F70C433D2;
	Mon, 12 Dec 2022 13:31:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670851869;
	bh=r8geQ20ZWjbuqKJcqHE+QM6C4z6oSoGzVMQPIt6ShJU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MP5HY6e7ZGm61mJqNKpoCQESyt7I016aRoOo/roZ9InkJGy/xgnU/fMCN4OkSXrdd
	 1cG9cSIaKKaGBherEM6m9S1/6n806RTVs5i+l7k8/D/kx6pmmAkYF+x1BfFwboWAGb
	 zAss52SOFXgN767sfeKwsjYCdNppeB6U9k7hklw4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartosz Golaszewski <brgl@bgdev.pl>,
	Linus Walleij <linus.walleij@linaro.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 060/123] gpiolib: improve coding style for local variables
Date: Mon, 12 Dec 2022 14:17:06 +0100
Message-Id: <20221212130929.453689464@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130926.811961601@linuxfoundation.org>
References: <20221212130926.811961601@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Bartosz Golaszewski <brgl@bgdev.pl>

[ Upstream commit e5ab49cd3d6937b1818b80cb5eb09dc018ae0718 ]

Drop unneeded whitespaces and put the variables of the same type
together for consistency with the rest of the code.

Signed-off-by: Bartosz Golaszewski <brgl@bgdev.pl>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Stable-dep-of: ec851b23084b ("gpiolib: fix memory leak in gpiochip_setup_dev()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpiolib.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 320baed949ee..a87c4cd94f7a 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -594,11 +594,11 @@ int gpiochip_add_data_with_key(struct gpio_chip *gc, void *data,
 			       struct lock_class_key *request_key)
 {
 	struct fwnode_handle *fwnode = gc->parent ? dev_fwnode(gc->parent) : NULL;
-	unsigned long	flags;
-	int		ret = 0;
-	unsigned	i;
-	int		base = gc->base;
 	struct gpio_device *gdev;
+	unsigned long flags;
+	int base = gc->base;
+	unsigned int i;
+	int ret = 0;
 
 	/*
 	 * First: allocate and populate the internal stat container, and
-- 
2.35.1



