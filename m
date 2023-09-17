Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84A476FCC
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 19:51:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E273DC433C8;
	Sun, 17 Sep 2023 19:51:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694980289;
	bh=sNBXR5k+6ue0LN93lWqKy3yiL1YOjcjrvS+k3reJuNA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wLJ5wWqxCh+20waQakHYa/Dxe69z/Wm4DKV8TaM3fhaM33w1NLV4ohbZZd0r90uqV
	 TKteJWqc80bPTqbskuisU/TgxCpOBoHIrnAiSGACOEng3+x6ToQ1Ev968/RAS12xBk
	 RI+/rc9r3b+x1Omu5Pp/ZcgMwEeaZTNJN/E7N+4w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Pirko <jiri@nvidia.com>,
	Shay Drory <shayd@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 149/285] net/mlx5: Give esw_offloads_load/unload_rep() "mlx5_" prefix
Date: Sun, 17 Sep 2023 21:12:29 +0200
Message-ID: <20230917191056.846715907@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191051.639202302@linuxfoundation.org>
References: <20230917191051.639202302@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Pirko <jiri@nvidia.com>

[ Upstream commit 9eca8bb8da4385b02bd02b6876af8d4225bf4713 ]

As esw_offloads_load/unload_rep() are used outside eswitch.c it is nicer
for them to have "mlx5_" prefix. Add it.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Shay Drory <shayd@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Stable-dep-of: 344134609a56 ("mlx5/core: E-Switch, Create ACL FT for eswitch manager in switchdev mode")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c      |  4 ++--
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h      |  4 ++--
 .../net/ethernet/mellanox/mlx5/core/eswitch_offloads.c | 10 +++++-----
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index 243c455f10297..85ddf6f7e37df 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -1078,7 +1078,7 @@ int mlx5_eswitch_load_vport(struct mlx5_eswitch *esw, u16 vport_num,
 	if (err)
 		return err;
 
-	err = esw_offloads_load_rep(esw, vport_num);
+	err = mlx5_esw_offloads_load_rep(esw, vport_num);
 	if (err)
 		goto err_rep;
 
@@ -1091,7 +1091,7 @@ int mlx5_eswitch_load_vport(struct mlx5_eswitch *esw, u16 vport_num,
 
 void mlx5_eswitch_unload_vport(struct mlx5_eswitch *esw, u16 vport_num)
 {
-	esw_offloads_unload_rep(esw, vport_num);
+	mlx5_esw_offloads_unload_rep(esw, vport_num);
 	mlx5_esw_vport_disable(esw, vport_num);
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index ae0dc8a3060d7..040ed6d79258f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -725,8 +725,8 @@ void mlx5_esw_set_spec_source_port(struct mlx5_eswitch *esw,
 				   u16 vport,
 				   struct mlx5_flow_spec *spec);
 
-int esw_offloads_load_rep(struct mlx5_eswitch *esw, u16 vport_num);
-void esw_offloads_unload_rep(struct mlx5_eswitch *esw, u16 vport_num);
+int mlx5_esw_offloads_load_rep(struct mlx5_eswitch *esw, u16 vport_num);
+void mlx5_esw_offloads_unload_rep(struct mlx5_eswitch *esw, u16 vport_num);
 
 int mlx5_esw_offloads_rep_load(struct mlx5_eswitch *esw, u16 vport_num);
 void mlx5_esw_offloads_rep_unload(struct mlx5_eswitch *esw, u16 vport_num);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index e59380ee1ead3..1eb49784c0e11 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -2424,7 +2424,7 @@ void mlx5_esw_offloads_rep_unload(struct mlx5_eswitch *esw, u16 vport_num)
 		__esw_offloads_unload_rep(esw, rep, rep_type);
 }
 
-int esw_offloads_load_rep(struct mlx5_eswitch *esw, u16 vport_num)
+int mlx5_esw_offloads_load_rep(struct mlx5_eswitch *esw, u16 vport_num)
 {
 	int err;
 
@@ -2448,7 +2448,7 @@ int esw_offloads_load_rep(struct mlx5_eswitch *esw, u16 vport_num)
 	return err;
 }
 
-void esw_offloads_unload_rep(struct mlx5_eswitch *esw, u16 vport_num)
+void mlx5_esw_offloads_unload_rep(struct mlx5_eswitch *esw, u16 vport_num)
 {
 	if (esw->mode != MLX5_ESWITCH_OFFLOADS)
 		return;
@@ -3355,7 +3355,7 @@ int esw_offloads_enable(struct mlx5_eswitch *esw)
 			vport->info.link_state = MLX5_VPORT_ADMIN_STATE_DOWN;
 
 	/* Uplink vport rep must load first. */
-	err = esw_offloads_load_rep(esw, MLX5_VPORT_UPLINK);
+	err = mlx5_esw_offloads_load_rep(esw, MLX5_VPORT_UPLINK);
 	if (err)
 		goto err_uplink;
 
@@ -3366,7 +3366,7 @@ int esw_offloads_enable(struct mlx5_eswitch *esw)
 	return 0;
 
 err_vports:
-	esw_offloads_unload_rep(esw, MLX5_VPORT_UPLINK);
+	mlx5_esw_offloads_unload_rep(esw, MLX5_VPORT_UPLINK);
 err_uplink:
 	esw_offloads_steering_cleanup(esw);
 err_steering_init:
@@ -3404,7 +3404,7 @@ static int esw_offloads_stop(struct mlx5_eswitch *esw,
 void esw_offloads_disable(struct mlx5_eswitch *esw)
 {
 	mlx5_eswitch_disable_pf_vf_vports(esw);
-	esw_offloads_unload_rep(esw, MLX5_VPORT_UPLINK);
+	mlx5_esw_offloads_unload_rep(esw, MLX5_VPORT_UPLINK);
 	esw_set_passing_vport_metadata(esw, false);
 	esw_offloads_steering_cleanup(esw);
 	mapping_destroy(esw->offloads.reg_c0_obj_pool);
-- 
2.40.1



