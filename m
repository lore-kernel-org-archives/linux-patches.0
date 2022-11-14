Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 774ED4C6A
	for <patches@lists.linux.dev>; Mon, 14 Nov 2022 13:04:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0ACAC433D7;
	Mon, 14 Nov 2022 13:04:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1668431079;
	bh=VWoPcngRA0ErmYdDOII9ukfQbykBsnABRsNdnLe51OA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QsmcOPxQcRFjRtFoBAMAlRKsq/iN9W5USCuzGu+c6R4/OGC1ieghS+Fke7zX7gWV+
	 wkYzK4ruvqI50jjLMKxMlQ3nw32x94bbGnvXxF1c5I3e0v8vSGViDjj+yyHMtKsgt3
	 SUmqElOHXDSfCIBHcl0xO/PeGozKu5zt/Byb2Fv4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianbo Liu <jianbol@nvidia.com>,
	Maor Dickman <maord@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 092/190] net/mlx5e: TC, Fix wrong rejection of packet-per-second policing
Date: Mon, 14 Nov 2022 13:45:16 +0100
Message-Id: <20221114124502.729152266@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124458.806324402@linuxfoundation.org>
References: <20221114124458.806324402@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jianbo Liu <jianbol@nvidia.com>

[ Upstream commit 9e06430841363a1d2932d546fdce1cc5edb3c2a0 ]

In the bellow commit, we added support for PPS policing without
removing the check which block offload of such cases.
Fix it by removing this check.

Fixes: a8d52b024d6d ("net/mlx5e: TC, Support offloading police action")
Signed-off-by: Jianbo Liu <jianbol@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index a687f047e3ae..229c14b1af00 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -4739,12 +4739,6 @@ int mlx5e_policer_validate(const struct flow_action *action,
 		return -EOPNOTSUPP;
 	}
 
-	if (act->police.rate_pkt_ps) {
-		NL_SET_ERR_MSG_MOD(extack,
-				   "QoS offload not support packets per second");
-		return -EOPNOTSUPP;
-	}
-
 	return 0;
 }
 
-- 
2.35.1



