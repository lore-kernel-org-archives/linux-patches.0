Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14D0A46B5
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:14:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BBD5C433EF;
	Mon, 16 Jan 2023 16:14:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673885682;
	bh=TIE2sObVWWJA3hlPG4oaNLsrf4hsiGg54YPFUHuWiKQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z4JEDLMww+qEtdvIU27e7AjP2rgU2OpBY09MkTFYfwNIZqGm7x1lDy9S4+seZmz8K
	 NildchSkd6uLomQ2r7LDTUMAcc9hQ0p6bR10/fRf54uXOZShlspgxdhG05rlHw8Y6q
	 FcOkudq+HuzhEcefgLeA2F+f6oT/CcijjCSaWECs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang ShaoBo <bobo.shaobowang@huawei.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 144/658] regulator: core: use kfree_const() to free space conditionally
Date: Mon, 16 Jan 2023 16:43:52 +0100
Message-Id: <20230116154916.047272279@linuxfoundation.org>
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
index ee71dcb009bf..9b4783bf63f7 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1604,7 +1604,7 @@ static struct regulator *create_regulator(struct regulator_dev *rdev,
 
 	regulator = kzalloc(sizeof(*regulator), GFP_KERNEL);
 	if (regulator == NULL) {
-		kfree(supply_name);
+		kfree_const(supply_name);
 		return NULL;
 	}
 
-- 
2.35.1



