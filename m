Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0661F14A99
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:13:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MS/zGO08"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 750C5C433C8;
	Mon, 23 Oct 2023 11:13:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698059621;
	bh=ujHTTZezBnBZFcFZeEHPTHALu6NSm7VyDeKTjVQ75SA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MS/zGO08Jh3ebg36bPp2bkUp+JlaNk4qshEpsOMibbDKgMyhYjvMWEP1LZbRlZhSi
	 YJVCeQBP0rpBrfqp/hx6Y1kAbqdRuyNfWWrwWohCaPv+nT42ncYoECFDuazXEWbpVi
	 VZRNCX/cEIZhLMPxWK+OfoE7O1IJ3uRkMwDVz+ns=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ferry Toth <ftoth@exalondelft.nl>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Subject: [PATCH 6.5 212/241] gpiolib: acpi: Add missing memset(0) to acpi_get_gpiod_from_data()
Date: Mon, 23 Oct 2023 12:56:38 +0200
Message-ID: <20231023104839.017756748@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104833.832874523@linuxfoundation.org>
References: <20231023104833.832874523@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

commit 479ac419206b5fe4ce4e40de61ac3210a36711aa upstream.

When refactoring the acpi_get_gpiod_from_data() the change missed
cleaning up the variable on stack. Add missing memset().

Reported-by: Ferry Toth <ftoth@exalondelft.nl>
Fixes: 16ba046e86e9 ("gpiolib: acpi: teach acpi_find_gpio() to handle data-only nodes")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpiolib-acpi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpio/gpiolib-acpi.c b/drivers/gpio/gpiolib-acpi.c
index fbda452fb4d6..51e41676de0b 100644
--- a/drivers/gpio/gpiolib-acpi.c
+++ b/drivers/gpio/gpiolib-acpi.c
@@ -951,6 +951,7 @@ static struct gpio_desc *acpi_get_gpiod_from_data(struct fwnode_handle *fwnode,
 	if (!propname)
 		return ERR_PTR(-EINVAL);
 
+	memset(&lookup, 0, sizeof(lookup));
 	lookup.index = index;
 
 	ret = acpi_gpio_property_lookup(fwnode, propname, index, &lookup);
-- 
2.42.0



