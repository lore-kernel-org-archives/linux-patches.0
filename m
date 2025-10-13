Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EF9A221555;
	Mon, 13 Oct 2025 15:45:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760370321; cv=none; b=Wl/jxW4ANtEFelHWzbgYu1XGM5AOsPKpfrDJsfRdxscS6zxuFoqNOkoN8l+zu9H9pA7YXRnmukrkfyf/usRGrGtVCGpfgk4zcN+yAssGtypdFpWlUVKh1P6VQTdmxX57BFcwr2V/Vh80fi7Fp7eC3OF8e1LZ3tF1mMqZjx+GsMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760370321; c=relaxed/simple;
	bh=MHHkgcdQOQlZW/GI9KczamMHJ1R0Zc3WMmbod4nYrYo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CL6orq2AQiAFDKsP01InNtuu3j5TYNzORLYlMYIOSRmt6pcjUa6UJSuiqxpCOBqMQJuuPXYnBXsd+o5bb4gIYit7aM+lAC5/8oBkJhXjM7/8yBEVD6PZ3S8vZJFj+635kc2l8wgKnYdB5sTLYXw0hBkL3VvOP7ab394+/kLIqQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HWkhOZku; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HWkhOZku"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89352C4AF1B;
	Mon, 13 Oct 2025 15:45:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760370320;
	bh=MHHkgcdQOQlZW/GI9KczamMHJ1R0Zc3WMmbod4nYrYo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HWkhOZkuHB5jFlglFIn0wLnFT377E7Wm500j/mqKm1DauoALRBe7aJy0feXlHf/sF
	 iCrEpvcwo7wDu+mUdD8MuiCcKVfLOtwBsq77lhtyrxsp6PLn9T+fzLv+82vpEjhQYc
	 niaLmAR4lXIRevjqK34ps2brIglxrmQ2he+1KV4w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xi Ruoyao <xry111@xry111.site>,
	Binbin Zhou <zhoubinbin@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <ukleinek@kernel.org>
Subject: [PATCH 6.17 522/563] pwm: loongson: Fix LOONGSON_PWM_FREQ_DEFAULT
Date: Mon, 13 Oct 2025 16:46:23 +0200
Message-ID: <20251013144430.222740750@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xi Ruoyao <xry111@xry111.site>

commit 75604e9a5b60707722028947d6dc6bdacb42282e upstream.

Per the 7A1000 and 7A2000 user manual, the clock frequency of their
PWM controllers is 50 MHz, not 50 kHz.

Fixes: 2b62c89448dd ("pwm: Add Loongson PWM controller support")
Signed-off-by: Xi Ruoyao <xry111@xry111.site>
Reviewed-by: Binbin Zhou <zhoubinbin@loongson.cn>
Reviewed-by: Huacai Chen <chenhuacai@loongson.cn>
Link: https://lore.kernel.org/r/20250816104904.4779-2-xry111@xry111.site
Cc: stable@vger.kernel.org
Signed-off-by: Uwe Kleine-König <ukleinek@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pwm/pwm-loongson.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pwm/pwm-loongson.c b/drivers/pwm/pwm-loongson.c
index 1ba16168cbb4..31a57edecfd0 100644
--- a/drivers/pwm/pwm-loongson.c
+++ b/drivers/pwm/pwm-loongson.c
@@ -49,7 +49,7 @@
 #define LOONGSON_PWM_CTRL_REG_DZONE	BIT(10) /* Anti-dead Zone Enable Bit */
 
 /* default input clk frequency for the ACPI case */
-#define LOONGSON_PWM_FREQ_DEFAULT	50000 /* Hz */
+#define LOONGSON_PWM_FREQ_DEFAULT	50000000 /* Hz */
 
 struct pwm_loongson_ddata {
 	struct clk *clk;
-- 
2.51.0



