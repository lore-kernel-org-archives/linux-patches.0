Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB8361917F4;
	Tue, 27 May 2025 02:37:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748313475; cv=none; b=L+lPFvAePRdX0Rr2AietREB47StgoFQrfYPLGMo61rZbhsq/L/8wuaN7+pfnTS/boRPSQuD7vbN2gJt/RE5T4mJPbMrqS8At9A2Li5c8cpi3XoBP4T+U6Oj42wzdYpzVt3jukKW2ScqiURslle+MkTpU3wcxaH8QJXnOB45AB0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748313475; c=relaxed/simple;
	bh=kIRuaEhuQ3RL20AjvrHTCG8H0uPTnQyPtIC4tWHNvx0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Rsmc6xoN1E+OR7S5rpMypeUAjyrnULonu4hEFS5PPyaFVdQERr1kFTkO0gXx0ObBhkcjof8CjFMY8tOk7iAnktASK9yNQ+GkyI8ldeLp9ojmBveOAuA199MFI19Hz8A3NZ9he8K57Owzp/Q2YgSTnxPm0r2m35cxO/+9aaCuofg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P+2wR/81; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P+2wR/81"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58351C4CEF5;
	Tue, 27 May 2025 02:37:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748313474;
	bh=kIRuaEhuQ3RL20AjvrHTCG8H0uPTnQyPtIC4tWHNvx0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P+2wR/81tMwpHjlcG8ellSYlikttXgG3qsCkTEn0n64iCCvmbMAL56XvsqI++qEZr
	 OzzeB6q1au1PVJ/BBNmQVw+FkX0BYojrwQPVRtYAZSvVr6FZBla2t8EybuPkbqnrWs
	 wUmnLnSOV0BvZWyjLwdoNTtRmpGVHcJ6sXruDn3AmOeiVQ8jp5KD0Wsb7Ffved9hRi
	 q7FhIG5GrUBq0Yjg64QXy/VwYChK+yYNpZm9qvtvtxqImdQeolQCNj7Pzx0U/fIVvu
	 ZiDmATxuPpNDzAgGPBlPsksjbT7//0Skq3TYw7FfQ9cVeRK9jUnXhKMyBzDx8aSlGy
	 /b0+kiN6BetGg==
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
Subject: [PATCH AUTOSEL 6.12 4/5] net: ethernet: ti: am65-cpsw: Lower random mac address error print to info
Date: Mon, 26 May 2025 22:37:44 -0400
Message-Id: <20250527023745.1017153-4-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250527023745.1017153-1-sashal@kernel.org>
References: <20250527023745.1017153-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.12.30
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

