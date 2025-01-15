Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D007248BBD;
	Wed, 15 Jan 2025 10:50:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938221; cv=none; b=p6uaPOyTCjRCci6roLiCYnKnZYe0zj0oARNNI8ozo55OH/7XUSSRwQucRCvP2dC1pplXymZ2QJxq9poH/R1rtGu9Uhnd5nqs/1OWuMx4QD36kOvcWH4cfmHbl/1V9lRqlvUzcWOOh3lKhb4EKNGKEHgLfZcT9MRcL+leGf7UkC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938221; c=relaxed/simple;
	bh=b44RuxisT7mK8XP3oxs0uMApoOl0k8BZ+wahviy6/gE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QZh16jDYoJFnd0lZSoQNRciJNjk7iz8o04UloRYcg0pJh99YQrsf2XqUuvaFt0yIGe7/cXNzueaN6jBR3N3VLQaNr1THBABaBlkgD92TU8lS2JEp5aO7ZuZIBsD6Qw/MrzZ5UgtPWMC0LZf22Oi2ZA25e+rlfXNnsRzg30ckpcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Te4vYnGK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Te4vYnGK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7653FC4CEDF;
	Wed, 15 Jan 2025 10:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938220;
	bh=b44RuxisT7mK8XP3oxs0uMApoOl0k8BZ+wahviy6/gE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Te4vYnGK8lHeUzGEEo1br3s8Cz6JZhprmvHvR7wf/f8OJ7Rl49GnMtVzda4CvgFYp
	 otQx2r/lSzxIiO+/4VnkR/URXW7hXBngpwAoysrHPK8dO8Nuk4gyknBB1AhtjfoFwF
	 r86hZOUvCR7HGDFv7g0JQ/KH08FBLUAZCUxKaUT0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yinbo Zhu <zhuyinbo@loongson.cn>,
	Hongliang Wang <wanghongliang@loongson.cn>,
	Binbin Zhou <zhoubinbin@loongson.cn>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Subject: [PATCH 6.12 118/189] gpio: loongson: Fix Loongson-2K2000 ACPI GPIO register offset
Date: Wed, 15 Jan 2025 11:36:54 +0100
Message-ID: <20250115103611.167973729@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103606.357764746@linuxfoundation.org>
References: <20250115103606.357764746@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Binbin Zhou <zhoubinbin@loongson.cn>

commit e59f4c97172de0c302894cfd5616161c1f0c4d85 upstream.

Since commit 3feb70a61740 ("gpio: loongson: add more gpio chip
support"), the Loongson-2K2000 GPIO is supported.

However, according to the firmware development specification, the
Loongson-2K2000 ACPI GPIO register offsets in the driver do not match
the register base addresses in the firmware, resulting in the registers
not being accessed properly.

Now, we fix it to ensure the GPIO function works properly.

Cc: stable@vger.kernel.org
Cc: Yinbo Zhu <zhuyinbo@loongson.cn>
Fixes: 3feb70a61740 ("gpio: loongson: add more gpio chip support")
Co-developed-by: Hongliang Wang <wanghongliang@loongson.cn>
Signed-off-by: Hongliang Wang <wanghongliang@loongson.cn>
Signed-off-by: Binbin Zhou <zhoubinbin@loongson.cn>
Link: https://lore.kernel.org/r/20250107103856.1037222-1-zhoubinbin@loongson.cn
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpio-loongson-64bit.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/gpio/gpio-loongson-64bit.c
+++ b/drivers/gpio/gpio-loongson-64bit.c
@@ -237,9 +237,9 @@ static const struct loongson_gpio_chip_d
 static const struct loongson_gpio_chip_data loongson_gpio_ls2k2000_data2 = {
 	.label = "ls2k2000_gpio",
 	.mode = BIT_CTRL_MODE,
-	.conf_offset = 0x84,
-	.in_offset = 0x88,
-	.out_offset = 0x80,
+	.conf_offset = 0x4,
+	.in_offset = 0x8,
+	.out_offset = 0x0,
 };
 
 static const struct loongson_gpio_chip_data loongson_gpio_ls3a5000_data = {


