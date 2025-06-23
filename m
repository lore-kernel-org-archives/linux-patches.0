Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A69F4409;
	Mon, 23 Jun 2025 22:00:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716039; cv=none; b=r+EocOAaD51IUkeW6dEDO9OW/2rbHUmSu96A9VXWAYTkkvDCL1GoqVfipXnsrujEbec1wzFf/CgqZYJKre9exPMftuImr4JOeqeijCCobON35fY/nUYM1O2vu4dxS7+WZl9kSiqQqYf2P/xw8CIrM7MfDGEwHot3ggVHnFWBZ8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716039; c=relaxed/simple;
	bh=tczerea8Pf74QjnK78vpmIyRylMgzQKUmD18CQ/8qn0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YxSXW2upOtqaYe9wj+AQcVsRZ6kA9wHS5H4E9H+tYW4G/x2bXw1MUJtq5Ds8FOiYlYOsB/A7/kJyki1imyK1MRrukytSkl/TZSwGUmrwazAfwlBamV1We89gM6dCuWZGXjbDZb6mbGfHA0Er1EQefE3ustXALpXLPX0VTAKgp8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y8Tgp6qu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y8Tgp6qu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C75FAC4CEEA;
	Mon, 23 Jun 2025 22:00:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716039;
	bh=tczerea8Pf74QjnK78vpmIyRylMgzQKUmD18CQ/8qn0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y8Tgp6quyen41gFQtkCqhOJ2vKTg4nB5ngl+Oj+RvH7/UMtf2sp3pMtVclAhxSgr7
	 j/KdNwJjpkNNqZ8Bu06+3IhvwBuKoS/eRp/OlJ7n3VwsmmRWQR/8v6750RrNlamxXT
	 TbXEHWDLG54i+xiign1K8ZOfLwlfKiTbmNehY3w0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Binbin Zhou <zhoubinbin@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Subject: [PATCH 6.15 488/592] gpio: loongson-64bit: Correct Loongson-7A2000 ACPI GPIO access mode
Date: Mon, 23 Jun 2025 15:07:26 +0200
Message-ID: <20250623130712.041129184@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Binbin Zhou <zhoubinbin@loongson.cn>

commit 72f37957007d25f4290e3ba40d40aaec1dd0b0cf upstream.

According to the description of the Loongson-7A2000 ACPI GPIO register in
the manual, its access mode should be BIT_CTRL_MODE, otherwise there maybe
some unpredictable behavior.

Cc: stable@vger.kernel.org
Fixes: 44fe79020b91 ("gpio: loongson-64bit: Add more gpio chip support")
Signed-off-by: Binbin Zhou <zhoubinbin@loongson.cn>
Reviewed-by: Huacai Chen <chenhuacai@loongson.cn>
Link: https://lore.kernel.org/r/20250610115926.347845-1-zhoubinbin@loongson.cn
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpio-loongson-64bit.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpio/gpio-loongson-64bit.c
+++ b/drivers/gpio/gpio-loongson-64bit.c
@@ -266,7 +266,7 @@ static const struct loongson_gpio_chip_d
 /* LS7A2000 ACPI GPIO */
 static const struct loongson_gpio_chip_data loongson_gpio_ls7a2000_data1 = {
 	.label = "ls7a2000_gpio",
-	.mode = BYTE_CTRL_MODE,
+	.mode = BIT_CTRL_MODE,
 	.conf_offset = 0x4,
 	.in_offset = 0x8,
 	.out_offset = 0x0,


