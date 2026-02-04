Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 621714218A5;
	Wed,  4 Feb 2026 14:59:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770217167; cv=none; b=ObqZ1nS09P6HZoo755+5vox2HOyJ7LQAfrccpIbNQVejdmjE3fImgNZf+UJXGFdmfeyeEDLu1dF9+HfHNi376sJ9yWRKAaCh9SBeoITnWfUEicJipLhFMbrc4s8w3mjGngzj045z3x65JADQG8kyDIU/Rf/VOr5NG3dvqgoOCOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770217167; c=relaxed/simple;
	bh=slgEEcRvI2AHfxS3XIGEcliVdduOzYepx0KbPnUh/XM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZBfmf4eNY8wbmBtsA2J9Aq8SKQ5OCQRudPwTP33NZVUbxsYjl63qeS/uErqQ7lUXMbVKRU/Qwt/qAV7ztWc6jtv0MUcXJ9/DY1/UPGPP1ZJh+zqn3DYS1iXu1lcJgk3Sed6xoLgrajAcRWiWr30hxcozreKksnLbdGzMWmHJPqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mQrnR2HH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mQrnR2HH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 800ECC4CEF7;
	Wed,  4 Feb 2026 14:59:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770217166;
	bh=slgEEcRvI2AHfxS3XIGEcliVdduOzYepx0KbPnUh/XM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mQrnR2HH7zwri1r2n7zPugtVoEgaxm5cma/OUOocM7RxJApl9gzD7qNdCKVKdUQOK
	 eFncktZZ32jZlhfJI5B6oN76YLICR3dQIztk8k6pRphoD5xlrFjLIeM/OvfxaDdsIh
	 jBCeVuzI2X9xdX6SfmqbpjNMFN46kUBrkqXoil48=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Yafang Shao <laoar.shao@gmail.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Gal Pressman <gal@nvidia.com>,
	Simon Horman <horms@kernel.org>,
	Tariq Toukan <tariqt@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 144/206] net/mlx5e: Report rx_discards_phy via rx_dropped
Date: Wed,  4 Feb 2026 15:39:35 +0100
Message-ID: <20260204143903.392071375@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143858.193781818@linuxfoundation.org>
References: <20260204143858.193781818@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yafang Shao <laoar.shao@gmail.com>

[ Upstream commit c9cfced17365b1df8c6ae6cd5db56aebd7ed9b57 ]

We noticed a high number of rx_discards_phy events on certain servers while
running `ethtool -S`. However, this critical counter is not currently
included in the standard /proc/net/dev statistics file, making it difficult
to monitor effectively—especially given the diversity of vendors across a
large fleet of servers.

Let's report it via the standard rx_dropped metric.

Suggested-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Gal Pressman <gal@nvidia.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/20241210022706.6665-1-laoar.shao@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 476681f10cc1 ("net/mlx5e: Account for netdev stats in ndo_get_stats64")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index b4e6a467409be..5504b7b3b3f90 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -3186,6 +3186,7 @@ mlx5e_get_stats(struct net_device *dev, struct rtnl_link_stats64 *stats)
 	}
 
 	stats->rx_missed_errors = priv->stats.qcnt.rx_out_of_buffer;
+	stats->rx_dropped = PPORT_2863_GET(pstats, if_in_discards);
 
 	stats->rx_length_errors =
 		PPORT_802_3_GET(pstats, a_in_range_length_errors) +
-- 
2.51.0



