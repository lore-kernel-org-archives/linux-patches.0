Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A7B81487CD;
	Thu, 12 Dec 2024 17:11:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023483; cv=none; b=C+3aJsp6VVxBgMDlRwaj8Y8j5Onp8rFn0zOQ2OHsHscrjAgS3WXA2Jv4gn8jtbv5JgkE08QZsUtZ9A0hWuO1ZUHN99Sug83yI8nEpSH5C1Ilfpu6/RG3sSdM30TFyZlI/QftJGF2eDbkLHFiFQbaxtTTkuN65jx56fANxAy/u5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023483; c=relaxed/simple;
	bh=L/Z2Icr8/DoFwmf6WAGG0MBT2frV89OSiUZJoe+TRUU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CQuRK7It7nMS4jjrVysD0keByZ0ijhACwj8RZTSy+8H54IWN8IjAZgpUOrR7cg4CWFvB37NF3DKgFnf6jrCvI1aj6yPCoPcIkxyAuWlqP2uJcpdpiQ8onRi59nFHC3/zVMAUC6cXTvBLY6KwVYcMRZfzUJaGkco59/hsFgYM618=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IfefeyaQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IfefeyaQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99FF4C4CECE;
	Thu, 12 Dec 2024 17:11:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023483;
	bh=L/Z2Icr8/DoFwmf6WAGG0MBT2frV89OSiUZJoe+TRUU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IfefeyaQD2YUmKDe7WjvwJagM8wOlqJkUnXB9Be0xixCIiAjRIZIzi+/X8j65pOXX
	 rnpAsVxZu5WT2GN3m8MeXt8Ny4nHUgdkl1Ak8RCRdiW3U1AxzYqvHzpdGb0HWH8Ild
	 fyPbC1CJFkVj42PXl2PDQx8WrUjm6uY1Gr0sKrxM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Barnab=C3=A1s=20Cz=C3=A9m=C3=A1n?= <barnabas.czeman@mainlining.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 518/565] pinctrl: qcom-pmic-gpio: add support for PM8937
Date: Thu, 12 Dec 2024 16:01:53 +0100
Message-ID: <20241212144332.268252828@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index b2562e8931397..42f8b661f19c0 100644
--- a/drivers/pinctrl/qcom/pinctrl-spmi-gpio.c
+++ b/drivers/pinctrl/qcom/pinctrl-spmi-gpio.c
@@ -1156,6 +1156,8 @@ static const struct of_device_id pmic_gpio_of_match[] = {
 	{ .compatible = "qcom,pm8350b-gpio", .data = (void *) 8 },
 	{ .compatible = "qcom,pm8350c-gpio", .data = (void *) 9 },
 	{ .compatible = "qcom,pm8916-gpio", .data = (void *) 4 },
+	/* pm8937 has 8 GPIOs with holes on 3, 4 and 6 */
+	{ .compatible = "qcom,pm8937-gpio", .data = (void *) 8 },
 	{ .compatible = "qcom,pm8941-gpio", .data = (void *) 36 },
 	/* pm8950 has 8 GPIOs with holes on 3 */
 	{ .compatible = "qcom,pm8950-gpio", .data = (void *) 8 },
-- 
2.43.0



