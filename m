Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20D5A3212
	for <patches@lists.linux.dev>; Tue,  7 Feb 2023 13:13:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83F1AC433EF;
	Tue,  7 Feb 2023 13:13:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675775617;
	bh=HjRZ5LEOHTx8ri2ZMeT/zMRGPTYZQRt6X7ovFnvrPYw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ac3hJzeA4pAVJyRZf2MPgaPBRXFbVtZZEQEb9PJGpImaHJPQRsMjqL9KB5gxM+6Ob
	 BeXuzKogg28zMfmpXlf3hSFAKEDYtDBEMZijtMkZFGuEo7EphhBd3xzfCf0kK/Ko8R
	 lpeHzFUWApacF2H0eO8n0kYS+3j9bBlRy19JVz8Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH 5.15 100/120] nvmem: core: remove nvmem_config wp_gpio
Date: Tue,  7 Feb 2023 13:57:51 +0100
Message-Id: <20230207125623.024875455@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125618.699726054@linuxfoundation.org>
References: <20230207125618.699726054@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

commit 569653f022a29a1a44ea9de5308b657228303fa5 upstream.

No one provides wp_gpio, so let's remove it to avoid issues with
the nvmem core putting this gpio.

Cc: stable@vger.kernel.org
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20230127104015.23839-5-srinivas.kandagatla@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvmem/core.c           |    4 +---
 include/linux/nvmem-provider.h |    2 --
 2 files changed, 1 insertion(+), 5 deletions(-)

--- a/drivers/nvmem/core.c
+++ b/drivers/nvmem/core.c
@@ -768,9 +768,7 @@ struct nvmem_device *nvmem_register(cons
 
 	nvmem->id = rval;
 
-	if (config->wp_gpio)
-		nvmem->wp_gpio = config->wp_gpio;
-	else if (!config->ignore_wp)
+	if (!config->ignore_wp)
 		nvmem->wp_gpio = gpiod_get_optional(config->dev, "wp",
 						    GPIOD_OUT_HIGH);
 	if (IS_ERR(nvmem->wp_gpio)) {
--- a/include/linux/nvmem-provider.h
+++ b/include/linux/nvmem-provider.h
@@ -66,7 +66,6 @@ struct nvmem_keepout {
  * @word_size:	Minimum read/write access granularity.
  * @stride:	Minimum read/write access stride.
  * @priv:	User context passed to read/write callbacks.
- * @wp-gpio:	Write protect pin
  * @ignore_wp:  Write Protect pin is managed by the provider.
  *
  * Note: A default "nvmem<id>" name will be assigned to the device if
@@ -81,7 +80,6 @@ struct nvmem_config {
 	const char		*name;
 	int			id;
 	struct module		*owner;
-	struct gpio_desc	*wp_gpio;
 	const struct nvmem_cell_info	*cells;
 	int			ncells;
 	const struct nvmem_keepout *keepout;


