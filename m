Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792773820;
	b=ofAlydjfbNdJ2T/2mAL9rq++GbtAbnI+UEbu0yb87sgfcsZ7eP9OUxTk6zHnZxdqfrh0
	 qru24u/GIUFBtyadXoXaU65t+ez4W9BsL1ygFf15YvZrG3jv/0NgAPfxKPwP/XPuaDMIx
	 H6DSWG2uua6r0OSEj2Qc49XanHvz1AlGzjOQD1h4ZOoGaLh5D+nQ63qomfJvv/jtARPiS
	 ZNW1jeWYyLDBXIOJnRExWkELO9bguM6UBtu1yA+yS+3Gb4g72UMZk/gKVOR+ZlnAY4cGX
	 OjfPrjYDg2M+nQaTgZPaPseFZOMWuRHCeYJmqNXuN/pZ7yj73k5RozEXOpzp/5Npsow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792773820;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tvW/tqD3aBMeL3RKIw3/2owlxoKdl5c6VrozK274mNU=;
	b=0AI+eoEOkQ50OacL0Moq6A1pzAzJlbqrhTsaLaZ4m0MZp6fvDH3mMEDPXXSVnlGARXka
	 gVdLMULyRoPwdfrXR/z54Ao4z7G8sFwWX0qrM94ee+03GuJXPhl65tVZsgTls0y+idiNi
	 WtATp/DomIkcZl3yMJx+BTd6hM7/1SP3PYWWsPfppoFSwuU/w0/o7u5gGE11ojIyNadZA
	 WSg3L36ww6k0hpZXoBqhIjKehuTAzoXcF2wVY5GOKfFORU6k40zOJUeG7EMyJY2rAMURz
	 lJROtBa5qDdd+EJB7baw8I3c+WC5gY+fysdNgN9B/LUY5RalSltoZmWNuijMEvtE+CQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=own2TXis;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0857F60A2624;
	Fri, 23 Oct 2026 16:43:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=own2TXis
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 520CC1F031E6;
	Fri, 23 Oct 2026 16:43:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792773819;
	bh=tvW/tqD3aBMeL3RKIw3/2owlxoKdl5c6VrozK274mNU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=own2TXis8qj8ja95cPxZsCbOq7GjT4TAMQo1t+6hnFRtEIAHhG8zDh0QxlNHY1n9I
	 VbIpODhvZiokcmKBYGT11+gi0i1LNEhCag1qcyabNGy/wSE4YvY4YXrr8QZ3tocWWg
	 TG2Z+O24HLGRBXd2L12ncCYDf3+fPa3p+lb/z4lY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Yu <a0282524688@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 027/193] gpio: nct6694: Mark the GPIO controller as sleeping
Date: Fri, 23 Oct 2026 18:35:04 +0200
Message-ID: <20261023163714.844273654@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163714.201276352@linuxfoundation.org>
References: <20261023163714.201276352@linuxfoundation.org>
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



