Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26F58134AC;
	Mon, 12 Aug 2024 16:25:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479908; cv=none; b=ZOZAhCyR2jlAt8FMQHgqD4rUyBbIv2MkLI08XiVIgY6w3xe36dpVG+pvEwzx6n/v2ibkGPVukAKQ4sth8+LnikJg/o2tEdE2ekbMSnVGtczEFCmCoqJqSHR4g/WC+pW9OU6yQ/92K1ttw8mSzH6oQeNRr5fuvByIEAGHbMEwkkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479908; c=relaxed/simple;
	bh=7v1vcJuQLqTL/DUcqYrggt+JMKLLSlFSZSU5v04uiSI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=S1Wn6faaP48DEDPrA0Zbwe/jV4XjUCyViVN1ilP7+ZsBcMsxuuNhgqhgQrTpnyvedUWjOOW/mSDvhye36/08kiX/3TDy5Z40rDxXQygydVL30jzJzg0Vagebb5V+lAdF+89Y0aokeefFD4Wui7QN/O2NNd/CX0CcXbo2hY/Zm78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j0t/kAke; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j0t/kAke"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A865C32782;
	Mon, 12 Aug 2024 16:25:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479907;
	bh=7v1vcJuQLqTL/DUcqYrggt+JMKLLSlFSZSU5v04uiSI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j0t/kAke29FuNnvwThGeBOuiVIRC6+bP57FOe0etgF/HMTc18MKd85R0rKlewBoIU
	 SGK2rzv5e/bZzXRuVQIIdmCeT9vOuRau7xRG8LQRLvkZhInXp1yQaP2y4nM5XqJMnm
	 uznZI5brZF5FFZUu/2Ls4pcW1iM2+qxFh/qFHMdo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabio Estevam <festevam@gmail.com>,
	=?UTF-8?q?Cs=C3=B3k=C3=A1s,
	=20Bence?= <csokas.bence@prolan.hu>,
	Andrew Lunn <andrew@lunn.ch>,
	Frank Li <Frank.Li@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 037/263] net: fec: Stop PPS on driver remove
Date: Mon, 12 Aug 2024 18:00:38 +0200
Message-ID: <20240812160147.962969894@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160146.517184156@linuxfoundation.org>
References: <20240812160146.517184156@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Csókás, Bence <csokas.bence@prolan.hu>

[ Upstream commit 8fee6d5ad5fa18c270eedb2a2cdf58dbadefb94b ]

PPS was not stopped in `fec_ptp_stop()`, called when
the adapter was removed. Consequentially, you couldn't
safely reload the driver with the PPS signal on.

Fixes: 32cba57ba74b ("net: fec: introduce fec_ptp_stop and use in probe fail path")
Reviewed-by: Fabio Estevam <festevam@gmail.com>
Link: https://lore.kernel.org/netdev/CAOMZO5BzcZR8PwKKwBssQq_wAGzVgf1ffwe_nhpQJjviTdxy-w@mail.gmail.com/T/#m01dcb810bfc451a492140f6797ca77443d0cb79f
Signed-off-by: Csókás, Bence <csokas.bence@prolan.hu>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20240807080956.2556602-1-csokas.bence@prolan.hu
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/fec_ptp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/freescale/fec_ptp.c b/drivers/net/ethernet/freescale/fec_ptp.c
index e32f6724f5681..2e4f3e1782a25 100644
--- a/drivers/net/ethernet/freescale/fec_ptp.c
+++ b/drivers/net/ethernet/freescale/fec_ptp.c
@@ -775,6 +775,9 @@ void fec_ptp_stop(struct platform_device *pdev)
 	struct net_device *ndev = platform_get_drvdata(pdev);
 	struct fec_enet_private *fep = netdev_priv(ndev);
 
+	if (fep->pps_enable)
+		fec_ptp_enable_pps(fep, 0);
+
 	cancel_delayed_work_sync(&fep->time_keep);
 	hrtimer_cancel(&fep->perout_timer);
 	if (fep->ptp_clock)
-- 
2.43.0



