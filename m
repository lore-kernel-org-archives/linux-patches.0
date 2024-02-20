Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89CC5446C9;
	Tue, 20 Feb 2024 21:38:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708465107; cv=none; b=ZrOpZkGkG3DV/n3AtEbVxfaGKZcxJ1PbYrevjw6vVU6xxnL3CSIPi0Ynp+4Hb4eEKJzrAdKp/4iDMNI1wR1RgLBABwsq6dK/MKeS3oflWb0xQArWGSb9orHHpdO04JPZzwkf12W5UfEAFKbtxzgpIoTqMeSihw3uIhl3AloMQ8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708465107; c=relaxed/simple;
	bh=OYSAKJdrA79LbLhLfCnmk+b4C/4qhDlP3AS6diVJ29Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mw1Df/KVTQod9Gk0E080yOLOaWwFwxoGpZTRYz2NGVzfr/mZnAdHlOllueR4Gh4/tuHLqfFc699ls1e+f5qAfehkzpN71vBauH8f+w9I6CPxXuLht9AVsBLI8CMIuR5nOvr7Q1N5T7jbXXDaKqZvcmH7aTgrXdd71Eu+19GQq+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JUAJbD3E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JUAJbD3E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE068C433C7;
	Tue, 20 Feb 2024 21:38:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708465107;
	bh=OYSAKJdrA79LbLhLfCnmk+b4C/4qhDlP3AS6diVJ29Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JUAJbD3Eu7N1wVVQwXv1C+4URvaEHKRB63pfOgkMF/9sIzTMlwwTQE8fvImzd8vzZ
	 I+T3egJibA3KKwQbAtHy+eItSEf+eJBB7apzByEtJc8/prJdxvy3Ot5X7mVkk42dQT
	 cgExsiYonqJVG0jKJr9I50JCSQwHuQUN7gTi19fM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Subject: [PATCH 6.7 239/309] gpiolib: add gpiod_to_gpio_device() stub for !GPIOLIB
Date: Tue, 20 Feb 2024 21:56:38 +0100
Message-ID: <20240220205640.642923190@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

commit 6ac86372102b477083db99a9af8246fb916271b5 upstream.

Add empty stub of gpiod_to_gpio_device() when GPIOLIB is not enabled.

Cc: <stable@vger.kernel.org>
Fixes: 370232d096e3 ("gpiolib: provide gpiod_to_gpio_device()")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/gpio/driver.h |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/include/linux/gpio/driver.h
+++ b/include/linux/gpio/driver.h
@@ -806,6 +806,12 @@ static inline int gpio_device_get_base(s
 	return -ENODEV;
 }
 
+static inline struct gpio_device *gpiod_to_gpio_device(struct gpio_desc *desc)
+{
+	WARN_ON(1);
+	return ERR_PTR(-ENODEV);
+}
+
 static inline int gpiochip_lock_as_irq(struct gpio_chip *gc,
 				       unsigned int offset)
 {


