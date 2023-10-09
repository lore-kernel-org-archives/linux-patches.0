Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 644F0339B5
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:54:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1i/+h7sF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4661C433C7;
	Mon,  9 Oct 2023 13:54:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696859649;
	bh=yYH8He+HjuIO8pbH94q8E3rES+jBR130eM8I4SFT93w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1i/+h7sF1R6p/WhVqJ0cqLRiZ0bg1TDqcuVqgYrc0ip7NQsuzcPAydclrqOXaoxyL
	 ClHLUC2LcfpsQ9spkpAFfdqqwkxG3QbC9yoFIUfE+kRD7POnsRYh19bSwoIbIa8hhI
	 p1CTRanmZCcA5IGzI7OkXr5jGN4JS/N+9ogfakx0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Duje=20Mihanovi=C4=87?= <duje.mihanovic@skole.hr>,
	Andy Shevchenko <andy@kernel.org>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Subject: [PATCH 4.19 87/91] gpio: pxa: disable pinctrl calls for MMP_GPIO
Date: Mon,  9 Oct 2023 15:06:59 +0200
Message-ID: <20231009130114.566085295@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130111.518916887@linuxfoundation.org>
References: <20231009130111.518916887@linuxfoundation.org>
User-Agent: quilt/0.67
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Duje Mihanović <duje.mihanovic@skole.hr>

commit f0575116507b981e6a810e78ce3c9040395b958b upstream.

Similarly to PXA3xx and MMP2, pinctrl-single isn't capable of setting
pin direction on MMP either.

Fixes: a770d946371e ("gpio: pxa: add pin control gpio direction and request")
Signed-off-by: Duje Mihanović <duje.mihanovic@skole.hr>
Reviewed-by: Andy Shevchenko <andy@kernel.org>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpio-pxa.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpio/gpio-pxa.c
+++ b/drivers/gpio/gpio-pxa.c
@@ -246,6 +246,7 @@ static bool pxa_gpio_has_pinctrl(void)
 	switch (gpio_type) {
 	case PXA3XX_GPIO:
 	case MMP2_GPIO:
+	case MMP_GPIO:
 		return false;
 
 	default:


