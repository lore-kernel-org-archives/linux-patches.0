Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63B6679C1
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:49:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D473BC433D6;
	Wed, 30 Nov 2022 18:49:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669834153;
	bh=CCaW/k/7B35DkKML/TLvGq/DCzTW80EVaH4QozGNgbU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ofsU1pCw6XPaHVTUf4IDpP154jCpHh8ir5VO763UL0Xzp2uR9fKObk7U8jpyX/Rs8
	 g3gJEPEP87aKrm/Mn+Mu6E7mQuqPc3KxJ+6FGgQjNpcfJ8d1IKwvmOeSpdYb1Z+h6v
	 5jNxhyF3ncfxP77LPdw33eik+Ib09Wy3JMibuBhs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Changzhong <zhangchangzhong@huawei.com>,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 149/289] net: marvell: prestera: add missing unregister_netdev() in prestera_port_create()
Date: Wed, 30 Nov 2022 19:22:14 +0100
Message-Id: <20221130180547.514210540@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zhang Changzhong <zhangchangzhong@huawei.com>

[ Upstream commit 9a234a2a085ab9fd2be8d0c1eedfcd10f74b97eb ]

If prestera_port_sfp_bind() fails, unregister_netdev() should be called
in error handling path.

Compile tested only.

Fixes: 52323ef75414 ("net: marvell: prestera: add phylink support")
Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Link: https://lore.kernel.org/r/1669115432-36841-1-git-send-email-zhangchangzhong@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/prestera/prestera_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_main.c b/drivers/net/ethernet/marvell/prestera/prestera_main.c
index a0ad0bcbf89f..9f588ecba93e 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_main.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_main.c
@@ -730,6 +730,7 @@ static int prestera_port_create(struct prestera_switch *sw, u32 id)
 	return 0;
 
 err_sfp_bind:
+	unregister_netdev(dev);
 err_register_netdev:
 	prestera_port_list_del(port);
 err_port_init:
-- 
2.35.1



