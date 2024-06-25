Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96EE912EBEA;
	Tue, 25 Jun 2024 09:42:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308524; cv=none; b=UjKzB+lbw5xdKI9QUMUgOGQDNYRgvx483l0d2GTirOfXSayzxdGxw2+8ZL+lCEdwX5vXlBz3V9IYmGzYaYPfO8vvzozgfuHdP/c5+nKIZJIpsiKxG/nwH+hgmIc0ONXHIIW9l+MBBe7kaL66xJCqMtyhC7Spuu3l5Ru3ZuYyldU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308524; c=relaxed/simple;
	bh=5QVU2hS60m+gpytyOqYN19PMm5QdiZvuEYSC/keHvDk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S3pLHY+ChVilxBVaBbzdVXwt+JSP5ygFhWNuqu3znyFbdVILAYI9NNE7bwnBbQvJ8zxOPHJc8wJO2heL2v7B6L9sEamExY5lTyBokGVH24vqqytY2VPOWAgIxg+v315bmmCC9EI1lnd5N8ZbgGM8gbhPLFA2dv869+UXwEsBYtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d0z/DXo9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d0z/DXo9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1ADC2C32781;
	Tue, 25 Jun 2024 09:42:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308524;
	bh=5QVU2hS60m+gpytyOqYN19PMm5QdiZvuEYSC/keHvDk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d0z/DXo9NLO7/RWejLBBsNoj9bPB2X9In//QNlsn1uZ6+Mhl46E26X5lrozGt9RIz
	 /KK1OSCt+cNMOZepAcpAH4rbsUjdvaXiAkfTYLWIEjed8MR7zoyJODlFG+5o1ipHnN
	 OATFnlalkSAAFOcpGS2OrGU9ewptSygzgrQo2QcI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 150/250] regulator: core: Fix modpost error "regulator_get_regmap" undefined
Date: Tue, 25 Jun 2024 11:31:48 +0200
Message-ID: <20240625085553.815414121@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085548.033507125@linuxfoundation.org>
References: <20240625085548.033507125@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index 2c33653ffdea3..51ff3f9eafd0e 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -3347,6 +3347,7 @@ struct regmap *regulator_get_regmap(struct regulator *regulator)
 
 	return map ? map : ERR_PTR(-EOPNOTSUPP);
 }
+EXPORT_SYMBOL_GPL(regulator_get_regmap);
 
 /**
  * regulator_get_hardware_vsel_register - get the HW voltage selector register
-- 
2.43.0



