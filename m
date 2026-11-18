Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032784;
	b=lwFXfqSqbYArIm5FyEUVrrE5KY44dM2lgVUI5KZslGcJrmZnTWaYR3CxyaIfJIeG5Deb
	 j9jNyKA3utnTN5kC9KTMNRNdxdXUtdc50ad0iDO03Ms63y//b17BOU6lEj7wfzFuWnGGS
	 rWoKUXjLhhBsIxwUdp0ozv6G1XMh1+aBaSmyRfBfw24Dj3VeGA0JiaSdp+U4koSAwPu+F
	 dt25GDplWGVHOQ+k6PxOhWLqsR2BnF7po6tNl//Q27uq/Gm45Y4O6sS3j7nZhX+5MoI94
	 Z5PoxgTtnyGriA8kn8kfcMb2IeiAGdisB2/9sM7m3cb4IFUhAK0YL7HixYgU5OxS6Tg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032784;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ECkzCrR6MkvdX5lnQCBDNWyUnqiWtn6om1e3WJtWKTE=;
	b=I++WzFliO6EHnqEe/e6DpLeoWDSolq6RHFA5d1o0r5YghWNG49ScvQl3lWOsgyC40N/+
	 HcmnbEowJYNy9Un7ETRLpY2qvlcf8wYD/5Vg+hGVyckUrwkUf7r1DlKlGeF5GPjb/0KyQ
	 wEAwJSNHtyveQtBFv7qalljp7lUflYKB1XcD7vIrxb7QerA5J3kUnHFTwLK62FbUMNNp0
	 /UL0zyl5YgbKVkY1yd9w8uZuNVOWkYA1zBf24iRiV2EZgSQRrckBDV9rQzadxJYUgrGJM
	 Pvh9c1Bp8sKXFWaveCXyT3iRrMIX6gtykLgrYqUSzA2URqeOKbMWS+0fJIfzU27VvoA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fJILWLKr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E19D0606A31C;
	Wed, 18 Nov 2026 20:13:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fJILWLKr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F32801F000C4;
	Wed, 18 Nov 2026 20:13:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032783;
	bh=ECkzCrR6MkvdX5lnQCBDNWyUnqiWtn6om1e3WJtWKTE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fJILWLKrV83bCu5deumcb0qOUmr0526rLftBnmUQ5wPoaCOoKHzpJnjnn6IDrE9rc
	 4sB3/+g/FUyKYBLHJUdkDPGcHKxthASNqEqzJMjhqSU/9xtkIamXmPyywZmGetLl+E
	 L8aBJKIQOTjb7iuKpGBgw04eKuUQMvxdoNxiLDi8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steen Hegelund <Steen.Hegelund@microchip.com>,
	Daniel Machon <daniel.machon@microchip.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1534/1756] net: sparx5: split sparx5_fdma_{start(),stop()}
Date: Wed, 18 Nov 2026 16:01:01 +0100
Message-ID: <20261118150110.033167689@linuxfoundation.org>
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

From: Daniel Machon <daniel.machon@microchip.com>

[ Upstream commit b91dcb237c69a05b06d64e2f4ba0a74a0552b80f ]

The two functions: sparx5_fdma_{start(),stop()} are responsible for a
number of things, namely: allocation and initialization of FDMA buffers,
activation FDMA channels in hardware and activation of the NAPI
instance.

This patch splits the buffer allocation and initialization into init and
deinit functions, and the channel and NAPI activation into start and
stop functions. This serves two purposes: 1) the start() and stop()
functions can be reused for lan969x and 2) prepares for future MTU
change support, where we must be able to stop and start the FDMA
channels and NAPI instance, without free'ing and reallocating the FDMA
buffers.

Reviewed-by: Steen Hegelund <Steen.Hegelund@microchip.com>
Signed-off-by: Daniel Machon <daniel.machon@microchip.com>
Link: https://patch.msgid.link/20250113-sparx5-lan969x-switch-driver-5-v2-2-c468f02fd623@microchip.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 1df26063ab9b ("net: sparx5: fix tx DCB index drift in fdma xmit")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/microchip/sparx5/sparx5_fdma.c   | 44 ++++++++++++++-----
 .../ethernet/microchip/sparx5/sparx5_main.c   |  7 ++-
 .../ethernet/microchip/sparx5/sparx5_main.h   |  2 +
 3 files changed, 41 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_fdma.c b/drivers/net/ethernet/microchip/sparx5/sparx5_fdma.c
