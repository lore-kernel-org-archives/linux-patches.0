Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16B1142DFFA
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:53:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301184; cv=none; b=BurVTFbNMN1cQlTEDoK2C3tDzsZefgl+BHDDLdViaTlBeGto8ivf3pLYy50IP8La9jABpizUgCby0uUFmX9x4sgXNQAitpSpvLK57Hy9k3kTRI8yD9BuwrChgCA/zrDe4Ky1IzMyVex9Wc+Al4FxVB+McllUBQQelJKMx4ELcLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301184; c=relaxed/simple;
	bh=Z/bdLUj1wqj9sxsuaIVpV0P7vtGpNZAyjM/rPm9AFew=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oEZaG7BcsX1S7ILOq2DOiCt0VYdDnAryjzeM3r2ebvV3y9DKDSiSRGkTNCDakPZu0FDe04hUyMtE6rAi+Pa+ouU9GaNL9wqhyeV1t9mGRZG4WLoLmMIBpftuz1IKAV5eNFJpH+PFDdZtF5HQnKvkIM8UYNo8NsQXg72bqP1piuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=o5NHg9pg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="o5NHg9pg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79A4DC116D0;
	Sat, 28 Feb 2026 17:53:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301184;
	bh=Z/bdLUj1wqj9sxsuaIVpV0P7vtGpNZAyjM/rPm9AFew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o5NHg9pg44W2Ylu6qdQYh9qo4+fwOPSuCFTET/faVB9lm913LBNNojPziUN6TUrFD
	 sB4EscTozF6WI2Fm3pteaPTdajGI6Y6HPiH8Z2ZwyjxPd+plefFkMiN7hBTUeSVTB1
	 LUlZ47BXvTe6EozVhln4cBHzgH59BTBctmwwskmnPdZ40AXGugz1CaQSReInjENUXF
	 yR5Vf6xCEDOQ5aCAvMR104fAePsdCR/btt5pcGM3NiW4un+V6xOCjnYWt9kAsteeZb
	 wY+L4/casaZQ09OegcG58bLaSp6yaM7HpxOVo7mJ66JGkNq84aMNj7LYOCiyt70/qa
	 d70HoqqTPmPgg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Marcus Folkesson <marcus.folkesson@gmail.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 353/752] Revert "mfd: da9052-spi: Change read-mask to write-mask"
Date: Sat, 28 Feb 2026 12:41:04 -0500
Message-ID: <20260228174750.1542406-353-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Marcus Folkesson <marcus.folkesson@gmail.com>

[ Upstream commit 12daa9c1954542bf98bb942fb2dadf19de79a44b ]

This reverts commit 2e3378f6c79a1b3f7855ded1ef306ea4406352ed.

Almost every register in this chip can be customized via OTP
memory. Somehow the value for R19, which decide if the flag is set
on read or write operation, seems to have been overwritten for the chip
the original patch were written for.

Revert the change to follow the default behavior.

Signed-off-by: Marcus Folkesson <marcus.folkesson@gmail.com>
Link: https://patch.msgid.link/20251124-da9052-revert-v1-1-fbeb2c894002@gmail.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/da9052-spi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/da9052-spi.c b/drivers/mfd/da9052-spi.c
index 80fc5c0cac2fb..be5f2b34e18ae 100644
--- a/drivers/mfd/da9052-spi.c
+++ b/drivers/mfd/da9052-spi.c
@@ -37,7 +37,7 @@ static int da9052_spi_probe(struct spi_device *spi)
 	spi_set_drvdata(spi, da9052);
 
 	config = da9052_regmap_config;
-	config.write_flag_mask = 1;
+	config.read_flag_mask = 1;
 	config.reg_bits = 7;
 	config.pad_bits = 1;
 	config.val_bits = 8;
-- 
2.51.0

