Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795617768;
	b=FVt7mcvDLLITsEN2c7ujx7KIw4paUfVZgNTA4CpIlA+7eHBgcko160UWPIzgwaFUkwmI
	 etuO3/qwAI0tWc3t2PaN7Lk/Rycd9GhwwSpGmU2ltfqbgjVe5qHeFT1gjefuFF0uf77en
	 HxTQZHiKFByWh646HgyEr2tv8r66c1jZSQz0QJeRD5KSR1fgxARB8kTOd7wFrmztNp9ug
	 KMvVE3Oi0yGL+zWXZXcdT5KJY+LAfdJrrMnozVVuk6xfEn81AEPcA//l2hL7DoVEwz5Cv
	 Y3j89W42VNCCiXLmbCvfIJfQ5btzzxqFp8u7LFrCm+4/bGnt0AFxYweJSb6YQsLc/Qw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795617768;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wiJxW/oBdR8z4fDoSxk2hP6S7wg9HzKipOeK27ti+Oc=;
	b=pdDTn+kihX5wQiU7bt/PJ3clIDtcDq/YTwgojN2rLQA8I/kfEQCO7AfDdwryVIL1rfzL
	 2rcNW+gLZKvhsDnoTu8X6E8k3Ns2VWXkRdeN976lNRWjvDnZdd+SOsfQ/15hxUGtjmPWR
	 W4wMXLzf9P5wJOZvqUtHQwbs+NEDBKOznntQ+2WWrHCV8DlnRbqjWwU9MDMklfVDEJLC/
	 IFnaMy4+tFRlYbUv1NpTvSBFWHqmERnvs0BC4gg17DjAbrFrF8FB0zVhKf1zs57Q5qTY7
	 Jn8ikPwURaBRkCTh9x81UrpPWkrX/p8XV/upTpTJvHEGrktBYWJYRz6T1XyQA/TpLWA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NcfUstrc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 361E1606A323;
	Wed, 25 Nov 2026 14:42:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NcfUstrc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7327D1F000C4;
	Wed, 25 Nov 2026 14:42:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795617768;
	bh=wiJxW/oBdR8z4fDoSxk2hP6S7wg9HzKipOeK27ti+Oc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NcfUstrcjdxqgCdNmRYpCMd2cD+PNcZzjladT3nlrXj4gxxPbCc6lPkT+EWcqMFf+
	 N717xACdrPwRxZktnsBBLm4kdcEQ7f+SqLnJh2l9gpsYMZP4R8SxmmYHl0eHMozVQ4
	 BqJXMMXa39QkpfqLtrp7oUi0ENyA3xh0sIqPgEYE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avi Weiss <thnkslprpt@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0066/1005] gpio: omap: Propagate runtime PM failures in probe and request
Date: Wed, 25 Nov 2026 15:23:24 +0100
Message-ID: <20261125143823.288788650@linuxfoundation.org>
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

From: Avi Weiss <thnkslprpt@gmail.com>

[ Upstream commit 05be1a99d6d68b24cbe24a191e1af67c70193ac3 ]

pm_runtime_get_sync() can fail when the OMAP PM domain cannot
resume a GPIO controller, but omap_gpio_probe() and
omap_gpio_request() ignore its return value.

Consequently, probe can register a GPIO controller despite a failed
resume, while a GPIO request can report success and modify GPIO
state even though runtime-PM acquisition failed.

Use pm_runtime_resume_and_get() in both paths and propagate
resume errors. On probe failure, disable runtime PM and unprepare
the debounce clock when applicable.

Reproduced both failures on QEMU N800 by injecting -EIO from the
OMAP PM-domain resume callback. The original driver continues
probe and accepts the GPIO request - while the patched driver
rejects both operations with -EIO. Normal GPIO controller
registration continues to work without fault injection.

Fixes: 77640aabd755 ("OMAP: GPIO: Implement GPIO as a platform device")
Fixes: 55b93c32520d ("gpio/omap: use pm-runtime framework")
Signed-off-by: Avi Weiss <thnkslprpt@gmail.com>
Link: https://patch.msgid.link/20261029103626.1527919-2-thnkslprpt@gmail.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-omap.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/gpio/gpio-omap.c b/drivers/gpio/gpio-omap.c
index 005420baecf4d..98a88dfda1954 100644
--- a/drivers/gpio/gpio-omap.c
+++ b/drivers/gpio/gpio-omap.c
@@ -813,8 +813,11 @@ static int omap_gpio_request(struct gpio_chip *chip, unsigned offset)
 {
 	struct gpio_bank *bank = gpiochip_get_data(chip);
 	unsigned long flags;
+	int ret;
 
-	pm_runtime_get_sync(chip->parent);
+	ret = pm_runtime_resume_and_get(chip->parent);
+	if (ret < 0)
+		return ret;
 
 	raw_spin_lock_irqsave(&bank->lock, flags);
 	omap_enable_gpio_module(bank, offset);
@@ -1468,7 +1471,13 @@ static int omap_gpio_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, bank);
 
 	pm_runtime_enable(dev);
-	pm_runtime_get_sync(dev);
+	ret = pm_runtime_resume_and_get(dev);
+	if (ret < 0) {
+		pm_runtime_disable(dev);
+		if (bank->dbck_flag)
+			clk_unprepare(bank->dbck);
+		return ret;
+	}
 
 	if (bank->is_mpuio)
 		omap_mpuio_init(bank);
-- 
2.53.0



