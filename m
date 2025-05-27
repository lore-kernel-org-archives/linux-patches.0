Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 231E020D51D;
	Tue, 27 May 2025 02:38:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748313491; cv=none; b=JNkkBHPLzW4ehsPXYFVoy5hZyDcnZTHys3cSBSNcpv5eKYSh1y3cMqE3cNl2vCynhBedwSazbQ0dn9Z1oO8Ck+YYuYeJdyiJOq4IjnPdN8r+LYe7FENy5QmtCmsDsZQkLADDOCnAaGPfP8opgc8vpU+1dZidboUewLBP2eL42UY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748313491; c=relaxed/simple;
	bh=xALzJ2K948o767nhe/sWuxh89Aspq8Ky3rif3OPAKGA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=hsS6w6agHJUbjOcu0hV08QR/sJuAp1NkfHEVEKfR5m3Exp+HVSpG4pkvJw/ItKoOT4EABNyxR0/DoOJXNEAqF9GAPbEbq95gjfCeRr+EORf2+Xd30ICwSt9fuVvEnwz9WuQREC4VfGJBSZL8+11ltXvabP9d+bb0I9/grHYCvg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hIboPzpS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hIboPzpS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87EB4C4CEED;
	Tue, 27 May 2025 02:38:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748313491;
	bh=xALzJ2K948o767nhe/sWuxh89Aspq8Ky3rif3OPAKGA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hIboPzpSpjrU6CuOHbj2ypJIBRX5DdMGB9ljUUOCFVqEeifAmDtTufiNwswrXHaZv
	 Hh3QCdxSEXvt9jdRmWMlQddVh2JEMjHnQsvBnHFfbrQ4TDfdR0W8ZbF7S4QMC634Y9
	 D27I313wBSOeKF69RX1x6plOc1cuVlHDEo3KkWht4PdKbBugVHBw86OFsTos+A+dwh
	 /hqBiR8EKKY7AfC9qn7vurP5LvoCEQoHHZVhG+Z8irJPoyKXtFSgZL5bg6B9TF4nTN
	 Y1Enhny2/BuhODiuQ/LBtlGRXZtSqOv739aMOe9fhbZIxcuVC6jbBJ4geMmTvT03PZ
	 SBaHDt4erprDQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Nishanth Menon <nm@ti.com>,
	Simon Horman <horms@kernel.org>,
	Roger Quadros <rogerq@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	andrew+netdev@lunn.ch,
	davem@davemloft.net,
	edumazet@google.com,
	pabeni@redhat.com,
	alexander.sverdlin@gmail.com,
	dan.carpenter@linaro.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 3/3] net: ethernet: ti: am65-cpsw: Lower random mac address error print to info
Date: Mon, 26 May 2025 22:38:04 -0400
Message-Id: <20250527023804.1017311-3-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250527023804.1017311-1-sashal@kernel.org>
References: <20250527023804.1017311-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.1.140
Content-Transfer-Encoding: 8bit

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

