Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017030;
	b=EI6onOvIur27sdnIa8w12Cp32b7wNhN0Hfvo7DcHR0LmZEraT317RSegJFSXorytTkDp
	 M8vWE/AzJJcL/3FfsE14LWv6MMIsizvdJFpeFZKoD/itmOXANh6Sy8OpSUmv+kyoaWQ51
	 UQPvPgNRq+oQjrhYt34H970tC+yU+WCU4wrvPD2v30DIOJDPBgbjM24FQukiGdBteeZE4
	 CHJzDq26LI5B4fQLwOng3yGExsJDLdCAs6OsV32jlDg0TCK6GMPIND3JdKIgcQz1wcXZP
	 dST/f9bee16+Xi6VfadGCZMmWDko2iumFlGVc/d+NuTsxuW38MfQJC0cKRy9KF53t7w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017030;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oQo58fwJ8t4rsUF8c5WTYVxomyw0QlGQwS5x4xeQpek=;
	b=wtwkHr3bNZoLfW1uak8OHYLmZFKcHSNyck7zSmmwHQSzKLs4PmH9ZDpTp7+rgYfGeVOR
	 kK6G5cb2Tv5Dda5tcKevKr0MoWii/hnmWi/rJuolVwxoLDjdctRfG9Y3zNqK5qdboAlJE
	 BOltgDwMYvZdlVrUUR4FPN4l86XNJnDG6p78DYgPzb+P6UyZWp5adWuTdKJJTowYpuZUz
	 1KjbqXZOuR8JJkuv6TE4JcwIYd6TfD8HNNWTAECYBiQ28uT+FeuxVXIUmOv71BAs8w+pr
	 OJZ79Mxa5C5iAIfrk9H7maVmPWxIpvxnogf5Dxs/WtJJf9p0GjIfl6XgmX7rxzHkLRQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Y+oJLBOE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8535606A331;
	Wed, 18 Nov 2026 15:50:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Y+oJLBOE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1527B1F000C6;
	Wed, 18 Nov 2026 15:50:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017030;
	bh=oQo58fwJ8t4rsUF8c5WTYVxomyw0QlGQwS5x4xeQpek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y+oJLBOEvXmOMQNvDYfltfNaKubNpEBwESE4meI4+wzyLvDkK0wmjcaIs+gEi4mhG
	 ITHtQfnhCs0POpAvMkt1AOHrjOXEty/WWnyEtZG3AWk852yZvNvnZpeK84VVn2Nn21
	 bqw9n8SbaH//VuwiEK1W5rgx2/y7E0Y3kgaPsMDc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0699/2651] RDMA/mlx5: Guard steering anchor resource destruction on create error
Date: Wed, 18 Nov 2026 15:32:19 +0100
Message-ID: <20261118150312.998963626@linuxfoundation.org>
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
index b155baee0017c..98cdc5c571557 100644
--- a/drivers/infiniband/hw/mlx5/fs.c
+++ b/drivers/infiniband/hw/mlx5/fs.c
@@ -3056,8 +3056,8 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_STEERING_ANCHOR_CREATE)(
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



