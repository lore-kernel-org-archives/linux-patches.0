Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624995;
	b=TfwtneKrR4Erg92NrRO71jDC95VUeVpqMeb8XRe1CG/H5BMnd7xgb1RKHfxSqUo0VEnp
	 adMJ5shrNRifXtmxkKiKuuokpstYRAvyJdxL77MHSMce+exeioJpQ5yrQX2nTpszv5mg6
	 cCJUhkYjEcgUHFGPZnbKuIf0RYtWA/unJmCw5e4tT81OKH909KwWWDHplJlrifQdCrSWJ
	 cbjXeBOsfwhQ+AKlEnwZyZOwnAk27Tfgq3W6u8K5KvQN0Uy/4c6LxKxOJMRfdwHWGlugT
	 rxpi7DXPXBqn9CeE6B6IQHqqk54doTCj/BSFjlUXrdTHC0NZXN2I/xImSMa9HdOnmfg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624995;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ncz8Fe/5Kk85A1OothaAv//e0FlcFKRPTzdrIpF+evo=;
	b=JEo4taUPWIUGJJeU67+qdFwZ1p8jQRA76aMX80NQT0HPe3+0M/QqBfOWNW1GpLYdJs0g
	 pvWoQyljWF7XwD61onFSJt6afH6eq16+bdwLZh2UHp21BkcuIKFv/oyvTo+NiBNx9CWPq
	 dw8p2XPan1YKGNovlWmm7Cu37CcwuRTqY+q8cCTdTx2XSQc084bBaY/FLnREp3mj7iKL9
	 bC8v9WQEfYB7g/gycrgY+zSEU/hbZiWDEYGSP9kDcXb8oCtGnaJinD0ENle+HMl8YuboZ
	 v1yCffc3p3EsTyjZfgVfuKwL2zHfMlo0Izctnd8sShHhOIdUYlJANos/1pMYbUvIpPA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KGCymt3A;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7222606A31E;
	Wed, 25 Nov 2026 16:43:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KGCymt3A
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC5BB1F000D1;
	Wed, 25 Nov 2026 16:43:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624995;
	bh=ncz8Fe/5Kk85A1OothaAv//e0FlcFKRPTzdrIpF+evo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KGCymt3Afs3/XxFo/fCjGCsFTBmk1TIsnQCV8XgJPjeOe5UgpSWtFdf4n9ZsgcZ78
	 x9GoXgOB9xh9fqEbN88SWRjPbd8akH20pJbqxsj5tISu9PLg9+W10CffsuKm3lvirf
	 5UMn3cEtWrfEeAowS5tXy5aFOvaoClGNJf0fwJa8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Changyul Lee <lcy8047@gmail.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 327/816] net/mlx5: macsec: Dont remove fs_id when adding a rule fails
Date: Wed, 25 Nov 2026 15:31:15 +0100
Message-ID: <20261125143856.770085181@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

From: Changyul Lee <lcy8047@gmail.com>

[ Upstream commit 5175da73dd128520ad6d704d7fe54926ee5f658b ]

macsec_fs_tx_add_rule() and macsec_fs_rx_add_rule() clean up a failed
rule with macsec_fs_{tx,rx}_del_rule(), which also calls
macsec_fs_id_del(). The fs_id is never in the xarray at that point:
macsec_fs_id_add() is the last step of adding a rule and removes its
own entry when it fails.

macsec_fs_id_del() then dereferences NULL, through macsec_device for
the first SA of a MACsec netdev and through fs_id_found otherwise. On
RX, the SAs of one SC share an fs_id, so a failure while adding another
SA drops the reference that an existing SA holds.

Split the rule teardown from the fs_id removal and do only the teardown
on the error paths.

Fixes: d4ece08f4b1d ("net/mlx5: Maintain fs_id xarray per MACsec device inside macsec steering")
Signed-off-by: Changyul Lee <lcy8047@gmail.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/20261105003419.4016283-1-lcy8047@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../mellanox/mlx5/core/lib/macsec_fs.c        | 38 ++++++++++++-------
 1 file changed, 24 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/macsec_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/macsec_fs.c
index 3d2473d9f3eac..41cf27867fa85 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/macsec_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/macsec_fs.c
@@ -768,13 +768,9 @@ static int macsec_fs_id_add(struct list_head *macsec_devices_list, u32 fs_id,
 	return err;
 }
 
