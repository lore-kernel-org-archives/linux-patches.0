Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CEB48BE0
	for <patches@lists.linux.dev>; Tue, 28 Mar 2023 14:56:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0D78C433D2;
	Tue, 28 Mar 2023 14:56:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680015407;
	bh=iliBO35pPbb8cSSfs7u5bcXlap/H8Z8gcldr9R4+8s4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n+9t+xpYGJIL1fPl5+21wtM1Er9iGrYo2Th0m7+uz/ADUfXB1tI6pKkf7nY0IQtZh
	 8kHPtHz1LdEiGYKVhkcA+QXJCypv6sDUVc264eJ1LRNudb8HFSNdsnWbD56/Cz5/4h
	 57M8UXdfTnuyMQf6SX/x3DKdpVo1uBMTVmBJAEXA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= <noltari@gmail.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 037/224] net: dsa: b53: mmap: fix device tree support
Date: Tue, 28 Mar 2023 16:40:33 +0200
Message-Id: <20230328142618.886360034@linuxfoundation.org>
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

From: Álvaro Fernández Rojas <noltari@gmail.com>

[ Upstream commit 30796d0dcb6e41c6558a07950f2ce60c209da867 ]

CPU port should also be enabled in order to get a working switch.

Fixes: a5538a777b73 ("net: dsa: b53: mmap: Add device tree support")
Signed-off-by: Álvaro Fernández Rojas <noltari@gmail.com>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Link: https://lore.kernel.org/r/20230316172807.460146-1-noltari@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/b53/b53_mmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/b53/b53_mmap.c b/drivers/net/dsa/b53/b53_mmap.c
index e968322dfbf0b..70887e0aece33 100644
--- a/drivers/net/dsa/b53/b53_mmap.c
+++ b/drivers/net/dsa/b53/b53_mmap.c
@@ -263,7 +263,7 @@ static int b53_mmap_probe_of(struct platform_device *pdev,
 		if (of_property_read_u32(of_port, "reg", &reg))
 			continue;
 
-		if (reg < B53_CPU_PORT)
+		if (reg < B53_N_PORTS)
 			pdata->enabled_ports |= BIT(reg);
 	}
 
-- 
2.39.2



