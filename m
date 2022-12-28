Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06B511863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:42:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E3F3C433D2;
	Wed, 28 Dec 2022 15:42:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672242177;
	bh=JPdw15exrtThGlpAOjLkbw8ap8naBIZp3edmxtlE5YM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jKa2DGoAys3b5GKNVw2zynb8A4OVUpsW8MIjKGdUeDGAPlQ8lU21piJvItnWcLSiI
	 /cENKE/5EZ6eeAJO2j8dUMQB6VpSbxix24jQ2Zo95qRx30MChcN0BX+unW9PlpkFwW
	 oNXomoTFmrw1NVoVQQn+SDgPMr9CyqzQcqSr/NdM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Can <yuancan@huawei.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0376/1073] ASoC: qcom: Add checks for devm_kcalloc
Date: Wed, 28 Dec 2022 15:32:44 +0100
Message-Id: <20221228144338.216242438@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yuan Can <yuancan@huawei.com>

[ Upstream commit 1bf5ee979076ceb121ee51c95197d890b1cee7f4 ]

As the devm_kcalloc may return NULL, the return value needs to be checked
to avoid NULL poineter dereference.

Fixes: 24caf8d9eb10 ("ASoC: qcom: lpass-sc7180: Add platform driver for lpass audio")
Signed-off-by: Yuan Can <yuancan@huawei.com>
Link: https://lore.kernel.org/r/20221124140510.63468-1-yuancan@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/qcom/lpass-sc7180.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/soc/qcom/lpass-sc7180.c b/sound/soc/qcom/lpass-sc7180.c
index 77a556b27cf0..24a1c121cb2e 100644
--- a/sound/soc/qcom/lpass-sc7180.c
+++ b/sound/soc/qcom/lpass-sc7180.c
@@ -131,6 +131,9 @@ static int sc7180_lpass_init(struct platform_device *pdev)
 
 	drvdata->clks = devm_kcalloc(dev, variant->num_clks,
 				     sizeof(*drvdata->clks), GFP_KERNEL);
+	if (!drvdata->clks)
+		return -ENOMEM;
+
 	drvdata->num_clks = variant->num_clks;
 
 	for (i = 0; i < drvdata->num_clks; i++)
-- 
2.35.1



