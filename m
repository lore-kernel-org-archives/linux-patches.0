Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD3C22F237D;
	Tue, 17 Jun 2025 16:07:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176469; cv=none; b=KZnT0MsFXW7u0VYy0H47Qdm4XisuzZzjv1aVTm37T2EEMdUJHKEKqsKOYkJ72QGojZHruDZjrfp9u50KZSVN5db+Pzta/Tu8OS7jZQDwEp1EX+Ysp+eQ5X8wAXcNtNibPo5cU6fQfDL1imJZ4EOdvI8tZ7Hf9D9P+uN/3u1OWxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176469; c=relaxed/simple;
	bh=gfAfyi593ClFvGR6r47Y3V6trg7V5V5+LwrD34c5djY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gucBVqUfhbagq4E3rQ10HnuFBgmEZ+kycrV17RhkcbePzDvUY4QaR8iZHa2xE4d7GZabcAqpq7xy50FV/j66kgRH1MWfNHBRHEy+PMHYlXghTcuxtUjxNrPWl7vab75ShOD1P5QL+cqfr6S1MnU5S+0AnrxNIRaIXga7XBThygI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ts9h0V9F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ts9h0V9F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D5F4C4CEE3;
	Tue, 17 Jun 2025 16:07:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176469;
	bh=gfAfyi593ClFvGR6r47Y3V6trg7V5V5+LwrD34c5djY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ts9h0V9F/DRtMwZE2yPYU9Fg1cfT/+cNol+Brxjv+kSQqGmQ6g2zle02PYkv4deuU
	 PSXdpbodHPymXD2UkCJ0/LC7yqGGiR2G0A3IOCRw4algmANFL4Q+oU6z+SYVP+X88b
	 T2YDDDfGalokCr+xHdztDqUPkXBE2PtM2dqAM7+E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hari Kalavakunta <kalavakunta.hari.prasad@gmail.com>,
	Paul Fertser <fercerpav@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 192/780] net: ncsi: Fix GCPS 64-bit member variables
Date: Tue, 17 Jun 2025 17:18:20 +0200
Message-ID: <20250617152459.296439966@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hari Kalavakunta <kalavakunta.hari.prasad@gmail.com>

[ Upstream commit e8a1bd8344054ce27bebf59f48e3f6bc10bc419b ]

Correct Get Controller Packet Statistics (GCPS) 64-bit wide member
variables, as per DSP0222 v1.0.0 and forward specs. The Driver currently
collects these stats, but they are yet to be exposed to the user.
Therefore, no user impact.

Statistics fixes:
Total Bytes Received (byte range 28..35)
Total Bytes Transmitted (byte range 36..43)
Total Unicast Packets Received (byte range 44..51)
Total Multicast Packets Received (byte range 52..59)
Total Broadcast Packets Received (byte range 60..67)
Total Unicast Packets Transmitted (byte range 68..75)
Total Multicast Packets Transmitted (byte range 76..83)
Total Broadcast Packets Transmitted (byte range 84..91)
Valid Bytes Received (byte range 204..11)

Signed-off-by: Hari Kalavakunta <kalavakunta.hari.prasad@gmail.com>
Reviewed-by: Paul Fertser <fercerpav@gmail.com>
Link: https://patch.msgid.link/20250410012309.1343-1-kalavakunta.hari.prasad@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ncsi/internal.h | 21 ++++++++++-----------
 net/ncsi/ncsi-pkt.h | 23 +++++++++++------------
 net/ncsi/ncsi-rsp.c | 21 ++++++++++-----------
 3 files changed, 31 insertions(+), 34 deletions(-)

