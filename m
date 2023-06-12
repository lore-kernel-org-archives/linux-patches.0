Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 357C111C88
	for <patches@lists.linux.dev>; Mon, 12 Jun 2023 10:50:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2BABC433EF;
	Mon, 12 Jun 2023 10:50:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686567032;
	bh=eA8MxUGKqwlvdn1b/GuiQ5TwkYikT2RnhAtjVgEPY64=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M7HUsOC6ZwkoVFR3yHX9ieUbNPsV4S5+bL8kw9LY7JR4WUjiasdQAeej471Mele1D
	 kdAhk6GRIZkPzF4KuSLxA0lFcq/GW+nTcfkKynxweMbRFzINJCvZXj0rg78K99gPng
	 LWHgQU/9HTqJLb1FyubC073fT5VXd+PFStI1s78Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 125/160] soc: qcom: ramp_controller: Fix an error handling path in qcom_ramp_controller_probe()
Date: Mon, 12 Jun 2023 12:27:37 +0200
Message-ID: <20230612101720.773741466@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230612101715.129581706@linuxfoundation.org>
References: <20230612101715.129581706@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit b3d0dcc8e359cf5d57fb6308bc9750af5da574b3 ]

'qrc' is known to be non-NULL at this point.
Checking for 'qrc->desc' was expected instead, so use it.

Fixes: a723c95fa137 ("soc: qcom: Add Qualcomm Ramp Controller driver")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/84727a79d0261b4112411aec23b553504015c02c.1681684138.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/qcom/ramp_controller.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/soc/qcom/ramp_controller.c b/drivers/soc/qcom/ramp_controller.c
index dc74d2a19de2b..5e3ba0be09035 100644
--- a/drivers/soc/qcom/ramp_controller.c
+++ b/drivers/soc/qcom/ramp_controller.c
@@ -296,7 +296,7 @@ static int qcom_ramp_controller_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	qrc->desc = device_get_match_data(&pdev->dev);
-	if (!qrc)
+	if (!qrc->desc)
 		return -EINVAL;
 
 	qrc->regmap = devm_regmap_init_mmio(&pdev->dev, base, &qrc_regmap_config);
-- 
2.39.2



