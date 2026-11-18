Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042652;
	b=F/594zFXpE8tPnDb3I+hKfv6XMc7seBwBxpfGFD1st6/9qc0ejR8aef6dx3auUq/A/uZ
	 761ktNievr1Lv/oH2T7GTdJ//hWegU4+IeMxkkHjHl8necNkyvtavag13Od0C5OPJTd1p
	 kcreH31pRrQDhQeMTjIXNTBobgv5XRxeE7Lf+qbbcfPwmvIcBc2euWvJN16MexYydhDA6
	 lwxQPWvdZOFmRG1yhwQl7NXYGAvSf3jNlNGVXwj+iNwftE1h6PTif/CvIAnlxFX3Z7LYV
	 2DAawCq+a66MHqQjSBupyoXH+5daNlNtimv8VwP6H9uHl7udjTwpInKHNTDHGqLrL4Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042652;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8dLbGlMoVc0ylU9YXm8fYo70FE1xKgIIhATxHXSw4m8=;
	b=q6HOH5iwLsJVmlEjDuZ7o+hkWBOI8jZbq4jlOiPiEjiAblVlDhKSkS0U0kXAKjrtZcbY
	 11dkD7WUTCF5Ad5ob7J+QpAANgHTTwDILxkWAhtLgi5bJDv5Mpw3bejN4QOD0hJa+dGQK
	 S6B6d8J1kPLd9RtYW5Wjd2FYlM716nibXiBMWAppOtLOcS+YR5je+SS7vuZ/XqWBaCvgf
	 DK4ddgtIrY25XYUGUDVHn73K89ekqSZFiGtiAYIsWDGh0we4uME0yk95P3d8a6nojatYS
	 PSlwAlqabgIav4ZtLaMluYlNIYVSCWykhmiRXLGJWy1+fQhkBgutzfOrBsEv7SCwctQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YGa7UvKq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B6F9606A31C;
	Wed, 18 Nov 2026 22:57:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YGa7UvKq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FCF91F000C4;
	Wed, 18 Nov 2026 22:57:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042652;
	bh=8dLbGlMoVc0ylU9YXm8fYo70FE1xKgIIhATxHXSw4m8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YGa7UvKqHhtw1gwprLSwoKMrorG0MgEtt9IB2+Q5kl5VYAiuiWDixV3halapxwByk
	 nGADSdYwuFXQFe59BiV3sfryFJdUFvjO3g27TahlrpNLcSWkatbonuw6523Kon5P78
	 OtAZpdc733aaW3oHMTTL4ArsCE0CEC/RANGZkBKA=
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
Subject: [PATCH 6.6 3206/3318] net/mlx4: always create the eth and ib auxiliary devices
Date: Wed, 18 Nov 2026 16:03:48 +0100
Message-ID: <20261118150455.929700117@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