diff --git a/net/ncsi/internal.h b/net/ncsi/internal.h
index 4e0842df5234e..2c260f33b55cc 100644
--- a/net/ncsi/internal.h
+++ b/net/ncsi/internal.h
@@ -143,16 +143,15 @@ struct ncsi_channel_vlan_filter {
 };
 
 struct ncsi_channel_stats {
-	u32 hnc_cnt_hi;		/* Counter cleared            */
-	u32 hnc_cnt_lo;		/* Counter cleared            */
-	u32 hnc_rx_bytes;	/* Rx bytes                   */
-	u32 hnc_tx_bytes;	/* Tx bytes                   */
-	u32 hnc_rx_uc_pkts;	/* Rx UC packets              */
-	u32 hnc_rx_mc_pkts;     /* Rx MC packets              */
-	u32 hnc_rx_bc_pkts;	/* Rx BC packets              */
-	u32 hnc_tx_uc_pkts;	/* Tx UC packets              */
-	u32 hnc_tx_mc_pkts;	/* Tx MC packets              */
-	u32 hnc_tx_bc_pkts;	/* Tx BC packets              */
+	u64 hnc_cnt;		/* Counter cleared            */
+	u64 hnc_rx_bytes;	/* Rx bytes                   */
+	u64 hnc_tx_bytes;	/* Tx bytes                   */
+	u64 hnc_rx_uc_pkts;	/* Rx UC packets              */
+	u64 hnc_rx_mc_pkts;     /* Rx MC packets              */
+	u64 hnc_rx_bc_pkts;	/* Rx BC packets              */
+	u64 hnc_tx_uc_pkts;	/* Tx UC packets              */
+	u64 hnc_tx_mc_pkts;	/* Tx MC packets              */
+	u64 hnc_tx_bc_pkts;	/* Tx BC packets              */
 	u32 hnc_fcs_err;	/* FCS errors                 */
 	u32 hnc_align_err;	/* Alignment errors           */
 	u32 hnc_false_carrier;	/* False carrier detection    */
@@ -181,7 +180,7 @@ struct ncsi_channel_stats {
 	u32 hnc_tx_1023_frames;	/* Tx 512-1023 bytes frames   */
 	u32 hnc_tx_1522_frames;	/* Tx 1024-1522 bytes frames  */
 	u32 hnc_tx_9022_frames;	/* Tx 1523-9022 bytes frames  */
-	u32 hnc_rx_valid_bytes;	/* Rx valid bytes             */
+	u64 hnc_rx_valid_bytes;	/* Rx valid bytes             */
 	u32 hnc_rx_runt_pkts;	/* Rx error runt packets      */
 	u32 hnc_rx_jabber_pkts;	/* Rx error jabber packets    */
 	u32 ncsi_rx_cmds;	/* Rx NCSI commands           */
diff --git a/net/ncsi/ncsi-pkt.h b/net/ncsi/ncsi-pkt.h
index f2f3b5c1b9412..24edb27379724 100644
--- a/net/ncsi/ncsi-pkt.h
+++ b/net/ncsi/ncsi-pkt.h
@@ -252,16 +252,15 @@ struct ncsi_rsp_gp_pkt {
 /* Get Controller Packet Statistics */
 struct ncsi_rsp_gcps_pkt {
 	struct ncsi_rsp_pkt_hdr rsp;            /* Response header            */
-	__be32                  cnt_hi;         /* Counter cleared            */
-	__be32                  cnt_lo;         /* Counter cleared            */
-	__be32                  rx_bytes;       /* Rx bytes                   */
-	__be32                  tx_bytes;       /* Tx bytes                   */
-	__be32                  rx_uc_pkts;     /* Rx UC packets              */
-	__be32                  rx_mc_pkts;     /* Rx MC packets              */
-	__be32                  rx_bc_pkts;     /* Rx BC packets              */
-	__be32                  tx_uc_pkts;     /* Tx UC packets              */
-	__be32                  tx_mc_pkts;     /* Tx MC packets              */
-	__be32                  tx_bc_pkts;     /* Tx BC packets              */
+	__be64                  cnt;            /* Counter cleared            */
+	__be64                  rx_bytes;       /* Rx bytes                   */
+	__be64                  tx_bytes;       /* Tx bytes                   */
+	__be64                  rx_uc_pkts;     /* Rx UC packets              */
+	__be64                  rx_mc_pkts;     /* Rx MC packets              */
+	__be64                  rx_bc_pkts;     /* Rx BC packets              */
+	__be64                  tx_uc_pkts;     /* Tx UC packets              */
+	__be64                  tx_mc_pkts;     /* Tx MC packets              */
+	__be64                  tx_bc_pkts;     /* Tx BC packets              */
 	__be32                  fcs_err;        /* FCS errors                 */
 	__be32                  align_err;      /* Alignment errors           */
 	__be32                  false_carrier;  /* False carrier detection    */
@@ -290,11 +289,11 @@ struct ncsi_rsp_gcps_pkt {
 	__be32                  tx_1023_frames; /* Tx 512-1023 bytes frames   */
 	__be32                  tx_1522_frames; /* Tx 1024-1522 bytes frames  */
 	__be32                  tx_9022_frames; /* Tx 1523-9022 bytes frames  */
-	__be32                  rx_valid_bytes; /* Rx valid bytes             */
+	__be64                  rx_valid_bytes; /* Rx valid bytes             */
 	__be32                  rx_runt_pkts;   /* Rx error runt packets      */
 	__be32                  rx_jabber_pkts; /* Rx error jabber packets    */
 	__be32                  checksum;       /* Checksum                   */
-};
+}  __packed __aligned(4);
 
 /* Get NCSI Statistics */
 struct ncsi_rsp_gns_pkt {
diff --git a/net/ncsi/ncsi-rsp.c b/net/ncsi/ncsi-rsp.c
index 4a8ce2949faea..8668888c5a2f9 100644
--- a/net/ncsi/ncsi-rsp.c
+++ b/net/ncsi/ncsi-rsp.c
@@ -926,16 +926,15 @@ static int ncsi_rsp_handler_gcps(struct ncsi_request *nr)
 
 	/* Update HNC's statistics */
 	ncs = &nc->stats;
-	ncs->hnc_cnt_hi         = ntohl(rsp->cnt_hi);
-	ncs->hnc_cnt_lo         = ntohl(rsp->cnt_lo);
-	ncs->hnc_rx_bytes       = ntohl(rsp->rx_bytes);
-	ncs->hnc_tx_bytes       = ntohl(rsp->tx_bytes);
-	ncs->hnc_rx_uc_pkts     = ntohl(rsp->rx_uc_pkts);
-	ncs->hnc_rx_mc_pkts     = ntohl(rsp->rx_mc_pkts);
-	ncs->hnc_rx_bc_pkts     = ntohl(rsp->rx_bc_pkts);
-	ncs->hnc_tx_uc_pkts     = ntohl(rsp->tx_uc_pkts);
-	ncs->hnc_tx_mc_pkts     = ntohl(rsp->tx_mc_pkts);
-	ncs->hnc_tx_bc_pkts     = ntohl(rsp->tx_bc_pkts);
+	ncs->hnc_cnt            = be64_to_cpu(rsp->cnt);
+	ncs->hnc_rx_bytes       = be64_to_cpu(rsp->rx_bytes);
+	ncs->hnc_tx_bytes       = be64_to_cpu(rsp->tx_bytes);
+	ncs->hnc_rx_uc_pkts     = be64_to_cpu(rsp->rx_uc_pkts);
+	ncs->hnc_rx_mc_pkts     = be64_to_cpu(rsp->rx_mc_pkts);
+	ncs->hnc_rx_bc_pkts     = be64_to_cpu(rsp->rx_bc_pkts);
+	ncs->hnc_tx_uc_pkts     = be64_to_cpu(rsp->tx_uc_pkts);
+	ncs->hnc_tx_mc_pkts     = be64_to_cpu(rsp->tx_mc_pkts);
+	ncs->hnc_tx_bc_pkts     = be64_to_cpu(rsp->tx_bc_pkts);
 	ncs->hnc_fcs_err        = ntohl(rsp->fcs_err);
 	ncs->hnc_align_err      = ntohl(rsp->align_err);
 	ncs->hnc_false_carrier  = ntohl(rsp->false_carrier);
@@ -964,7 +963,7 @@ static int ncsi_rsp_handler_gcps(struct ncsi_request *nr)
 	ncs->hnc_tx_1023_frames = ntohl(rsp->tx_1023_frames);
 	ncs->hnc_tx_1522_frames = ntohl(rsp->tx_1522_frames);
 	ncs->hnc_tx_9022_frames = ntohl(rsp->tx_9022_frames);
-	ncs->hnc_rx_valid_bytes = ntohl(rsp->rx_valid_bytes);
+	ncs->hnc_rx_valid_bytes = be64_to_cpu(rsp->rx_valid_bytes);
 	ncs->hnc_rx_runt_pkts   = ntohl(rsp->rx_runt_pkts);
 	ncs->hnc_rx_jabber_pkts = ntohl(rsp->rx_jabber_pkts);
 
-- 
2.39.5



