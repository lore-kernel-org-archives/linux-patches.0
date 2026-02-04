Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 550C6219301;
	Wed,  4 Feb 2026 14:49:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770216568; cv=none; b=s8dYi3LT2KsPRLqbMtD0aZdwglG9TiYBLl926u3f17UNGhES1kdqToQ66xckNhaYNqF9Vc9LTEVeJIHe7WnJOR/Z8qEVw0EdxMTBZwuVLOzHajP9gwYqwPgcWT/E+ZbA8FVppvwr7s0mGnbxMa4cfqlILFryZ6YsjorOIME6gXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770216568; c=relaxed/simple;
	bh=c8MVxv0zgQkNgouIeIho35OeMbo3SZwgM57enWLQlKw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HeUTquTXybRaB8A+m//voY+JC+SyrYWa0Agr4Yoi3SrzBbnC6jFUp1+EcH8j8xKV45J52neRO9UAtRQBwfaR4obWzbT19SQRwU8Wy2FMC3m1CmM90F20jpYiX66FNnrcI1bEY71BktV2L4XIK79PqcmvFhZ2j009MZLkK2FqutU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gstIBQJJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gstIBQJJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5DA2C4CEF7;
	Wed,  4 Feb 2026 14:49:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770216568;
	bh=c8MVxv0zgQkNgouIeIho35OeMbo3SZwgM57enWLQlKw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gstIBQJJfwSaI+8U+gYMcGqScgKRiWSdOBwTU8iaUFOgpZsjeXfb34qMAd/gv4hPI
	 CWxegi29VzEIQm4bNggM4dWo1f6rir5Wlnj88KyO0zuS4a0167KwZAEdvoEs5Di0rP
	 JBtmjXH3o9Occ6QCOu+45Hsh7iVpff8pjGWltVqc=
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
Subject: [PATCH 5.10 126/161] net/mlx5e: Report rx_discards_phy via rx_dropped
Date: Wed,  4 Feb 2026 15:39:49 +0100
Message-ID: <20260204143856.278306715@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143851.755002596@linuxfoundation.org>
References: <20260204143851.755002596@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index af98d9e59626d..36f5d5e449209 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -3696,6 +3696,7 @@ mlx5e_get_stats(struct net_device *dev, struct rtnl_link_stats64 *stats)
 	}
 
 	stats->rx_missed_errors = priv->stats.qcnt.rx_out_of_buffer;
+	stats->rx_dropped = PPORT_2863_GET(pstats, if_in_discards);
 
 	stats->rx_length_errors =
 		PPORT_802_3_GET(pstats, a_in_range_length_errors) +
-- 
2.51.0



