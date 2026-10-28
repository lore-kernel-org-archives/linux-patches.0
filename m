Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216797;
	b=xNIl/Z3NUj6bocqP1hyBm2MDso9Wac0deHbn3zEMMxZpdIOASrYzCNGBPXzm9SnhfwHV
	 CgN8jsK0lAJgkMc9hxZUMJAXGwqUB53UiXURUN4w3TDElwOaZMliVxTzOPs6fIxbXBQih
	 90MFWSiW/3MVBszzpbOVSO27QPQ7Uc2Y4u7pUi4+HrjOOMh9xHyLgs4VZzFL8GAP5axSw
	 SNM8fOurYmb6lFZmf/mhfeD4oeRcsfnhAq+pTFL23Ard7NDpyYQq0X+e7ziPisylkTp90
	 +3Stos4y3N+G4KvhM3nI+6CEUD+vdkX58qRkz56iFA1DitQvxZs0Kq96a+p4oezOgYw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216797;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fcx7ttRFpvAy3RFEuzWwoBD4plFdWow38QQ9KMu2ih4=;
	b=QHH/5eDtJmuncpBDI8/xy70+QeCl8z4ed4zGJucGOVYBjTlgjTCVBvhR/FSSMZk5PlkW
	 zEpAvIZWCSV2a8N3Biphb3fxUk/pacDmIIbkPIoP6rMHRRt0S6vgbtAaxuU83AS4zRZCm
	 XT32FvpYxELmg/wF7YigWsJuAX0fBSP+z/NCsbgGB87VMpVPw9FtuiFdUhWuyDLdVuUN0
	 Zvqe3h9uUlWgN0Wc9Uaw6wva4F6CPvrS+IuwKc/EIjn1Gt7ama9aqdRMLZaeFAyvKAjfH
	 J//ZSqiTTQKsuYFhcZcd0WiXTEBV0v2qEns6W1JOFkE75GaAo0lQyBs3CZH3L8ehjnA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nW1usuZ9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8E9C606A31D;
	Wed, 28 Oct 2026 19:46:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nW1usuZ9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4382C1F01825;
	Wed, 28 Oct 2026 19:46:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216796;
	bh=fcx7ttRFpvAy3RFEuzWwoBD4plFdWow38QQ9KMu2ih4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nW1usuZ9bReqckfWilCjNJsyOtzhRWVqwiTzES3YSISs2cjR9jUg+qxUF6X1nQtwt
	 c8wUOZegEJMqUV4Qwp9lqEHtZ1tt4IX9s2ulXCOLWeNkVWY5Lfrw933G1uTXNKGUvn
	 3nGyLpFV42LMwmO5pgAfHa0UEP8itrYPgcPpRLKk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wenst@chromium.org>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1681/1887] pinctrl: mediatek: paris: bypass pinctrl GPIO layer in set GPIO direction
Date: Wed, 28 Oct 2026 18:02:57 +0100
Message-ID: <20261028170537.711447059@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen-Yu Tsai <wenst@chromium.org>

[ Upstream commit c87c9046c4e00d599454e033a477176c4d73ac2a ]

pinctrl_gpio_direction_input() / pinctrl_gpio_direction_output() take
the pinctrl mutex. This causes a gpiochip operations to need to sleep.
Worse yet, the .can_sleep field in the gpiochip is not set. This causes
the shared GPIO proxy to trip over, as it uses gpiod_cansleep() to check
whether it can use a spinlock or needs a mutex. In this case, it ends
up taking a spinlock, then calls pinctrl_gpio_direction_output(), which
takes a mutex. This causes a huge warning.

While this class of Mediatek hardware does not have separate clear/set
registers, the pinctrl context has a spinlock that is taken whenever
a register read-modify-write is done. Also, once the GPIO function is
selected / muxed in, further GPIO operations do not involve pinctrl
operations or state. The GPIO direction and level values do not require
toggling the pinmux or any other pin config options.

Switch to directly calling mtk_pinmux_gpio_set_direction() in the GPIO
set direction callbacks to avoid taking the pinctrl mutex. Drop the
.gpio_set_direction field in mtk_pmxops to signal we are no longer using
the pinctrl GPIO layer for setting the direction.

Signed-off-by: Chen-Yu Tsai <wenst@chromium.org>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/mediatek/pinctrl-paris.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/pinctrl/mediatek/pinctrl-paris.c b/drivers/pinctrl/mediatek/pinctrl-paris.c
index 464bedc0fe454..bb9c70a1333be 100644
--- a/drivers/pinctrl/mediatek/pinctrl-paris.c
+++ b/drivers/pinctrl/mediatek/pinctrl-paris.c
@@ -770,7 +770,6 @@ static const struct pinmux_ops mtk_pmxops = {
 	.get_function_name	= mtk_pmx_get_func_name,
 	.get_function_groups	= mtk_pmx_get_func_groups,
 	.set_mux		= mtk_pmx_set_mux,
-	.gpio_set_direction	= mtk_pinmux_gpio_set_direction,
 	.gpio_request_enable	= mtk_pinmux_gpio_request_enable,
 };
 
@@ -899,7 +898,7 @@ static int mtk_gpio_direction_input(struct gpio_chip *chip, unsigned int gpio)
 	if (gpio >= hw->soc->npins)
 		return -EINVAL;
 
-	return pinctrl_gpio_direction_input(chip, gpio);
+	return mtk_pinmux_gpio_set_direction(hw->pctrl, NULL, gpio, true);
 }
 
 static int mtk_gpio_direction_output(struct gpio_chip *chip, unsigned int gpio,
@@ -912,7 +911,7 @@ static int mtk_gpio_direction_output(struct gpio_chip *chip, unsigned int gpio,
 
 	mtk_gpio_set(chip, gpio, value);
 
-	return pinctrl_gpio_direction_output(chip, gpio);
+	return mtk_pinmux_gpio_set_direction(hw->pctrl, NULL, gpio, false);
 }
 
 static int mtk_gpio_to_irq(struct gpio_chip *chip, unsigned int offset)
-- 
2.53.0



