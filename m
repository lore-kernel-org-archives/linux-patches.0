Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6C568BE0
	for <patches@lists.linux.dev>; Tue, 28 Mar 2023 14:59:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BC61C433D2;
	Tue, 28 Mar 2023 14:59:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680015549;
	bh=upTXbOOZyD5jfy1RwA+Q/zsGtT9gImRRhm1yjOvbTFg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=naGbgVpNYlqmuw2i8xk0/uOvBrT0fLMRXxyGYtfQiq6GqFeSPyTDC3eLdbBQ+uNRf
	 oR3heVk1lhMXyExNPrsxgT9XEyVTa0u96T+PoyCgvMgo45Z/EFjQcYYJMoXIAhsa5F
	 ALn/ZeR1SNRhucAdLRqY42m4v7W64AUZTR1O/8P0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liang He <windhl@126.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 090/224] net: mdio: thunder: Add missing fwnode_handle_put()
Date: Tue, 28 Mar 2023 16:41:26 +0200
Message-Id: <20230328142621.012935010@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142617.205414124@linuxfoundation.org>
References: <20230328142617.205414124@linuxfoundation.org>
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
 drivers/net/mdio/mdio-thunder.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/mdio/mdio-thunder.c b/drivers/net/mdio/mdio-thunder.c
index 822d2cdd2f359..394b864aaa372 100644
--- a/drivers/net/mdio/mdio-thunder.c
+++ b/drivers/net/mdio/mdio-thunder.c
@@ -104,6 +104,7 @@ static int thunder_mdiobus_pci_probe(struct pci_dev *pdev,
 		if (i >= ARRAY_SIZE(nexus->buses))
 			break;
 	}
+	fwnode_handle_put(fwn);
 	return 0;
 
 err_release_regions:
-- 
2.39.2



