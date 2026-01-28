Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 664552FE044;
	Wed, 28 Jan 2026 15:48:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615329; cv=none; b=uXLwelzTFm5BN6Kg1ECJaBp/9D0foLJIOUn6VrTyQLPTqpNh04Hq30uhWWSNx8LSyDFg16XgCuVF4o16XmbmcTkvQ1uVgf8fJW67jQZDxAgRYvwCw5Aml48kHJPDDV8P/YgRulspn1OPvN3FPSsttMfe8jRartaZ4ecJTxZ5Yd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615329; c=relaxed/simple;
	bh=BvWMQuLifGXD40IIuBptYfbqwVdMxUrm8+EfNqX8PF8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oRVlDJKmBtogZNlyLXQ27cHxIbJarkgTwmqyRh9gyu1vWbqFwEr8wwI4kA+fD/dJw5aYqsFiurMd1pMhE+iWEAKEo1bXEze4gMzUwl6ChvFhCEgRjhLqb1iFDi0PuPB0xAsly4Wp8tWQB2bxzw5bBLNmT9rKt7a8LHpGK+2+8qM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mft0qRxK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mft0qRxK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4DFCC4CEF1;
	Wed, 28 Jan 2026 15:48:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615329;
	bh=BvWMQuLifGXD40IIuBptYfbqwVdMxUrm8+EfNqX8PF8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mft0qRxK0MaJWaqR1qs2tbuG9lDgzVT6jFdN3BXFCxtnzC6FTMzAoqFzMHYN8CEEG
	 tqHn94CuHIPZLBIPmmb8X5FGeshPooQmBEg1yecfkzyrhrOu4JU2Y/hGB1h8tCk3Mq
	 J/ehF+y7GAp7TotfPrYoIT9wPB61Cw9WntNOz5AA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Subject: [PATCH 6.12 145/169] gpio: cdev: Correct return code on memory allocation failure
Date: Wed, 28 Jan 2026 16:23:48 +0100
Message-ID: <20260128145339.224122332@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145334.006287341@linuxfoundation.org>
References: <20260128145334.006287341@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tzung-Bi Shih <tzungbi@kernel.org>

commit faff6846474e99295a139997f93ef6db222b5cee upstream.

-ENOMEM is a more appropriate return code for memory allocation
failures.  Correct it.

Cc: stable@vger.kernel.org
Fixes: 20bddcb40b2b ("gpiolib: cdev: replace locking wrappers for gpio_device with guards")
Signed-off-by: Tzung-Bi Shih <tzungbi@kernel.org>
Link: https://lore.kernel.org/r/20260116081036.352286-6-tzungbi@kernel.org
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpiolib-cdev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpio/gpiolib-cdev.c
+++ b/drivers/gpio/gpiolib-cdev.c
@@ -2767,7 +2767,7 @@ static int gpio_chrdev_open(struct inode
 
 	cdev = kzalloc(sizeof(*cdev), GFP_KERNEL);
 	if (!cdev)
-		return -ENODEV;
+		return -ENOMEM;
 
 	cdev->watched_lines = bitmap_zalloc(gdev->ngpio, GFP_KERNEL);
 	if (!cdev->watched_lines)


