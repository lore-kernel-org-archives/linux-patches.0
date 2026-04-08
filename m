Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 756032727F3;
	Wed,  8 Apr 2026 18:51:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674304; cv=none; b=vBRXa3rwh9T/oIMVAgC+w4buY+Mn3tPDtS57WJIKjZLmvsxh7H/+sMfeY3vxjY2CWZ3UeYX3NTWEisZdZmMESI1+TSewfG92h2ncM63M0ZCB+K78oGPaJfJDwjLE2aWc+HGVz+Y552AkJ/7rgTVJRihchCiwjCGZO6wsX2nB4u4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674304; c=relaxed/simple;
	bh=ad4RPspniCC01YUVNoJs++PV8Ct7Dui19yd4lUir8ww=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OXJyrh+P5EhlpwiFv8klK99r+UmDxS82s9xQrd7jyqUKQXdPtL5aErlm8rDLiUcYB7/DibqxIQb0eMyol6pVWeiFqBp8yMNK9vEecHLwxeklECUPI/P0NF4IX1LomGamtHV6X51EZwj/Kupg+sa+8m2TuzVmRoN3aM874jV78B8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PzUumMBD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PzUumMBD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD553C19421;
	Wed,  8 Apr 2026 18:51:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674304;
	bh=ad4RPspniCC01YUVNoJs++PV8Ct7Dui19yd4lUir8ww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PzUumMBDLXU3NJE/389i25E25CplyiKEvTYbHZD79O6Dz/BAqItHZmKlfMfgrA5Fg
	 PBARa/XT1LF1exu4PwCPUulP2Ww4MWm/W9nVCB9KRCNhFxzuCpThKl+xucPV+6ST5v
	 SkG1eqhFiUYGCf3PA71X9c3+yFOv+nFQYxD3ctuI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Fang <wei.fang@nxp.com>,
	Claudiu Manoil <claudiu.manoil@nxp.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 046/311] net: enetc: do not access non-existent registers on pseudo MAC
Date: Wed,  8 Apr 2026 20:00:46 +0200
Message-ID: <20260408175941.135431885@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175939.393281918@linuxfoundation.org>
References: <20260408175939.393281918@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wei Fang <wei.fang@nxp.com>

[ Upstream commit f2df9567b123145a07ee4ea7440e233f5d0232cc ]

The ENETC4_PM_IEVENT and ENETC4_PM_CMD_CFG registers do not exist on the
ENETC pseudo MAC, so the driver should prevent from accessing them.

Fixes: 5175c1e4adca ("net: enetc: add basic support for the ENETC with pseudo MAC for i.MX94")
Signed-off-by: Wei Fang <wei.fang@nxp.com>
Tested-by: Claudiu Manoil <claudiu.manoil@nxp.com>
Reviewed-by: Claudiu Manoil <claudiu.manoil@nxp.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260324062121.2745033-4-wei.fang@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/enetc/enetc4_pf.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc4_pf.c b/drivers/net/ethernet/freescale/enetc/enetc4_pf.c
index 6a334f2848448..993c27e342266 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc4_pf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc4_pf.c
@@ -814,6 +814,9 @@ static void enetc4_mac_tx_graceful_stop(struct enetc_pf *pf)
 	val |= POR_TXDIS;
 	enetc_port_wr(hw, ENETC4_POR, val);
 
+	if (enetc_is_pseudo_mac(si))
+		return;
+
 	enetc4_mac_wait_tx_empty(si, 0);
 	if (si->hw_features & ENETC_SI_F_QBU)
 		enetc4_mac_wait_tx_empty(si, 1);
@@ -856,6 +859,9 @@ static void enetc4_mac_rx_graceful_stop(struct enetc_pf *pf)
 	struct enetc_si *si = pf->si;
 	u32 val;
 
+	if (enetc_is_pseudo_mac(si))
+		goto check_rx_busy;
+
 	if (si->hw_features & ENETC_SI_F_QBU) {
 		val = enetc_port_rd(hw, ENETC4_PM_CMD_CFG(1));
 		val &= ~PM_CMD_CFG_RX_EN;
@@ -868,6 +874,7 @@ static void enetc4_mac_rx_graceful_stop(struct enetc_pf *pf)
 	enetc_port_wr(hw, ENETC4_PM_CMD_CFG(0), val);
 	enetc4_mac_wait_rx_empty(si, 0);
 
+check_rx_busy:
 	if (read_poll_timeout(enetc_port_rd, val,
 			      !(val & PSR_RX_BUSY),
 			      100, 10000, false, hw,
-- 
2.53.0



