Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 541FF13AC4
	for <patches@lists.linux.dev>; Mon, 26 Jun 2023 18:29:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3DD7C433C0;
	Mon, 26 Jun 2023 18:29:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687804195;
	bh=OzeipN3I+iR/9kL2cyXVLietlRx4UE/bzV8CPzpaz8w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LHUslleeT07jukepzx0J/2PyovbJYNubukWdFrDJl5xgB41PUoCd/swcy56fg6z7H
	 /vWwfS+ks9/GWUjtAHsLM+Hnyw0DC0AMbOM5yaORa1qk6kBMxwXnUBRQV8xbfG7H0R
	 BYCYb/z0gD21Qfr1pXXC8gx0COhWS3EqUPkdniKE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Teresa Remmet <t.remmet@phytec.de>,
	Frieder Schrempf <frieder.schrempf@kontron.de>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 073/170] regulator: pca9450: Fix LDO3OUT and LDO4OUT MASK
Date: Mon, 26 Jun 2023 20:10:42 +0200
Message-ID: <20230626180803.914411253@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230626180800.476539630@linuxfoundation.org>
References: <20230626180800.476539630@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Teresa Remmet <t.remmet@phytec.de>

[ Upstream commit 7257d930aadcd62d1c7971ab14f3b1126356abdc ]

L3_OUT and L4_OUT Bit fields range from Bit 0:4 and thus the
mask should be 0x1F instead of 0x0F.

Fixes: 0935ff5f1f0a ("regulator: pca9450: add pca9450 pmic driver")
Signed-off-by: Teresa Remmet <t.remmet@phytec.de>
Reviewed-by: Frieder Schrempf <frieder.schrempf@kontron.de>
Link: https://lore.kernel.org/r/20230614125240.3946519-1-t.remmet@phytec.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/regulator/pca9450.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/regulator/pca9450.h b/include/linux/regulator/pca9450.h
index 3c01c2bf84f53..505c908dbb817 100644
--- a/include/linux/regulator/pca9450.h
+++ b/include/linux/regulator/pca9450.h
@@ -196,11 +196,11 @@ enum {
 
 /* PCA9450_REG_LDO3_VOLT bits */
 #define LDO3_EN_MASK			0xC0
-#define LDO3OUT_MASK			0x0F
+#define LDO3OUT_MASK			0x1F
 
 /* PCA9450_REG_LDO4_VOLT bits */
 #define LDO4_EN_MASK			0xC0
-#define LDO4OUT_MASK			0x0F
+#define LDO4OUT_MASK			0x1F
 
 /* PCA9450_REG_LDO5_VOLT bits */
 #define LDO5L_EN_MASK			0xC0
-- 
2.39.2



