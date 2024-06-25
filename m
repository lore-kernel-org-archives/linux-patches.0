Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72407146A67;
	Tue, 25 Jun 2024 09:52:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719309136; cv=none; b=VbcJ3PUCqGbzwN8E3Ya6ji7KHGIdxbLkRbzU0mt7D3N1TwWjgbn2EN+jcmMw4At3lj6h2LcqPQ8EnLdnUyuZp9qdytjoWzinmtXrni7JaW52QTCVZcNDdyX3dzRMgI/pzQ/aPrsD9p5rh8LfY/M6j5Z+ObUaRwIP/nussF83MHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719309136; c=relaxed/simple;
	bh=YW5Xnw945sRX88uJqvpYgzn6sjM4RzXdCzVCPFpifRI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KyBRORU16vqSyZ66rHKMSCJKiwmVOb4IOgRP88JCiJxIDoq7RPcaQEUrKXPzQiptTXd7iAw7aCaCQqC7cWmn58PXXb2e7rMuivgCUpUqmSq9/sRoO/+uHvDcQa8kTUpp++onOM9mJLH+f0zsMlOMckydIYIKv2S820HDyEndtLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hbiXdOuG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hbiXdOuG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E26B4C32781;
	Tue, 25 Jun 2024 09:52:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719309136;
	bh=YW5Xnw945sRX88uJqvpYgzn6sjM4RzXdCzVCPFpifRI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hbiXdOuG3044d3dQrxqzgw79bRl4oAYbYscNp7kPyGYm93F1aaQgJ+OKXVxAJcsDJ
	 hYqlYAOghd7jcA2o31FV7G0e4PLGdlgIWFJHvyF9S6dQWuZ74K4aOa+z6g9tyyR/HF
	 ALxY4If002f+r0m7k0WQG/opGeOFzGx71GB0z3uU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 107/192] regulator: core: Fix modpost error "regulator_get_regmap" undefined
Date: Tue, 25 Jun 2024 11:32:59 +0200
Message-ID: <20240625085541.282040869@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085537.150087723@linuxfoundation.org>
References: <20240625085537.150087723@linuxfoundation.org>
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

From: Biju Das <biju.das.jz@bp.renesas.com>

[ Upstream commit 3f60497c658d2072714d097a177612d34b34aa3d ]

Fix the modpost error "regulator_get_regmap" undefined by adding export
symbol.

Fixes: 04eca28cde52 ("regulator: Add helpers for low-level register access")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202406110117.mk5UR3VZ-lkp@intel.com
Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Link: https://lore.kernel.org/r/20240610195532.175942-1-biju.das.jz@bp.renesas.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index dfb986377a989..c96bf095695fd 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -3334,6 +3334,7 @@ struct regmap *regulator_get_regmap(struct regulator *regulator)
 
 	return map ? map : ERR_PTR(-EOPNOTSUPP);
 }
+EXPORT_SYMBOL_GPL(regulator_get_regmap);
 
 /**
  * regulator_get_hardware_vsel_register - get the HW voltage selector register
-- 
2.43.0



