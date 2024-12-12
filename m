Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A1CB1547F0;
	Thu, 12 Dec 2024 15:46:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734018397; cv=none; b=tv4yvzL7jZuOuWcMlkIZU/61Nx39DI2Jmfaddhz5co2GjNF3FPt8eY4xFyil1XjhlyTegcmmv2B8lsaA2v+S12WdYkAjIp9Txkf5RPdVnZgGmjpVP7TjHNRlYEHjQMSNmZVGYm4Of5qg+nIOxHd6vfa83E4opb5TK7BRqCDLeyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734018397; c=relaxed/simple;
	bh=WmN623csvytoGA7e4iYJysfr18kSfEYDB4F0ODWFHZM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=txmlSSH+v1eEjyw8RZMtPEAJ2TtjtI70vniA1HBmJuUBAucjftV986rAzuws20dWWJrW5U9aPYH+jE1Cs0BgitgiDHAqgHyqckirxRLhcEHBJTIMLQPhX4SvPX3Mtu/jifxsLj6sh7EqVVK0kO55iRxG6TJ+swwkPpn27Pk6skM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DAqbz9/O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DAqbz9/O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72163C4CECE;
	Thu, 12 Dec 2024 15:46:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734018397;
	bh=WmN623csvytoGA7e4iYJysfr18kSfEYDB4F0ODWFHZM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DAqbz9/OZB3+BEhOiR98haYhQ9pw2A3CUGksZl/YRXmY6IZCqjMYn8iZbep5r02xf
	 OqVLYQArMgTu2tpsmLO6FQRWkNx9mKA6VANXkOMpdqlqhEe0fgXDazUERMxh4wLnLn
	 ZoM7AJr7t96RzSLWfwvEuUuBxo/M1lfE8lOaU7vU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Barnab=C3=A1s=20Cz=C3=A9m=C3=A1n?= <barnabas.czeman@mainlining.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 281/356] pinctrl: qcom-pmic-gpio: add support for PM8937
Date: Thu, 12 Dec 2024 16:00:00 +0100
Message-ID: <20241212144255.685617050@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Barnabás Czémán <barnabas.czeman@mainlining.org>

[ Upstream commit 89265a58ff24e3885c2c9ca722bc3aaa47018be9 ]

PM8937 has 8 GPIO-s with holes on GPIO3, GPIO4 and GPIO6.

Signed-off-by: Barnabás Czémán <barnabas.czeman@mainlining.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/20241031-msm8917-v2-2-8a075faa89b1@mainlining.org
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/qcom/pinctrl-spmi-gpio.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/pinctrl/qcom/pinctrl-spmi-gpio.c b/drivers/pinctrl/qcom/pinctrl-spmi-gpio.c
index 8acaae88b87e8..a4d0594a83265 100644
--- a/drivers/pinctrl/qcom/pinctrl-spmi-gpio.c
+++ b/drivers/pinctrl/qcom/pinctrl-spmi-gpio.c
@@ -1226,6 +1226,8 @@ static const struct of_device_id pmic_gpio_of_match[] = {
 	{ .compatible = "qcom,pm8550ve-gpio", .data = (void *) 8 },
 	{ .compatible = "qcom,pm8550vs-gpio", .data = (void *) 6 },
 	{ .compatible = "qcom,pm8916-gpio", .data = (void *) 4 },
+	/* pm8937 has 8 GPIOs with holes on 3, 4 and 6 */
+	{ .compatible = "qcom,pm8937-gpio", .data = (void *) 8 },
 	{ .compatible = "qcom,pm8941-gpio", .data = (void *) 36 },
 	/* pm8950 has 8 GPIOs with holes on 3 */
 	{ .compatible = "qcom,pm8950-gpio", .data = (void *) 8 },
-- 
2.43.0



