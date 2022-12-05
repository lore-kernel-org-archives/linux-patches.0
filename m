Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A13415C83
	for <patches@lists.linux.dev>; Mon,  5 Dec 2022 19:34:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0CFEC433B5;
	Mon,  5 Dec 2022 19:34:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670268873;
	bh=VkOFT7DBQT7Up2BTSVl1Iqk88N6FZaJHKY6oqZRsDbs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uhZ36DLu03Nmx7yM6ULFjDBK0VxzVO15Z0UNzXHY237BziSQ4fJBcmOhnlozplZqr
	 FWkAsPYWmXwFR+SJp3hzKRboE8JlIBF4we7XXfIZ1TXXc5vkzJdtS5b/La2Z9zJdm/
	 0rRd0mU1dVFIuW77Wcl0TF/hLrL9QPzYUoSHCYXw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiasheng Jiang <jiasheng@iscas.ac.cn>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 042/120] can: m_can: Add check for devm_clk_get
Date: Mon,  5 Dec 2022 20:09:42 +0100
Message-Id: <20221205190807.801435141@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190806.528972574@linuxfoundation.org>
References: <20221205190806.528972574@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jiasheng Jiang <jiasheng@iscas.ac.cn>

[ Upstream commit 68b4f9e0bdd0f920d7303d07bfe226cd0976961d ]

Since the devm_clk_get may return error,
it should be better to add check for the cdev->hclk,
as same as cdev->cclk.

Fixes: f524f829b75a ("can: m_can: Create a m_can platform framework")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Link: https://lore.kernel.org/all/20221123063651.26199-1-jiasheng@iscas.ac.cn
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/m_can/m_can.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index c4596fbe6d2f..46ab6155795c 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -1931,7 +1931,7 @@ int m_can_class_get_clocks(struct m_can_classdev *cdev)
 	cdev->hclk = devm_clk_get(cdev->dev, "hclk");
 	cdev->cclk = devm_clk_get(cdev->dev, "cclk");
 
-	if (IS_ERR(cdev->cclk)) {
+	if (IS_ERR(cdev->hclk) || IS_ERR(cdev->cclk)) {
 		dev_err(cdev->dev, "no clock found\n");
 		ret = -ENODEV;
 	}
-- 
2.35.1



