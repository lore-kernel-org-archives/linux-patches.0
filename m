Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 473F746B5
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:15:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC2B5C433EF;
	Mon, 16 Jan 2023 16:15:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673885759;
	bh=ykiS9gqIOKUeTcu+OBR+7ICt5G8aiKgvRB+1qDg0wAo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1Gfi3EmZ+PAZdm1Ho359CtUDu3Kx85P7ycrhVO40YOpIHyX2t3bozjD1R9l+07PR6
	 mdfC7Q0mcnSY/qRt4RMf3rH9U8c+r1S2jd5v1rSDI2Z6M5MipqpvjDC/eRa1k53BkX
	 o5+17Y+04PmYvBWIK8SkFa4pbs3fbK+pvw5e9S9w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Pavan Chebbi <pavan.chebbi@broadcom.com>,
	Jay Vosburgh <jay.vosburgh@canonical.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 173/658] bonding: uninitialized variable in bond_miimon_inspect()
Date: Mon, 16 Jan 2023 16:44:21 +0100
Message-Id: <20230116154917.392844817@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
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
index 0b7994cb9380..0885991347d0 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -2102,10 +2102,10 @@ static int bond_slave_info_query(struct net_device *bond_dev, struct ifslave *in
 /* called with rcu_read_lock() */
 static int bond_miimon_inspect(struct bonding *bond)
 {
+	bool ignore_updelay = false;
 	int link_state, commit = 0;
 	struct list_head *iter;
 	struct slave *slave;
-	bool ignore_updelay;
 
 	if (BOND_MODE(bond) == BOND_MODE_ACTIVEBACKUP) {
 		ignore_updelay = !rcu_dereference(bond->curr_active_slave);
-- 
2.35.1



