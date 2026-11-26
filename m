Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704410;
	b=lLYM0X1C3NlBY4H7CSQB3pjMkgLzbU0DjFEYZG8L1sH8pAQb/Z9SXsoBdtFcotOv8Vod
	 eYdFzPQDtOlsNZxNJTwg65rdlzGpGlux97Kni7nwe3f1ap3iVa+tibU12fnjoeL7o5IXP
	 shuVCEi/MDVGz34OPOGa/bdP9bu9BV0+hpHx45epGLVZ1RFA/fZia0cpk+0PKXfS2JH/C
	 JXXsXEYaX3yR6alznqc99kRb/pEWRc1jvImhuCTcDA8GtwXvP2WWtiKP3/huXoi9IQwhg
	 iu+KC5zU6PXdMXOvZ25WW1XHAurs5tCjyWq126KBh4SWUdiMQ7HE2xzaQJPDx83PlAA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704410;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=elr0WOK10YbzCKAujKiziieJgbO2Ew/fF7NFimZr2g4=;
	b=j/3P1Go9LJIeEpqV/f+bcPmINvayoKv4wkcBX3QtnUYY+FEUQIPqWlMFZZ63XHOWjVXZ
	 pyLM6lFg3LvWcF5d6LAze13ecY1CIj5mdTGSehGdvoeXOeLMdfjF6Q5lzAc2VVCaeoErw
	 u6Zlv8fwWq0tvChSCFK+GZAyE+dgEJ7O5VPBQRO9x7/J1di6haEsscVjRWc25P1e9rH4E
	 VCQ4eWyo8GPhH5TdcoJ262s24JoaghqRZJ5D6nMcZV9a0jUe2FnMLh0Aj978PUP1i6E+Q
	 1rGuMDOZWR9LUKkHDfZcjXkuDSUVPfI+UdnLDGGQCo4T9oW2jYJm0oG/Laz9NnwrK1Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AqeAmHue;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 336BC606A31C;
	Thu, 26 Nov 2026 14:46:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AqeAmHue
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70FD81F000CA;
	Thu, 26 Nov 2026 14:46:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704410;
	bh=elr0WOK10YbzCKAujKiziieJgbO2Ew/fF7NFimZr2g4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AqeAmHueKmz+saEisVUmnH0pfyTqsj6jdw2sDUTGFEhfGWt/qWDvu1jd7i3IO8gj6
	 mvLPNuFMZunKKNL3eR6G+llpzcxgkfL1UNTZyAkYvobqmL7h2Y2aiS1LW5B5/lF+If
	 keQrCx+SzZxWVdoAqO/Fr1Hy9JuVFvimQuzSAGn4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 115/265] gpiolib: of: return -ENOENT from of_gpio_count() stub
Date: Thu, 26 Nov 2026 15:37:25 +0100
Message-ID: <20261126143613.054875505@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

[ Upstream commit e20e4b8cda2b4d7dd32dbd2c0875a15d92545f04 ]

gpiod_count() and its firmware backends are expected to return either a
positive number of GPIOs or a negative error code (-ENOENT) when no
GPIOs are assigned. However, the !CONFIG_OF_GPIO stub for
of_gpio_count() returns 0 instead of -ENOENT. This causes gpiod_count()
to skip the platform_gpio_count() fallback (which triggers when
count < 0) and erroneously return 0 to callers.

Change the stub to return -ENOENT to match the real of_gpio_count()
implementation and the other error-returning stubs in gpiolib-of.h.

Fixes: f626d6dfb709 ("gpio: of: Break out OF-only code")
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Link: https://patch.msgid.link/20261105-b4-gpiolib-free-v3-3-bb47ad58642d@gmail.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpiolib-of.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpio/gpiolib-of.h b/drivers/gpio/gpiolib-of.h
index ed26664f15378..7951793358c0e 100644
--- a/drivers/gpio/gpiolib-of.h
+++ b/drivers/gpio/gpiolib-of.h
@@ -27,7 +27,7 @@ static inline int of_gpiochip_add(struct gpio_chip *gc) { return 0; }
 static inline void of_gpiochip_remove(struct gpio_chip *gc) { }
 static inline int of_gpio_get_count(struct device *dev, const char *con_id)
 {
-	return 0;
+	return -ENOENT;
 }
 static inline bool of_gpio_need_valid_mask(const struct gpio_chip *gc)
 {
-- 
2.53.0



