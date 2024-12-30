Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14140537E9;
	Mon, 30 Dec 2024 15:50:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735573808; cv=none; b=P0xZEaPJEpqLgr/dub66MCzpLO5jSRDrryvcs1wCVfaAsWpn2Hxd0B7WCoqfcRsfPHAzXGkLHfnUpxpjEU5W0BcqG3VGhoduTzI0uHondNHVBH5TGN5Lg0dDOqD5BpxlexiVvPGZ0LrtEe9vQcZhnrBxeYTuDLNomlfPNRdquN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735573808; c=relaxed/simple;
	bh=Zbm8yqghCU+RyctjZJUd8yvzqAP2HAakTvPvY0g8Vng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aqNl/Ylj2COvD2A7uF7TzuFQX/dd9qjXlqZHDVh1C+NX50vESo/6e5Y6NVoq4t0AcdC2KzdShdexOTK5wjoL4VsgUIN67sBN7RbP2agU7vgoYsG41pdhx2ML3eBnQLIeEoQxwfG4YwLBLH5L2Fq4suRvpdBhz/nR0XvJRKVoquo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2B6GyAeI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2B6GyAeI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84B03C4CED0;
	Mon, 30 Dec 2024 15:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735573807;
	bh=Zbm8yqghCU+RyctjZJUd8yvzqAP2HAakTvPvY0g8Vng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2B6GyAeItq9TvsBhQI8TAmegYYaQa2ZbarbbEpq/x8DdMX2Qdg6C4J9X1OftHCNN+
	 gkpbs6bBEtsPeweVXcVDkeMLa3FBipU0wUMuGKtUxXsHCxieRfmHuZOcF6i28mYdUW
	 z3zWypd/zRIZmBQ5ZeVF1Sf1E1vdrfDfJM4I7kn8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 40/86] regmap: Use correct format specifier for logging range errors
Date: Mon, 30 Dec 2024 16:42:48 +0100
Message-ID: <20241230154213.239742417@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154211.711515682@linuxfoundation.org>
References: <20241230154211.711515682@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 1db04886def6..3011f7f9381b 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -1062,13 +1062,13 @@ struct regmap *__regmap_init(struct device *dev,
 
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



