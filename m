Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 288FB1D173C;
	Wed,  2 Oct 2024 14:51:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727880668; cv=none; b=lup2NsXadI5UaTUJkhU9IHWkpNB9UmfOGzp2ZcXdBP52MWTd4kHK6kjlVWd/FHxkX00fUpyKzGd1HiagyniYFezB2IUOeb+KrISUAmqYbYdgyrCsGOiLKq0Ydg7qnjuIsaLoZ7A81MuiXMS4UG39hw2GZenGuO0y/1qOKYgpZ0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727880668; c=relaxed/simple;
	bh=nnNYtqRyzZxL82+YNzWM+qKJjtUrK0tgubp52IR4iQc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=enlAjsGk+iTB/9e2PUU2IPd+y+3WMCWL6wl638C1l90glKgvYkShdevRuJ8DmtqcHYiVUkYM1P/z2KXm3SikKq94hhtzWyB1hiDwfXgQXD4OY7YJP4o3Vgrr6+gWr8N8s4bMsHhoFhbg987jRtFq6MQ5QDlp9fO0NbEGWxFAwL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZMpFaOsB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZMpFaOsB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8028C4CEC2;
	Wed,  2 Oct 2024 14:51:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727880668;
	bh=nnNYtqRyzZxL82+YNzWM+qKJjtUrK0tgubp52IR4iQc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZMpFaOsBqdAqBs4jcmfrgbMie3eSHuLvrxMQxhWpRXmVKZxQIc0Qxq8IOhiUulF8J
	 dMS55CsRjZRbfZbA13V3CC9JNKVKl2JRRy/NBAP51vo6s5So+exWRm9FqBiITxr6Gm
	 KMlHng0DDS60jpk8Ec9kx1wiT/HI4ZcF5xL1iztc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"qin.wan@hp.com, andreas.noever@gmail.com, michael.jamet@intel.com, mika.westerberg@linux.intel.com, YehezkelShB@gmail.com, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, Alexandru Gagniuc" <alexandru.gagniuc@hp.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Qin Wan <qin.wan@hp.com>,
	Alexandru Gagniuc <alexandru.gagniuc@hp.com>
Subject: [PATCH 6.6 506/538] thunderbolt: Use constants for path weight and priority
Date: Wed,  2 Oct 2024 15:02:25 +0200
Message-ID: <20241002125812.414934098@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mika Westerberg <mika.westerberg@linux.intel.com>

[ Upstream commit f73edddfa2a64a185c65a33f100778169c92fc25 ]

Makes it easier to follow and update. No functional changes.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Qin Wan <qin.wan@hp.com>
Signed-off-by: Alexandru Gagniuc <alexandru.gagniuc@hp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thunderbolt/tunnel.c |   39 +++++++++++++++++++++++++++------------
 1 file changed, 27 insertions(+), 12 deletions(-)

--- a/drivers/thunderbolt/tunnel.c
+++ b/drivers/thunderbolt/tunnel.c
@@ -21,12 +21,18 @@
 #define TB_PCI_PATH_DOWN		0
 #define TB_PCI_PATH_UP			1
 
+#define TB_PCI_PRIORITY			3
+#define TB_PCI_WEIGHT			1
+
 /* USB3 adapters use always HopID of 8 for both directions */
 #define TB_USB3_HOPID			8
 
 #define TB_USB3_PATH_DOWN		0
 #define TB_USB3_PATH_UP			1
 
+#define TB_USB3_PRIORITY		3
+#define TB_USB3_WEIGHT			3
+
 /* DP adapters use HopID 8 for AUX and 9 for Video */
 #define TB_DP_AUX_TX_HOPID		8
 #define TB_DP_AUX_RX_HOPID		8
@@ -36,6 +42,12 @@
 #define TB_DP_AUX_PATH_OUT		1
 #define TB_DP_AUX_PATH_IN		2
 
