Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 810B9FBE8
	for <patches@lists.linux.dev>; Thu,  1 Jun 2023 13:26:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3615C4339C;
	Thu,  1 Jun 2023 13:26:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685625968;
	bh=4pl3bzXbQb+AMVNEM2UaNk2EwidArJcoHzS78gffqlg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZcDJefWv4vGBr3V+puucys7yliexbc+9+AlvLt5hd9pqratTqy5+lCeFklA7Qv5hP
	 OJOsp3BQstKjd2DVsq6aXoVJXrO3hD8pfjfZtmKvrK8Hp0er7Bn/X8qFqmY1m0hqri
	 r8Z89zqY9AyuvStzUuCgzJMhtrm5ED7bakO8MoPU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <error27@gmail.com>,
	ChiaEn Wu <chiaen_wu@richtek.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 07/45] power: supply: rt9467: Fix passing zero to dev_err_probe
Date: Thu,  1 Jun 2023 14:21:03 +0100
Message-Id: <20230601131939.037641616@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230601131938.702671708@linuxfoundation.org>
References: <20230601131938.702671708@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: ChiaEn Wu <chiaen_wu@richtek.com>

[ Upstream commit bc97139ff13598fa5becf6b582ef99ab428c03ef ]

Fix passing zero to 'dev_err_probe()' in 'rt9467_request_interrupt()'

Fixes: 6f7f70e3a8dd ("power: supply: rt9467: Add Richtek RT9467 charger driver")
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <error27@gmail.com>
Link: https://lore.kernel.org/r/202305111228.bHLWU6bq-lkp@intel.com/
Signed-off-by: ChiaEn Wu <chiaen_wu@richtek.com>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/rt9467-charger.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/power/supply/rt9467-charger.c b/drivers/power/supply/rt9467-charger.c
index 73f744a3155d4..ea33693b69779 100644
--- a/drivers/power/supply/rt9467-charger.c
+++ b/drivers/power/supply/rt9467-charger.c
@@ -1023,7 +1023,7 @@ static int rt9467_request_interrupt(struct rt9467_chg_data *data)
 	for (i = 0; i < num_chg_irqs; i++) {
 		virq = regmap_irq_get_virq(data->irq_chip_data, chg_irqs[i].hwirq);
 		if (virq <= 0)
-			return dev_err_probe(dev, virq, "Failed to get (%s) irq\n",
+			return dev_err_probe(dev, -EINVAL, "Failed to get (%s) irq\n",
 					     chg_irqs[i].name);
 
 		ret = devm_request_threaded_irq(dev, virq, NULL, chg_irqs[i].handler,
-- 
2.39.2



