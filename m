Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024164;
	b=J6PuMNb2JKJX6eJC3+bFflsm6xlAQfQgt39rLhtGRPeS/qu1qrcwWsIyiPf+v/tI1Y4n
	 q2hX7JgRJ0BqT7Qp67JTHIFtVmbz1bp+k5uPEhu6laI/J61rixz4o1ay+PrzQcluPW85G
	 RAgvAoQHPwP0XugYuKOKgWxpnez+hcS7FxkBKlJ6/cxbhW8UWHjMn2Snn88LT0Njd1P77
	 NyOYOFV2XXQYwn78K0JqYcjFI+7Egw8xH6dedNg9j8isrd4yE2PeUGQ3Nfotzk85NN9J9
	 jbmM8DkHTe6v+bSImhQLinzSe99ERjrOYJlw8s/IF6RyHGScaPgmlSWhEmKKdPErgIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024164;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=O3arX2Cqo03Sj/7K3sucLBoOhcPbMG5wFC6/V6dznlk=;
	b=vOd9yPPUTzp277YfteNC6x+tUR1eB1jVbBdqTTs0pqQFaWv/LlPOU5XgxQHDpl4zTNX7
	 n3i/VaXCGem0rK6rE3LUyx9Lx0qG5PMAE3r7zr2P1ER2wUy5hC4ak5y3WVI4FDiTigWnj
	 +5yc0djQDIPCRJTvzN6elxWodjSdR1gCjFbM3XzUj1HKCAjs9v7tZ0DfLYXZcfOsC3ST+
	 0muSbgU+PolTUQ0WY8wpq972vLDjmyqzM2p53zQDw09gMVbpQwR+xUUdJ1UtEpFMBS030
	 NIvxzCBbEh64DnQQ0xGzQe4xYx5bFq3DeZBCqtVSMASOIUP0y9fnyOcK0Lc+VYsiieA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I+SKeXyz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6F50606A31C;
	Wed, 18 Nov 2026 17:49:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I+SKeXyz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47B221F000C4;
	Wed, 18 Nov 2026 17:49:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024163;
	bh=O3arX2Cqo03Sj/7K3sucLBoOhcPbMG5wFC6/V6dznlk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I+SKeXyzcl0Tcv7WgjlLKGuqGUVMjI8Pk8L9GrAFX+qtyORsLMjbkJ+B9Kf/kCGO0
	 k7rzqJubz6RehE4B5qHJfCmqwRk78CmqRQ4M85ZmFSMCcpWQgaSEhMIMzSWyN6df8Y
	 VgdmfwSwM3VBG7TwR0ymGPwFbtxcDzJZCsN+GsW0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0628/2151] RDMA/mlx5: Guard steering anchor resource destruction on create error
Date: Wed, 18 Nov 2026 15:39:23 +0100
Message-ID: <20261118150144.773096863@linuxfoundation.org>
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

From: Li RongQing <lirongqing@baidu.com>

[ Upstream commit 193aaf5b57f05d9f0403cfdaff3eda3b8d11ec13 ]

The steering anchor resources are shared between anchors with the same
priority and are protected by rule_goto_table_ref.

When steering anchor creation succeeds but uverbs_copy_to() fails, the
error path drops the reference acquired for the new anchor. However, it
unconditionally calls mlx5_steering_anchor_destroy_res(), even when
other anchors are still using the shared resources.

This can destroy the shared flow table, flow groups, and rules while
existing anchors still hold references to them, resulting in a
use-after-free when those anchors are subsequently cleaned up.

Only destroy the shared resources when dropping the reference makes
rule_goto_table_ref zero, consistent with the existing cleanup path.

Fixes: e1f4a52ac171 ("RDMA/mlx5: Create an indirect flow table for steering anchor")
Signed-off-by: Li RongQing <lirongqing@baidu.com>
Link: https://patch.msgid.link/20260917085419.1792-1-lirongqing@baidu.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/fs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/fs.c b/drivers/infiniband/hw/mlx5/fs.c
index b0f7663c24c1e..5739d763029bd 100644
--- a/drivers/infiniband/hw/mlx5/fs.c
+++ b/drivers/infiniband/hw/mlx5/fs.c
@@ -3041,8 +3041,8 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_STEERING_ANCHOR_CREATE)(
 	return 0;
 
 destroy_res:
-	--ft_prio->anchor.rule_goto_table_ref;
-	mlx5_steering_anchor_destroy_res(ft_prio);
+	if (!--ft_prio->anchor.rule_goto_table_ref)
+		mlx5_steering_anchor_destroy_res(ft_prio);
 put_flow_table:
 	put_flow_table(dev, ft_prio, true);
 free_obj:
-- 
2.53.0



