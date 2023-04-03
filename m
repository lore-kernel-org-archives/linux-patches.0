Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 971545683
	for <patches@lists.linux.dev>; Mon,  3 Apr 2023 14:15:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F519C4339B;
	Mon,  3 Apr 2023 14:15:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680531331;
	bh=JqR/Z1y+e/iqi/iXaOGYGocTsi+1ImpfOKQRV36tgzg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fJMfF16fFzkQfdA9fJfdkPvrDEtyeCVfQOHrNtvxXx6I0Wb0thPa7ts/Wxk0FQH3d
	 eBIiiHxj+ucjKxk13i53cZA6m54nykjQIqyP8F4nSP7c+ayMl24UkrAjNkkjQoeoEu
	 mNP9lbOhiYN5linF4wsbCma/alMDnOgWfl4Ybdko=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liang He <windhl@126.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 22/84] net: mdio: thunder: Add missing fwnode_handle_put()
Date: Mon,  3 Apr 2023 16:08:23 +0200
Message-Id: <20230403140354.133424295@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140353.406927418@linuxfoundation.org>
References: <20230403140353.406927418@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Liang He <windhl@126.com>

[ Upstream commit b1de5c78ebe9858ccec9d49af2f76724f1d47e3e ]

In device_for_each_child_node(), we should add fwnode_handle_put()
when break out of the iteration device_for_each_child_node()
as it will automatically increase and decrease the refcounter.

Fixes: 379d7ac7ca31 ("phy: mdio-thunder: Add driver for Cavium Thunder SoC MDIO buses.")
Signed-off-by: Liang He <windhl@126.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/mdio-thunder.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/phy/mdio-thunder.c b/drivers/net/phy/mdio-thunder.c
index c0c922eff760c..959bf342133a7 100644
--- a/drivers/net/phy/mdio-thunder.c
+++ b/drivers/net/phy/mdio-thunder.c
@@ -107,6 +107,7 @@ static int thunder_mdiobus_pci_probe(struct pci_dev *pdev,
 		if (i >= ARRAY_SIZE(nexus->buses))
 			break;
 	}
+	fwnode_handle_put(fwn);
 	return 0;
 
 err_release_regions:
-- 
2.39.2



