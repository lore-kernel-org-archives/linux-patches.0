Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9CE62222CA;
	Mon,  2 Jun 2025 14:00:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748872820; cv=none; b=Pru5EJswc+/lGPP8UDfue5Xjm+yY9HpSS1xBmB3JDliNy2QfS8EqjIezTdqnpuxEEGRxkuPLusa22QsRzjGXVN5ESa0FYVRssFRmBRIJAahWpZgJzPhZnEwZxb71tz+HfljFaWPtg0PiE1ur95N8FuxBntB7Yw6DMbwcGcs1j3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748872820; c=relaxed/simple;
	bh=DxQ/bz9XDPkNv13V7uqtTL6UNJdlxmT1fkVEYXVHXKQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MX7W7pmh+F87BiHHY2HVUVEZkjbtRcnOe2acUGfhbXmRnnILLrEu/hTYLJA/dmqARX6uWAcPi5dp8i2sxOvyQ1d0dnj9Ua2KvLcIHAs4tkZJWi8p1AetkExHXDoK0qsWiSTKEyiMQseVK/jtDOscQTzlO3eIkQlD3lU3d4pt0fI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RGZc0Dez; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RGZc0Dez"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 315DBC4CEEE;
	Mon,  2 Jun 2025 14:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748872820;
	bh=DxQ/bz9XDPkNv13V7uqtTL6UNJdlxmT1fkVEYXVHXKQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RGZc0DezsJ7kTTgD2A27mKrvTFdDuYVgGjnyHwahMdxQYSLpetf0Wqayu86S9p74c
	 d6H7R/7u3pVNosLTh8gF/yKHj3Y5zxEqE9nLOxbuVljbHpA3l1U518awG4ncTpFuCo
	 hyVY25BZiBV1STrLUbM7vB+mjeS3Z9rR5Zq0wXC8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nishanth Menon <nm@ti.com>,
	Simon Horman <horms@kernel.org>,
	Roger Quadros <rogerq@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 72/73] net: ethernet: ti: am65-cpsw: Lower random mac address error print to info
Date: Mon,  2 Jun 2025 15:47:58 +0200
Message-ID: <20250602134244.520440326@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134241.673490006@linuxfoundation.org>
References: <20250602134241.673490006@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nishanth Menon <nm@ti.com>

[ Upstream commit 50980d8da71a0c2e045e85bba93c0099ab73a209 ]

Using random mac address is not an error since the driver continues to
function, it should be informative that the system has not assigned
a MAC address. This is inline with other drivers such as ax88796c,
dm9051 etc. Drop the error level to info level.

Signed-off-by: Nishanth Menon <nm@ti.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Roger Quadros <rogerq@kernel.org>
Link: https://patch.msgid.link/20250516122655.442808-1-nm@ti.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ti/am65-cpsw-nuss.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index cac67babe4559..1141107407165 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -2775,7 +2775,7 @@ static int am65_cpsw_nuss_init_slave_ports(struct am65_cpsw_common *common)
 							port->slave.mac_addr);
 			if (!is_valid_ether_addr(port->slave.mac_addr)) {
 				eth_random_addr(port->slave.mac_addr);
-				dev_err(dev, "Use random MAC address\n");
+				dev_info(dev, "Use random MAC address\n");
 			}
 		}
 
-- 
2.39.5



