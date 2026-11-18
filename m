Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022039;
	b=z8Yx3UVSmwgN/lXQKawYtMym/jaGBCDBmUh95XJrdShGGkOtMNTgh06Fs8bY9JKi4ipO
	 bDuBuW6FxZgAWskRiOHlCSFl6EY7EZ+eyBdn1Vs6VnVqWskBGZ1b+hrbdUUZeh2/Vuqjl
	 gaSGk/Y7Ol4WwAKaGo1+hg0UmNI6ozAFTfCl8cJmDzxEmXHCI3/Kcl/zQzz7E2O96/O9P
	 PPLUCatA7if6yVPM9kv4EJvTWF9JeqiBrvDvXGXGL8DDXHmVSnQ0yMxMtBMhvCYgStogr
	 w+4xYmndR/ZVf7KvTx6fIWwu44MM3NtDmW7dWIs2tiFlgG3kyrCZ3G4Ka+1ycxCBqkw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022039;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/JOnQIm6SP7ZTFe1zJGicgTM9X/KdIKBFgH57vt3/1Y=;
	b=s1Z58lhOHGi6C74EPQaDAxRF8BXjOXUvh9L38df1900UuicHwwjjwc4DMSrrGZnU/zNX
	 Jf/HZr4ClIanMtob4sgolVZuT3bNeRykeCRQMjVIl9zOyQpez98JFgC6HObVMjJD3B/et
	 cdBqbuEOB/L8jxiwhKcotSyk8hzmB/sXDv9RLL8jX3An6BI23dhTf6VKJagkI5DcHEkCe
	 7rmnwYB/vecJlaX6+pEwanErlAMZhNZ/EN4ahfBbdz/Pu7cIX/fB1AUi4/htbeUSV4siU
	 6bGSY56DzbU4v0jEatTyovGbp4JTkohSlW61Q95YIj2HiYERWqKf0VVGBsQ0AgjA/Qg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QBVb+q5X;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CFF4606A332;
	Wed, 18 Nov 2026 17:13:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QBVb+q5X
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BC751F000C4;
	Wed, 18 Nov 2026 17:13:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022039;
	bh=/JOnQIm6SP7ZTFe1zJGicgTM9X/KdIKBFgH57vt3/1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QBVb+q5XwifvLW9sEButif9T42Mb8zl2FW/9BmxgQsUCEuWcC3o91A0k5rAbUL7jQ
	 wtPpz+YfOdFiCCfzFmnRDMuHA+Eode6hhBfqQJ1KHI3DKXTv4xXChYVNDQfOLfvH3k
	 WrZ5uSE1iMGFUwws6fEYSteLnzTY+qOYS5PIpPGU=
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
Subject: [PATCH 7.3 2520/2651] net/mlx4: always create the eth and ib auxiliary devices
Date: Wed, 18 Nov 2026 16:02:40 +0100
Message-ID: <20261118150415.406729866@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 82e467c45d231..31860b4abe43f 100644
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



