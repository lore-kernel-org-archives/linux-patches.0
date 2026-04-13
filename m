Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6687826CE32;
	Mon, 13 Apr 2026 16:20:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097257; cv=none; b=jMUjM9YU/tcj3BMctTzP0mdqddB+/mBQbncIQDPp1UbDiLT0BV3+OjZxtO0199/SUysR9WW28YNkatb51OOVhY0V7AhpNbmfcsUoRMybxzS+G2mQ3SASgvZCTjzmHgFhR5FT21thITg+7pzsRMLpsrlGlSls0nJC0C0TIlPjF3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097257; c=relaxed/simple;
	bh=msJOWydZThja1+3Xu2I2iFUF0LbzBDfDD74FTqHBCJk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DzxSO05wTDgGPijte1zAXwZNe3dHXPLXFl3IG9pqTWU583Z5/TNLWabCqGlDfqg8KUYwo8VPsffv78d0RA4veF4XydkgTyiS+vufw9rbXWxScvWpucJfIcGD9GsFT81finKvCUCitAMDRguN5ary6c7AzjJzQ0HjgdOVpuoItlo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cXxP2I6w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cXxP2I6w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E918FC2BCAF;
	Mon, 13 Apr 2026 16:20:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097257;
	bh=msJOWydZThja1+3Xu2I2iFUF0LbzBDfDD74FTqHBCJk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cXxP2I6wTHkMUpb5+duimL4y+M6nXxl/C2hYmg73pMHLxSKDUmmn4xoiszke3Le//
	 agTFdqNzL1ougouPucUQKhiAzWSDpwk0UETlJvR4VGnB6CbwXRWAddrmRpwSLTDzQ3
	 RgzgMG2bppEpKylbKEfdEu5mw9hRh1w9yMEc3V7Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 067/570] net: dpaa2-switch replace direct MAC access with dpaa2_switch_port_has_mac()
Date: Mon, 13 Apr 2026 17:53:18 +0200
Message-ID: <20260413155832.952399224@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit bc230671bfb25c2d3c225f674fe6c03cea88d22e ]

The helper function will gain a lockdep annotation in a future patch.
Make sure to benefit from it.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Tested-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: 74badb9c20b1 ("dpaa2-switch: Fix interrupt storm after receiving bad if_id in IRQ handler")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-ethtool.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-ethtool.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-ethtool.c
index 720c9230cab57..0b41a945e0fff 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-ethtool.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-ethtool.c
@@ -196,7 +196,7 @@ static void dpaa2_switch_ethtool_get_stats(struct net_device *netdev,
 				   dpaa2_switch_ethtool_counters[i].name, err);
 	}
 
-	if (port_priv->mac)
+	if (dpaa2_switch_port_has_mac(port_priv))
 		dpaa2_mac_get_ethtool_stats(port_priv->mac, data + i);
 }
 
-- 
2.51.0



