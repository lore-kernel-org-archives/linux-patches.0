Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B89A71C07
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:06:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CD52C433F0;
	Wed, 28 Dec 2022 16:06:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672243576;
	bh=W/Xnmc97F+AtLcG8E2pp6biNEpuKZmfhp14G8o0Nryc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=klaeowJPk9L+mNapfiw80onytyhAJyXYgXSnQLvjyXsDjB+R8ocpvrWaQA3c3EWYn
	 /ob+Ej6lBBp5Hjkrpyxn+apoyid/hTQPFp9UncLO1sw8/kLzZ4Tp9A/5ldzwrROvnl
	 6OxnL6eglTd0UCbfQb6sTQyuBmcRTxQtVejLwYxA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Can <yuancan@huawei.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0515/1146] regulator: qcom-labibb: Fix missing of_node_put() in qcom_labibb_regulator_probe()
Date: Wed, 28 Dec 2022 15:34:14 +0100
Message-Id: <20221228144344.163200385@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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

[ Upstream commit cf34ac6aa2b12fb0c3aacfdcae8acd7904b949ec ]

The reg_node needs to be released through of_node_put() in the error
handling path when of_irq_get_byname() failed.

Fixes: 390af53e0411 ("regulator: qcom-labibb: Implement short-circuit and over-current IRQs")
Signed-off-by: Yuan Can <yuancan@huawei.com>
Link: https://lore.kernel.org/r/20221203062109.115043-1-yuancan@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/qcom-labibb-regulator.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/regulator/qcom-labibb-regulator.c b/drivers/regulator/qcom-labibb-regulator.c
index 639b71eb41ff..bcf7140f3bc9 100644
--- a/drivers/regulator/qcom-labibb-regulator.c
+++ b/drivers/regulator/qcom-labibb-regulator.c
@@ -822,6 +822,7 @@ static int qcom_labibb_regulator_probe(struct platform_device *pdev)
 			if (irq == 0)
 				irq = -EINVAL;
 
+			of_node_put(reg_node);
 			return dev_err_probe(vreg->dev, irq,
 					     "Short-circuit irq not found.\n");
 		}
-- 
2.35.1



