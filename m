Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774398;
	b=HpI03LcOJ/ZqyjRouByivTNPsPni7TuLiiJzEwPl5dSo1kKmdoVQg6jWC6yVGBv5qx72
	 +8DmoeJzWG+hwVUBgFQ8AlEmJZw/SbYQAGpZ0pl6GbFa+uFnDzSLm7hUb7RJ3DIYIhSE4
	 srGzXXuQ034n5Nw9gNcdzrC71bV24elNzh+5TuWuOrcdV/s+QJQr4DNiY31kLLe7LSUrM
	 3H30a6b0HDYPdPjEJ4rZlSWYeMp4FYtxbURjiRbjMUFcw6nU+/WWHX/dUk+zwRTFt5kAe
	 BO0mBNgAKLFAWZEdgRhk1jmG5i9UmSwUK1bjL48pfefSrwaOkNGh0O+BYB1ntQ4qDbA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774398;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZcQaF5GjdD+s9ByG/L/2IWl3FOeC5x8utfdK0zq0BjA=;
	b=wjElblIZoYj4OBlHKDSxwDBAYx+O/+9qkuzLJvKP68PKeoXmpA2vCWiYGtcQwUyQF0u/
	 WxvSL5Ohk6VY3PDfFDKWknsb75CIJm/oITObu+Yw3B13pA3J3As1nMHheWYdoTEhUseIa
	 qiawuLDPTs18vmDS1joV3KaOwLKJCnnFRIfqaksd+VxHePWVxW9x5EgiVDBUMs5A4ZmX5
	 LcwzMdHa8ghwypE+wm/FoBS7HlD9PVLVVHQqIAD9AXsv945Sc1fUcDabT8gNlKXm0xwWH
	 5IVRTDGevCCABjAWmk0DnYWdPZcjrzJp/v7Qi1IYMeoC9ww6wzkr8iJLhTGn8Lv+Paw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=urNszPua;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48BBF606A31A;
	Fri, 23 Oct 2026 16:53:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=urNszPua
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 985A31F01825;
	Fri, 23 Oct 2026 16:53:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774398;
	bh=ZcQaF5GjdD+s9ByG/L/2IWl3FOeC5x8utfdK0zq0BjA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=urNszPuaWS5uCNGLzYkvq5oaGPATMXkVzw/9tmBlYyBtSawaQ43KkVBmtrs2fPbDc
	 N8xDk1Zoyo2SUiCMfyhG6X+oVq3I7OEXM/Sm0d7M6JHQL8jYdXU9MTOzFsmkd9cP+3
	 47m4HYso49EGkTTxIUsuSWIbKWlHpPTEO2qkYeH4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Yu <a0282524688@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 027/242] gpio: nct6694: Mark the GPIO controller as sleeping
Date: Fri, 23 Oct 2026 18:37:49 +0200
Message-ID: <20261023163714.425500589@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Yu <a0282524688@gmail.com>

[ Upstream commit fcbc48dc650d2f58bfe19c4486830de0e9cad62e ]

The GPIO callbacks take a mutex and issue USB transfers, so this GPIO
chip must not be used in atomic context. Change the can_sleep switch in
struct gpio_chip to true.

Fixes: 611a995e8ae1 ("gpio: Add Nuvoton NCT6694 GPIO support")
Signed-off-by: Ming Yu <a0282524688@gmail.com>
Link: https://patch.msgid.link/20261007092102.3768818-2-a0282524688@gmail.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-nct6694.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-nct6694.c b/drivers/gpio/gpio-nct6694.c
index a8607f0d99153..a38add1cde293 100644
--- a/drivers/gpio/gpio-nct6694.c
+++ b/drivers/gpio/gpio-nct6694.c
@@ -444,7 +444,7 @@ static int nct6694_gpio_probe(struct platform_device *pdev)
 	data->gpio.set_config		= nct6694_set_config;
 	data->gpio.init_valid_mask	= nct6694_init_valid_mask;
 	data->gpio.base			= -1;
-	data->gpio.can_sleep		= false;
+	data->gpio.can_sleep		= true;
 	data->gpio.owner		= THIS_MODULE;
 	data->gpio.ngpio		= NCT6694_NR_GPIO;
 
-- 
2.53.0



