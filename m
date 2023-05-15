Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 751EAFBF6
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:50:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9C14C433A1;
	Mon, 15 May 2023 17:50:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684173037;
	bh=78+3sAd+Pzct+cdC/aPsGnTrySnJraeL1fsSQU54C1k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c7hIjJ9mEfb866cQaXMPZ5cAsUOdbDiMEZb/JSl8kWujJFzqqpor/mkrXZScrhTUS
	 avlk2gNObBhtE7JyD1MtoZIVFbrSNo3DxrCon51o9gQOD7RAsvyA41XApRqMMJ7HZg
	 czscz6TnFuCcUTdFiK8hMq8/8l4Ibzsth0olwyew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shannon Nelson <shannon.nelson@amd.com>,
	Simon Horman <simon.horman@corigine.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 320/381] ionic: remove noise from ethtool rxnfc error msg
Date: Mon, 15 May 2023 18:29:31 +0200
Message-Id: <20230515161751.257877539@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161736.775969473@linuxfoundation.org>
References: <20230515161736.775969473@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Shannon Nelson <shannon.nelson@amd.com>

[ Upstream commit 3711d44fac1f80ea69ecb7315fed05b3812a7401 ]

It seems that ethtool is calling into .get_rxnfc more often with
ETHTOOL_GRXCLSRLCNT which ionic doesn't know about.  We don't
need to log a message about it, just return not supported.

Fixes: aa3198819bea6 ("ionic: Add RSS support")
Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/pensando/ionic/ionic_ethtool.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
index 35c72d4a78b3f..8e5b01af85ed2 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
@@ -693,7 +693,7 @@ static int ionic_get_rxnfc(struct net_device *netdev,
 		info->data = lif->nxqs;
 		break;
 	default:
-		netdev_err(netdev, "Command parameter %d is not supported\n",
+		netdev_dbg(netdev, "Command parameter %d is not supported\n",
 			   info->cmd);
 		err = -EOPNOTSUPP;
 	}
-- 
2.39.2



