Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033022;
	b=AF4a/pAXwhzJ2xdmmjNIrrKd1mcN28bQ/dvY10PQo3RRzLvNtoJ4vfYVpvcH7lRZX6Qb
	 2NLdRVVOjZSKRewwmfLQ2HUx3PiPgVMCabOJabrTewWeyouIcge35Dq2pYFF+vXyCC01D
	 ncGHryRLqrmoO8AnxPX5eXzvQB91HPx3PccKQVMgXK0kqRAdbEFNc9nz1u6XXwnzTBMFS
	 N/Ly57yUE5fdyFDsxf3SFhej5cEFMuEQTpFySl75xZPuYNlLAVRLwddt2BR3ECnpWbbh8
	 C62SucxaFSC2Ho4Cs0A3YPvrnlMr133IwELeSfGwyW8e8TnC5Ot64eO70Fr2Mr8BfKw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033022;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+Lo0wtVyRrEHYSX8TUt5tGCBhBvGClZLZWBeyG4YNZg=;
	b=sQD1JJL+NV6bN+kUCENLgMJ6or5nmpGMeN98GY4pO3783fyM1YBf/BLlJNGysygnix+Q
	 lkRYWxdHb7GTDDwJs1ubjAS+ZhIA/VAWCQDsBNw2I/v5Dho3PiUa3T+P01+gJqre0B5rg
	 6pQWHhinddCKiqAqIhdZuJVMWLs8t2F/nHpYxkqPWxpk0yjbagAiyL7oTwO/YqtvneWLX
	 4ZXEMmbbsLrzTMJ7mhRpbGXfFTLAqGIyRMJRpG5GY/+GfqTS0Ypd9fsl3VTIy2QBQXfXa
	 9QoQ6beXhFbweMmJqHRJ+SsgjSf0yvnMynXCFmYy2JaVGgaR4zhBfzz47gnXkdcY3jQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lEPn00hU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D721F606A31C;
	Wed, 18 Nov 2026 20:17:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lEPn00hU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41E171F000C4;
	Wed, 18 Nov 2026 20:17:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033022;
	bh=+Lo0wtVyRrEHYSX8TUt5tGCBhBvGClZLZWBeyG4YNZg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lEPn00hUqsEAqpc9OTymcDb078u7MBLAm8uIuwUax1k+Hmvmt7k/qwBlvj2wyDNzh
	 cGvR5ymZHp5MhGPAeCQZnKUWV3MNuPBfLLxPPYT6ra8rvWIrQw3sfCaO/4PFvo+UVq
	 Nqua+5rRkQ/xMGxGljmlzFi+yssw+SHTZAMhPrz0=
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
Subject: [PATCH 6.12 1620/1756] net/mlx4: always create the eth and ib auxiliary devices
Date: Wed, 18 Nov 2026 16:02:27 +0100
Message-ID: <20261118150114.322941656@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



