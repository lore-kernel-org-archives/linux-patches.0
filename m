Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2990F31DDBC;
	Tue, 26 Aug 2025 11:34:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208090; cv=none; b=L28oMwLmtUrFSeC/HGR6aug3LDmcPfGW77orc9ERRHUdkFv20qYgHif+6EzQPlktyLgxnTXfftliJAyZfqCDOGU9juT3s5ligL/wtSjt3LD7XQ2jgvdSNEvDdDXJXvrGLMcRek04H/Ej6LMAiX4Lt32LytxP0mXbN6frS3AeywU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208090; c=relaxed/simple;
	bh=hIE7D3tHYKORnISV02+ERWVePivWc5dGGjDm21vF63w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ay8VpBVETO0oe/x2T/JZxBG9kz0SVCdhowJP4+dKLYVhH1wPJwBFk+fDVEuaytI90bmOo3oZB3c3kcTy4EygjWEwhmnKB+DNXRjBpCdfWkcr5dQ69fjoMMkx57AyuvME2t8DLZuzImT5YEGq0H2eCk9wDpTKGEutpZxNGtqdCwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MrN8V2Za; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MrN8V2Za"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA4D8C4CEF1;
	Tue, 26 Aug 2025 11:34:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208090;
	bh=hIE7D3tHYKORnISV02+ERWVePivWc5dGGjDm21vF63w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MrN8V2ZaF5ufAxS9RtNZYnwhwTAM4HtoGR6dPFQR8rLeKpaCLkTZkqgx2SqhXJh0B
	 tmzU8CHx5Tmlb80xYfj3Afojj6RjZcyAL3d9hS21mCwFw7Zai6fapzsLBQrcg0wegU
	 DePDI8FiFbLNBFx7QdVzHlwd8fkDR+WFmLt53OQE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yevgeny Kliteynik <kliteyn@nvidia.com>,
	Vlad Dogaru <vdogaru@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 416/457] net/mlx5: HWS, fix bad parameter in CQ creation
Date: Tue, 26 Aug 2025 13:11:40 +0200
Message-ID: <20250826110947.574914967@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

[ Upstream commit 2462c1b9217246a889ec318b3894d84e4dd709c6 ]

'cqe_sz' valid value should be 0 for 64-byte CQE.

Fixes: 2ca62599aa0b ("net/mlx5: HWS, added send engine and context handling")
Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Vlad Dogaru <vdogaru@nvidia.com>
Signed-off-by: Mark Bloch <mbloch@nvidia.com>
Link: https://patch.msgid.link/20250817202323.308604-2-mbloch@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/steering/hws/send.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/send.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/send.c
index c4b22be19a9b..b0595c9b09e4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/send.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/send.c
@@ -964,7 +964,6 @@ static int hws_send_ring_open_cq(struct mlx5_core_dev *mdev,
 		return -ENOMEM;
 
 	MLX5_SET(cqc, cqc_data, uar_page, mdev->priv.uar->index);
-	MLX5_SET(cqc, cqc_data, cqe_sz, queue->num_entries);
 	MLX5_SET(cqc, cqc_data, log_cq_size, ilog2(queue->num_entries));
 
 	err = hws_send_ring_alloc_cq(mdev, numa_node, queue, cqc_data, cq);
-- 
2.50.1



