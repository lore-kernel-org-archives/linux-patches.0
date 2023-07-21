Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9E82200A9
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 19:17:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29341C433C8;
	Fri, 21 Jul 2023 19:17:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689967052;
	bh=ACj0LKtOXM9UF51BatyewBRGZC6YeE+ghIg8iWszAgQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J6k4j4stAKnr3X1QyV64p6cuQYfOY+bFTaenaGrvMBsByiV4tlOqfzjdD4OcGmQDX
	 DKJlIr8GLCLPY81c/lDaUTAAkVPn3BrUKOLWG3skg/ruvqoqR6eQ6pTMZt+q0GMrrG
	 3vL+8JlCoCjVNcxDHhc5C55HR2d7IO1ktwLHiHtI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junfeng Guo <junfeng.guo@intel.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 028/223] gve: Set default duplex configuration to full
Date: Fri, 21 Jul 2023 18:04:41 +0200
Message-ID: <20230721160522.070390625@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160520.865493356@linuxfoundation.org>
References: <20230721160520.865493356@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Junfeng Guo <junfeng.guo@intel.com>

[ Upstream commit 0503efeadbf6bb8bf24397613a73b67e665eac5f ]

Current duplex mode was unset in the driver, resulting in the default
parameter being set to 0, which corresponds to half duplex. It might
mislead users to have incorrect expectation about the driver's
transmission capabilities.
Set the default duplex configuration to full, as the driver runs in
full duplex mode at this point.

Fixes: 7e074d5a76ca ("gve: Enable Link Speed Reporting in the driver.")
Signed-off-by: Junfeng Guo <junfeng.guo@intel.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Message-ID: <20230706044128.2726747-1-junfeng.guo@intel.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/google/gve/gve_ethtool.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/google/gve/gve_ethtool.c b/drivers/net/ethernet/google/gve/gve_ethtool.c
index 38df602f2869c..033f17cb96be0 100644
--- a/drivers/net/ethernet/google/gve/gve_ethtool.c
+++ b/drivers/net/ethernet/google/gve/gve_ethtool.c
@@ -541,6 +541,9 @@ static int gve_get_link_ksettings(struct net_device *netdev,
 		err = gve_adminq_report_link_speed(priv);
 
 	cmd->base.speed = priv->link_speed;
+
+	cmd->base.duplex = DUPLEX_FULL;
+
 	return err;
 }
 
-- 
2.39.2



