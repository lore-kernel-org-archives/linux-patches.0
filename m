Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028076;
	b=kAXzUk3ScJ6gbDSpvROsHIeUBqNNyBbhCVbgcIVLaqT8uOSfsGGIqT6hy4B9o+jb0R1Q
	 vieMqK+9nUwpnwUqcv+GU1MC3LDC9jKOTFKzIbekX3H4d9k5MRAJT1WgbwezKPEYLocWs
	 Wu6JKjDBorZDyb0+8n1b60DhB5qoZYBAhOXiBIayVs/n3RN55EC5DX/EmoIzoMJYs/Sg2
	 jOiO7IekCTju7cyLYhqYJkf68N0pCF/g5LDo4v0ITTwptJ7Mw+1FSUY9AvdIQIONwWUdv
	 diAXtfdYz1yC2MPHJZM5jGEMkqk577q04/4EqMTccja40avrOCiJPExMq6Q3jpMXZYA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028076;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VbDXvu5agfX6q8a7PkGWGfGE2ygjaFxYr2g8uaeRiUo=;
	b=GroYqa4i9bvhfI+zkk3OFGI0xAJOmLNFSKcthDDg2G9hhav1gZCKEJ8+CywLhg4IPTZe
	 9hj5zjTmpQsrJS7IZfy3CQ/tOsrNJ3IIUR5b78hD0xBzJ4sI1qtjPDEr+Bb9VR1x7Ffko
	 S2rgQpEWfBIsv0gJPv8RtepT4he3YNl5bdvktF1WwalWScSenOR1d7pjlNtvEXfxq1TNh
	 YgwtynDZWl6Bka5OFYShuALGvnNWFimrJuCdkHMdIf1g0XET7CiMVfSeZ89T9t+ARh9dP
	 +XbRLte/q9T8hTE28TQi3esH0CAjEbwhv1PcR9JKe5rrTMGUtg72+++b+gPLFM3nosQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="aUyT/Rz5";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B099606A31C;
	Wed, 18 Nov 2026 18:54:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aUyT/Rz5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4CCD1F000C5;
	Wed, 18 Nov 2026 18:54:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028076;
	bh=VbDXvu5agfX6q8a7PkGWGfGE2ygjaFxYr2g8uaeRiUo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aUyT/Rz56BklAqH2oivRhqxjjVYdQW/FbwSGS6Jbe/N0Vcu3eWrRSHqaX+/IcGlPQ
	 7I9kQI3pykB0ecr13o/ibBqAE7C8sAPd4/SoIbjVeQu2CbpTZoQQxyIROSOzXF+aVm
	 qnZOxQwpb/xYUpTyIyi/TZgRPJBusSilSpIBE7wE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Romanovsky <leon@kernel.org>,
	Peter Morrow <pdmorrow@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Daniel Machon <daniel.machon@microchip.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Dave Miller <davem@davem-thinkpadp1gen8.ibmlond.csb>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 2017/2151] net/mlx4: always create the eth and ib auxiliary devices
Date: Wed, 18 Nov 2026 16:02:32 +0100
Message-ID: <20261118150235.216075461@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Morrow <pdmorrow@gmail.com>

[ Upstream commit 557d80138618b9d17407733d4ec25b33d3971d60 ]

Since commit 7d22b1cb9d84 ("mlx4: Connect the infiniband part to the
auxiliary bus"), mlx4_core creates the "ib" auxiliary device only for
an IB port or a device that advertises IBoE. Before it, each mlx4
interface was offered every device and decided in its own add callback.
mlx4_ib_add() accepted Ethernet ports without IBoE and registered them
for raw packet QPs only.

ConnectX-3 VFs on Azure have an Ethernet port and no IBoE, so since
v6.6 they get no RDMA device. DPDK's mlx4 PMD, which needs only raw
packet QPs, then cannot open them:

  net_mlx4: cannot access device, is mlx4_ib loaded?

Restore the old behaviour by creating both auxiliary devices for every
device and letting mlx4_en and mlx4_ib decide in probe, as their add
callbacks did. mlx4_ib_probe() returns -ENODEV when there are no usable
ports, and mlx4_en_probe() binds a device without Ethernet ports but
creates no netdevs, as mlx4_en_add() did.

Tested on 6.12.111 on an Azure VM with two ConnectX-3 VFs: each gets an
eth and an ib auxiliary device, and DPDK attaches both VFs and passes
traffic through them.

Fixes: 7d22b1cb9d84 ("mlx4: Connect the infiniband part to the auxiliary bus")
Closes: https://lore.kernel.org/r/20261014133951.3219055-1-pdmorrow@gmail.com
Suggested-by: Leon Romanovsky <leon@kernel.org>
Assisted-by: LLM
Signed-off-by: Peter Morrow <pdmorrow@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Daniel Machon <daniel.machon@microchip.com>
Acked-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Dave Miller <davem@davem-thinkpadp1gen8.ibmlond.csb>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx4/intf.c | 15 ++-------------
 1 file changed, 2 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/intf.c b/drivers/net/ethernet/mellanox/mlx4/intf.c
index a371b970ac1e2..5bb6272968148 100644
--- a/drivers/net/ethernet/mellanox/mlx4/intf.c
+++ b/drivers/net/ethernet/mellanox/mlx4/intf.c
@@ -43,23 +43,12 @@ static DEFINE_IDA(mlx4_adev_ida);
 
 static bool is_eth_supported(struct mlx4_dev *dev)
 {
-	for (int port = 1; port <= dev->caps.num_ports; port++)
-		if (dev->caps.port_type[port] == MLX4_PORT_TYPE_ETH)
-			return true;
-
-	return false;
+	return true;
 }
 
 static bool is_ib_supported(struct mlx4_dev *dev)
 {
-	for (int port = 1; port <= dev->caps.num_ports; port++)
-		if (dev->caps.port_type[port] == MLX4_PORT_TYPE_IB)
-			return true;
-
-	if (dev->caps.flags & MLX4_DEV_CAP_FLAG_IBOE)
-		return true;
-
-	return false;
+	return true;
 }
 
 static const struct mlx4_adev_device {
-- 
2.53.0



