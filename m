Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F00DA2576;
	Mon,  2 Jun 2025 15:19:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748877592; cv=none; b=fJ1JtOYpbr1N2zETMtSB/5TrQQHBd4nXkHdlcdgunrzDkM0mzFgqcdpgrPgRj0fOlrMQjALkXyiiPZLo3mho8s9MHhJY28SMghgHeJALY+eaEA+MtqDFVtjNwrFjvKgbBRxdViro4Sy9d1kHZO9pBykyUGijauIZKrA7htDU7/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748877592; c=relaxed/simple;
	bh=hwh/NkDhypaV0bOqljlQSffYOHy4Ih5AYdFgmnMmxXI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ct2jAnrt+/o7FLFqqnjdzNhNTctmJtekb04+Ud1Cp3kdcUzS3sCMWqDHdqPiFUrUysKNfR64l7HC0xK7Ig7rb8sb4W0DNohgrW/000jCwa/QqbSN/8O6XAySNlbt8avT8L2Oj/44+xTOlz5KWQjwKDfWcSlGFKB2BTZRxd4P2uw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vTJMb1w7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vTJMb1w7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FF56C4CEEB;
	Mon,  2 Jun 2025 15:19:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748877591;
	bh=hwh/NkDhypaV0bOqljlQSffYOHy4Ih5AYdFgmnMmxXI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vTJMb1w79gRkls//Rlqi2Xu0U7lqbcZQZxjqw4cbWbt4kyBuQW6CNc263I4p9w7GC
	 y7zSd+7MJDYhq0lfJhrJa3fcil8yJgfCZh56PjxWQpGD2hV10Z7iDpMeSQaRsn5sH9
	 051IkvYygi7lJhMNRLRjJBKU+q72WC5OenjQOjyw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nishanth Menon <nm@ti.com>,
	Simon Horman <horms@kernel.org>,
	Roger Quadros <rogerq@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 325/325] net: ethernet: ti: am65-cpsw: Lower random mac address error print to info
Date: Mon,  2 Jun 2025 15:50:01 +0200
Message-ID: <20250602134333.145555321@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134319.723650984@linuxfoundation.org>
References: <20250602134319.723650984@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 32828d4ac64ce..a0a9e4e13e77b 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -1918,7 +1918,7 @@ static int am65_cpsw_nuss_init_slave_ports(struct am65_cpsw_common *common)
 							port->slave.mac_addr);
 			if (!is_valid_ether_addr(port->slave.mac_addr)) {
 				eth_random_addr(port->slave.mac_addr);
-				dev_err(dev, "Use random MAC address\n");
+				dev_info(dev, "Use random MAC address\n");
 			}
 		}
 	}
-- 
2.39.5



