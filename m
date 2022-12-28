Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D31711863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:44:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59CE7C433D2;
	Wed, 28 Dec 2022 15:44:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672242288;
	bh=XLg79VMhhZqbJHjNnjLkcFP55YOPi1edZZ8B3rmu09A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=apb2U9XFvGvdNVe98kbcgS4ZKpL6NY+OrBVV7RzZX6IGE8Zt+qU8mBdHncPcEhkBB
	 sE2aomHKofPVz6Qzq0ilJvZKnmemuihvq6iQ0tZNcrpVCNif+8EV+4mZ6QOnvxduLb
	 0jVTbM0XGf4KGk5xbQitEgBtCyyoFa6LdRmRD4L8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang ShaoBo <bobo.shaobowang@huawei.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0365/1073] regulator: core: use kfree_const() to free space conditionally
Date: Wed, 28 Dec 2022 15:32:33 +0100
Message-Id: <20221228144337.915987771@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Wang ShaoBo <bobo.shaobowang@huawei.com>

[ Upstream commit dc8d006d15b623c1d80b90b45d6dcb6e890dad09 ]

Use kfree_const() to free supply_name conditionally in create_regulator()
as supply_name may be allocated from kmalloc() or directly from .rodata
section.

Fixes: 87fe29b61f95 ("regulator: push allocations in create_regulator() outside of lock")
Signed-off-by: Wang ShaoBo <bobo.shaobowang@huawei.com>
Link: https://lore.kernel.org/r/20221123034616.3609537-1-bobo.shaobowang@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index afd17b13de7c..b7e7eec1084e 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1795,7 +1795,7 @@ static struct regulator *create_regulator(struct regulator_dev *rdev,
 
 	regulator = kzalloc(sizeof(*regulator), GFP_KERNEL);
 	if (regulator == NULL) {
-		kfree(supply_name);
+		kfree_const(supply_name);
 		return NULL;
 	}
 
-- 
2.35.1



