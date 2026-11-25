Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619266;
	b=p4aFDgHEB5fkRqQVf/Wck9Noc4XZ2uz28QcsncpgZFmxPqRPfscTo9RLF3QNwzdbkqM8
	 qYhGa1vR8SAeHUfif9u01AWxq+yd5M9VIM7tOuOCrQd56G0/vNa6paKtEUF3k2ntirns2
	 NZenmj3rClVPtuK/yhVNcorG+fS8e37CDlnV3yT7xccIMwJ9c9qfAEqTBawnqWfqbFetg
	 ugrlQ6CrauiPSalmT4rT4oVZZ2UqdgNGt/nj7vrODc/FZwvEUa0ATuU5GfcZJ+1olunl/
	 DI5A4SMw75DoEJ0Y5WUbW5vrkwYbHekw4x5zQwqxOnfV9pho0YJ8PscYkPFqs795kpA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619266;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=42/5iFvOzqUHIL4jYUBs5SAp4w2jxwHlP4Ia3HJONsU=;
	b=gY4jxiqsi33v87bjsDIZr9f3gw30Nl2SF0L7dBX37y+3ka8afPGNeHDqy+sO0xFNIOxi
	 KBRxMBt9De0mdDFkTy9OEJuk4xWHeSSQoPPvM91+/AUCW/H2kluHYjx0fQBym/RtBpZzd
	 TE7vI1JRXqGzudOqmgMAVOFQC+msfUghQCSTGVvZXF+d5eZlSRkLPDnzCfWQMnMAq3Guf
	 I452yMjmbszN/qp+z2qWEmajaPW9U9mjHPS0+xnqswl7KQ3V/BdnPdSSQ6thov6NsDqqk
	 nOX4tLs2SJSNUJ2cyESW8IRdclDIYHIV5ZSAAH+keJdS1Ij7vRuIkn516gpkPu1dikA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mfPUi0bI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F2B2606A32D;
	Wed, 25 Nov 2026 15:07:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mfPUi0bI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 659C61F000D1;
	Wed, 25 Nov 2026 15:07:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619265;
	bh=42/5iFvOzqUHIL4jYUBs5SAp4w2jxwHlP4Ia3HJONsU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mfPUi0bIJf5QiO8AbTH92S4W3Eqm+PXkuI7/0E/RzhOPUwZlIxCDu2eYQ7lIKuLQc
	 QaRg0nkcztf8IcRMwmCnqLSykm6Ltvb4Jln4ZN8a93tFV0L+vsDUQaehe+G/cz6Qwv
	 b30m6nsQHJUw6Pcl8xP09QXNxKK6QYAI/Tc1jFM4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Uri Dar <udar@nvidia.com>,
	Shay Drori <shayd@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Daniel Machon <daniel.machon@microchip.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0540/1005] net/mlx5: Lag, Return error when enabling MPESW without LAG support
Date: Wed, 25 Nov 2026 15:31:18 +0100
Message-ID: <20261125143834.395678892@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Uri Dar <udar@nvidia.com>

[ Upstream commit a532a7049ba23edeb2e16f7bb5929314f2e47ca0 ]

When firmware reports a function as not LAG capable (lag_master=0 or
num_lag_ports < 2), mlx5_lag_add_mdev() creates no LAG object for it.
Enabling multiport E-Switch on such a device returns 0 from
mlx5_lag_mpesw_queue_work(), so
"devlink dev param set ... esw_multiport value true" reports success
although nothing was enabled, and a following "devlink dev param show"
still reports false.

Return -EOPNOTSUPP instead. mlx5_lag_mpesw_disable() ignores the return
value, so disabling keeps its current behavior.

Fixes: a32327a3a02c ("net/mlx5: Lag, Control MultiPort E-Switch single FDB mode")
Signed-off-by: Uri Dar <udar@nvidia.com>
Reviewed-by: Shay Drori <shayd@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Daniel Machon <daniel.machon@microchip.com>
Link: https://patch.msgid.link/20261110114350.2639891-1-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c
index abf72026c7513..549d31812c2f9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c
@@ -227,7 +227,7 @@ static int mlx5_lag_mpesw_queue_work(struct mlx5_core_dev *dev,
 	int err = 0;
 
 	if (!ldev)
-		return 0;
+		return -EOPNOTSUPP;
 
 	work = kzalloc_obj(*work);
 	if (!work)
-- 
2.53.0



