Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C1DA3EDAD7;
	Wed,  4 Feb 2026 15:32:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770219167; cv=none; b=GWKIzW1RglkFioL6wj+JMCPjWeQ/vxtxWWqPDBresGOytcYsp5wHczYG3/IzJ3DaOW8RYBTBue9BAkMbDsTuASj7TcNJ5SQdzVykKJUSUTiksEkAO9K1IiLvrFbMe4cDhWSc1dYDdECj0bvJP8mtXGajO4fK9uinkHqCKAwgHsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770219167; c=relaxed/simple;
	bh=E5YaBkwbENCg2m/Xx+nZ6Na90+fq9lDkjVSQE94MCFY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mptLve0F75Nq8p2T8gcM8Qi9Q7yC9DgfFoX4i1MM9d6tUe+kpDEaCdhHgG7gcULI9SDMuW1OUdRSaQLhkuvdU2xZrddFCc21jLs6UDfDKNJYUcojfbd4jbsPcGiPMJ26DIuCWWRCctj4HEW94xMA5ePkd9NLAcNK500HwjWEqr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZdjYOY0T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZdjYOY0T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F11E1C4CEF7;
	Wed,  4 Feb 2026 15:32:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770219167;
	bh=E5YaBkwbENCg2m/Xx+nZ6Na90+fq9lDkjVSQE94MCFY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZdjYOY0TSlCHelft+BBxQG9X/imrMRVDr9XdL+GEDMu+mKrFlzhGjCAL/uyuGIhwl
	 X8DiRmXRIpTJ0E2wYhKQUcjJhKhkPk4v486MAwnRO/gzQeoNrLooqPDKXCxPRC2VqR
	 XhwFe42Y+Bm9NBbbAGFhAZb+anbgBrcuiq4ThSFM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abel Vesa <abelvesa@kernel.org>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Linus Walleij <linusw@kernel.org>
Subject: [PATCH 6.18 060/122] pinctrl: lpass-lpi: implement .get_direction() for the GPIO driver
Date: Wed,  4 Feb 2026 15:40:42 +0100
Message-ID: <20260204143854.015111532@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143851.857060534@linuxfoundation.org>
References: <20260204143851.857060534@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>

commit 4f0d22ec60cee420125f4055af76caa0f373a3fe upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pinctrl/qcom/pinctrl-lpass-lpi.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

--- a/drivers/pinctrl/qcom/pinctrl-lpass-lpi.c
+++ b/drivers/pinctrl/qcom/pinctrl-lpass-lpi.c
@@ -312,6 +312,22 @@ static const struct pinconf_ops lpi_gpio
 	.pin_config_group_set		= lpi_config_set,
 };
 
+static int lpi_gpio_get_direction(struct gpio_chip *chip, unsigned int pin)
+{
+	unsigned long config = pinconf_to_config_packed(PIN_CONFIG_LEVEL, 0);
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
@@ -409,6 +425,7 @@ static void lpi_gpio_dbg_show(struct seq
 #endif
 
 static const struct gpio_chip lpi_gpio_template = {
+	.get_direction		= lpi_gpio_get_direction,
 	.direction_input	= lpi_gpio_direction_input,
 	.direction_output	= lpi_gpio_direction_output,
 	.get			= lpi_gpio_get,


