Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618968;
	b=P5KfWJT7wQYkW4SOL+fjBGYVwFlNhyK66TE4TjwiMUFNE8GNUQbbP50G4sZW4fqgGNLI
	 zVUtKdn0foGdJgH1kPQ4ixtOcwGYhXDT5N4xC9PW1JXQn++u/yirxgMoqSb8mSJNMIQ3H
	 UBbyVc7PDXF08mlqneIQwJY+XuuX3un0Y6aUveq7PDJtxkYdlTQH+WjYCqePBWD5mbye1
	 Gdm0wumSMEiFqZ4JMk2sLxQBSsT3RQhGeRtAnQHF0LAff9ej8HyT8ss5bAR83B/EnFGup
	 gwIdMyxueDoyhE3MnADqM739S2Ryxtkl3O48A7dnLeIAnXKIfXT8mWGPW9GDRNf3ocw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618968;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hf4nS61SG7U88m9VtDgJ5vpmiIoz0GDmdOLhv5PTHL8=;
	b=LogP3JPEVyVjTARi3ZLlhoDmKyB+F+H4t21l0xfDQ9v3/5huqxve00FTKjh8uAkuO6yv
	 LuqxmFKi4WNy7YnXsRqko07lrIn9ltB+7sXC8Jj1EF96rHl5PkJao1DCdZ5UXLjzQLDp2
	 PIhZnNMnVMBl1yQUWJHeu54kyNAbeYN3SbzVDlCm8Y0ss9ADt5VC5z+LLI+B8q7Xm77J7
	 Dqfm6Ph9CX0jUgOD4chkUcrHEP+3EuxAIF8OAdRlZ8bqcjuKGR7p5XAcdnWgtFfT/C89T
	 nESKECJnV4+1vw6SQ0S3amfuBzvZA8yjIxJkO/23wqpNLhf+26Q7o0u54qp/Ikvamqg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Fg8iFHAf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E560606A33D;
	Wed, 25 Nov 2026 15:02:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Fg8iFHAf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 157B81F000C0;
	Wed, 25 Nov 2026 15:02:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618967;
	bh=hf4nS61SG7U88m9VtDgJ5vpmiIoz0GDmdOLhv5PTHL8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Fg8iFHAfBTyM5idpFz48ifEHpj/N8icXznTDg0vgwZ7kb7nf1NDJkhJaMkHkzAuEt
	 t5AZWIxwXOQUFtbxkuyV87rGdHZsxqa/XXkz5p3ngG0CjRG8+1iWeSNqxHKkfXVlDA
	 /dsPbb90SWGDE9dTjp4aBdBTAQcrr886m65/wous=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0409/1005] gpiolib: of: return -ENOENT from of_gpio_count() stub
Date: Wed, 25 Nov 2026 15:29:07 +0100
Message-ID: <20261125143831.332673562@linuxfoundation.org>
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
index 218cfe5bc4ac3..9ca540d93f93b 100644
--- a/drivers/gpio/gpiolib-of.h
+++ b/drivers/gpio/gpiolib-of.h
@@ -46,7 +46,7 @@ static inline bool of_gpiochip_instance_match(struct gpio_chip *gc,
 static inline int of_gpio_count(const struct fwnode_handle *fwnode,
 				const char *con_id)
 {
-	return 0;
+	return -ENOENT;
 }
 static inline int of_gpiochip_get_lflags(struct gpio_chip *chip,
 					 struct fwnode_reference_args *gpiospec,
-- 
2.53.0



