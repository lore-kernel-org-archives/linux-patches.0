Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECB58157E8B;
	Wed,  3 Jul 2024 10:54:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004078; cv=none; b=ZPUM4ZYITg9c/6CzgWsBujf3gHVwKlvY201V5Xkl4QKGr4bx5wtIm51Ksts7+CFcIitD7uZfvUf38v3wi3QzjtC3ncjJcj5JGPIEFb7WTwz/66obZrP1du8bg2Y2m4kmYKfuSDGLDmeiVoirXRTDelWVr0K/l/75qjdsZYqxiU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004078; c=relaxed/simple;
	bh=95d/C0eQMR88frAvyGiXSb3eNpz8WKfNG165HpDgFNM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mlBzaR6qoxOsPlEWNaogVhmJv343ayBzD7/tYC9RyVGIK1eXxW4XnjRsj6ndf06DaEMMTOSZwEt4apZtlzCIC999n/ZIPNbAOAXYkhOLhxRR8z6P0TsQrMSRI6mhXPZgNU1t6DFVzti1jCAm6qxFJ1P4VgecwCIomRCHX76mDnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LNQx6f9f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LNQx6f9f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ECFFC2BD10;
	Wed,  3 Jul 2024 10:54:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004077;
	bh=95d/C0eQMR88frAvyGiXSb3eNpz8WKfNG165HpDgFNM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LNQx6f9fK5Jpokq1eqygheDPVWjCTN3qFiiZY0jc5M2ObuGDn1hNckU53JbZ/LqFj
	 CYs7iQsCEQ9wFDBmPouxSlfTNs/HPIC4ZapbvcdNo1l08IaP/ooqqg3bNe4pHUXPvS
	 iowyeLymt009Djopq4aqbqB2wIyEAfW0XDd6BaVI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 114/189] regulator: core: Fix modpost error "regulator_get_regmap" undefined
Date: Wed,  3 Jul 2024 12:39:35 +0200
Message-ID: <20240703102845.802014653@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102841.492044697@linuxfoundation.org>
References: <20240703102841.492044697@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 5c50e7add5779..a01a769b2f2d1 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -3074,6 +3074,7 @@ struct regmap *regulator_get_regmap(struct regulator *regulator)
 
 	return map ? map : ERR_PTR(-EOPNOTSUPP);
 }
+EXPORT_SYMBOL_GPL(regulator_get_regmap);
 
 /**
  * regulator_get_hardware_vsel_register - get the HW voltage selector register
-- 
2.43.0



