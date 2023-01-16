Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 073A546B7
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:09:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63E5BC433F1;
	Mon, 16 Jan 2023 16:09:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673885393;
	bh=MGBw/PBOU46eeBtY46uz0AIBIqcMkt6mI+JMcBWO2Mw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j73J1fCyIrQh851nKMWO7mJc+8N1moCU0aMItibEDELOl/wia8KKlsOTRunIM5veQ
	 QiYTamx6UUPcUvGUs50vNN7A79RCjxemKH6Fw7XdfX8QRactbtb2jAfNt42QKH9dq2
	 4DTNCiqu7hFhF+F0NjnYGT/afm3/A0G9zf2VhIPQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zeal Robot <zealci@zte.com.cn>,
	Minghao Chi <chi.minghao@zte.com.cn>,
	Nishanth Menon <nm@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 027/658] soc: ti: knav_qmss_queue: Use pm_runtime_resume_and_get instead of pm_runtime_get_sync
Date: Mon, 16 Jan 2023 16:41:55 +0100
Message-Id: <20230116154910.865553879@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Minghao Chi <chi.minghao@zte.com.cn>

[ Upstream commit 12eeb74925da70eb39d90abead9de9793be3d4c8 ]

Using pm_runtime_resume_and_get is more appropriate for simplifying
code.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Minghao Chi <chi.minghao@zte.com.cn>
Signed-off-by: Nishanth Menon <nm@ti.com>
Link: https://lore.kernel.org/r/20220418062955.2557949-1-chi.minghao@zte.com.cn
Stable-dep-of: e961c0f19450 ("soc: ti: knav_qmss_queue: Fix PM disable depth imbalance in knav_queue_probe")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/ti/knav_qmss_queue.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/soc/ti/knav_qmss_queue.c b/drivers/soc/ti/knav_qmss_queue.c
index d5fc00979628..593df764eb57 100644
--- a/drivers/soc/ti/knav_qmss_queue.c
+++ b/drivers/soc/ti/knav_qmss_queue.c
@@ -1789,9 +1789,8 @@ static int knav_queue_probe(struct platform_device *pdev)
 	INIT_LIST_HEAD(&kdev->pdsps);
 
 	pm_runtime_enable(&pdev->dev);
-	ret = pm_runtime_get_sync(&pdev->dev);
+	ret = pm_runtime_resume_and_get(&pdev->dev);
 	if (ret < 0) {
-		pm_runtime_put_noidle(&pdev->dev);
 		dev_err(dev, "Failed to enable QMSS\n");
 		return ret;
 	}
-- 
2.35.1



