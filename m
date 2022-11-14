Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 721FA4C6A
	for <patches@lists.linux.dev>; Mon, 14 Nov 2022 12:49:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B859FC433C1;
	Mon, 14 Nov 2022 12:49:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1668430183;
	bh=yNTTRrPevQuceNBp58hbtVb38KyDvewXfKKi0B+8Mc0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rul3E5a3QW062p5YPo3jklm4apZIuJaa2UfSlk8cgizWOpIWRLhEwzdpP9xd/HCIe
	 NWx+vLkJZYUhPLUjDV6bChkJGlHTJATLodmQkdRfzE+tVA1xjGqdKLZRt5AOWUx2xJ
	 npB57+PyIu6PhGqgZl1jVRMD4mjZb3NvyeiMx2j4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhengchao Shao <shaozhengchao@huawei.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 43/95] cxgb4vf: shut down the adapter when t4vf_update_port_info() failed in cxgb4vf_open()
Date: Mon, 14 Nov 2022 13:45:37 +0100
Message-Id: <20221114124444.330319588@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124442.530286937@linuxfoundation.org>
References: <20221114124442.530286937@linuxfoundation.org>
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
index 2820a0bb971b..5e1e46425014 100644
--- a/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c
@@ -858,7 +858,7 @@ static int cxgb4vf_open(struct net_device *dev)
 	 */
 	err = t4vf_update_port_info(pi);
 	if (err < 0)
-		return err;
+		goto err_unwind;
 
 	/*
 	 * Note that this interface is up and start everything up ...
-- 
2.35.1



