Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD11B47125C;
	Tue, 21 Jul 2026 18:16:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657763; cv=none; b=GU4+8VQEPo1TXj6tLvdrJDdmEYLqs+W4BW4KZpM4S7QDoSmW/qPMndnBbCzH2qWyhx0VoYG6LAYgMolBjGZ+hcfcqznMUNWWEA5CgNbGraM1LWolwUp9T7rTtXKql2R+cOY9L3O0XhcpQ9nT6YAvgNbIZSlpOw+evw1Ay09YTtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657763; c=relaxed/simple;
	bh=Lv9jvYJggOJ00VERSG9FCwluF7aj8dPyiOixK90OSQE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HkZwfutJHnxm/AYIzu0mRMF9KdfLw3bsNoJxbKxQMzWylvC236tEvBYfmNIVgF2GM2Vg4leA3sPEkZj8bic+nrsmNe31cIbNucXjowjoUql2vp/jtOHObiBz6GS2ZWIMjqlQx6BXjXhZmEloXROG6EruLcGmejI4iVRiD0n2OMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fvJpPI0U; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fvJpPI0U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E06C1F00A3A;
	Tue, 21 Jul 2026 18:16:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657762;
	bh=EGjpzUbZJ2Q1P+MK0OZBrJxGbDjCy4oPmnKeO34oACE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fvJpPI0UmFeF6OdACnv0LKLEegddPSBPtehtwElGYMyuqRxjIewLlKP4PFCCZUcW9
	 Oht4DVIJgHsArdf0PlbxZAOQgqNeYOM2orDErh2yimHbx+u7kuKAYHnDenMNTlJvvL
	 Rjz3JdUZn4NDM+xSaZGOD66XKd8HcWzg4rC+tDzY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0881/1611] gpiolib: initialize return value in gpiochip_set_multiple()
Date: Tue, 21 Jul 2026 17:16:37 +0200
Message-ID: <20260721152535.207581774@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ruoyu Wang <ruoyuw560@gmail.com>

[ Upstream commit 99dfa46baba29513d1094c8f30bc86c6ef88543a ]

gpiochip_set_multiple() falls back to setting lines one by one when the
chip does not provide set_multiple(). If the fallback path receives an
empty mask, the loop is skipped and ret is returned without being
initialized.

Initialize ret to 0 so an empty mask is treated as a successful no-op.

Fixes: 9b407312755f ("gpiolib: rework the wrapper around gpio_chip::set_multiple()")
Signed-off-by: Ruoyu Wang <ruoyuw560@gmail.com>
Acked-by: Uwe Kleine-König <u.kleine-koenig@baylibre.com>
Link: https://patch.msgid.link/20260620155319.79994-1-ruoyuw560@gmail.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpiolib.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 67f362d53d53f5..9d3c33e1c9f995 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -3657,7 +3657,7 @@ static int gpiochip_set_multiple(struct gpio_chip *gc,
 				 unsigned long *mask, unsigned long *bits)
 {
 	unsigned int i;
-	int ret;
+	int ret = 0;
 
 	lockdep_assert_held(&gc->gpiodev->srcu);
 
-- 
2.53.0



