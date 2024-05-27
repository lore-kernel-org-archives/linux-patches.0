Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51EA9168C4;
	Mon, 27 May 2024 19:24:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837891; cv=none; b=YmksciU/1ENXxJ20847MRFm4EfPW+P9joE68rXDPaTomuOYhinrA8+JDv4Opta/UVzGi/yO/+H4MsREi0eVuZahz9l27+z/A5HUmZGxtzbPea/vPjln+AmILjLbnsZV0clm5RiYZoKS8ng5+DZbNNj7be/s5Nxuab10JmQO/PXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837891; c=relaxed/simple;
	bh=LslLf36W1hJ/r4s6pxUAbH1EJIZdHtTPeymKKSl/MHw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r0hFLu/7HUkzVTN2gcFNWM997tQTPH/Xpomd4SA5RhlFqje5ldVRqbPUfXeTe0HKTmSIbvuF10tfPRMAHAd9yPtGrSVqudY9rOIl66ebjBZgkUPpR/pLH+NhsSCHs9+cTuIFAmOWNSOuhU182pNgXyL290VyYWBSkWxsHaf3Hd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VqmSbbGC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VqmSbbGC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DED3FC2BBFC;
	Mon, 27 May 2024 19:24:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837891;
	bh=LslLf36W1hJ/r4s6pxUAbH1EJIZdHtTPeymKKSl/MHw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VqmSbbGCgx2rCtj2/cBKJ3QOvryLNRGtH5kvkGABZDM9Dj7kgrPeB2NdRvJcLUGJf
	 fDwUlpMKMeiU8JQ3JrismZOLVWOYTNw2rsFx9kKkUPb5y0i0IvRnhBG3IbNNsSfivQ
	 cJ43PDIvh5Qg0STQ14OV1PNdxM67D21YSNCUC/Zk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Subbaraya Sundeep <sbhatta@marvell.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 186/493] mlx5: avoid truncating error message
Date: Mon, 27 May 2024 20:53:08 +0200
Message-ID: <20240527185636.432797357@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit b324a960354b872431d25959ad384ab66a7116ec ]

clang warns that one error message is too long for its destination buffer:

drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c:1876:4: error: 'snprintf' will always be truncated; specified size is 80, but format string expands to at least 94 [-Werror,-Wformat-truncation-non-kprintf]

Reword it to be a bit shorter so it always fits.

Fixes: 70f0302b3f20 ("net/mlx5: Bridge, implement mdb offload")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Subbaraya Sundeep <sbhatta@marvell.com>
Link: https://lore.kernel.org/r/20240326223825.4084412-5-arnd@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
index 1b9bc32efd6fa..c5ea1d1d2b035 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
@@ -1874,7 +1874,7 @@ int mlx5_esw_bridge_port_mdb_add(struct net_device *dev, u16 vport_num, u16 esw_
 				 "Failed to lookup bridge port vlan metadata to create MDB (MAC=%pM,vid=%u,vport=%u)\n",
 				 addr, vid, vport_num);
 			NL_SET_ERR_MSG_FMT_MOD(extack,
-					       "Failed to lookup bridge port vlan metadata to create MDB (MAC=%pM,vid=%u,vport=%u)\n",
+					       "Failed to lookup vlan metadata for MDB (MAC=%pM,vid=%u,vport=%u)\n",
 					       addr, vid, vport_num);
 			return -EINVAL;
 		}
-- 
2.43.0



