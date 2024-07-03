Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71D4A7CF1F;
	Wed,  3 Jul 2024 10:45:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720003526; cv=none; b=unss7FNd/AFZ9gZ6s+sTIPNNrVM8Ubz1v6V13ETgMxr0mrS4sIwSCxODmacqetUc1X6kdKRKuKOOxV81fBJjLKnUhm9D2pQ7gUP0Wkh7pbLwPcYBjg1iNDMDIOQqwbTZITRB7h3zwQjtOfuNmBggyaUnG9WK8BeYT1eu2bmddN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720003526; c=relaxed/simple;
	bh=fNray+cyU8KcSJNxyMCBUyVJGS1G2X7TZs7kjym5fl8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z4dA9HcoWFAuqn+J44DzqsaguMo2jLlrWooocsvmzOHftZpbvtJiQyvOkOSZ8irVBHTfazM7WmVg8pCtiw2SAkDtb9JqVnI8y+umeOWFH6p3c0fy8bxnX1a6rofzP0y3katpGU/hEl5XdZyQwdG5OmA5YfhiU/qlVS4fUuVgGvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J72wYiL2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J72wYiL2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFC2BC2BD10;
	Wed,  3 Jul 2024 10:45:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720003526;
	bh=fNray+cyU8KcSJNxyMCBUyVJGS1G2X7TZs7kjym5fl8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J72wYiL2/JBO9IuJxlqkO0G5C/XRBk481AsTyKc27dGNNM/Ho+wAnnAmj3M++cAxR
	 VMPRIwGoEouq4vgD3QPiEWuRVzJddFAwAFuNc95Th/O1DGCviEqttp3FddH7GqapA5
	 E21H77d+LGFL+oudpVUOBZZjWlB7rxcfz6FqJD80=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 077/139] regulator: core: Fix modpost error "regulator_get_regmap" undefined
Date: Wed,  3 Jul 2024 12:39:34 +0200
Message-ID: <20240703102833.348705542@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102830.432293640@linuxfoundation.org>
References: <20240703102830.432293640@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 14f9977f1ec08..6831ce0ae49dd 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -2710,6 +2710,7 @@ struct regmap *regulator_get_regmap(struct regulator *regulator)
 
 	return map ? map : ERR_PTR(-EOPNOTSUPP);
 }
+EXPORT_SYMBOL_GPL(regulator_get_regmap);
 
 /**
  * regulator_get_hardware_vsel_register - get the HW voltage selector register
-- 
2.43.0



