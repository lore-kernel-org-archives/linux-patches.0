Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027786;
	b=Y001AFisrdUQpLLBE4WGvJr9tC0tkKQM8dekeYF1rCEB/SgOnVh6TNnJy0loUpCeg1vJ
	 enCDcATufce3V6TSP0SFCEfXbsOrQDB8oyc2dmnlAeYELW1HDUFcgkh7bfsYCxdwAudhR
	 FaKXGeuLqBhPquKIsqVaI04LjMo3bf/DbvC+GSWCUX7WuWwJcE0GlbQJABktzNRCb6tLn
	 i2xJH0rSCL+2o14uQf/iEs0wraPGqbmL1pbEF9hP7marSxFn2q0Nfn/QELL9tkzpz/kLs
	 Amk+EGmk8YqnVYEd+HgoG2Fzt8iFB2B6/X+MfVWK2ImEANv891xLWnZIBYcTs74h4mw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027786;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FY3thWeHE+hNktTjNGLjnXfYRQJ4F3Wiftjn/BIqpJM=;
	b=OVDhjX9ndsSsRfVK5BimD9CpLG5uxA3rsfYNyln7yesjbdEXV6NVNeefXpKPhto1FW2O
	 GQpIin8dwy279spX4eCb9KTiUpj9gYPRoYQJp+Of8BNWmwtbQZhPnyAvXnrFIyHAUBR3u
	 Y1I0n6IgOG/0w3hTcleSDsYMqmm4dCTx1aahqNuNDRGX8pkGV7yA3mZPPX8QSXKc0D77W
	 DFYfy1I6kO8gHp+Ith2SY7+8Wi4KYuqiplGPviC0LVgJUJ+eY8D5mj0myjFAARMKKZgUH
	 DPd0XtWRIGUXeM0CuR4/RhaOnwIe0owita8ChwISM42UMbg7Z2U/QIQsw0+WGlYdMFw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=msDgAZfr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8D26606A339;
	Wed, 18 Nov 2026 18:49:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=msDgAZfr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EF381F000C6;
	Wed, 18 Nov 2026 18:49:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027786;
	bh=FY3thWeHE+hNktTjNGLjnXfYRQJ4F3Wiftjn/BIqpJM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=msDgAZfrFGC5p4oXEnYx4fG1r88XhPiD465PbezQMTZ3qnsXSybKV5zCUBaO+/0EE
	 d7lc4rVGlCM6v7xNESYOWZs8t6H6eKfBHLdVFu6f1WDNXr9uMy6YnqW10EW+GyNGbU
	 yMlInSu2GPK1lSCpP7F0uxhUNoCWvDjeGx1vO3LM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Cassen <acassen@corp.free.fr>,
	Yevgeny Kliteynik <kliteyn@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1872/2151] net/mlx5: HWS, fix modify header pool match for copy actions
Date: Wed, 18 Nov 2026 16:00:07 +0100
Message-ID: <20261118150229.988114151@linuxfoundation.org>
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

From: Alexandre Cassen <acassen@corp.free.fr>

[ Upstream commit d425ec9bb9371d52d492ac4d09f0da6e26561684 ]

mlx5_fs_hws_mh_pool_match() compares a single dword of each action
since rules pass their values as arguments. Copy and add_field actions
keep their destination in the second dword and HWS reads them from the
pattern alone. Two modify headers whose copies differ only in
destination then share a pool and the second rule writes to the wrong
field.

Use the HWS core comparison that checks these actions in full.

Found while checking a Sashiko AI review report and confirmed against
the HWS pattern code. Not reproduced. No in-kernel user puts such
actions on the FDB but RDMA flow actions can. Tested for regressions on
ConnectX-7 with firmware 28.48.1000 on a little-endian host.

Fixes: b36315ca69cb ("net/mlx5: fs, add HWS modify header API function")
Signed-off-by: Alexandre Cassen <acassen@corp.free.fr>
Reviewed-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Link: https://patch.msgid.link/20261019133159.1742411-3-acassen@corp.free.fr
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../mellanox/mlx5/core/steering/hws/fs_hws_pools.c    | 11 ++++-------
 .../mellanox/mlx5/core/steering/hws/pat_arg.c         |  8 ++++----
 .../mellanox/mlx5/core/steering/hws/pat_arg.h         |  5 +++++
 3 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws_pools.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws_pools.c
index 839d71bd42164..f1ce03bdffe70 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws_pools.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws_pools.c
@@ -3,6 +3,7 @@
 
 #include <mlx5_core.h>
 #include "fs_hws_pools.h"
+#include "internal.h"
 
 #define MLX5_FS_HWS_DEFAULT_BULK_LEN 65536
 #define MLX5_FS_HWS_POOL_MAX_THRESHOLD BIT(18)
@@ -385,7 +386,7 @@ bool mlx5_fs_hws_mh_pool_match(struct mlx5_fs_pool *mh_pool,
 			       struct mlx5hws_action_mh_pattern *pattern)
 {
 	struct mlx5hws_action_mh_pattern *pool_pattern;
-	int num_actions, i;
+	int num_actions;
 
 	pool_pattern = mh_pool->pool_ctx;
 	if (WARN_ON_ONCE(!pool_pattern))
@@ -394,12 +395,8 @@ bool mlx5_fs_hws_mh_pool_match(struct mlx5_fs_pool *mh_pool,
 	if (pattern->sz != pool_pattern->sz)
 		return false;
 	num_actions = pattern->sz / MLX5_UN_SZ_BYTES(set_add_copy_action_in_auto);
-	for (i = 0; i < num_actions; i++) {
-		if ((__force __be32)pattern->data[i] !=
-		    (__force __be32)pool_pattern->data[i])
-			return false;
-	}
-	return true;
+	return mlx5hws_pat_compare_pattern(num_actions, pool_pattern->data,
+					   num_actions, pattern->data);
 }
 
 struct mlx5hws_action *mlx5_fc_get_hws_action(struct mlx5hws_context *ctx,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/pat_arg.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/pat_arg.c
index f5f7eebfb52de..8d08f6773b024 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/pat_arg.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/pat_arg.c
@@ -96,10 +96,10 @@ void mlx5hws_pat_uninit_pattern_cache(struct mlx5hws_pattern_cache *cache)
 	kfree(cache);
 }
 
-static bool mlx5hws_pat_compare_pattern(int cur_num_of_actions,
-					__be64 cur_actions[],
-					int num_of_actions,
-					__be64 actions[])
+bool mlx5hws_pat_compare_pattern(int cur_num_of_actions,
+				 __be64 cur_actions[],
+				 int num_of_actions,
+				 __be64 actions[])
 {
 	int i;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/pat_arg.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/pat_arg.h
index 7fbd8dc7aa186..2be7787104e10 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/pat_arg.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/pat_arg.h
@@ -49,6 +49,11 @@ int mlx5hws_pat_init_pattern_cache(struct mlx5hws_pattern_cache **cache);
 
 void mlx5hws_pat_uninit_pattern_cache(struct mlx5hws_pattern_cache *cache);
 
+bool mlx5hws_pat_compare_pattern(int cur_num_of_actions,
+				 __be64 cur_actions[],
+				 int num_of_actions,
+				 __be64 actions[]);
+
 bool mlx5hws_pat_verify_actions(struct mlx5hws_context *ctx, __be64 pattern[], size_t sz);
 
 int mlx5hws_arg_create(struct mlx5hws_context *ctx,
-- 
2.53.0



