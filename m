Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030025;
	b=2BnYTH/n8OBWpZfwYZK69sMybCcyAaQlJ7c34X1rdShfAL83eLP2wZ0jWFEd7SfWB3A6
	 lL6FZ6v01/mUlvjta0jZxfotqHISo7mdUozAshNtr49wIUKX7k3KEq16ikwLuNz3u1047
	 MEtMoM5l9C1+gox49t0+KyMoyZRqCiRBtIQ6uF7RdCMnG4ELWfzODuHKAkDUwzqS2VP7A
	 B2z7ktJom5eJ77JCvh8ZNgCfQ6Ff/ID5cqTiEIJxG8HHRc3q3qTF4/LwGk+tUgIas8Kq4
	 OneVJIyXE0yNqbFNCbGFjObGNYIS899cQ5FtcGpIOYhemwUdBzLZHpFbga+TYZlIp8Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030025;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0bGs/CXXMG3S3ldTsMeiteTdVOxCCnxridCEQ8cxOsM=;
	b=eOWCU72YZKKaKLlG6hpweBR3Je5UqSNrsJfvt4wN2vfy4y+2k3G1waE47inwCLgyINia
	 cQQoavdNEoTdkup4gExXGkRftRHMcQCn3p/cxbF4y0MeiOAaDxgdOv9kIaephSMcdEcuK
	 1GsyC0m97bptY/Y1nwGIp3a3ts37RWgiDFOkjIvvULOk8ZRTLAhRl1gXRRlwH0pGsIN+y
	 wbGGQcXNIocF0rXv564vpDMNSNLa8EbtH6+3dbpHLkFhwekDanl+SXdntEndYWX1GiR08
	 DsN/9w5u8gKvg4i7GknLCty5LDpXvDMXBSZ4yzjj8EmdjMk6xAKqDFaY1EPJrjFddDQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dciHakPk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8831B606A320;
	Wed, 18 Nov 2026 19:27:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dciHakPk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF37A1F000C4;
	Wed, 18 Nov 2026 19:27:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030025;
	bh=0bGs/CXXMG3S3ldTsMeiteTdVOxCCnxridCEQ8cxOsM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dciHakPkb+QD/OjhrMFjFbvducdJ3mwREsZr1YL7pO2otZUDMG4Mcl6YmVdNJBlCS
	 /8WdalKlNN6droM1aMekXB79DE7oSi2r+ZHK7YGYe/Hp5kYmSDkHmtI+MaL2mcaBiW
	 Ni7ksKEXcrSmvdf/l4MYCsckhMuB+b0rXf3aJ4Y4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0516/1756] RDMA/mlx5: Guard steering anchor resource destruction on create error
Date: Wed, 18 Nov 2026 15:44:03 +0100
Message-ID: <20261118150029.713811372@linuxfoundation.org>
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
index 520034acf73aa..186085cfb4e9b 100644
--- a/drivers/infiniband/hw/mlx5/fs.c
+++ b/drivers/infiniband/hw/mlx5/fs.c
@@ -2466,8 +2466,8 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_STEERING_ANCHOR_CREATE)(
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



