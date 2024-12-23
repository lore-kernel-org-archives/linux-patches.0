Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77F8D8827;
	Mon, 23 Dec 2024 16:15:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734970546; cv=none; b=dUcxregsWEmIkDZkmmYWMEe955NZA/6S8eSd1OqHHYi8rO9NUinGwkYkUo2LfAs3We7DVwiy/lN4uVtMxJYWldAp/kZZzyZL7Hu741uwdXCHqZhhERpg03GspMq+my4w278Xq3snhI3h+IIgKsoaFTxbYVcpS1N4Xku8+iFG6GA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734970546; c=relaxed/simple;
	bh=gClrYNXOj5THuZHeWB1QbP2+IAYKQCzR1s9lqSPb/e0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WXXYC3sZ0t3iWHizyShWsJMCEjPO+OHaQUHRKRXAcmB6rAsRNIHkj2DYG+m5p9cByMp3WEGuEdNfhOSt6nXxBDrmm9WoC+Tf5gxZXBno/vMaUMRQIM/FE9S1nM1qKXHmU1BJTF/Ew9umj9wxnoCiR8EniJXZ+YwRYjwFogP3tN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nKu5sN2V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nKu5sN2V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A404C4CED3;
	Mon, 23 Dec 2024 16:15:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734970546;
	bh=gClrYNXOj5THuZHeWB1QbP2+IAYKQCzR1s9lqSPb/e0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nKu5sN2VZZenjABQC+8K4y6ePrDq8laGOeZ9I3/FWDSZMP/D6I9qXv0/P0ystiuAi
	 +/SO0LEmrRP1srMBBFXSJSbcSIkM70A5KwNtVW5DMkcxHRDsy+yRVCVi8RYNrA565F
	 C2PBljYU14VDhNC9bw+WPVSg/pqAG1vIlGDO2PfM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Rafael Beims <rafael.beims@toradex.com>,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	=?UTF-8?q?Cs=C3=B3k=C3=A1s,
	=20Bence?= <csokas.bence@prolan.hu>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.6 115/116] net: fec: make PPS channel configurable
Date: Mon, 23 Dec 2024 16:59:45 +0100
Message-ID: <20241223155404.024495438@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155359.534468176@linuxfoundation.org>
References: <20241223155359.534468176@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Francesco Dolcini <francesco.dolcini@toradex.com>

commit 566c2d83887f0570056833102adc5b88e681b0c7 upstream.

Depending on the SoC where the FEC is integrated into the PPS channel
might be routed to different timer instances. Make this configurable
from the devicetree.

When the related DT property is not present fallback to the previous
default and use channel 0.

Reviewed-by: Frank Li <Frank.Li@nxp.com>
Tested-by: Rafael Beims <rafael.beims@toradex.com>
Signed-off-by: Francesco Dolcini <francesco.dolcini@toradex.com>
Reviewed-by: Csókás, Bence <csokas.bence@prolan.hu>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Csókás, Bence <csokas.bence@prolan.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/freescale/fec_ptp.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/freescale/fec_ptp.c
+++ b/drivers/net/ethernet/freescale/fec_ptp.c
@@ -523,8 +523,6 @@ static int fec_ptp_enable(struct ptp_clo
 	unsigned long flags;
 	int ret = 0;
 
-	fep->pps_channel = DEFAULT_PPS_CHANNEL;
-
 	if (rq->type == PTP_CLK_REQ_PPS) {
 		fep->reload_period = PPS_OUPUT_RELOAD_PERIOD;
 
@@ -706,12 +704,16 @@ void fec_ptp_init(struct platform_device
 {
 	struct net_device *ndev = platform_get_drvdata(pdev);
 	struct fec_enet_private *fep = netdev_priv(ndev);
+	struct device_node *np = fep->pdev->dev.of_node;
 	int irq;
 	int ret;
 
 	fep->ptp_caps.owner = THIS_MODULE;
 	strscpy(fep->ptp_caps.name, "fec ptp", sizeof(fep->ptp_caps.name));
 
+	fep->pps_channel = DEFAULT_PPS_CHANNEL;
+	of_property_read_u32(np, "fsl,pps-channel", &fep->pps_channel);
+
 	fep->ptp_caps.max_adj = 250000000;
 	fep->ptp_caps.n_alarm = 0;
 	fep->ptp_caps.n_ext_ts = 0;


