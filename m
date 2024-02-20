Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81AE4446C9;
	Tue, 20 Feb 2024 21:38:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708465104; cv=none; b=jW8n5urhtwQicN4yXGI5jb9ARG28iLIkQvjkabBiL+ZYFPlYqmNig8JQEEKlXTTmOxQ8IYGl8FOBOBCjw7eWjJzqiVvbUgKfIXD6cU4zeKuucGDdZGNwak422/+mM0U31MmEM2e6lN5vzecPdMXjFXQoUrmzO+C7x56fWtcKBfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708465104; c=relaxed/simple;
	bh=5K5kIEWzFpmI40Wbl19bPlDHjmkeuDjtSsng6IXC86I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jHM9PA8A7/gwRdCmGqm098Yep75kYrL8yhHFr03Y9PgEab/mokj+dmS+eDdD0cO9ln9wSPdHqvbIpJNVtECq9NpJJ4vYYbVM3Sjg1yFSiympMtzQAxS/xXi5SW0Pd8wuvycFSE1jRAOowGFXbLf1B0ilSWazcc0g5vFQpJQtO/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lfSsDNo1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lfSsDNo1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBB27C433C7;
	Tue, 20 Feb 2024 21:38:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708465104;
	bh=5K5kIEWzFpmI40Wbl19bPlDHjmkeuDjtSsng6IXC86I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lfSsDNo185F39KqgmjJYNHe/ZMH+txx5KbQoW9eHuI6ddru7ATgYJxpjNWm3Yunoe
	 UQEL8w56tIZLo4aOyCA73CVTx4/wN8aBZGje5Qccwu2cJOP/xBHYSheziQQU5WiuN2
	 JPRwKSnCY7QRjEiLO5p5mL/pP8HLy0Sx3MNuT5qc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Subject: [PATCH 6.7 238/309] gpiolib: add gpio_device_get_base() stub for !GPIOLIB
Date: Tue, 20 Feb 2024 21:56:37 +0100
Message-ID: <20240220205640.608737466@linuxfoundation.org>
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

commit ebe0c15b135b1e4092c25b95d89e9a5899467499 upstream.

Add empty stub of gpio_device_get_base() when GPIOLIB is not enabled.

Cc: <stable@vger.kernel.org>
Fixes: 8c85a102fc4e ("gpiolib: provide gpio_device_get_base()")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/gpio/driver.h |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/include/linux/gpio/driver.h
+++ b/include/linux/gpio/driver.h
@@ -800,6 +800,12 @@ static inline struct gpio_chip *gpiod_to
 	return ERR_PTR(-ENODEV);
 }
 
+static inline int gpio_device_get_base(struct gpio_device *gdev)
+{
+	WARN_ON(1);
+	return -ENODEV;
+}
+
 static inline int gpiochip_lock_as_irq(struct gpio_chip *gc,
 				       unsigned int offset)
 {


