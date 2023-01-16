Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEF0D6FA0
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 17:04:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64401C433D2;
	Mon, 16 Jan 2023 17:04:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673888676;
	bh=bXeRqgNQFwi9x1GHEsSNUIb15saTTuepFY7BYZhJUYY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sEageDjKw12c3Zde8muBV4MwoMMIfuUszHle/NSPnDV09zBzVvwVfVh2myRCdCIxe
	 z3z6frLDPeDYlq7neOkl/+kCqmKPcgEEvIsIiF15l12vVaWsqAsEyqzQ6EObcQanpJ
	 OM144tgBotuw9BFDVIzCRLbZNzZ8Cq5ktE7UgxJ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Pavan Chebbi <pavan.chebbi@broadcom.com>,
	Jay Vosburgh <jay.vosburgh@canonical.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 096/338] bonding: uninitialized variable in bond_miimon_inspect()
Date: Mon, 16 Jan 2023 16:49:29 +0100
Message-Id: <20230116154825.085908390@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154820.689115727@linuxfoundation.org>
References: <20230116154820.689115727@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dan Carpenter <error27@gmail.com>

[ Upstream commit e5214f363dabca240446272dac54d404501ad5e5 ]

The "ignore_updelay" variable needs to be initialized to false.

Fixes: f8a65ab2f3ff ("bonding: fix link recovery in mode 2 when updelay is nonzero")
Signed-off-by: Dan Carpenter <error27@gmail.com>
Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Acked-by: Jay Vosburgh <jay.vosburgh@canonical.com>
Link: https://lore.kernel.org/r/Y4SWJlh3ohJ6EPTL@kili
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/bonding/bond_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 98e64f63d9ba..0ffca2890e9a 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -2076,10 +2076,10 @@ static int bond_slave_info_query(struct net_device *bond_dev, struct ifslave *in
 /* called with rcu_read_lock() */
 static int bond_miimon_inspect(struct bonding *bond)
 {
+	bool ignore_updelay = false;
 	int link_state, commit = 0;
 	struct list_head *iter;
 	struct slave *slave;
-	bool ignore_updelay;
 
 	ignore_updelay = !rcu_dereference(bond->curr_active_slave);
 
-- 
2.35.1



