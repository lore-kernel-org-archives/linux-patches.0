Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A077D3BF2EF;
	Thu, 15 Jan 2026 16:55:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496131; cv=none; b=E4QKc0oUSmkXWzEqou3/t1p3C2pGd2n9ECzL2OsVFDhpWUcZqyVelXARpTBpHsDAIHTSxZNmvidRbJRk3lgajpiFalqRNO3Jpm/V9J0EIslE7hEO2ellhPHHHjddrpmcqo5wtODkTCBHBNNl4/F3QFCQOpzK8OIeBx8jbJSj1mI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496131; c=relaxed/simple;
	bh=FKPRZkRQTLUWQLNNZpz99N+r4GXCqax9cT570QK5sNc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=af+9wLfpIuFj7ADH7Xm4UtpmRqyrp0qbExuK2WoxMmjEhQlMIJZ4dJktAQmyuXca83/FDI7r7TpPop4ES914ssQGtBg89G8Mm7sitmCzaUj4NWs4avU+FT/ZhfrMCqcb+nnDYJIN8fzFL9qlMS+qzBnK9j6kZRcehrSa6SLsWSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1ltGh7sG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1ltGh7sG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA9D9C116D0;
	Thu, 15 Jan 2026 16:55:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496131;
	bh=FKPRZkRQTLUWQLNNZpz99N+r4GXCqax9cT570QK5sNc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1ltGh7sGQ4Wao0oJAmADt9JvdJQrjz78efAJXOZGTRF08OwZACQNDG/xoRO17gajl
	 lJ82Z0NSe+PSlfD1+woModiZfUqUl3uubcuIC6V3elLS9JxGBpKowOUKUOi8tl15ir
	 k91q8iqkpEeTQ6qZMUHnZ06hcPsjfn+KLaT2ahrM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linus.walleij@linaro.org>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 089/181] gpiolib: remove unnecessary out of memory messages
Date: Thu, 15 Jan 2026 17:47:06 +0100
Message-ID: <20260115164205.536647780@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164202.305475649@linuxfoundation.org>
References: <20260115164202.305475649@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

[ Upstream commit 0ba6f1ed3808b1f095fbdb490006f0ecd00f52bd ]

We don't need to add additional logs when returning -ENOMEM so remove
unnecessary error messages.

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Stable-dep-of: a7ac22d53d09 ("gpiolib: fix race condition for gdev->srcu")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpiolib.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index cd8800ba5825f..f2ed234b4135e 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -2316,10 +2316,8 @@ int gpiochip_add_pingroup_range(struct gpio_chip *gc,
 	int ret;
 
 	pin_range = kzalloc(sizeof(*pin_range), GFP_KERNEL);
-	if (!pin_range) {
-		chip_err(gc, "failed to allocate pin ranges\n");
+	if (!pin_range)
 		return -ENOMEM;
-	}
 
 	/* Use local offset as range ID */
 	pin_range->range.id = gpio_offset;
@@ -2379,10 +2377,8 @@ int gpiochip_add_pin_range_with_pins(struct gpio_chip *gc,
 	int ret;
 
 	pin_range = kzalloc(sizeof(*pin_range), GFP_KERNEL);
-	if (!pin_range) {
-		chip_err(gc, "failed to allocate pin ranges\n");
+	if (!pin_range)
 		return -ENOMEM;
-	}
 
 	/* Use local offset as range ID */
 	pin_range->range.id = gpio_offset;
-- 
2.51.0



