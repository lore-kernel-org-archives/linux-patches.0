Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D00A1514F6;
	Mon,  6 Jan 2025 15:44:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178271; cv=none; b=YxyyDUSVtF6MAPe+pwCak4iMG11c798KZX+TIKc6LFvAn/+BL55MuFH3v4an9+1P2RYFmxN+vJZPkdiM/+W95z+y5UIVJ5cQLw+JYOkR8Vzri2YaqFn/Ea1uYiUiS2fxWtWlT2ZoSX1JiYMqHW24cpbpgl1LMGmh6n22IA5o0Mo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178271; c=relaxed/simple;
	bh=BffO8B9F7c1D85ahwXMJeqgJq4ost+vhgmTs2yViyvs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F+vFlkqCnvrlYIDjDFMHjB/+N7GBLtsjkzz07m+JOb0N/NeNozXR1qh5ul/gWXMIUJtqh+wQfMBnTAuSXCdXxyTE0ljbbn3pmQ/ltRx/TGYGhKjnH+/8FPYn+6ueKVeLc7ZVnMIgYnfHGfgRzgqgdshkj5fG75BEc6s8VXiD1Bs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QNeAzX1n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QNeAzX1n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89A8AC4CED2;
	Mon,  6 Jan 2025 15:44:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178270;
	bh=BffO8B9F7c1D85ahwXMJeqgJq4ost+vhgmTs2yViyvs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QNeAzX1ncEXCB889TEO3uTdHEcLHm1VV11s0hZC4Mm3gKSmZT7ti/8D8Fir3XDofc
	 la4VwxKrFk1LmdI9EfgegZD3jeeZU4nu9cNporDrjipGkP7bjCxaQu4OFVhcm9QqrX
	 VdbBwoJI8dMwBdD9coHswOxDj9e1e+cg3UVI3a74=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 063/138] regmap: Use correct format specifier for logging range errors
Date: Mon,  6 Jan 2025 16:16:27 +0100
Message-ID: <20250106151135.620765521@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151133.209718681@linuxfoundation.org>
References: <20250106151133.209718681@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Mark Brown <broonie@kernel.org>

[ Upstream commit 3f1aa0c533d9dd8a835caf9a6824449c463ee7e2 ]

The register addresses are unsigned ints so we should use %u not %d to
log them.

Signed-off-by: Mark Brown <broonie@kernel.org>
Link: https://patch.msgid.link/20241127-regmap-test-high-addr-v1-1-74a48a9e0dc5@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/regmap/regmap.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index ccf002c536fb..fb463d19a70a 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -1115,13 +1115,13 @@ struct regmap *__regmap_init(struct device *dev,
 
 		/* Sanity check */
 		if (range_cfg->range_max < range_cfg->range_min) {
-			dev_err(map->dev, "Invalid range %d: %d < %d\n", i,
+			dev_err(map->dev, "Invalid range %d: %u < %u\n", i,
 				range_cfg->range_max, range_cfg->range_min);
 			goto err_range;
 		}
 
 		if (range_cfg->range_max > map->max_register) {
-			dev_err(map->dev, "Invalid range %d: %d > %d\n", i,
+			dev_err(map->dev, "Invalid range %d: %u > %u\n", i,
 				range_cfg->range_max, map->max_register);
 			goto err_range;
 		}
-- 
2.39.5



