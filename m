Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1770718C35D;
	Wed,  3 Jul 2024 11:23:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005820; cv=none; b=mhAqPLs37Wn1IYofye9mpvNDF8zINmNGDz8ev4SonjxQWl33zU8PgRWoV02Fta0dQv9KOPhdnq+dcW0lzsS80cvqkSip0MLLTaSUgQfaL0JH9bo1DuwGV7iEr409y0KS/Dc+R7R+K2MgFc5zlwHTWJ1rVH0DhPZKHaYFMwgrEwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005820; c=relaxed/simple;
	bh=MKX4Lv0MXlZEPjLFYMh3gBkhQ75SR4PQdNq9v5KFfMI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bSMZVTtt5pKwRbS7Z4FbKr3sHfoBCCXnoKWWHxQmcH4rqWgFaF48nKrgRI14SL0+axsk+mWgg8Sm1dCQbYFvi2Qlb9y47Tj36EZidmnSvO5dnVzN+F9IAIvp6IDdo+uWeafB4Ld4/4JA0sb/a+GlEyXCBFQ2saCbMSrE55B5iuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kZMm3HCy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kZMm3HCy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94A74C2BD10;
	Wed,  3 Jul 2024 11:23:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005820;
	bh=MKX4Lv0MXlZEPjLFYMh3gBkhQ75SR4PQdNq9v5KFfMI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kZMm3HCyfB5EZvIG4iV6OKXyqehmsnAXarNLcsn/XvUuhkv+OEQblPMwK1jwTCmfZ
	 SdbFPnzp9a/o9CACU4keokwcf35Cn3SjpKMK8tagU8MJ/Bu49ClkjsYNXyXsXxGqO8
	 wAqJWp/cbAxIFXlBln1vwGfo8BZjMr+p91LjaiK8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 206/356] regulator: core: Fix modpost error "regulator_get_regmap" undefined
Date: Wed,  3 Jul 2024 12:39:02 +0200
Message-ID: <20240703102920.899892904@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index d6febb9ec60d9..879f4a77e91db 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -3297,6 +3297,7 @@ struct regmap *regulator_get_regmap(struct regulator *regulator)
 
 	return map ? map : ERR_PTR(-EOPNOTSUPP);
 }
+EXPORT_SYMBOL_GPL(regulator_get_regmap);
 
 /**
  * regulator_get_hardware_vsel_register - get the HW voltage selector register
-- 
2.43.0



