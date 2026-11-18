Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021542;
	b=p+yuJa0WZLOh0F2IgFu3SiULR39FTu1rbm58xN814xFZSBmIsTp2d5XsVYvc6GuVdTwv
	 jYvx4YJZG3Q5TsfXw10k/3jAViazIS65p+ZSgJoN5XKEQEJz9xTIvloacz4GoZxXuldWz
	 tkCn1IOARmlzyBbeyQm6+V45K7sZZj599cp+krjhOZrsW4pwFXsHm8YsTK+R+2+aalOTb
	 dVhsoFYxcbX0iDZY3GXC6KEPplH7B9XwsfefiULM+CAHspoEytY0hEAx5S0wdIqc2XusJ
	 4DeRR99iZjRTMFWfuonoRWri7YgqjhSqxP4udZVWPf9gOT5EKxRxj89hxw2GPzfiIGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021542;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2Cxhu32QqW84U6UdDBQhvttj99q7IPZujCgbMLWP2SQ=;
	b=eNn58YMeP2xIFCyS7RPIS/Q344X7pxUZ6M2waZ6ZNW3ibgwuqjJ4NYkVolrNae3i2oXa
	 /itsGu1gyrjrNEpMmBz1vVgJlZr9JkRoTxNwpDpy7NdI92hbKRYQ+LlX0JveMKTNeSx0H
	 a+QZxH4fwV9GK56eLM9ihCF5sZpvmpbgLrL28QZpbjYqW/equQwfbAm9plQM11+C14pqp
	 gmH/yI2J8+UCw8hq6d3i1OK4KJsc1+3a/CkRcddg4D9HIZH7gOlFCO0Z2RWpmf7wSwZuL
	 gX8o3IjSPrcQtRpmyy6IPTM6q1xgemlFavU4tptwIICIF0McyswGS8r7s+6H34nY+iQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WRVs8TTd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C0C1606A31C;
	Wed, 18 Nov 2026 17:05:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WRVs8TTd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CC571F000C6;
	Wed, 18 Nov 2026 17:05:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021541;
	bh=2Cxhu32QqW84U6UdDBQhvttj99q7IPZujCgbMLWP2SQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WRVs8TTdGMs4bTOkkibzkKKy2quKVULYa0kG2oh5DZMu65liGLwBvF5geEsyJ1W+q
	 1q2KWnFkxS+WEUJ0Le+Kj3CynBcKgRMoeXdkcbrMAWnWrLOCaSybjGgL5d7krPGwtU
	 k0Lka9OiVPwhvMDxTlfqtt3OsJEYu71yOuE8DyPk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cosmin Ratiu <cratiu@nvidia.com>,
	Carolina Jubran <cjubran@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2344/2651] net/mlx5e: Stop asserting for RTNL when closing channels
Date: Wed, 18 Nov 2026 15:59:44 +0100
Message-ID: <20261118150409.469769497@linuxfoundation.org>
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

From: Cosmin Ratiu <cratiu@nvidia.com>

[ Upstream commit e0a958ddfc89f2e1c43448cdaeb5b30e54e19448 ]

mlx5e_close_channels() has an ASSERT_RTNL() from the time when RTNL was
required for closing channels.
But the driver has been switched to using the netdev lock a while back,
and this fired from a flow which was forgotten during the conversion:

mlx5e_tx_timeout_work()
  -> mlx5e_reporter_tx_timeout()
  -> mlx5e_health_report()
  -> mlx5e_tx_reporter_timeout_recover()
  -> mlx5e_safe_reopen_channels()
  -> mlx5e_safe_switch_params()
  -> mlx5e_close_channels()

The RTNL is not acquired here, but the netdev lock is, and it is enough.

Rather than switching to netdev_assert_locked(), simply drop the assert.
Upper layers (networking core, ethtool core) provide locking and lower
layers (NAPI helpers) assert that the netdev lock is held.

Fixes: 8f7b00307bf1 ("net/mlx5e: Convert mlx5 netdevs to instance locking")
Signed-off-by: Cosmin Ratiu <cratiu@nvidia.com>
Reviewed-by: Carolina Jubran <cjubran@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Acked-by: Stanislav Fomichev <sdf@fomichev.me>
Link: https://patch.msgid.link/20261020153659.3440902-1-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 4c6060d54fbed..38ce7d0a9001e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -3075,7 +3075,6 @@ void mlx5e_close_channels(struct mlx5e_channels *chs)
 {
 	int i;
 
-	ASSERT_RTNL();
 	if (chs->ptp) {
 		mlx5e_ptp_close(chs->ptp);
 		chs->ptp = NULL;
-- 
2.53.0



