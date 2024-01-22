Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E56716BB56;
	Tue, 23 Jan 2024 02:02:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975375; cv=none; b=BSnTJg4ggD1QPTS8+mz+GFqt6Wy+59S2oSVuzzOsjxqm6rX8e7YW/eiTXZNTnsturBmGlKhMKQFKwk4zEF4Tlu78pAT0JOHhHzTeAHjedbGeD3I+uSJEdI9EFbG58AI/t7DTNu337FLoV8xOAIR7jxi2bML0tkJW97ay/vxazVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975375; c=relaxed/simple;
	bh=1rQSdOYTvyyeB4Zm2uUC7L5zYEenqFlKLLLJqwdFPnM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NqlTh3POZQxZ4gVwROXRcZ6yXAfRt3KOXUz6oGQJBnRpMu3RMQixPIRGHLleZt5Hfb3TGdubhoYPTC+xO62uspLfHN9A5vHxkBocPrGMFOSJQI+bhScCG1iQk/ONX/XIx/yILRVQ7WwxrduLcEK+WOX8XqvPxXFKse5+BNoXve8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WjwsVM3i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WjwsVM3i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A99C8C433C7;
	Tue, 23 Jan 2024 02:02:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975374;
	bh=1rQSdOYTvyyeB4Zm2uUC7L5zYEenqFlKLLLJqwdFPnM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WjwsVM3il5ajxtMhFL4p0dU60rFmpsgYRHKER7MwuXusy2SdIug6wC+iAaRWBWblO
	 d0ghQWuba1Crjm5cjx2853NAlCSRXAuPzeR2ryQKFkKgmg71fMWtIKPO/IcOT/9dYH
	 /RwxyOAFHFEPMJHoCkcrC3d0mveMsCgb2m723BtU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 329/583] gpio: sysfs: drop the mention of gpiochip_find() from sysfs code
Date: Mon, 22 Jan 2024 15:56:20 -0800
Message-ID: <20240122235822.112631801@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

[ Upstream commit e404b0cc9f0b0b551f3276a814d38abf1f26d98f ]

We have removed all callers of gpiochip_find() so don't mention it in
gpiolib-sysfs.c.

Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Stable-dep-of: 48e1b4d369cf ("gpiolib: remove the GPIO device from the list when it's unregistered")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpiolib-sysfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpio/gpiolib-sysfs.c b/drivers/gpio/gpiolib-sysfs.c
index c7c5c19ebc66..12d853845bb8 100644
--- a/drivers/gpio/gpiolib-sysfs.c
+++ b/drivers/gpio/gpiolib-sysfs.c
@@ -817,7 +817,7 @@ static int __init gpiolib_sysfs_init(void)
 		 * gpiochip_sysfs_register() acquires a mutex. This is unsafe
 		 * and needs to be fixed.
 		 *
-		 * Also it would be nice to use gpiochip_find() here so we
+		 * Also it would be nice to use gpio_device_find() here so we
 		 * can keep gpio_chips local to gpiolib.c, but the yield of
 		 * gpio_lock prevents us from doing this.
 		 */
-- 
2.43.0



