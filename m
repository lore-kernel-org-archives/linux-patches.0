Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7CA51C29
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:13:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9207C433C1;
	Wed, 23 Nov 2022 09:13:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669194789;
	bh=KfUir19TSvhmNm+dwMk976J/jmUEZp/swwa4ZEnU1Ws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AZrbqB8UpeYBmSu9+xB6G3uS13veZEtpydexrgMxfdU9OfgTpYuhFF8H1C7qSyUSW
	 i0KIbHDCPTEXaC5mrgFCN6mlHnyUOSPGkUwWXpnVS8BBv6MfdJ8A0fpmnYUyAfACjo
	 3LOZGt0uds7n6eImgSXpc3NgPbw8zStd6uFZ6WuY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhengchao Shao <shaozhengchao@huawei.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 032/156] cxgb4vf: shut down the adapter when t4vf_update_port_info() failed in cxgb4vf_open()
Date: Wed, 23 Nov 2022 09:49:49 +0100
Message-Id: <20221123084559.111679716@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084557.816085212@linuxfoundation.org>
References: <20221123084557.816085212@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zhengchao Shao <shaozhengchao@huawei.com>

[ Upstream commit c6092ea1e6d7bd12acd881f6aa2b5054cd70e096 ]

When t4vf_update_port_info() failed in cxgb4vf_open(), resources applied
during adapter goes up are not cleared. Fix it. Only be compiled, not be
tested.

Fixes: 18d79f721e0a ("cxgb4vf: Update port information in cxgb4vf_open()")
Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
Link: https://lore.kernel.org/r/20221109012100.99132-1-shaozhengchao@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c b/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c
index f4d41f968afa..97963d9a6d16 100644
--- a/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c
@@ -860,7 +860,7 @@ static int cxgb4vf_open(struct net_device *dev)
 	 */
 	err = t4vf_update_port_info(pi);
 	if (err < 0)
-		return err;
+		goto err_unwind;
 
 	/*
 	 * Note that this interface is up and start everything up ...
-- 
2.35.1



