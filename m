Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624709;
	b=yiXMXFtX1KUyi6q8IOj6Fd4QdztLbfPJgXIphKW0xyIgXGfnq4JTekLfRKxRqHcFmI3K
	 kkYloOfLZgL8EcoqDkj6fPJvaCaNMFDdhCJCQzjeBiqGp3zADVgD82b7tweWZWNxTkgQK
	 mUV5sp8RVaiL9kYnDvLnaQkzAFGxAxDf4O0YmBjVHWyVsOlbXIIZGO1GE4un2R58TdQic
	 xHMPfTSC5f29G8YuMbQpenwGdWRA9ulOysw2foWHmArp8BYePJiAeevZQBkEP11oKGAFR
	 U2abS1mmzum0S2L/QaxSs1gPsPZUk+kktKsKLA0hxgM5nlmxqsgayxIOQLfaWN6Pqug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624709;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hoyaycmQx7cwOUl+8YWMOoo8o69elLZx0gwnEFUIEy0=;
	b=FAbYgP8GcznLQhDycST31SCt0CWXKGlxkONtI135csKKwTDn0m6HOmJDAy5JLmByV4li
	 6kFyIDMi4OIKxle9gl++X2AHDedxPAgWSJ3KesRsYCo8S7IPoxy/k7FSsAL3ZCdVjniff
	 tZWlbTN2Tah2qELIpi0eO7bphjO2B0uKE8f2ikKpnm4p44MGvsRz/5pDLJGRrrw6HNfSn
	 CWrZv7iKU1JqbRIVKAJv436brAfg2sRKwj3gjgifWXCXrsaF4RC2hQ/U53Pk99f3vspGE
	 tlWir5jQKAPyFEgSytkk3/eGOiwuuyB46yf/lQHYaixrI8i4s4ovtrDSAqTGMpEq23w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="fDIpZI/E";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C35B3606A33E;
	Wed, 25 Nov 2026 16:38:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fDIpZI/E
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 224991F000C6;
	Wed, 25 Nov 2026 16:38:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624709;
	bh=hoyaycmQx7cwOUl+8YWMOoo8o69elLZx0gwnEFUIEy0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fDIpZI/Ee0ZEUUoUCvjlQjZuV1AeKXoT7OXnoVuBzHCws0yVhOZ67qVFQLHHMvhaO
	 SVDJzgmYehjb7UUor5ZfFvwqALzJdGVmUYnqVw0Znpq4j7nC9KZxK7s1Asxg6fYl6F
	 5wQaWJyM3us81/ghnV3dUqDiKQy79hPZDxsPIXZk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 283/816] gpiolib: of: return -ENOENT from of_gpio_count() stub
Date: Wed, 25 Nov 2026 15:30:31 +0100
Message-ID: <20261125143855.758504005@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 16d6ac8cb156c..a90fd075d9569 100644
--- a/drivers/gpio/gpiolib-of.h
+++ b/drivers/gpio/gpiolib-of.h
@@ -36,7 +36,7 @@ static inline void of_gpiochip_remove(struct gpio_chip *gc) { }
 static inline int of_gpio_count(const struct fwnode_handle *fwnode,
 				const char *con_id)
 {
-	return 0;
+	return -ENOENT;
 }
 #endif /* CONFIG_OF_GPIO */
 
-- 
2.53.0



