Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211476;
	b=jPDiKIb8XrHoA1q6ZE5Os/1PMN+0oZ9OIdFB49UYh+hl1wHYCifo7+tm1vsyQQq0Z5o7
	 gxITquuAZbtug762ZoB7brTjx+WwQugTKc5306qur0QAPvdtMpiqAFnEqrud76/3cSaOZ
	 Dc9xs9Xd2YkRcTCO8T0i2lN3Pl0XO6ud3yhSxR3LuLyUZ+/xuoxMt7IkZdSBUzKim2Ue7
	 o/ScDo0APZkNKA2pQjPvAYxPhz2qKWj1UQgXb8OdZOicVSUELjRsR9FKYH9c+LDgiXDU6
	 AJyb5dHKtrEzT2PNs2IKBJ1mlv8+diIv/4FsnJNt8c/9x+/sBWWHyUWBBg7sM1I2XtQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211476;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xXBUj1xql1v4H0uz9sqrJJ9QjuJqWyLhd/C9RvnqPxs=;
	b=pYXkNq5/FJ8FskXek2bVsVap8lxUiCqftV7rDRfO5vI5fkE9P8dj3V7E8FtV76IJmWWN
	 7NC39zPUisz8R/PPNz5SYaV7d/R7HNiw5CU6lM26VOB9mKswi4h5GLoXAvudOOvEhKj5K
	 cOySZ0TabtLY9bO8R8gKOIF8rWGURKmVfvIGk8o4i6bQGaHkg/lWqPSUdub0RNKaGtaUT
	 sqNZ0YQ8orgepkMcvymXMdc/KQ5UAZHzfnlCCDDWDJHS3WTtr2TZr4c7UFPe4yww+9jR1
	 7M+BQdpJwyanzImiZTs7QutVPQtnH+v/PeNYohhLI90zMxvjHEj4J51YdrI07iosPxw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bx1ay1Ho;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 355DF606A31D;
	Wed, 28 Oct 2026 18:17:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bx1ay1Ho
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5339B1F01825;
	Wed, 28 Oct 2026 18:17:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211475;
	bh=xXBUj1xql1v4H0uz9sqrJJ9QjuJqWyLhd/C9RvnqPxs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bx1ay1Ho5I+5BwwuC21W2anT7TwbftvCJZUTyG3GVLKir3SnO8VaSLomVDhqUM0Ba
	 ZRSGEu6Om7o1+ycrXcvx8Dg/i1tdtimBp9iDgkiML6DBFOjDH0cnZnl5Fw12bOJTWU
	 40DYOm3ToCOmHVZTzSCBMNaFyBmCkcj87UTR0Ftw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Changyul Lee <lcy8047@gmail.com>,
	Sang-Hoon Choi <csh0052@gmail.com>,
	Linus Walleij <linusw@kernel.org>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 391/571] gpio: exar: initialize the ID before registering its cleanup
Date: Wed, 28 Oct 2026 17:58:58 +0100
Message-ID: <20261028170017.291875893@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sang-Hoon Choi <csh0052@gmail.com>

[ Upstream commit 4d69e74034b208588636ecc177e0dd43a7696af3 ]

devm_add_action_or_reset() invokes the cleanup action immediately when
registering the action fails.  gpio_exar_probe() currently stores the
allocated ID in exar_gpio only after registering the action, so that
failure makes exar_devm_ida_free() release ID 0.  If the allocated ID is
nonzero, this leaks that ID and can free ID 0 belonging to another device.

Store the ID before registering the cleanup action so both the immediate
failure path and normal device teardown release the correct allocation.

Fixes: 5300ebb695fa ("gpio: exar: use devm action for freeing the IDA and drop remove()")
Reported-by: Changyul Lee <lcy8047@gmail.com>
Assisted-by: LLM
Signed-off-by: Sang-Hoon Choi <csh0052@gmail.com>
Reviewed-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/179070265834.12871.48183786512201899.idr-bug-79@gmail.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-exar.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-exar.c b/drivers/gpio/gpio-exar.c
index 902a385ae7339..320424dccc4e9 100644
--- a/drivers/gpio/gpio-exar.c
+++ b/drivers/gpio/gpio-exar.c
@@ -166,6 +166,7 @@ static int gpio_exar_probe(struct platform_device *pdev)
 	index = ida_alloc(&ida_index, GFP_KERNEL);
 	if (index < 0)
 		return index;
+	exar_gpio->index = index;
 
 	ret = devm_add_action_or_reset(dev, exar_devm_ida_free, exar_gpio);
 	if (ret)
@@ -181,7 +182,6 @@ static int gpio_exar_probe(struct platform_device *pdev)
 	exar_gpio->gpio_chip.set = exar_set_value;
 	exar_gpio->gpio_chip.base = -1;
 	exar_gpio->gpio_chip.ngpio = ngpios;
-	exar_gpio->index = index;
 	exar_gpio->first_pin = first_pin;
 
 	ret = devm_gpiochip_add_data(dev, &exar_gpio->gpio_chip, exar_gpio);
-- 
2.53.0



