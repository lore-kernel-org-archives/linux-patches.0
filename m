Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F16F15ACF
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:43:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87AD4C433C9;
	Tue, 25 Jul 2023 11:43:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690285420;
	bh=6RSC/1Um4v/gX+v3CBYYV17yXwAw6TpPCRfnfjf++KY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oqm/ZewqsJjNjYviSERPezP0pmvNPtZuC5jqWn9/vdkriVfbsKQvFwf+5WdK3LOuR
	 18Ao6EMw8A5m0xdND766TJf1RR/5yKZdSMYf7+JBDNlRDIWGSpRlvd0V2YrZxiefDY
	 o92Ut+g+iIPSIXLaX1aZzX7ep4YuJl6+VBLarBBo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prasad Koya <prasad@arista.com>,
	Sasha Neftin <sasha.neftin@intel.com>,
	Naama Meir <naamax.meir@linux.intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 199/313] igc: set TP bit in supported and advertising fields of ethtool_link_ksettings
Date: Tue, 25 Jul 2023 12:45:52 +0200
Message-ID: <20230725104529.630251269@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104521.167250627@linuxfoundation.org>
References: <20230725104521.167250627@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Prasad Koya <prasad@arista.com>

[ Upstream commit 9ac3fc2f42e5ffa1e927dcbffb71b15fa81459e2 ]

set TP bit in the 'supported' and 'advertising' fields. i225/226 parts
only support twisted pair copper.

Fixes: 8c5ad0dae93c ("igc: Add ethtool support")
Signed-off-by: Prasad Koya <prasad@arista.com>
Acked-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Naama Meir <naamax.meir@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/igc/igc_ethtool.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/intel/igc/igc_ethtool.c b/drivers/net/ethernet/intel/igc/igc_ethtool.c
index cbcb8611ab50d..0a4e7f5f292ac 100644
--- a/drivers/net/ethernet/intel/igc/igc_ethtool.c
+++ b/drivers/net/ethernet/intel/igc/igc_ethtool.c
@@ -1668,6 +1668,8 @@ static int igc_get_link_ksettings(struct net_device *netdev,
 	/* twisted pair */
 	cmd->base.port = PORT_TP;
 	cmd->base.phy_address = hw->phy.addr;
+	ethtool_link_ksettings_add_link_mode(cmd, supported, TP);
+	ethtool_link_ksettings_add_link_mode(cmd, advertising, TP);
 
 	/* advertising link modes */
 	if (hw->phy.autoneg_advertised & ADVERTISE_10_HALF)
-- 
2.39.2