-static void macsec_fs_tx_del_rule(struct mlx5_macsec_fs *macsec_fs,
-				  struct mlx5_macsec_tx_rule *tx_rule,
-				  void *macdev)
+static void macsec_fs_tx_free_rule(struct mlx5_macsec_fs *macsec_fs,
+				   struct mlx5_macsec_tx_rule *tx_rule)
 {
-	macsec_fs_id_del(&macsec_fs->macsec_devices_list, tx_rule->fs_id, macdev,
-			 &macsec_fs->sci_hash, true);
-
 	if (tx_rule->rule) {
 		mlx5_del_flow_rules(tx_rule->rule);
 		tx_rule->rule = NULL;
@@ -795,6 +791,15 @@ static void macsec_fs_tx_del_rule(struct mlx5_macsec_fs *macsec_fs,
 	macsec_fs_tx_ft_put(macsec_fs);
 }
 
+static void macsec_fs_tx_del_rule(struct mlx5_macsec_fs *macsec_fs,
+				  struct mlx5_macsec_tx_rule *tx_rule,
+				  void *macdev)
+{
+	macsec_fs_id_del(&macsec_fs->macsec_devices_list, tx_rule->fs_id, macdev,
+			 &macsec_fs->sci_hash, true);
+	macsec_fs_tx_free_rule(macsec_fs, tx_rule);
+}
+
 #define MLX5_REFORMAT_PARAM_ADD_MACSEC_OFFSET_4_BYTES 1
 
 static union mlx5_macsec_rule *
@@ -887,7 +892,7 @@ macsec_fs_tx_add_rule(struct mlx5_macsec_fs *macsec_fs,
 	goto out_spec;
 
 err:
-	macsec_fs_tx_del_rule(macsec_fs, tx_rule, macsec_ctx->secy->netdev);
+	macsec_fs_tx_free_rule(macsec_fs, tx_rule);
 	macsec_rule = NULL;
 out_spec:
 	kvfree(spec);
@@ -1652,15 +1657,11 @@ static void macsec_fs_rx_ft_put(struct mlx5_macsec_fs *macsec_fs)
 	macsec_fs_rx_destroy(macsec_fs);
 }
 
-static void macsec_fs_rx_del_rule(struct mlx5_macsec_fs *macsec_fs,
-				  struct mlx5_macsec_rx_rule *rx_rule,
-				  void *macdev, u32 fs_id)
+static void macsec_fs_rx_free_rule(struct mlx5_macsec_fs *macsec_fs,
+				   struct mlx5_macsec_rx_rule *rx_rule)
 {
 	int i;
 
-	macsec_fs_id_del(&macsec_fs->macsec_devices_list, fs_id, macdev,
-			 &macsec_fs->fs_id_hash, false);
-
 	for (i = 0; i < RX_NUM_OF_RULES_PER_SA; ++i) {
 		if (rx_rule->rule[i]) {
 			mlx5_del_flow_rules(rx_rule->rule[i]);
@@ -1678,6 +1679,15 @@ static void macsec_fs_rx_del_rule(struct mlx5_macsec_fs *macsec_fs,
 	macsec_fs_rx_ft_put(macsec_fs);
 }
 
+static void macsec_fs_rx_del_rule(struct mlx5_macsec_fs *macsec_fs,
+				  struct mlx5_macsec_rx_rule *rx_rule,
+				  void *macdev, u32 fs_id)
+{
+	macsec_fs_id_del(&macsec_fs->macsec_devices_list, fs_id, macdev,
+			 &macsec_fs->fs_id_hash, false);
+	macsec_fs_rx_free_rule(macsec_fs, rx_rule);
+}
+
 static void macsec_fs_rx_setup_fte(struct mlx5_flow_spec *spec,
 				   struct mlx5_flow_act *flow_act,
 				   struct mlx5_macsec_rule_attrs *attrs,
@@ -1837,7 +1847,7 @@ macsec_fs_rx_add_rule(struct mlx5_macsec_fs *macsec_fs,
 	return macsec_rule;
 
 err:
-	macsec_fs_rx_del_rule(macsec_fs, rx_rule, macsec_ctx->secy->netdev, fs_id);
+	macsec_fs_rx_free_rule(macsec_fs, rx_rule);
 	macsec_rule = NULL;
 out_spec:
 	kvfree(spec);
-- 
2.53.0



