Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23050148319;
	Tue, 25 Jun 2024 10:00:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719309621; cv=none; b=rV/rdv1wY6WyvnOUoTfD3CT/nUiLID/7p+nXPta1puPZsLjaPZcpZhZoWSoEmtygj/OzSLhjsGW31eypKFWxdCmDY87vzbVK+jBtnnF5zG98CqVQzDsEXQKtwkPrzwSFij+1G1AoZP6Ft1br0zP8tuhYaQTH3YTYI8ElR5kM3ow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719309621; c=relaxed/simple;
	bh=qe+W64PwunpHkOjJQCiaRn3JlwXQc6enj1bPrHOROso=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r5k9Hda3ff8U0k0Er7I9j+4suMdI3EzLxRCVAvqVjYQ20JbjG5gKk1ebB3o3bcT+62I4zkUjipKyGjtktAYDe1FSSCHbOmvqIOu/SapeNQ3AEEM2wd/WA9a0KxcENwPSSimO4rvPsoFSbpJrF7xkTP1HpdDsCSA8lcVXtRgAt4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o0CekT7P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o0CekT7P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CAA9C32781;
	Tue, 25 Jun 2024 10:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719309621;
	bh=qe+W64PwunpHkOjJQCiaRn3JlwXQc6enj1bPrHOROso=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o0CekT7PE/4IR+oS6lNK47H1I8imqmsCM2xSgQmVDJraoSuyA1MpGDNHKIydjx6HB
	 7RGmevAvHaJzu6HBVQ+8J64QGxlX1uGFA50xa6GMDsbb7HUY01OSjo+YX7zo6uRh+K
	 V5ilKTvhbuswiNI+4jl9lSpSvAp8m5PVbszS8JGQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 078/131] regulator: core: Fix modpost error "regulator_get_regmap" undefined
Date: Tue, 25 Jun 2024 11:33:53 +0200
Message-ID: <20240625085528.905831566@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085525.931079317@linuxfoundation.org>
References: <20240625085525.931079317@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index ff11f37e28c71..518b64b2d69bc 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -3341,6 +3341,7 @@ struct regmap *regulator_get_regmap(struct regulator *regulator)
 
 	return map ? map : ERR_PTR(-EOPNOTSUPP);
 }
+EXPORT_SYMBOL_GPL(regulator_get_regmap);
 
 /**
  * regulator_get_hardware_vsel_register - get the HW voltage selector register
-- 
2.43.0



