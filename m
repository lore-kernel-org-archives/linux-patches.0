Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619107;
	b=kIavTxcVrrCOCZT04NU7SWYU48Maq5YtZZgMXDQTvK4ydoGDcojWHlTqae/mH6OsETn7
	 F3a9YQkqCWjOCFok4bk5kUhHIqMMxfu/iuLKPH1OC7Krras6eyywsv7QejOqhKqjtGSWI
	 Eg+95FtXsob/tA+wPMetdwJNJhDrfAlIeKoYr4Rx4DB+1+5tSeXbj9Okr/hGS+u8pRSy2
	 N7/pfx1dh5US5l7FdShfuLWfS5qs4PY53bbApms6C/09J+Zog388RJjqccClGnvVYAJsT
	 gELAF+Gy+scG9KoxUOg4hVh1Q/nIbxPdp8JD7DtDSPArQsRezR5R07iqPxVmo58keHg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619107;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=F1RjG2olC2n05ycsLfKZfdukTNfESHL8qpZKtW2VkqU=;
	b=Dp6FFM70zrVVrV2/fZzTtsQebI/zyDbYkDwvtQxDMffu11tfYL3C9KbW4vItq+15GStN
	 pEAT8oq8gPbF8bgPGDff7fUVsj6jUH6wsukqhEdUkeXUaljCfWO370Q9TpOMqaiynqXQy
	 EUb2lnD3/EewAfflrOqI5/zv1Io/9gCGqSTeRp9mAjMBB3/KEQuI1lQLg2yepvxXG1Tc/
	 P+zUdGCfmkv3VUxhBouVfsG+5i73xs2x8uJn4IUjsTDCNXugkcZ/hHR0gM+oI8vJaybS9
	 Vv2gRTe80OLp1R+gUuxef8ITvRdz6Wr2he2iLTs1Yyyz8Iwdrzx0T0bzKGjlVaVJoUw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=q3sCV9oU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5BA2606A321;
	Wed, 25 Nov 2026 15:05:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=q3sCV9oU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07E4E1F000C0;
	Wed, 25 Nov 2026 15:05:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619107;
	bh=F1RjG2olC2n05ycsLfKZfdukTNfESHL8qpZKtW2VkqU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q3sCV9oUmIqvv3ly3l4ZCLi/CElEydYmiQV8VC31YM+S9vzCUROjyvRDhM9x6be7J
	 v+lL+TRguieFBAw7Hza41fAN6Nk2eTTlrUrZ/GsGdJKuqblXjdKFvB1ZGI4bf1hNCx
	 PXlglvTDrLaRSFgCzGqu8wTo0Z6SCLgfKuvfbRIE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shay Drory <shayd@nvidia.com>,
	Moshe Shemesh <moshe@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0491/1005] net/mlx5: E-switch, Restore host PF enable for ECPF that isnt E-switch manager
Date: Wed, 25 Nov 2026 15:30:29 +0100
Message-ID: <20261125143833.249139552@linuxfoundation.org>
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

From: Shay Drory <shayd@nvidia.com>

[ Upstream commit 4777203cc9af51db5ae647920c14ee9451e783d7 ]

The cited commit breaks host PF enable_hca when the ECPF isn't E-switch
manager. For example, when the link layer is infiniband, the ECPF isn't
E-switch manager, so after the cited commit enable_hca is never issued
for the host PF, it stays in initializing state and fails to probe.

Fix it by checking esw_allowed() only for vport bookkeeping

Fixes: 0e6c95c98829 ("net/mlx5: Support devlink port state for host PF")
Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/20261104184756.773910-1-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/mellanox/mlx5/core/eswitch.c | 24 +++++++++----------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index fc197d1dc9dfe..603e8ae72734c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -1509,13 +1509,9 @@ int mlx5_esw_pf_enable_hca(struct mlx5_core_dev *dev, u16 vport_num)
 	struct mlx5_vport *vport;
 	int err;
 
-	if (!mlx5_core_is_ecpf(dev) || !mlx5_esw_allowed(esw))
+	if (!mlx5_core_is_ecpf(dev))
 		return 0;
 
-	vport = mlx5_eswitch_get_vport(esw, vport_num);
-	if (IS_ERR(vport))
-		return PTR_ERR(vport);
-
 	/* Once vport and representor are ready, take the PF out of
 	 * initializing state. Enabling HCA clears the iser->initializing
 	 * bit and PF driver loading can progress.
@@ -1524,7 +1520,11 @@ int mlx5_esw_pf_enable_hca(struct mlx5_core_dev *dev, u16 vport_num)
 	if (err)
 		return err;
 
-	vport->pf_activated = true;
+	if (mlx5_esw_allowed(esw)) {
+		vport = mlx5_eswitch_get_vport(esw, vport_num);
+		if (!IS_ERR(vport))
+			vport->pf_activated = true;
+	}
 
 	return 0;
 }
@@ -1535,18 +1535,18 @@ int mlx5_esw_pf_disable_hca(struct mlx5_core_dev *dev, u16 vport_num)
 	struct mlx5_vport *vport;
 	int err;
 
-	if (!mlx5_core_is_ecpf(dev) || !mlx5_esw_allowed(esw))
+	if (!mlx5_core_is_ecpf(dev))
 		return 0;
 
-	vport = mlx5_eswitch_get_vport(esw, vport_num);
-	if (IS_ERR(vport))
-		return PTR_ERR(vport);
-
 	err = mlx5_cmd_pf_disable_hca(dev, vport_num);
 	if (err)
 		return err;
 
-	vport->pf_activated = false;
+	if (mlx5_esw_allowed(esw)) {
+		vport = mlx5_eswitch_get_vport(esw, vport_num);
+		if (!IS_ERR(vport))
+			vport->pf_activated = false;
+	}
 
 	return 0;
 }
-- 
2.53.0