+#define TB_DP_VIDEO_PRIORITY		1
+#define TB_DP_VIDEO_WEIGHT		1
+
+#define TB_DP_AUX_PRIORITY		2
+#define TB_DP_AUX_WEIGHT		1
+
 /* Minimum number of credits needed for PCIe path */
 #define TB_MIN_PCIE_CREDITS		6U
 /*
@@ -46,6 +58,9 @@
 /* Minimum number of credits for DMA path */
 #define TB_MIN_DMA_CREDITS		1
 
+#define TB_DMA_PRIORITY			5
+#define TB_DMA_WEIGHT			1
+
 static unsigned int dma_credits = TB_DMA_CREDITS;
 module_param(dma_credits, uint, 0444);
 MODULE_PARM_DESC(dma_credits, "specify custom credits for DMA tunnels (default: "
@@ -213,8 +228,8 @@ static int tb_pci_init_path(struct tb_pa
 	path->egress_shared_buffer = TB_PATH_NONE;
 	path->ingress_fc_enable = TB_PATH_ALL;
 	path->ingress_shared_buffer = TB_PATH_NONE;
-	path->priority = 3;
-	path->weight = 1;
+	path->priority = TB_PCI_PRIORITY;
+	path->weight = TB_PCI_WEIGHT;
 	path->drop_packages = 0;
 
 	tb_path_for_each_hop(path, hop) {
@@ -1152,8 +1167,8 @@ static void tb_dp_init_aux_path(struct t
 	path->egress_shared_buffer = TB_PATH_NONE;
 	path->ingress_fc_enable = TB_PATH_ALL;
 	path->ingress_shared_buffer = TB_PATH_NONE;
-	path->priority = 2;
-	path->weight = 1;
+	path->priority = TB_DP_AUX_PRIORITY;
+	path->weight = TB_DP_AUX_WEIGHT;
 
 	tb_path_for_each_hop(path, hop)
 		tb_dp_init_aux_credits(hop);
@@ -1196,8 +1211,8 @@ static int tb_dp_init_video_path(struct
 	path->egress_shared_buffer = TB_PATH_NONE;
 	path->ingress_fc_enable = TB_PATH_NONE;
 	path->ingress_shared_buffer = TB_PATH_NONE;
-	path->priority = 1;
-	path->weight = 1;
+	path->priority = TB_DP_VIDEO_PRIORITY;
+	path->weight = TB_DP_VIDEO_WEIGHT;
 
 	tb_path_for_each_hop(path, hop) {
 		int ret;
@@ -1471,8 +1486,8 @@ static int tb_dma_init_rx_path(struct tb
 	path->ingress_fc_enable = TB_PATH_ALL;
 	path->egress_shared_buffer = TB_PATH_NONE;
 	path->ingress_shared_buffer = TB_PATH_NONE;
-	path->priority = 5;
-	path->weight = 1;
+	path->priority = TB_DMA_PRIORITY;
+	path->weight = TB_DMA_WEIGHT;
 	path->clear_fc = true;
 
 	/*
@@ -1505,8 +1520,8 @@ static int tb_dma_init_tx_path(struct tb
 	path->ingress_fc_enable = TB_PATH_ALL;
 	path->egress_shared_buffer = TB_PATH_NONE;
 	path->ingress_shared_buffer = TB_PATH_NONE;
-	path->priority = 5;
-	path->weight = 1;
+	path->priority = TB_DMA_PRIORITY;
+	path->weight = TB_DMA_WEIGHT;
 	path->clear_fc = true;
 
 	tb_path_for_each_hop(path, hop) {
@@ -1845,8 +1860,8 @@ static void tb_usb3_init_path(struct tb_
 	path->egress_shared_buffer = TB_PATH_NONE;
 	path->ingress_fc_enable = TB_PATH_ALL;
 	path->ingress_shared_buffer = TB_PATH_NONE;
-	path->priority = 3;
-	path->weight = 3;
+	path->priority = TB_USB3_PRIORITY;
+	path->weight = TB_USB3_WEIGHT;
 	path->drop_packages = 0;
 
 	tb_path_for_each_hop(path, hop)


