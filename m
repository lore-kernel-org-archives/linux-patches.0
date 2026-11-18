Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061992;
	b=lnxm+/Hv6TOJbGhmCTqIjm5dv3OmT6AOB706dT4ddZgmBP+Kf1rKaz5FGEx8oXT+oZJB
	 KWhXcv2jxbDegNG4fBkxrbIMengUCokVKHDojzYOsGuH5/Q53mO/eT09CIM7tYBWaQ0ru
	 G0XvLjNWlIw2iWYq/l+Jtm3WPN8hdSrxrNevE3q0L/AiNsUpvvZfvwWaAq3uWiknOQRHP
	 KXKLrYrGhs6H7SLEbLbPPyKUot7GxoejYvYz/Jc/w+36ESd2yRGNZsZusE+RPj+8LSLIF
	 N7m5hNaoIZBGUDr4k9//0qayO6gGK5lKizU3MaQitlNZXJ9/3021XzOfRG1Fhz/vNJw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061992;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yQ4Gjzx+C7itv6H1FV/B19vqxxhJUyXgeNLbFE/ALTM=;
	b=GsROtHHGUch8qCHghCWeY9Zji/OL9KK5LCNz5gaMvPMHPof3ZWRmuu8NYHwwkllRDfzQ
	 6NL0q/1Za4W6Fv0qhB7nlwQrGGsqsY4NL00BTYvfgZDraaCBaTG3+PTiz5wVcizsCowYn
	 3sDqe7NrZk97SY4OXAPAVDG1eQ6g6mEdjEvWkGuKcZLn+m/zv4F9EicHxtY3b+BwA+vsb
	 +xtvK0Nzggz8algCK0lFsWntQyIAzw+w8xx8XNEpWn8tJT9Gro4a+NXYOxF9shvXEYCoB
	 AJ5kQXlAbFToyzwR7byiYttPdx04qCFoPRJOTCcyxfursc9VeZvq2fI4Hr2PJzOgP1Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=THGstUD0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C0A6606A32F;
	Thu, 19 Nov 2026 04:19:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=THGstUD0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A613B1F000C4;
	Thu, 19 Nov 2026 04:19:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061992;
	bh=yQ4Gjzx+C7itv6H1FV/B19vqxxhJUyXgeNLbFE/ALTM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=THGstUD0Lh3VTTQngl0wcl69UvcbBeztSDzb7LY9i2hJ1yQ4xNZrDkNz9fdltuESl
	 RWW7MK2u2aq7/lZsivjbModUyv2+3MBTkXJVUbKCLPmWPcFDDNYr4iljSPh8HGyOnA
	 dyHMhfjE/dly1+sXdcNCMqoODk8wOrTl2UZ4ijSM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shannon Nelson <snelson@pensando.io>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1751/1848] ionic: remove some unnecessary oom messages
Date: Wed, 18 Nov 2026 16:03:09 +0100
Message-ID: <20261118150032.775990898@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shannon Nelson <snelson@pensando.io>

[ Upstream commit c0c682eeb8ccb11c05c29c34820224b7556cdf19 ]

Remove memory allocation fail messages where the OOM stack
trace will make it obvious which allocation request failed.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: d90d1a768b3b ("ionic: fix port_info use-after-free on firmware recovery")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/pensando/ionic/ionic_dev.c  | 2 +-
 drivers/net/ethernet/pensando/ionic/ionic_lif.c  | 8 +++-----
 drivers/net/ethernet/pensando/ionic/ionic_main.c | 4 +---
 3 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_dev.c b/drivers/net/ethernet/pensando/ionic/ionic_dev.c
index b5f681918f6ee..4fc7af836a061 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_dev.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_dev.c
@@ -142,7 +142,7 @@ int ionic_heartbeat_check(struct ionic *ionic)
 
 			work = kzalloc(sizeof(*work), GFP_ATOMIC);
 			if (!work) {
-				dev_err(ionic->dev, "%s OOM\n", __func__);
+				dev_err(ionic->dev, "LIF reset trigger dropped\n");
 			} else {
 				work->type = IONIC_DW_TYPE_LIF_RESET;
 				if (fw_status & IONIC_FW_STS_F_RUNNING &&
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index f0c48f20d086d..ea6e7a7ddf822 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -855,7 +855,7 @@ static bool ionic_notifyq_service(struct ionic_cq *cq,
 	case IONIC_EVENT_RESET:
 		work = kzalloc(sizeof(*work), GFP_ATOMIC);
 		if (!work) {
-			netdev_err(lif->netdev, "%s OOM\n", __func__);
+			netdev_err(lif->netdev, "Reset event dropped\n");
 		} else {
 			work->type = IONIC_DW_TYPE_LIF_RESET;
 			ionic_lif_deferred_enqueue(&lif->deferred, work);
@@ -1064,10 +1064,8 @@ static int ionic_lif_addr(struct ionic_lif *lif, const u8 *addr, bool add,
 
 	if (!can_sleep) {
 		work = kzalloc(sizeof(*work), GFP_ATOMIC);
-		if (!work) {
-			netdev_err(lif->netdev, "%s OOM\n", __func__);
+		if (!work)
 			return -ENOMEM;
-		}
 		work->type = add ? IONIC_DW_TYPE_RX_ADDR_ADD :
 				   IONIC_DW_TYPE_RX_ADDR_DEL;
 		memcpy(work->addr, addr, ETH_ALEN);
@@ -1200,7 +1198,7 @@ static void ionic_set_rx_mode(struct net_device *netdev, bool can_sleep)
 		if (!can_sleep) {
 			work = kzalloc(sizeof(*work), GFP_ATOMIC);
 			if (!work) {
-				netdev_err(lif->netdev, "%s OOM\n", __func__);
+				netdev_err(lif->netdev, "rxmode change dropped\n");
 				return;
 			}
 			work->type = IONIC_DW_TYPE_RX_MODE;
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_main.c b/drivers/net/ethernet/pensando/ionic/ionic_main.c
index 694e710244e69..28617afecf287 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_main.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_main.c
@@ -513,10 +513,8 @@ int ionic_port_init(struct ionic *ionic)
 						     idev->port_info_sz,
 						     &idev->port_info_pa,
 						     GFP_KERNEL);
-		if (!idev->port_info) {
-			dev_err(ionic->dev, "Failed to allocate port info\n");
+		if (!idev->port_info)
 			return -ENOMEM;
-		}
 	}
 
 	sz = min(sizeof(ident->port.config), sizeof(idev->dev_cmd_regs->data));
-- 
2.53.0



