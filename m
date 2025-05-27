Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EADC20409A;
	Tue, 27 May 2025 02:38:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748313483; cv=none; b=XcHvMh1FUJy3Oe44NsrFJMom/jgtup7RIG/KWPYAGnXNgNPzLZbsqSHoGwGvuT4UhwlpoeHy4DYeXFCP1zXMYns7qEalnUKalx3ZvCEA/u6Y1VpEHcjnwb2YzxEW6HgH56xSi9LQhJHWdF1hkeTaPNgnLoyx24g8cwmvGCU6i7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748313483; c=relaxed/simple;
	bh=MpHIJl4Skd66AmQMjmb122pJJVSuewLE5MMH7G1YrpY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=eBf9kyo0PntiBh9MaaoqzUroj5r7uPE2CG0wVpYWwbkLwIdmbUCvMZcFlixYfoHBiRvulpJEHdSX2qWE4jilclux9iIUfRx0O+t80hRjyZxcH86clvcCa802KtleB6VnZQvfxJGNoCC8Y7BXxBLTR07ODiFGXzNdRVRF6zZzA8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HhQdToHM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HhQdToHM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 650BBC4CEED;
	Tue, 27 May 2025 02:38:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748313482;
	bh=MpHIJl4Skd66AmQMjmb122pJJVSuewLE5MMH7G1YrpY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HhQdToHMKkK0sQqzI6RULythZ8rshv9e2QBMsD7LcMXA2x6f5F6y0d5Ew+QuQhV8h
	 A8siWC50IwEzs2kHyvOcPAA01S0GH0IQC+FA5u7ZZ8sJyT//0EGJz49AT8NkmVnnFv
	 wT/4dkELJBy9NYLvTM+fQGEofnbDsTYkYvDHTO6uCzYzhIBnnKoJlHf8gA7uyRSjyx
	 m7IaZY/fktk+uZxQCU4WTyDMnFeOUuxZf1MM7Wim+FM606M9pNfxHbR6G5vWfgcJyT
	 C6fhUE+HPKyuxKm+AzgnTeXfR9RE6VwPFeznNMpZKwbFnf/qXKARPTEEQijlEJuQt2
	 M/YQtP+gQkz5g==
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
Subject: [PATCH AUTOSEL 6.6 3/4] net: ethernet: ti: am65-cpsw: Lower random mac address error print to info
Date: Mon, 26 May 2025 22:37:55 -0400
Message-Id: <20250527023756.1017237-3-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250527023756.1017237-1-sashal@kernel.org>
References: <20250527023756.1017237-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.6.92
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
index 9c8376b271891..c379a958380ce 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -2095,7 +2095,7 @@ static int am65_cpsw_nuss_init_slave_ports(struct am65_cpsw_common *common)
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

