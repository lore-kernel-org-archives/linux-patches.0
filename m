Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FB0E2727F3;
	Wed,  8 Apr 2026 18:52:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674340; cv=none; b=VQ2n4BhZnOlRjBhdYzKWFSXBeKaLlgp5vqYLd6OH9SjrhG6anLtZo04fLGlkcraHHWZ/EOQxCJBdF8wir915FLraOSmGgu8/KYrGZkUUJSHqnyMgnYDA5NDcSeN5fIS13ZhryERrQtVxeGIpN6YMtMICEg0s+aiVnOOYsg+yDBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674340; c=relaxed/simple;
	bh=M/wD2HxE8VPVP3f8w5/jApW2BvR+ri0SiD1VouB3bRY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ik+pWEm6/9uFS0icGmmvI2fv11crNY33Q6zSaqaO3KyBqZVJRg0kUA4DFTmUhY3z3Vqgth1I1fU+rHu3Zy3pnELkmq4briRiRfjRmyRvMkvUJpTe2fVVA6t5pBSSLBRTazwb3D+l57sC5WTRlnrxXarhZtGSyyWA2m3pmfCcPIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kxKDTf6n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kxKDTf6n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8579C19421;
	Wed,  8 Apr 2026 18:52:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674340;
	bh=M/wD2HxE8VPVP3f8w5/jApW2BvR+ri0SiD1VouB3bRY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kxKDTf6nyb/xzCyST/Vd6cIDhlDWQK2QDQejGeLs6vCXYJpJDNPi1vYs7UJpNmkV8
	 XwYKs+x7qwkConbvTpJYrn8FkqeIfcgb1sItTyPPylQ3sj2QTndSTCMXoqAMhrgGfq
	 XPlic7elOeeQh4CzkcAPt3RiEt03y8KrHENla6CE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Fang <wei.fang@nxp.com>,
	Clark Wang <xiaoning.wang@nxp.com>,
	Claudiu Manoil <claudiu.manoil@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 059/311] net: enetc: check whether the RSS algorithm is Toeplitz
Date: Wed,  8 Apr 2026 20:00:59 +0200
Message-ID: <20260408175941.619046747@linuxfoundation.org>
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

[ Upstream commit d389954a6cae7bf76b7b082ac3511d177b77ef2d ]

Both ENETC v1 and v4 only provide Toeplitz RSS support. This patch adds
a validation check to reject attempts to configure other RSS algorithms,
avoiding misleading configuration options for users.

Fixes: d382563f541b ("enetc: Add RFS and RSS support")
Signed-off-by: Wei Fang <wei.fang@nxp.com>
Reviewed-by: Clark Wang <xiaoning.wang@nxp.com>
Reviewed-by: Claudiu Manoil <claudiu.manoil@nxp.com>
Link: https://patch.msgid.link/20260326075233.3628047-2-wei.fang@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/enetc/enetc_ethtool.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c b/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
index 2fe140ddebb23..a393647e6062c 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
@@ -795,6 +795,10 @@ static int enetc_set_rxfh(struct net_device *ndev,
 	struct enetc_si *si = priv->si;
 	int err = 0;
 
+	if (rxfh->hfunc != ETH_RSS_HASH_NO_CHANGE &&
+	    rxfh->hfunc != ETH_RSS_HASH_TOP)
+		return -EOPNOTSUPP;
+
 	/* set hash key, if PF */
 	if (rxfh->key && enetc_si_is_pf(si))
 		enetc_set_rss_key(si, rxfh->key);
-- 
2.53.0



