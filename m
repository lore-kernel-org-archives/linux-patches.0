Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618104;
	b=XNgaLkJYZGFdIM9iw84RUTINlYMIQ1im7LMKZP7kVssURqXla/sayhbjJ0engnjMYlaX
	 E7fMO7/bZhmg6zVuEJNNDmEgC25b0NXISueoDevRkYVI+W+SgWJWjE6ZVCNCjL2GpXl2e
	 q6LDVRsPEJ8vv3YBFW4dCyO7pTO1Ytqc8EkCg3tkTdfUkATzOuL3Bz4ObtTfMjkF7WL4D
	 YHZAODFnFbeL5wWhJcWfNhHhwxnY3FVJIlSOb/WLBoD7x15TD/ISX6pSlmUJfeXjvcbXv
	 +1TClUXvBekeP51hDUS15SE/shrjh6LDCCvAoYVRft9I74Q6SPhRYi2KZIlhP3sv9QA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618104;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=n0W92DUCCB9hfohUUMOnBMKj1D7VH+0pXotuHJpMfRI=;
	b=Z83zk3kftEbPCcxCFewHJTi0fCZ2p9booBgbaxCX+alVeJJNWz6c4kKrBWt+DjxTWsX4
	 4VOccehaO7Hw4ESZnm9NsaT4AQv7JPqXbNU1ZElFscqak/b9i+mFxTQgePFoUZvBGakVn
	 AXIJcRh5EdyOVkrv8xTqTaw5HIRsHn53mOC9uu++laKfud4ZFJPbXoZNiya+TR4c2ibYy
	 oK7mQAkGvfUpCoZLkJtyuEeDeAZWvHrcBLaHLjVKt8LqfEcZD6BCR02Yd/kV0QQBgIZVr
	 +QqlZJqaLYrLcBjWI3leq+v0clJma/N8xVLeXHfYqDaXGJHaizLw63Ql5c6OD6WuyZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HR0cgoUt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E73DA606A31E;
	Wed, 25 Nov 2026 14:48:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HR0cgoUt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B30B11F000D0;
	Wed, 25 Nov 2026 14:48:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618103;
	bh=n0W92DUCCB9hfohUUMOnBMKj1D7VH+0pXotuHJpMfRI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HR0cgoUtFOAjAWSAyM0GzZk3BKseVwQBAqAixNStZEYUC2CakHitjwUFJz5QI78vH
	 AZAFfdWAFX6AEdA0UNs7MWtVhoqTKuhh1d/cGIGSd1ViQlCjugyxiRtVgmw7urqPKY
	 /voS2/VLpvXv6oFwVwHy+qc2CjPaZCV4uopDjc7g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Machon <daniel.machon@microchip.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0166/1005] net: sparx5/lan969x: release the in-flight slot of a stale TX skb
Date: Wed, 25 Nov 2026 15:25:04 +0100
Message-ID: <20261125143825.631367929@linuxfoundation.org>
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

From: Daniel Machon <daniel.machon@microchip.com>

[ Upstream commit 873363ac591a1774aa3ced84f7ea3d93a3eb9b07 ]

sparx5_ptp_txtstamp_request() counts every two step TX skb waiting for
its timestamp in sparx5->ptp_skbs, and refuses new ones once
SPARX5_MAX_PTP_ID are in flight. sparx5_ptp_txtstamp_old_release()
frees the skbs that have waited longer than SPARX5_PTP_TIMEOUT.

Before this patch, old_release() does not decrement ptp_skbs, so every
skb whose timestamp never arrives, for example because the switch
discarded the frame, keeps its slot forever. Once SPARX5_MAX_PTP_ID
slots are lost, two step frames fail to transmit on every port of the
switch.

Return the number of released skbs from old_release() and subtract it
from ptp_skbs in txtstamp_request(), under the ptp_ts_id_lock it already
takes.

This fixes the accounting only. A port's stale skbs are still aged out
only when that port sends a two step frame, so a port that stops sending
them keeps its stale skbs, and their slots, until it sends one again.
That behaviour is unchanged by this patch.

Found by an AI code review agent. Reproduced on a lan9696 board with a
modified kernel that drops the TX timestamps of two step frames, after
which two step timestamping stopped working on the port. With the fix,
timestamping keeps working on that board and on a sparx5 PCB135 board.

Fixes: 70dfe25cd866 ("net: sparx5: Update extraction/injection for timestamping")
Signed-off-by: Daniel Machon <daniel.machon@microchip.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20261029-sparx5-ptp-stale-tx-slot-v1-1-ec15f391bbb7@microchip.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/microchip/sparx5/sparx5_ptp.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_ptp.c b/drivers/net/ethernet/microchip/sparx5/sparx5_ptp.c
index 2826e48af1033..9f61692b243b7 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_ptp.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_ptp.c
@@ -204,9 +204,10 @@ static void sparx5_ptp_classify(struct sparx5_port *port, struct sk_buff *skb,
 	*rew_op = IFH_REW_OP_TWO_STEP_PTP;
 }
 
-static void sparx5_ptp_txtstamp_old_release(struct sparx5_port *port)
+static unsigned int sparx5_ptp_txtstamp_old_release(struct sparx5_port *port)
 {
 	struct sk_buff *skb, *skb_tmp;
+	unsigned int purged = 0;
 	unsigned long flags;
 
 	spin_lock_irqsave(&port->tx_skbs.lock, flags);
@@ -217,8 +218,11 @@ static void sparx5_ptp_txtstamp_old_release(struct sparx5_port *port)
 
 		__skb_unlink(skb, &port->tx_skbs);
 		dev_kfree_skb_any(skb);
+		purged++;
 	}
 	spin_unlock_irqrestore(&port->tx_skbs.lock, flags);
+
+	return purged;
 }
 
 int sparx5_ptp_txtstamp_request(struct sparx5_port *port,
@@ -226,6 +230,7 @@ int sparx5_ptp_txtstamp_request(struct sparx5_port *port,
 {
 	struct sparx5 *sparx5 = port->sparx5;
 	u8 rew_op, pdu_type, pdu_w16_offset;
+	unsigned int purged;
 	unsigned long flags;
 
 	sparx5_ptp_classify(port, skb, &rew_op, &pdu_type, &pdu_w16_offset);
@@ -236,9 +241,10 @@ int sparx5_ptp_txtstamp_request(struct sparx5_port *port,
 	if (rew_op != IFH_REW_OP_TWO_STEP_PTP)
 		return 0;
 
-	sparx5_ptp_txtstamp_old_release(port);
+	purged = sparx5_ptp_txtstamp_old_release(port);
 
 	spin_lock_irqsave(&sparx5->ptp_ts_id_lock, flags);
+	sparx5->ptp_skbs -= purged;
 	if (sparx5->ptp_skbs == SPARX5_MAX_PTP_ID) {
 		spin_unlock_irqrestore(&sparx5->ptp_ts_id_lock, flags);
 		return -EBUSY;
-- 
2.53.0



