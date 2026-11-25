Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620114;
	b=YJFyf3UiCFwzE4lkFkx788zIZof073zC8Ae66MkAdSAmKGifOhikEXZhpWR4sneaIxms
	 droJoCp3zmmj/Nte9a1+26RleuNU07XE6R9GwYV++fJzRaNUhf9YXtgV85vqyrW4pB/J3
	 8oCl3vxeUPaqjSM8bfh/U2zc9PdfmV1djOgR8xFfmctKAQivwtQzMyxqKw8nENLB3U2GW
	 BaedHzp408TqtphwnWHY4fbkk5bMvcTXLez8Narop0C1UrXGcKF8HHAw1CuFYBQPRSA6Q
	 +/nt+hamQmWLoMZdMlz6bF+q/+izxWN/MbCx5sGOdHHPftQIr0ha670bk9tR11bRHzQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620114;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JTK7XbeHAws4upIw07iVHATrefXuu4o6xbi53SldinQ=;
	b=p3Dwv4nTC0dF1jmmfCzkwZrk2xNzFa+xt3/A5MPSc8jSqtRIGw/+frzN8DYZwVlp3THl
	 Agnt9y11PkfaFNSUlrJUru24SETdYAVKUPKs+3OuermqyzxTPX11XIbIBPzo8FREwqQk9
	 kco8GP4cplxZJC3Ltti//+Hzo6BqUbNipCdasHl0PlcLwRML7UJtRyuulSHXKKRu3+T4J
	 ZqYB4yA2A0l/U5X5s1IhtDdtcRBQK/hybGMZqrR4KHzRC63Rkb3sFldVy0jZZyl8iGSvF
	 GVdaKIiKZDSyuWDEk50RP0vzBlBLiTdEB+IFWyCneMdhB+Xgni/ttN08UCw2jknwzhg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Fof4Oo3F;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4183C606A321;
	Wed, 25 Nov 2026 15:21:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Fof4Oo3F
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DB291F000C4;
	Wed, 25 Nov 2026 15:21:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620114;
	bh=JTK7XbeHAws4upIw07iVHATrefXuu4o6xbi53SldinQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Fof4Oo3F2+g2+TLYMe5KioBqBtGoUHkpHOwj0RUpXagjuSWu0h2TVbfc/VZa+0hWn
	 RuFHl6pfx25ANuAPCROhgElhP82gD0KBh8lkmd/z0AoGpCVDYa0bfo2GuyW06w4Rvs
	 Gs29JBcvTR9qGOpjzXSdhv1vjP4h+7LW6oJ9MdEU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Mika Westerberg <westeri@kernel.org>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Subject: [PATCH 7.3 0813/1005] gpio: of: fix potential misconfiguration of hogged lines
Date: Wed, 25 Nov 2026 15:35:51 +0100
Message-ID: <20261125143840.772818529@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>

commit c62364eeac0f123478fca2f2d8e2424fdcd55032 upstream.

In of_gpiochip_get_lflags() the local variable xlate_flags is declared
without being initialized before its address is passed to
of_xlate_and_get_gpiod_flags() when processing a devicetree gpio-hog
child node. If a driver uses an of_xlate() callback that doesn't update
the flags argument (like gpiochip_fwd_delay_of_xlate()) we'll end up
passing that uninitialized value to of_convert_gpio_flags(), potentially
misconfiguring the hogged GPIO.

Initialize xlate_flags to 0.

Cc: stable@vger.kernel.org
Fixes: d1d564ec4992 ("gpio: move hogs into GPIO core")
Closes: https://sashiko.dev/#/bug/linux-2bb44847-fd6e-406c-878d-9739da2cb8b5
Reviewed-by: Linus Walleij <linusw@kernel.org>
Reviewed-by: Mika Westerberg <westeri@kernel.org>
Link: https://patch.msgid.link/20261105-gpiolib-of-hog-uninitialized-v1-1-fcaeaccefab6@oss.qualcomm.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpiolib-of.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpio/gpiolib-of.c
+++ b/drivers/gpio/gpiolib-of.c
@@ -725,7 +725,7 @@ int of_gpiochip_get_lflags(struct gpio_c
 			   struct fwnode_reference_args *gpiospec,
 			   unsigned long *lflags)
 {
-	enum of_gpio_flags xlate_flags;
+	enum of_gpio_flags xlate_flags = 0;
 	struct of_phandle_args args;
 	struct gpio_desc *desc;
 


