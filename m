Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE5DA1EE02B;
	Tue, 12 Nov 2024 10:35:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407723; cv=none; b=NI8mc4JHL1oAYAxKnYOTUJLGdlXABWux6/CSztsMZ8GtKlL7W1+f8KM8ISuSIRzYEYmiciDDWFKwUQzrqYxlWS0HG1YZAqgnwkgiR1icupArQCyKRbjzXEaU+NTS4St/OpWY0uUZlbtGg/DkmlHmkhkhpLN4P99JBx7z/rh5x5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407723; c=relaxed/simple;
	bh=iow3Sfsbtozb1yVMMVJqdZuCeakqV6F163VjRbm4p70=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OixBBXKheJTIWX2VEbYfusEpoKfJ6pwtDX30B3vgzZk4l8qBuf2BDJa6Wcj9Busy/sOFK2jV2aX8v6oHcbeDUERmLG32hHgaaj+stJwQA8AJFjkK3ECwFB4YeB9PC9HFfTaAti9tEo/ZU9YXHZBni4l+ofGwpC+hogIbsF3ZRiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pb18rXju; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pb18rXju"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61B38C4CECD;
	Tue, 12 Nov 2024 10:35:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407722;
	bh=iow3Sfsbtozb1yVMMVJqdZuCeakqV6F163VjRbm4p70=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pb18rXjueE+GFraJ10zB072hyJ9OmrzFkhn/67LLxVBQo7za11LOrzB8SWkIqEWRM
	 filtHVMP74nxxrLogaIMfj7Wyt6ZcsRp+oeOlcA78kEpAU/gSMbcBM8xspouk98XZs
	 JpBSBfq5ietTeE53buPvnpq5Uffzc1K0tbKHl27E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ChiYuan Huang <cy_huang@richtek.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 030/119] regulator: rtq2208: Fix uninitialized use of regulator_config
Date: Tue, 12 Nov 2024 11:20:38 +0100
Message-ID: <20241112101849.865476857@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101848.708153352@linuxfoundation.org>
References: <20241112101848.708153352@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: ChiYuan Huang <cy_huang@richtek.com>

[ Upstream commit 2feb023110843acce790e9089e72e9a9503d9fa5 ]

Fix rtq2208 driver uninitialized use to cause kernel error.

Fixes: 85a11f55621a ("regulator: rtq2208: Add Richtek RTQ2208 SubPMIC")
Signed-off-by: ChiYuan Huang <cy_huang@richtek.com>
Link: https://patch.msgid.link/00d691cfcc0eae9ce80a37b62e99851e8fdcffe2.1729829243.git.cy_huang@richtek.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/rtq2208-regulator.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/rtq2208-regulator.c b/drivers/regulator/rtq2208-regulator.c
index 2d54844c4226b..e05531c8c0298 100644
--- a/drivers/regulator/rtq2208-regulator.c
+++ b/drivers/regulator/rtq2208-regulator.c
@@ -513,7 +513,7 @@ static int rtq2208_probe(struct i2c_client *i2c)
 	struct regmap *regmap;
 	struct rtq2208_regulator_desc *rdesc[RTQ2208_LDO_MAX];
 	struct regulator_dev *rdev;
-	struct regulator_config cfg;
+	struct regulator_config cfg = {};
 	struct rtq2208_rdev_map *rdev_map;
 	int i, ret = 0, idx, n_regulator = 0;
 	unsigned int regulator_idx_table[RTQ2208_LDO_MAX],
-- 
2.43.0



