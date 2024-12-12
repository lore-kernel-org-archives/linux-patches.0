Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80933223301;
	Thu, 12 Dec 2024 16:02:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734019321; cv=none; b=AUTMOh37OHzEq926hTv4JMH1oiX/o6pagRTmIBd4joYqJ12QJ5/f8r6Sti92kLLhEW/w6dJkdcNS/nnOcP4sMgQ+dQwbrQSjb2D2HRZBtaCBDRWnEVaZelD65hTdaV9QY2tJpyY+HfirRY00zsU4LXMXz8ptkLF6hYF3QUjkKGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734019321; c=relaxed/simple;
	bh=QUyH5/+6hNe1w9DMfHHmCOq/mMLCOeUXWGA+gBwMJTI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JJRnVNEBY0/F0ymycWkE+tQDxtQf0dZDtpAT05zf1zzCceIs/PNfmN0CwkTuSNAMihZ1W14ai3zxy/aPmeR32it/nPa2Oiw9/eD2lI7362+jY7O3rQwJuHAupIcTt9jvhNSDT+jekiRW1+FyTi7zLectgcrvbPyOZWBx/iOJvVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D6FBXrv3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D6FBXrv3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A338C4CECE;
	Thu, 12 Dec 2024 16:02:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734019321;
	bh=QUyH5/+6hNe1w9DMfHHmCOq/mMLCOeUXWGA+gBwMJTI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D6FBXrv3iPAceCWPkn/0oJ4wP+4HRj4WcJLSwZMvGXFh1uJoJvgWmBE9Y1TavNcCC
	 zmELaGai+aRlysm3ig3m5i9J1tHcyWgkq1qeUkvnlWNPKYStltZZbe7FhW3T/92LUC
	 lGysSirhHA6pN0zC4fgwcsOde0wqmdmvOtSZQSF4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dipendra Khadka <kdipendra88@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Andrew Lunn <andrew@lunn.ch>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 159/772] octeontx2-pf: handle otx2_mbox_get_rsp errors in otx2_ethtool.c
Date: Thu, 12 Dec 2024 15:51:44 +0100
Message-ID: <20241212144356.500554355@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dipendra Khadka <kdipendra88@gmail.com>

[ Upstream commit e26f8eac6bb20b20fdb8f7dc695711ebce4c7c5c ]

Add error pointer check after calling otx2_mbox_get_rsp().

Fixes: 75f36270990c ("octeontx2-pf: Support to enable/disable pause frames via ethtool")
Fixes: d0cf9503e908 ("octeontx2-pf: ethtool fec mode support")
Signed-off-by: Dipendra Khadka <kdipendra88@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c  | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
index af779ae40d3c2..2d6f6edb15106 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
@@ -333,6 +333,11 @@ static void otx2_get_pauseparam(struct net_device *netdev,
 	if (!otx2_sync_mbox_msg(&pfvf->mbox)) {
 		rsp = (struct cgx_pause_frm_cfg *)
 		       otx2_mbox_get_rsp(&pfvf->mbox.mbox, 0, &req->hdr);
+		if (IS_ERR(rsp)) {
+			mutex_unlock(&pfvf->mbox.lock);
+			return;
+		}
+
 		pause->rx_pause = rsp->rx_pause;
 		pause->tx_pause = rsp->tx_pause;
 	}
@@ -1072,6 +1077,11 @@ static int otx2_set_fecparam(struct net_device *netdev,
 
 	rsp = (struct fec_mode *)otx2_mbox_get_rsp(&pfvf->mbox.mbox,
 						   0, &req->hdr);
+	if (IS_ERR(rsp)) {
+		err = PTR_ERR(rsp);
+		goto end;
+	}
+
 	if (rsp->fec >= 0)
 		pfvf->linfo.fec = rsp->fec;
 	else
-- 
2.43.0



