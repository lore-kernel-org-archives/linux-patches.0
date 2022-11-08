Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBECB15CAE
	for <patches@lists.linux.dev>; Tue,  8 Nov 2022 14:01:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41E54C433D6;
	Tue,  8 Nov 2022 14:01:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667916092;
	bh=GCabpm9/xT/smrh0ODekTqJWCGTUD8Odg3wfKwulJ6A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tn+Soi0lVxbKupdU3jUuOW9m6uXKJ29+653qZqvx98SRDu5HAg6Fz7ib8DJKlXr3g
	 P8+oyNgVOeRbHZO6nVhpwN5o4gIM1q4BzlQj33vOHLhXAI2uy90kCKFlYqxaKo82Fv
	 DFLJQWGgr/McdVcFBkxnfYxjpKos/8aZLu2uX7/w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 043/144] isdn: mISDN: netjet: fix wrong check of device registration
Date: Tue,  8 Nov 2022 14:38:40 +0100
Message-Id: <20221108133347.093931085@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133345.346704162@linuxfoundation.org>
References: <20221108133345.346704162@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit bf00f5426074249058a106a6edbb89e4b25a4d79 ]

The class is set in mISDN_register_device(), but if device_add() returns
error, it will lead to delete a device without added, fix this by using
device_is_registered() to check if the device is registered.

Fixes: a900845e5661 ("mISDN: Add support for Traverse Technologies NETJet PCI cards")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/isdn/hardware/mISDN/netjet.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/isdn/hardware/mISDN/netjet.c b/drivers/isdn/hardware/mISDN/netjet.c
index a52f275f8263..f8447135a902 100644
--- a/drivers/isdn/hardware/mISDN/netjet.c
+++ b/drivers/isdn/hardware/mISDN/netjet.c
@@ -956,7 +956,7 @@ nj_release(struct tiger_hw *card)
 	}
 	if (card->irq > 0)
 		free_irq(card->irq, card);
-	if (card->isac.dch.dev.dev.class)
+	if (device_is_registered(&card->isac.dch.dev.dev))
 		mISDN_unregister_device(&card->isac.dch.dev);
 
 	for (i = 0; i < 2; i++) {
-- 
2.35.1



