Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2A82FBEA
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:04:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18F86C4339B;
	Mon, 15 May 2023 17:04:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684170267;
	bh=Z/gDJJJKMVNdVuRO3qUjS8ELSXpCSLM7BwbRrtdpN58=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RQY02RxKhE0tNdkyik34WCkULX6Q6mGN0iOVwe5K+hoeFOgREa6jF5i9U0qrRcIHe
	 0NNLuILxRxAJp3v8gkN3/Msk1qsJ03HkoE3kdBKOx5LfqUGUyyE3XQxDjOeU6iwIw/
	 TTlNm1PwFivsBob5jx+0wOljzNwti47H7BHwRVlQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shannon Nelson <shannon.nelson@amd.com>,
	Simon Horman <simon.horman@corigine.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 076/239] ionic: remove noise from ethtool rxnfc error msg
Date: Mon, 15 May 2023 18:25:39 +0200
Message-Id: <20230515161723.966490915@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161721.545370111@linuxfoundation.org>
References: <20230515161721.545370111@linuxfoundation.org>
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
index 01c22701482d9..d7370fb60a168 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
@@ -691,7 +691,7 @@ static int ionic_get_rxnfc(struct net_device *netdev,
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



