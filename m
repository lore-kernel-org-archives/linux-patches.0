Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705247;
	b=kj6whbnQ6u3ww48B3U541uPSOuJshxZxUsViVNxv6Tz+NgcfyCORPD2Wa5nFzzfQLkAl
	 6dmE7BH51hgm+UWCHBW/cdYViGDHQwTjF/NMe6IqyGPQ/kFY1+LoqYS6aN27VEQcBHCNO
	 2Tn03wWSf506S7+eHOJ/iTgG+krEVHr5Eh1dNid/t6gt5cCRk2tjzs93gxycHcTOaHh8o
	 ptFBxSM0vHYv3MrKmk9zfGPtb5uvJLZ216YLulAZmfWhIkz7BFC55Fg4qsc/+pcb/t4h7
	 CGnmdWPU5l/Bt3rI5MyA9qN4Sa8iDn93abnB5+hQealnmIReqFFlhr9hJFskTiaB1Og==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705247;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=O4SaNfeDHt5KP9S6mR0l9JPfVFV3SkgkHrS/0LH4aa4=;
	b=WaT5TX9OH2p2KBlqIMWVoCJHSnUUvY6/A3Nh/3+pCuFDAOLatCWNHFLHZUmx112sHUxb
	 66OGgy30vtzIT65eMMvDXBJ4rGu9D18lg/Go0Hn3lm/PeSijFSBZ4wVoopA/U3joJnOya
	 6Dqw+kTz4Yo8YFNA65F6MyCq810JkMVh9kfru66MoPHuOpujsYRnoswbcpUj0MWVUYPbA
	 RjW2+x5SZtnfL98Ess6VfqxtoIhyxagzuyCt8Bqfi1pDBH30/Kcw35UmeWER6+Ouarazh
	 wdJlK3vvqtJ604GlHyXsPSGYe+oJfisOPCUN5y7WJZfXEQXGtUbVBt2PokOLRjVFf1Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="lP/sAuji";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03189606A31C;
	Thu, 26 Nov 2026 15:00:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lP/sAuji
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CBEA1F000C4;
	Thu, 26 Nov 2026 15:00:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705246;
	bh=O4SaNfeDHt5KP9S6mR0l9JPfVFV3SkgkHrS/0LH4aa4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lP/sAujimeCO5J5toAf5KqTlGsrAqIA9sCElmqYnqj1GjGP3JmGcbPrRNH5z24BQx
	 9xdovfSwgxNSRjZsO03hWyCLbnkAqWsXqh+jbPBvVQAryug1q5GJDs9n945SWOyfBc
	 XgqCSaHH4dcAIT47jBqIsuWwGvPRNulyzqh5j/xY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 135/319] gpiolib: of: return -ENOENT from of_gpio_count() stub
Date: Thu, 26 Nov 2026 15:38:23 +0100
Message-ID: <20261126144009.793652058@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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
index 8af2bc899aab2..9cab0194554eb 100644
--- a/drivers/gpio/gpiolib-of.h
+++ b/drivers/gpio/gpiolib-of.h
@@ -28,7 +28,7 @@ static inline int of_gpiochip_add(struct gpio_chip *gc) { return 0; }
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



