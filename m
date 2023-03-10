Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23A52882B
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 15:12:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8296AC433EF;
	Fri, 10 Mar 2023 15:12:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678461164;
	bh=ObKncRY/+VTkOQHvEEDC0z6qX8GiOM3+fy2Ztnrv2ck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lX0hmT19NFqK8xBeAY7lPuJKZ00uKkYEMtOK/flEVlNP5/FCdtXhHYZT4V6p0/qSh
	 rEY3wysc4T4iY7ZHVMMNYrv7W72RRPQ+SEbSnruUoK9qsaUzSFlLVA1n6MHyd+xlGJ
	 6HT2GEu/IvJjuBdI9bGpiZ3yyFZAYmxwpTPTriWM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Deepak R Varma <drv@mailo.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 046/136] octeontx2-pf: Use correct struct reference in test condition
Date: Fri, 10 Mar 2023 14:42:48 +0100
Message-Id: <20230310133708.466001510@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133706.811226272@linuxfoundation.org>
References: <20230310133706.811226272@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Deepak R Varma <drv@mailo.com>

[ Upstream commit 3acd9db9293f3b33ac04e8d44ed05b604ad1ac26 ]

Fix the typo/copy-paste error by replacing struct variable ah_esp_mask name
by ah_esp_hdr.
Issue identified using doublebitand.cocci Coccinelle semantic patch.

Fixes: b7cf966126eb ("octeontx2-pf: Add flow classification using IP next level protocol")
Link: https://lore.kernel.org/all/20210111112537.3277-1-naveenm@marvell.com/
Signed-off-by: Deepak R Varma <drv@mailo.com>
Link: https://lore.kernel.org/r/Y/YYkKddeHOt80cO@ubun2204.myguest.virtualbox.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
index 77a13fb555fb6..63889449b8f61 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
@@ -748,7 +748,7 @@ static int otx2_prepare_ipv6_flow(struct ethtool_rx_flow_spec *fsp,
 
 		/* NPC profile doesn't extract AH/ESP header fields */
 		if ((ah_esp_mask->spi & ah_esp_hdr->spi) ||
-		    (ah_esp_mask->tclass & ah_esp_mask->tclass))
+		    (ah_esp_mask->tclass & ah_esp_hdr->tclass))
 			return -EOPNOTSUPP;
 
 		if (flow_type == AH_V6_FLOW)
-- 
2.39.2



