Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9073C256C8B;
	Wed, 25 Feb 2026 01:40:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983647; cv=none; b=UVQ07JT3NBFOaI7YZGK+DKKQc4WUhNipkvSDHwKqpW+/QjVStLjJeTY4nPpcrkXXe/+Td9IHQQUpbpkpERvKDczVW0yjNYmw9GRLjPaQNHpZFlZvhqacfQyWlXKP3Rw2zHT6G8fIfEeocLRiOeoJ0F196Obk76A43wswJHnMvzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983647; c=relaxed/simple;
	bh=868/8SyeUw4KEpVYTFDky8MpE2uLlOYLLstGlG5xeJw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hi2AQE8y+fHSpSKjsvzw/nV4kQ2ZMueH1k5FCDUOTwVlOOUbwkZXTyo+vNp2hIZ/YyBRCLqoAIIPsghB9y16SOVsjkoz7rIG+KOLtsbP8qv28QY1Zi/cL3eokgv0XKlXXDoZEuA9l5aEa/HAremM6DFS6yFdYZBJupF4MMAFAC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xsmm4Dz5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xsmm4Dz5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52C1CC116D0;
	Wed, 25 Feb 2026 01:40:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983647;
	bh=868/8SyeUw4KEpVYTFDky8MpE2uLlOYLLstGlG5xeJw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xsmm4Dz5xMr1bnKRmNC1+2fW+OTm7HwuQVp7KNUDOlNxP2qdPcViC5tQmev/neLcs
	 YBfM+hz3n7Hy1kbZJrytJIvyPoPxmRf5zJfw9IZaxXZS4+3mJoxF1vQQH52PhTtWFq
	 hHgGyyBHtbdBkDZVmkONdHHqsjKPtkcQj53ATJzc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>,
	Tj <tj.iam.tj@proton.me>
Subject: [PATCH 6.19 734/781] gpio: amd-fch: ionly return allowed values from amd_fch_gpio_get()
Date: Tue, 24 Feb 2026 17:24:03 -0800
Message-ID: <20260225012417.733536548@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

[ Upstream commit fbd03587ba732c612b8a569d1cf5bed72bd3a27c ]

As of 86ef402d805d ("gpiolib: sanitize the return value of
gpio_chip::get()") gpiolib requires drivers implementing GPIOs to only
return 0, 1 or negative error for the get() callbacks. Ensure that
amd-fch complies with this requirement.

Fixes: 86ef402d805d ("gpiolib: sanitize the return value of gpio_chip::get()")
Reported-and-tested-by: Tj <tj.iam.tj@proton.me>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Link: https://patch.msgid.link/aZTlwnvHt2Gho4yN@google.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-amd-fch.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/gpio/gpio-amd-fch.c b/drivers/gpio/gpio-amd-fch.c
index e6c6c3ec7656e..9f329938202bf 100644
--- a/drivers/gpio/gpio-amd-fch.c
+++ b/drivers/gpio/gpio-amd-fch.c
@@ -8,6 +8,7 @@
  *
  */
 
+#include <linux/bitfield.h>
 #include <linux/err.h>
 #include <linux/io.h>
 #include <linux/kernel.h>
@@ -120,15 +121,15 @@ static int amd_fch_gpio_get(struct gpio_chip *gc,
 			    unsigned int offset)
 {
 	unsigned long flags;
-	int ret;
+	u32 val;
 	struct amd_fch_gpio_priv *priv = gpiochip_get_data(gc);
 	void __iomem *ptr = amd_fch_gpio_addr(priv, offset);
 
 	spin_lock_irqsave(&priv->lock, flags);
-	ret = (readl_relaxed(ptr) & AMD_FCH_GPIO_FLAG_READ);
+	val = readl_relaxed(ptr);
 	spin_unlock_irqrestore(&priv->lock, flags);
 
-	return ret;
+	return FIELD_GET(AMD_FCH_GPIO_FLAG_READ, val);
 }
 
 static int amd_fch_gpio_request(struct gpio_chip *chip,
-- 
2.51.0



