Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C978A1A5A4
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:22:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GuyJBIbB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A0B7C433C8;
	Mon,  9 Oct 2023 13:22:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696857744;
	bh=5x/KGXInpSWmPP9fuZdaMUvqmF0DJyggdbu+tv5MOTw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GuyJBIbBVnoJwqwHpi1tTrITiQ4cDQDel7pEzUZvYr1GAoihpGZxXr2pvRjVtZx4L
	 WXvVGg0ufhSl0kH/iIlQzi3/JdkBIVioY2nPSllNtYXD/4CyNcrTFLwpSUfvpkQ1JF
	 OzMHW+iL+rAj+d/K7tmjtcn0qa0veZrjouHcwuLQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Andy Shevchenko <andy@kernel.org>,
	Andrew Jeffery <andrew@codeconstruct.com.au>
Subject: [PATCH 6.1 143/162] gpio: aspeed: fix the GPIO number passed to pinctrl_gpio_set_config()
Date: Mon,  9 Oct 2023 15:02:04 +0200
Message-ID: <20231009130126.852859697@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130122.946357448@linuxfoundation.org>
References: <20231009130122.946357448@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

commit f9315f17bf778cb8079a29639419fcc8a41a3c84 upstream.

pinctrl_gpio_set_config() expects the GPIO number from the global GPIO
numberspace, not the controller-relative offset, which needs to be added
to the chip base.

Fixes: 5ae4cb94b313 ("gpio: aspeed: Add debounce support")
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Reviewed-by: Andy Shevchenko <andy@kernel.org>
Reviewed-by: Andrew Jeffery <andrew@codeconstruct.com.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpio-aspeed.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpio/gpio-aspeed.c
+++ b/drivers/gpio/gpio-aspeed.c
@@ -963,7 +963,7 @@ static int aspeed_gpio_set_config(struct
 	else if (param == PIN_CONFIG_BIAS_DISABLE ||
 			param == PIN_CONFIG_BIAS_PULL_DOWN ||
 			param == PIN_CONFIG_DRIVE_STRENGTH)
-		return pinctrl_gpio_set_config(offset, config);
+		return pinctrl_gpio_set_config(chip->base + offset, config);
 	else if (param == PIN_CONFIG_DRIVE_OPEN_DRAIN ||
 			param == PIN_CONFIG_DRIVE_OPEN_SOURCE)
 		/* Return -ENOTSUPP to trigger emulation, as per datasheet */


