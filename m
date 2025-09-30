Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4DB623506A;
	Tue, 30 Sep 2025 15:04:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244676; cv=none; b=iHWwApAKcmePUY97w9a8yQuSGiihpxYstqJif6v1kEXQHXH1q02r4kES94lRne8kQYDBRbF88sFRez/N8n5OYBS431WPRCs2SsyXH6pgMOVOuwE7eKM2y5Ofs+NYMzoqrk6ZRN8/+bLrZHzn+ruVncOybTn+Nmmd8/rojRRDCGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244676; c=relaxed/simple;
	bh=/0JoDeLLbUC24cblWDyvzxISn9L97AxLhmqL4OVPmlg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c01Y2LzWD/XRKVy+g2OTZSaqZ5BH8HDl/o+T2jlVb+epC/nsoOkERH9jJNWO0troFLNRNH+2oRnVa8rydk25BXNkbo3f/OD23W5/sTEO22Ubl7FASCQA/Saz7QiTWbGvMKSzqSzhRSA0ju+WhJSuv5y0k77g9zjMcor9BQGPZGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HNmJOsET; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HNmJOsET"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31A3DC113D0;
	Tue, 30 Sep 2025 15:04:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244676;
	bh=/0JoDeLLbUC24cblWDyvzxISn9L97AxLhmqL4OVPmlg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HNmJOsETB/MpD0c0eEyAJHBK0Cxi22DmqRCoZz5UP0eL5OMJrwLbFHrysglbqs7Z8
	 3aLBWU2VUIzdFOyBAeG/jz7xMkhYDazTAoh8/6IraV3pHsw9lne3zIcSzvR1lnuur6
	 IwOBwy669UqTZ1GCAohEni9IaCKPi3m2XuAHtdq8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vlad Dogaru <vdogaru@nvidia.com>,
	Yevgeny Kliteynik <kliteyn@nvidia.com>,
	Simon Horman <horms@kernel.org>,
	Mark Bloch <mbloch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 080/143] net/mlx5: HWS, remove unused create_dest_array parameter
Date: Tue, 30 Sep 2025 16:46:44 +0200
Message-ID: <20250930143834.426545264@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143831.236060637@linuxfoundation.org>
References: <20250930143831.236060637@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Vlad Dogaru <vdogaru@nvidia.com>

[ Upstream commit 60afb51c89414b3d0061226415651f29a7eaf932 ]

`flow_source` is not used anywhere in mlx5hws_action_create_dest_array.

Signed-off-by: Vlad Dogaru <vdogaru@nvidia.com>
Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Mark Bloch <mbloch@nvidia.com>
Link: https://patch.msgid.link/20250703185431.445571-2-mbloch@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: efb877cf27e3 ("net/mlx5: HWS, ignore flow level for multi-dest table")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../mellanox/mlx5/core/steering/hws/action.c      |  7 ++-----
 .../mellanox/mlx5/core/steering/hws/fs_hws.c      | 15 ++++++---------
 .../mellanox/mlx5/core/steering/hws/mlx5hws.h     |  8 ++------
 3 files changed, 10 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/action.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/action.c
index 8e4a085f4a2ec..6b36a4a7d895f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/action.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/action.c
@@ -1358,12 +1358,9 @@ mlx5hws_action_create_modify_header(struct mlx5hws_context *ctx,
 }
 
 struct mlx5hws_action *
-mlx5hws_action_create_dest_array(struct mlx5hws_context *ctx,
-				 size_t num_dest,
+mlx5hws_action_create_dest_array(struct mlx5hws_context *ctx, size_t num_dest,
 				 struct mlx5hws_action_dest_attr *dests,
-				 bool ignore_flow_level,
-				 u32 flow_source,
-				 u32 flags)
+				 bool ignore_flow_level, u32 flags)
 {
 	struct mlx5hws_cmd_set_fte_dest *dest_list = NULL;
 	struct mlx5hws_cmd_ft_create_attr ft_attr = {0};
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.c
index 47e3947e7b512..131e74b2b7743 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.c
@@ -572,14 +572,12 @@ static void mlx5_fs_put_dest_action_sampler(struct mlx5_fs_hws_context *fs_ctx,
 static struct mlx5hws_action *
 mlx5_fs_create_action_dest_array(struct mlx5hws_context *ctx,
 				 struct mlx5hws_action_dest_attr *dests,
-				 u32 num_of_dests, bool ignore_flow_level,
-				 u32 flow_source)
+				 u32 num_of_dests, bool ignore_flow_level)
 {
 	u32 flags = MLX5HWS_ACTION_FLAG_HWS_FDB | MLX5HWS_ACTION_FLAG_SHARED;
 
 	return mlx5hws_action_create_dest_array(ctx, num_of_dests, dests,
-						ignore_flow_level,
-						flow_source, flags);
+						ignore_flow_level, flags);
 }
 
 static struct mlx5hws_action *
@@ -1016,7 +1014,6 @@ static int mlx5_fs_fte_get_hws_actions(struct mlx5_flow_root_namespace *ns,
 		}
 		(*ractions)[num_actions++].action = dest_actions->dest;
 	} else if (num_dest_actions > 1) {
-		u32 flow_source = fte->act_dests.flow_context.flow_source;
 		bool ignore_flow_level;
 
 		if (num_actions == MLX5_FLOW_CONTEXT_ACTION_MAX ||
@@ -1026,10 +1023,10 @@ static int mlx5_fs_fte_get_hws_actions(struct mlx5_flow_root_namespace *ns,
 		}
 		ignore_flow_level =
 			!!(fte_action->flags & FLOW_ACT_IGNORE_FLOW_LEVEL);
-		tmp_action = mlx5_fs_create_action_dest_array(ctx, dest_actions,
-							      num_dest_actions,
-							      ignore_flow_level,
-							      flow_source);
+		tmp_action =
+			mlx5_fs_create_action_dest_array(ctx, dest_actions,
+							 num_dest_actions,
+							 ignore_flow_level);
 		if (!tmp_action) {
 			err = -EOPNOTSUPP;
 			goto free_actions;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/mlx5hws.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/mlx5hws.h
index a2fe2f9e832d2..32d7d75bc6daf 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/mlx5hws.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/mlx5hws.h
@@ -728,18 +728,14 @@ mlx5hws_action_create_push_vlan(struct mlx5hws_context *ctx, u32 flags);
  * @dests: The destination array. Each contains a destination action and can
  *	   have additional actions.
  * @ignore_flow_level: Whether to turn on 'ignore_flow_level' for this dest.
- * @flow_source: Source port of the traffic for this actions.
  * @flags: Action creation flags (enum mlx5hws_action_flags).
  *
  * Return: pointer to mlx5hws_action on success NULL otherwise.
  */
 struct mlx5hws_action *
-mlx5hws_action_create_dest_array(struct mlx5hws_context *ctx,
-				 size_t num_dest,
+mlx5hws_action_create_dest_array(struct mlx5hws_context *ctx, size_t num_dest,
 				 struct mlx5hws_action_dest_attr *dests,
-				 bool ignore_flow_level,
-				 u32 flow_source,
-				 u32 flags);
+				 bool ignore_flow_level, u32 flags);
 
 /**
  * mlx5hws_action_create_insert_header - Create insert header action.
-- 
2.51.0



