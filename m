Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 725D11836EF;
	Wed,  3 Jul 2024 11:08:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004904; cv=none; b=oIVKXwrYX3Sw8EWIiF91CuoIz2aQKR0lIcXkRoK8ADunisYNuFY8GhDuxwvfBdhNsBHOU3nIt4dC3/EOOQx9BnuntOs7okZ3xB1umDZK/tBQfkCcRoP0eSL9l44uekUv6263lBwuvVeMhMae9Ywtlf/h4hPOZVXlkvsb1GKzQ5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004904; c=relaxed/simple;
	bh=s3MbZ8zcz6C2/iZO/afECOIpg6YvztTuzyJwo7hAaMw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qld5p6w7gra6ZBjr9MvoIhy7EVQ9Xz3y+ccxUGfWfxF9rTVGt1JBlmBBuFSSeIXo47JYmz2KYdRsDpSRuRM+Mqg4IH8PfWgAcuZ1UdhRa248YyXcniI4tR4V5KjAEZBzocaG5YgXrf0ybyA3pmb6HMl7qdYxDImk8tj++WObPMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jZrzjRXO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jZrzjRXO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAAC1C2BD10;
	Wed,  3 Jul 2024 11:08:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004904;
	bh=s3MbZ8zcz6C2/iZO/afECOIpg6YvztTuzyJwo7hAaMw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jZrzjRXOfEJ4z/QxMjZbTl9+mJWJhzyNlnPjOH4CreeLdd5hB6iqO/vBytCdWn7+s
	 nsGD3m+ARaEr6Fx1HE7mcvPJ2HCyFas2W+r+EpdkhzDxVRNDPLKj1uzoi442Jw55dM
	 5sURLr/Q5MyYknC1iyQ8fHiphZKJUrGv0eraLvhU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 154/290] regulator: core: Fix modpost error "regulator_get_regmap" undefined
Date: Wed,  3 Jul 2024 12:38:55 +0200
Message-ID: <20240703102909.996810933@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102904.170852981@linuxfoundation.org>
References: <20240703102904.170852981@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 2d1a23b9eae3b..7082cffdd10e6 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -3185,6 +3185,7 @@ struct regmap *regulator_get_regmap(struct regulator *regulator)
 
 	return map ? map : ERR_PTR(-EOPNOTSUPP);
 }
+EXPORT_SYMBOL_GPL(regulator_get_regmap);
 
 /**
  * regulator_get_hardware_vsel_register - get the HW voltage selector register
-- 
2.43.0



