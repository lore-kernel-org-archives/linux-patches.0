Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621943;
	b=K9Ai/NZ512UosHQQI52MgzEC6sbG4xhIBrto+8QmDYRAd5uy5Z7lvmt6+czE/SScXidE
	 fn4vIBXK5vmXWYPeaymU8SISanymaymL7Tnm1cOQGHjM9KPqdXTt2NkjM4GmmLaSMoKhB
	 4K9pnf8kTCEi3qtnBFzbokVku7hqkl/FS95AxV8Xf8opWcOwFCleu9CAiOabAMEg4vInp
	 tin6xHK5uuBeM3lZQRraukUr872VilIM+4/66+48/ZPb+1csc4a0o2VDlxcRGwegQYzx6
	 beUicMaeHRKiOQsHzRH4HM1Dgb+KA3u6U2t7hSG14dyPZUKRUZrbMoF/hr9ObPhqk3Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621943;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wIwHcK2FxKJn9wZO1N4jh443yG8uYSPbkrqQserX4ws=;
	b=XMX9GwwWBQDJPb+AyIYPAWW5sSUVC8lr0Oh0KhL+vn5mLP9k/n6cbA37Z79fuk9BnTVO
	 xMGgfq5mm4uySvjPpnrHw8DEIRTvk9jUOCSitYEtYjjTkLuRiNZuEaDnfuzGL/FZsfaXO
	 vFqEBnNIMOFTttWvqenP+A9018aefeA5DLnQ2aBEHO3511pmjGWgjELQ9YkM7llUxMRMD
	 MOn65Utj+vc8whQqgCBBB0MXr7+H+mp4hftgTm/oGaSrwb3RDZP+bvtDuZLeNPQUuRFM1
	 KFDInimOv7oxQ1wcJUpg5HHYGL9GL4MYSEuRaerfDcWykvfNfZdNKXEFz/ctKjq8G/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GtiKnCRx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F535606A323;
	Wed, 25 Nov 2026 15:52:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GtiKnCRx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1F471F000E1;
	Wed, 25 Nov 2026 15:52:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621942;
	bh=wIwHcK2FxKJn9wZO1N4jh443yG8uYSPbkrqQserX4ws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GtiKnCRx34AFdsDp2T64ad+WX6r4NFBiUrljYeku7DKa5j2N12wmp9T78M9vn9sUe
	 o8KF3oXdjcPgDs+qzjShvCOH02zpDFsfMZ9WyUJ8OgqZ28Eu7kd/DIq05T/RM+zCnn
	 QM8jYuwcNT0kl2DgkbjHMs36gUUMyCHLcnbTSqpU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 354/990] gpiolib: of: return -ENOENT from of_gpio_count() stub
Date: Wed, 25 Nov 2026 15:28:41 +0100
Message-ID: <20261125143830.385382600@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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
index 2257f7a498a10..4778b46256bb9 100644
--- a/drivers/gpio/gpiolib-of.h
+++ b/drivers/gpio/gpiolib-of.h
@@ -42,7 +42,7 @@ static inline bool of_gpiochip_instance_match(struct gpio_chip *gc,
 static inline int of_gpio_count(const struct fwnode_handle *fwnode,
 				const char *con_id)
 {
-	return 0;
+	return -ENOENT;
 }
 #endif /* CONFIG_OF_GPIO */
 
-- 
2.53.0



