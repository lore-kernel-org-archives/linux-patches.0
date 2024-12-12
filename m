Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 349FC22333E;
	Thu, 12 Dec 2024 17:33:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734024820; cv=none; b=fK3ws9UuOF2G1J5yNorvZMybN2ocI4ryj+Z0und/0wlTUq9YjRRmRJ/c8WqLaDGJ+LU1lxZ90TEOOD/ZKeW83XvUFGSgzd5Eq9/0aZqYJkEG05CG6Tk7052DxhFDROCv1EEnLcJkIbelSUVHPXbyPdHya0/t//rFWaLe8dMGB7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734024820; c=relaxed/simple;
	bh=G9h9msecA7T7o9jhCPVSNdmYjaMzScqfrS1Sige3AA4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OrR2WRQwEbEH0MENyb3z7E0O0nkHW5LGn36qxKPgKT+jfSEi8YrHTESyZtQzhCOvAsZ8uTbYzm17AxO77/GmoiQm/yLXLKCpQJkfU2WPahpl8NHdCKtHNmsnTu+KqZx1NvWkCRN6qHDRIZWvdMYF4cQ6B+TKfKxKXMFeZhRjawo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N4ZtQz+e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N4ZtQz+e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0F6CC4CEDD;
	Thu, 12 Dec 2024 17:33:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734024820;
	bh=G9h9msecA7T7o9jhCPVSNdmYjaMzScqfrS1Sige3AA4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N4ZtQz+etd6ZU05EwBt0Zh5HTXT+7oWuqhRrrN3aXMH74L5EeHD1FGXjww6fPfdZX
	 zgfiKwR40RWmrUBGA8r3INk/9midpRBBOaHkc8cilBeWu7ZXnL+AIYvBRzgiNonD/k
	 rlGxYV+S2TAroudXskpTUIHNVA+l098IHF6QjGEo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Barnab=C3=A1s=20Cz=C3=A9m=C3=A1n?= <barnabas.czeman@mainlining.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 423/459] pinctrl: qcom-pmic-gpio: add support for PM8937
Date: Thu, 12 Dec 2024 16:02:41 +0100
Message-ID: <20241212144310.472766106@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 17441388ce8f5..fd1e4fb176c79 100644
--- a/drivers/pinctrl/qcom/pinctrl-spmi-gpio.c
+++ b/drivers/pinctrl/qcom/pinctrl-spmi-gpio.c
@@ -1106,6 +1106,8 @@ static int pmic_gpio_remove(struct platform_device *pdev)
 static const struct of_device_id pmic_gpio_of_match[] = {
 	{ .compatible = "qcom,pm8005-gpio", .data = (void *) 4 },
 	{ .compatible = "qcom,pm8916-gpio", .data = (void *) 4 },
+	/* pm8937 has 8 GPIOs with holes on 3, 4 and 6 */
+	{ .compatible = "qcom,pm8937-gpio", .data = (void *) 8 },
 	{ .compatible = "qcom,pm8941-gpio", .data = (void *) 36 },
 	/* pm8950 has 8 GPIOs with holes on 3 */
 	{ .compatible = "qcom,pm8950-gpio", .data = (void *) 8 },
-- 
2.43.0



