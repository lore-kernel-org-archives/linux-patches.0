Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705021;
	b=vW1spVu4HdEzK47yWkxb9MfO4vhOaNxqpHoTPN0n0p0z6MpyA83wAYwf/9tFpCI3Onid
	 SLh0PWeGw2tzcasFYaun0j80+wvc8sfo6Kf3sNqIN2qEry9VcRZfqHeN9uEnX6m54/of7
	 Pk5GMjwul4DrELfA3REax4pfpnpHWAXBLB6MFvJiZgULe6rlGb5u6oXHPuvGwDIO5D6Cm
	 CXSt+wYvEZ22oE1h+XLqf91LEqAZR4EAUWSBVsPMF4/5CZoR4lT+2WY6cUFE1sXWLqHER
	 FWG7Zl3egu3/+iLzTcjoaHeeuQ+cN/QF2Ss3GsCLLOsFSd7rXJA5taT68MDeYDuYGsw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705021;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kEtoMlNyJn/Zm9vf3NbB22oBprvDjnNtb0z+QaK0FKk=;
	b=Pj9wWXZpGNfVMeH7IOB5XUSv+CDpIzM7TWpRpL8P+VQ0MFWMU0oZRV5gYqmUCETrYf5g
	 h5AePMJMBpkteZ/LNKiZn4M9AnxF2fQXBUu8Rc2ECbq26Mf7q/C+gDFb5h80ZMVQCgU7p
	 lsRBHKP0dPijLPp7/Xz/yfIhmgGreZrMkbkYbK+rtdqGpmkFoNCT8qOA7w0UUxVtvNtWd
	 9XNZ3aSlYLIjqnyqJLRxPV2xwkQxXxzweAK97wZNJkfPqP1nE4zJJcWaLc0XAAiaKm1V0
	 iEodtTBxBtCoQchlGbWvinHAldotzpgXiBPj7OCCtHktQqnS052+7n2VhQhXiFeWy3w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ILHGUuV7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E1E0606A31C;
	Thu, 26 Nov 2026 14:57:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ILHGUuV7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E465D1F000C4;
	Thu, 26 Nov 2026 14:57:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705021;
	bh=kEtoMlNyJn/Zm9vf3NbB22oBprvDjnNtb0z+QaK0FKk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ILHGUuV7SBDYLe5yoDdcgoKZEREBPcM0Ncd3Km94xsP741uZffg+qrgSsMDla0AD+
	 9uWNG2qWlwZiAvF/S6vZOTYtFdod1ffbf3cU9QoVLkmhh2LSTTHazQbv2LviqTdfbo
	 KlL3Vj+BQSzniBsi2m8Acek+EFUWlk6oc5RpDSSk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avi Weiss <thnkslprpt@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 029/319] gpio: omap: Propagate runtime PM failures in probe and request
Date: Thu, 26 Nov 2026 15:36:37 +0100
Message-ID: <20261126144007.398596425@linuxfoundation.org>
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
index 171e2150c3626..cdb17d4bce747 100644
--- a/drivers/gpio/gpio-omap.c
+++ b/drivers/gpio/gpio-omap.c
@@ -777,8 +777,11 @@ static int omap_gpio_request(struct gpio_chip *chip, unsigned offset)
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
@@ -1465,7 +1468,13 @@ static int omap_gpio_probe(struct platform_device *pdev)
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



