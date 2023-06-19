Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B0B33C23
	for <patches@lists.linux.dev>; Mon, 19 Jun 2023 10:38:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A85C0C433C8;
	Mon, 19 Jun 2023 10:38:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687171133;
	bh=NU6FtV+glwnYxvvBXnryZ3yMhhNrZNpzjTZ1oY/t/L8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nHmXaGzTwxMv6BX9AOXMuTp5f69N+bOhJrabpYoWRzAdHEr2L7aNAxoYgqm9oKiSu
	 A+UkjWRRoCLNQWo2Ik7jI2K9WEqBLrtc71+ysRio+dwyRQA4N+H3J0MdfA1wSFTD9N
	 pIAI9n3aIyfzbIWLTcg48UYtsiiKOMvrl2qxbLOc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Roger Quadros <rogerq@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 160/187] net: ethernet: ti: am65-cpsw: Call of_node_put() on error path
Date: Mon, 19 Jun 2023 12:29:38 +0200
Message-ID: <20230619102205.313775659@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230619102157.579823843@linuxfoundation.org>
References: <20230619102157.579823843@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 374283a1001277e4d07491387aac1fad5aa08d43 ]

This code returns directly but it should instead call of_node_put()
to drop some reference counts.

Fixes: dab2b265dd23 ("net: ethernet: ti: am65-cpsw: Add support for SERDES configuration")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Roger Quadros <rogerq@kernel.org>
Link: https://lore.kernel.org/r/e3012f0c-1621-40e6-bf7d-03c276f6e07f@kili.mountain
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ti/am65-cpsw-nuss.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index bcea87b7151c0..ad69c5d5761b3 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -2031,7 +2031,7 @@ static int am65_cpsw_nuss_init_slave_ports(struct am65_cpsw_common *common)
 		/* Initialize the Serdes PHY for the port */
 		ret = am65_cpsw_init_serdes_phy(dev, port_np, port);
 		if (ret)
-			return ret;
+			goto of_node_put;
 
 		port->slave.mac_only =
 				of_property_read_bool(port_np, "ti,mac-only");
-- 
2.39.2



