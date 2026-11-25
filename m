Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619110;
	b=2OwlYGSsqqdUsX9+PRY/wtkw9JL4/gnUBe8zaeuETmTDuGGIpGbvwY4j175JRZZrl8oQ
	 CRSYK1PzwZrwvph/VNDuFAkxymG7o8b4TI2HYNg27MpDnCAQJpIDJTdJLEo4FBtzfKdli
	 zAfiWElfHzOUwxytGmXQ+IDD5120NnJqHEAEHZDm7TiXrB3/OCO7Ux0WjKfPdPmEVXERf
	 0k8oq/HX9gqpxDB5uZEKUb85+JhgZ0C6roNapZUOL/J74wWZ3de5XFuS28FhNr3j2T78K
	 ju9pvBELLpx0XDYHUS4EA/yIQ+jjnw5c7RqAJK4dX2LQxlRJ8LJIiahPqjXrsUBmk4Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619110;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=thqTClCmNysP48b51GmlTBVcsshkLARrCyfot/R+J44=;
	b=MSMs1YbZAng19uDfzbblB5TZvdU+ScLbH0t7AHzaJZnu+Ehf8MkJjUB13AzTs64Eu1VX
	 MaZXwH/gqaZILVdJbsoo1cCMfl+HeVJPpJXPUF2GAWnkhKgCd3Q4tc6JLgrMgLb0lwgF1
	 s+q1+cthuxzhjJCx/IwG0PVI6AytMceM5Y90LACaypgRQmOlogP0lA7XHcaSeROUCNE/M
	 JT48CdCYzm9uGI+3lGT4xlRzfXjPiEwnw30OkgJe007zFOaqQwyLp4Uu3RxaCAHhBjTlx
	 50qMc5oFw/DqhO8siF8icX+LKWG1b8XuDX9GJuu1U+I5DqRHBWjiPj6BRFkPEyZGBRQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=njr8cKeU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80B29606A31E;
	Wed, 25 Nov 2026 15:05:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=njr8cKeU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D09151F000C4;
	Wed, 25 Nov 2026 15:05:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619110;
	bh=thqTClCmNysP48b51GmlTBVcsshkLARrCyfot/R+J44=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=njr8cKeU7syXUBIRJR+/3KolblC2SHttg7zfu9L1Q3KhUrieAgjiiHi0HlI64mwTU
	 9wpm4sAcy4rsNqE84bErXeXNMhG5nrqTXt3kruagODTo5QsoW2r1hlGp0SVDEK9ETS
	 ODI4M8kNX8Ln4DccEbyDmn2lw7ZyoS04zmNbhBAY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Changyul Lee <lcy8047@gmail.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0492/1005] net/mlx5: macsec: Dont remove fs_id when adding a rule fails
Date: Wed, 25 Nov 2026 15:30:30 +0100
Message-ID: <20261125143833.271443578@linuxfoundation.org>
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
index 7d785c937d43d..4892175ca5774 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/macsec_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/macsec_fs.c
@@ -764,13 +764,9 @@ static int macsec_fs_id_add(struct list_head *macsec_devices_list, u32 fs_id,
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
@@ -791,6 +787,15 @@ static void macsec_fs_tx_del_rule(struct mlx5_macsec_fs *macsec_fs,
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
@@ -883,7 +888,7 @@ macsec_fs_tx_add_rule(struct mlx5_macsec_fs *macsec_fs,
 	goto out_spec;
 
 err:
-	macsec_fs_tx_del_rule(macsec_fs, tx_rule, macsec_ctx->secy->netdev);
+	macsec_fs_tx_free_rule(macsec_fs, tx_rule);
 	macsec_rule = NULL;
 out_spec:
 	kvfree(spec);
@@ -1648,15 +1653,11 @@ static void macsec_fs_rx_ft_put(struct mlx5_macsec_fs *macsec_fs)
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
@@ -1674,6 +1675,15 @@ static void macsec_fs_rx_del_rule(struct mlx5_macsec_fs *macsec_fs,
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
@@ -1833,7 +1843,7 @@ macsec_fs_rx_add_rule(struct mlx5_macsec_fs *macsec_fs,
 	return macsec_rule;
 
 err:
-	macsec_fs_rx_del_rule(macsec_fs, rx_rule, macsec_ctx->secy->netdev, fs_id);
+	macsec_fs_rx_free_rule(macsec_fs, rx_rule);
 	macsec_rule = NULL;
 out_spec:
 	kvfree(spec);
-- 
2.53.0



