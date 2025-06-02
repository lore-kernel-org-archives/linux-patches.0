Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF83F231A51;
	Mon,  2 Jun 2025 14:02:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748872973; cv=none; b=aC4k8CJAeh0x19sEMV1r0PKdKuIkibqDJKHmppofqoW2mXKQPVIW1S8clnSUH9ee2cxPC2X5pTV2o6cvOGUGikPTPY/Aha4ykh0J5CyAwLzNW7ZSRY1BteN7+kRn8/5BuGlf1NQE75e0tFTaZNrpQw+U7ogXOAQsi32DOpyXLsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748872973; c=relaxed/simple;
	bh=Ma7QPiCJCFK4ijRA5ysBtHmMrIxUvntwWyUGpu0MhDE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nS/4OA1Qe3T9vMKkHuFCbVvsLYxdRU+g0lKxQIdj0W9KuVyOFPxnA2m2T6kapLG/zF5Ygmb4IJRbHISs1cOOBdek7MlfO6JrJ5RoGi1hrPvmVBuLQ5xJqfdU30net45ZBU7kO37erp5S/xuwnJvJD8uhB90PWWUx601D/svLU5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YgIW9hAq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YgIW9hAq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A589C4CEEE;
	Mon,  2 Jun 2025 14:02:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748872972;
	bh=Ma7QPiCJCFK4ijRA5ysBtHmMrIxUvntwWyUGpu0MhDE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YgIW9hAqcUScaYLs4m2mqzGJbxkFHl8INk0YA/iDDw2z6OiPYYAiT+5H12PQvjP3n
	 8eaXCC7t7/2V/PNv6GAnOW92bgK77HUAEiEwNjcUJ1xK3Z5WWBDFSE/9YqRNwcs6nm
	 x7Mabh2m7u4BSDSXwvvVTgP8J5qKcYdOCvc0AN58=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nishanth Menon <nm@ti.com>,
	Simon Horman <horms@kernel.org>,
	Roger Quadros <rogerq@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 54/55] net: ethernet: ti: am65-cpsw: Lower random mac address error print to info
Date: Mon,  2 Jun 2025 15:48:11 +0200
Message-ID: <20250602134240.403762758@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134238.271281478@linuxfoundation.org>
References: <20250602134238.271281478@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index a21e7c0afbfdc..61788a43cb861 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -2699,7 +2699,7 @@ static int am65_cpsw_nuss_init_slave_ports(struct am65_cpsw_common *common)
 							port->slave.mac_addr);
 			if (!is_valid_ether_addr(port->slave.mac_addr)) {
 				eth_random_addr(port->slave.mac_addr);
-				dev_err(dev, "Use random MAC address\n");
+				dev_info(dev, "Use random MAC address\n");
 			}
 		}
 
-- 
2.39.5



