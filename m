Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 455586FA0
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 17:04:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE2ADC433EF;
	Mon, 16 Jan 2023 17:04:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673888674;
	bh=rmUNwuHkCZK/kL94eohe6D4tak7ZalGMdhKeu+Yj4iY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mC8IDZNyqEcscs7ynSLuj5MxUKD735cVRlDUHtrhbYhcvWir78pcg1q+TrS+yGdXj
	 3a36Y77vacdbdTCjLQbx+8/ByhwmQH6bltoPu+gsJZDj14onmyw+MMpxN731K5kF1n
	 tnPZgDKr33IrC54mQtkloQyc2sXYMJS2Ns3iFu0c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hui Tang <tanghui20@huawei.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 078/338] mtd: lpddr2_nvm: Fix possible null-ptr-deref
Date: Mon, 16 Jan 2023 16:49:11 +0100
Message-Id: <20230116154824.281403345@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154820.689115727@linuxfoundation.org>
References: <20230116154820.689115727@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Hui Tang <tanghui20@huawei.com>

[ Upstream commit 6bdd45d795adf9e73b38ced5e7f750cd199499ff ]

It will cause null-ptr-deref when resource_size(add_range) invoked,
if platform_get_resource() returns NULL.

Fixes: 96ba9dd65788 ("mtd: lpddr: add driver for LPDDR2-NVM PCM memories")
Signed-off-by: Hui Tang <tanghui20@huawei.com>
Acked-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20221114090240.244172-1-tanghui20@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/lpddr/lpddr2_nvm.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/mtd/lpddr/lpddr2_nvm.c b/drivers/mtd/lpddr/lpddr2_nvm.c
index 5e36366d9b36..19b00225c7ef 100644
--- a/drivers/mtd/lpddr/lpddr2_nvm.c
+++ b/drivers/mtd/lpddr/lpddr2_nvm.c
@@ -448,6 +448,8 @@ static int lpddr2_nvm_probe(struct platform_device *pdev)
 
 	/* lpddr2_nvm address range */
 	add_range = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!add_range)
+		return -ENODEV;
 
 	/* Populate map_info data structure */
 	*map = (struct map_info) {
-- 
2.35.1



