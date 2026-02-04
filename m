Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 948F8421A1E;
	Wed,  4 Feb 2026 15:22:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770218529; cv=none; b=TSmfmkkz8TMDZ4ARTBnL537oAMV7XC7kWvMBVPtAprEr4rhBcObU36f97+GCa0C/ojoCSPSehrpbKt8rrStBSrORh+g/uog4p3DuOTZHp1cVdFcrvB6iHcdbCNpOmuKJUjBKpCO8C0lcun4qFBz5xnAiFQ+iXRpuB+biLcZ9LAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770218529; c=relaxed/simple;
	bh=J5BXDay3RGkNvHId5rvkSYzcW8LXpSoki4i47C9HDcw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lSwKPTrb6rOaZYsUL0/VI2pZniy56k+EAoErqURJ5kArEDwO8UkaDtOkFqQCCjikupeWn+kdYHsHxRJnpBPiT54LZcdeZ3/kP9tNfLtEhPUK3/v0kn94Bnnj+aIHMrbEUS/Vc6F8sUvzm9KLu0s87uEurrnesAz+EFyHO7OVbp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Da33IEP8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Da33IEP8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E844C4CEF7;
	Wed,  4 Feb 2026 15:22:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770218529;
	bh=J5BXDay3RGkNvHId5rvkSYzcW8LXpSoki4i47C9HDcw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Da33IEP8cdN6EbvLSJ6/6zbq/YCn9VJn3aPfhQocdehmgC/T7nvv6CEKzHHZmpdEd
	 xKbOrppxV1Bb/2zG4fIZGAf3H64lVCcWGrU4gW5jR61EiKuc8zyOE9tcxMdlWnuUb3
	 hmtQECMaQKhUG/Bmx9achJ4j4kmDKQppr9qJHcsw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abel Vesa <abelvesa@kernel.org>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 58/72] pinctrl: lpass-lpi: implement .get_direction() for the GPIO driver
Date: Wed,  4 Feb 2026 15:41:01 +0100
Message-ID: <20260204143847.735995998@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143845.603454952@linuxfoundation.org>
References: <20260204143845.603454952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>

[ Upstream commit 4f0d22ec60cee420125f4055af76caa0f373a3fe ]

GPIO controller driver should typically implement the .get_direction()
callback as GPIOLIB internals may try to use it to determine the state
of a pin. Add it for the LPASS LPI driver.

Reported-by: Abel Vesa <abelvesa@kernel.org>
Cc: stable@vger.kernel.org
Fixes: 6e261d1090d6 ("pinctrl: qcom: Add sm8250 lpass lpi pinctrl driver")
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Tested-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com> # X1E CRD
Tested-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Signed-off-by: Linus Walleij <linusw@kernel.org>
[ PIN_CONFIG_LEVEL => PIN_CONFIG_OUTPUT ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pinctrl/qcom/pinctrl-lpass-lpi.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

--- a/drivers/pinctrl/qcom/pinctrl-lpass-lpi.c
+++ b/drivers/pinctrl/qcom/pinctrl-lpass-lpi.c
@@ -279,6 +279,22 @@ static const struct pinconf_ops lpi_gpio
 	.pin_config_group_set		= lpi_config_set,
 };
 
+static int lpi_gpio_get_direction(struct gpio_chip *chip, unsigned int pin)
+{
+	unsigned long config = pinconf_to_config_packed(PIN_CONFIG_OUTPUT, 0);
+	struct lpi_pinctrl *state = gpiochip_get_data(chip);
+	unsigned long arg;
+	int ret;
+
+	ret = lpi_config_get(state->ctrl, pin, &config);
+	if (ret)
+		return ret;
+
+	arg = pinconf_to_config_argument(config);
+
+	return arg ? GPIO_LINE_DIRECTION_OUT : GPIO_LINE_DIRECTION_IN;
+}
+
 static int lpi_gpio_direction_input(struct gpio_chip *chip, unsigned int pin)
 {
 	struct lpi_pinctrl *state = gpiochip_get_data(chip);
@@ -377,6 +393,7 @@ static void lpi_gpio_dbg_show(struct seq
 #endif
 
 static const struct gpio_chip lpi_gpio_template = {
+	.get_direction		= lpi_gpio_get_direction,
 	.direction_input	= lpi_gpio_direction_input,
 	.direction_output	= lpi_gpio_direction_output,
 	.get			= lpi_gpio_get,


