Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D632220F88
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 19:10:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 517C6C433C8;
	Fri, 21 Jul 2023 19:10:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689966640;
	bh=eoZRbh0h2Jfl9teXnIUwlKQFTa47yCVPXx2tjvwB5Ys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DoXAGOYyYCzmJk75GXCtR2JlUsWGxu/EajIWhf64VvbQhaS+z8ifu8nd+p6zEguyv
	 9PqUHG+Cqil9j0Cnv6DuTDfZiDEUhMQ40wblsEJKfzNXgp6Ud8IsmiKQsN64gOIRNK
	 621Nbw+LAOt7rBL8RzeQ0td2QGvicIJs32flormU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junfeng Guo <junfeng.guo@intel.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 408/532] gve: Set default duplex configuration to full
Date: Fri, 21 Jul 2023 18:05:12 +0200
Message-ID: <20230721160636.593697717@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160614.695323302@linuxfoundation.org>
References: <20230721160614.695323302@linuxfoundation.org>
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
index 6a0663aadd1e9..1f8cc722aae30 100644
--- a/drivers/net/ethernet/google/gve/gve_ethtool.c
+++ b/drivers/net/ethernet/google/gve/gve_ethtool.c
@@ -532,6 +532,9 @@ static int gve_get_link_ksettings(struct net_device *netdev,
 		err = gve_adminq_report_link_speed(priv);
 
 	cmd->base.speed = priv->link_speed;
+
+	cmd->base.duplex = DUPLEX_FULL;
+
 	return err;
 }
 
-- 
2.39.2



