Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A169282F3D;
	Mon, 23 Mar 2026 16:11:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774282286; cv=none; b=jdSr1YUpilRUjpEnCf0XgIBz35ws4emm85cUl4JFJK93B5F/IEwx+PkR2BG8fWJnekVqMhvtshrmt3sKQ88YJ0FIMAxkA0D6NE2ju7/wKqGIMC37n/4laXzgWsnQDvMKesFJMjt9+oTwC9mRM9Eb3gSbxID4IVuqbcbZfHktVPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774282286; c=relaxed/simple;
	bh=OULJojnyA75qtcoZB+DlbExcxisDL5bb9WbyM25TTnc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mybqreaIiPt/sZknj54QjSDi4yWFv6Qm5hGMAWkxwf4MYSX+57pX0d1EnWobEeEbL45MU0yKfjIt+AFJL1tbM3R42OfMdl611COWmjqGjrIhFXqSc3UsOij7wsGXhsWUBf8QRyQgHcOx9pVPwRf92KbV7z0cDrQyVLV6CDvZhBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2ZdPX+qT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2ZdPX+qT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D10BC4CEF7;
	Mon, 23 Mar 2026 16:11:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774282285;
	bh=OULJojnyA75qtcoZB+DlbExcxisDL5bb9WbyM25TTnc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2ZdPX+qTtvrB360Z8NY5mhgEdUnS1WW/dMSS0xyBFAPIW1U5lfZk61p9tAtNVSnz6
	 7R6foANBMLLi9y4/ibysmjdcb7r2fabLCwO56qQDhR17O/FaXNvx/nFpUGmUilw94y
	 Qcm3VO4JRXgPHSO+NZXxlUj65hFaTl18Q6ESQDZE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 101/481] net: dpaa2-switch replace direct MAC access with dpaa2_switch_port_has_mac()
Date: Mon, 23 Mar 2026 14:41:23 +0100
Message-ID: <20260323134527.744518161@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



