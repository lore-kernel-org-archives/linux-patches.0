Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CE978F57
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:44:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9622C433C7;
	Sun, 16 Jul 2023 20:44:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689540274;
	bh=1sw3kHkQWLbdKu9iT7kE2JQu/DG5YM3rSRfH0Vyb7+U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MZ/i4oqo9C7N1N5N99YTfoAJrX9duNs31Jyp0T/aT1nbmAKXogdta6ybgCh0ePMcN
	 /ilR4E/csxJOwZEkRnawnRqtsm/alYr+pCJvmSrF5GQbHBlQFssvYwian2ryXS5Koq
	 ieorLul0EWa2CdH/9ivv7A78F67d7owX5+ouC0D0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wells Lu <wellslutw@gmail.com>,
	Andy Shevchenko <andy.shevchenko@gmail.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 304/591] pinctrl:sunplus: Add check for kmalloc
Date: Sun, 16 Jul 2023 21:47:23 +0200
Message-ID: <20230716194931.758106511@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194923.861634455@linuxfoundation.org>
References: <20230716194923.861634455@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Wells Lu <wellslutw@gmail.com>

[ Upstream commit 73f8ce7f961afcb3be49352efeb7c26cc1c00cc4 ]

Fix Smatch static checker warning:
potential null dereference 'configs'. (kmalloc returns null)

Changes in v2:
1. Add free allocated memory before returned -ENOMEM.
2. Add call of_node_put() before returned -ENOMEM.

Fixes: aa74c44be19c ("pinctrl: Add driver for Sunplus SP7021")
Signed-off-by: Wells Lu <wellslutw@gmail.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Link: https://lore.kernel.org/r/1685277277-12209-1-git-send-email-wellslutw@gmail.com
[Rebased on the patch from Lu Hongfei]
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/sunplus/sppctl.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/pinctrl/sunplus/sppctl.c b/drivers/pinctrl/sunplus/sppctl.c
index 0449595b943cf..6b24fa0e63c0f 100644
--- a/drivers/pinctrl/sunplus/sppctl.c
+++ b/drivers/pinctrl/sunplus/sppctl.c
@@ -975,8 +975,7 @@ static int sppctl_dt_node_to_map(struct pinctrl_dev *pctldev, struct device_node
 
 sppctl_map_err:
 	for (i = 0; i < (*num_maps); i++)
-		if (((*map)[i].type == PIN_MAP_TYPE_CONFIGS_PIN) &&
-		    (*map)[i].data.configs.configs)
+		if ((*map)[i].type == PIN_MAP_TYPE_CONFIGS_PIN)
 			kfree((*map)[i].data.configs.configs);
 	kfree(*map);
 	of_node_put(parent);
-- 
2.39.2



