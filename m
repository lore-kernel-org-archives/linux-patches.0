Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5076579C0
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:48:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6D4DC433D6;
	Wed, 30 Nov 2022 18:48:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669834126;
	bh=o9uSvNsAIfzXiZca4keuSiJpQj8TmnCSVSIxhnQDkdk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b3E4E9cZItcPe3tjM6oPWPr8O6zQsCdVQSgKObQKocC6Ptr85EtV6ooZggpizwINS
	 ndLcnY4od/kMytO4cbOhRR9OZenRLRP/eRWBszAHM+IwpRmKRWbML4OOYNolQwwPu8
	 QcI5ii2MPcvpelpP/fEXcMRtnRm9ZOoPUOoePJbY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Yongjun <weiyongjun1@huawei.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 112/289] net: phy: at803x: fix error return code in at803x_probe()
Date: Wed, 30 Nov 2022 19:21:37 +0100
Message-Id: <20221130180546.679475495@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Wei Yongjun <weiyongjun1@huawei.com>

[ Upstream commit 1f0dd412e34e177621769866bef347f0b22364df ]

Fix to return a negative error code from the ccr read error handling
case instead of 0, as done elsewhere in this function.

Fixes: 3265f4218878 ("net: phy: at803x: add fiber support")
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://lore.kernel.org/r/20221118103635.254256-1-weiyongjun@huaweicloud.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/at803x.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
index 59fe356942b5..249e7ee4a2bb 100644
--- a/drivers/net/phy/at803x.c
+++ b/drivers/net/phy/at803x.c
@@ -862,8 +862,10 @@ static int at803x_probe(struct phy_device *phydev)
 			.wolopts = 0,
 		};
 
-		if (ccr < 0)
+		if (ccr < 0) {
+			ret = ccr;
 			goto err;
+		}
 		mode_cfg = ccr & AT803X_MODE_CFG_MASK;
 
 		switch (mode_cfg) {
-- 
2.35.1