index 61df874b76235..b65074b358899 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_fdma.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_fdma.c
@@ -258,10 +258,6 @@ static int sparx5_fdma_rx_alloc(struct sparx5 *sparx5)
 	fdma_dcbs_init(fdma, FDMA_DCB_INFO_DATAL(fdma->db_size),
 		       FDMA_DCB_STATUS_INTR);
 
-	netif_napi_add_weight(rx->ndev, &rx->napi, sparx5_fdma_napi_callback,
-			      FDMA_WEIGHT);
-	napi_enable(&rx->napi);
-	sparx5_fdma_rx_activate(sparx5, rx);
 	return 0;
 }
 
@@ -406,7 +402,7 @@ static void sparx5_fdma_injection_mode(struct sparx5 *sparx5)
 	}
 }
 
-int sparx5_fdma_start(struct sparx5 *sparx5)
+int sparx5_fdma_init(struct sparx5 *sparx5)
 {
 	int err;
 
@@ -439,24 +435,52 @@ int sparx5_fdma_start(struct sparx5 *sparx5)
 	return err;
 }
 
+int sparx5_fdma_deinit(struct sparx5 *sparx5)
+{
+	sparx5_fdma_stop(sparx5);
+	fdma_free_phys(&sparx5->rx.fdma);
+	fdma_free_phys(&sparx5->tx.fdma);
+
+	return 0;
+}
+
 static u32 sparx5_fdma_port_ctrl(struct sparx5 *sparx5)
 {
 	return spx5_rd(sparx5, FDMA_PORT_CTRL(0));
 }
 
+int sparx5_fdma_start(struct sparx5 *sparx5)
+{
+	struct sparx5_rx *rx = &sparx5->rx;
+
+	netif_napi_add_weight(rx->ndev,
+			      &rx->napi,
+			      sparx5_fdma_napi_callback,
+			      FDMA_WEIGHT);
+
+	napi_enable(&rx->napi);
+
+	sparx5_fdma_rx_activate(sparx5, rx);
+
+	return 0;
+}
+
 int sparx5_fdma_stop(struct sparx5 *sparx5)
 {
+	struct sparx5_rx *rx = &sparx5->rx;
+	struct sparx5_tx *tx = &sparx5->tx;
 	u32 val;
 
-	napi_disable(&sparx5->rx.napi);
+	napi_disable(&rx->napi);
+
 	/* Stop the fdma and channel interrupts */
-	sparx5_fdma_rx_deactivate(sparx5, &sparx5->rx);
-	sparx5_fdma_tx_deactivate(sparx5, &sparx5->tx);
+	sparx5_fdma_rx_deactivate(sparx5, rx);
+	sparx5_fdma_tx_deactivate(sparx5, tx);
+
 	/* Wait for the RX channel to stop */
 	read_poll_timeout(sparx5_fdma_port_ctrl, val,
 			  FDMA_PORT_CTRL_XTR_BUF_IS_EMPTY_GET(val) == 0,
 			  500, 10000, 0, sparx5);
-	fdma_free_phys(&sparx5->rx.fdma);
-	fdma_free_phys(&sparx5->tx.fdma);
+
 	return 0;
 }
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_main.c b/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
index 5b83cd4b6270b..2c07a320cd8a2 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
@@ -698,8 +698,11 @@ static int sparx5_start(struct sparx5 *sparx5)
 					       sparx5_fdma_handler,
 					       0,
 					       "sparx5-fdma", sparx5);
-		if (!err)
-			err = sparx5_fdma_start(sparx5);
+		if (!err) {
+			err = sparx5_fdma_init(sparx5);
+			if (!err)
+				sparx5_fdma_start(sparx5);
+		}
 		if (err)
 			sparx5->fdma_irq = -ENXIO;
 	} else {
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_main.h b/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
index fde3e3d686d17..319cb020a9bcc 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
@@ -314,6 +314,8 @@ int sparx5_manual_injection_mode(struct sparx5 *sparx5);
 void sparx5_port_inj_timer_setup(struct sparx5_port *port);
 
 /* sparx5_fdma.c */
+int sparx5_fdma_init(struct sparx5 *sparx5);
+int sparx5_fdma_deinit(struct sparx5 *sparx5);
 int sparx5_fdma_start(struct sparx5 *sparx5);
 int sparx5_fdma_stop(struct sparx5 *sparx5);
 int sparx5_fdma_xmit(struct sparx5 *sparx5, u32 *ifh, struct sk_buff *skb);
-- 
2.53.0



