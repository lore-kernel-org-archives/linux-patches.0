Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A34891AB6C9;
	Tue,  3 Dec 2024 15:54:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241267; cv=none; b=RpN5fQCezgc10wJxLNLYFVqua63NB/A6BFJ1DwORjyoWypRxE+b1wEg7pFgHkUJQnC1NVCoJAtFqHgH4DbV41SCgxQ45IJ2DOG23waKhDQi1BBWhkwUC+sx8ZI9/N/XghEdsAkEpRds53ekgV14BKfdPq9UOb3Dwbcpl6oJUVEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241267; c=relaxed/simple;
	bh=puaU0uf+NiGPaoHGq26hrTvzq7SC1sU3bNYNEmq67t0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nJjG7b6rbHR0TU/IU4fIyMCIcYzfp9u5ilwGfQO5cMHurgiZLm34ZnD7djhRAhlU/DHvLLaxlE3EZbtWgyU9fgMAL4ZxKRo37HKmo05NNucmiGJQyY7lAvrwNds1zLBbNc1VTgRxP2b+2/x0trLZRgMNWuVtN28qOab4678otds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HFN/NXGX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HFN/NXGX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 117B0C4CED6;
	Tue,  3 Dec 2024 15:54:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241267;
	bh=puaU0uf+NiGPaoHGq26hrTvzq7SC1sU3bNYNEmq67t0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HFN/NXGXbvz1LDX/TM7s1zoUZKdIx29hk2uDicK8rYk+FGhIXxcMUAPXU2vYXvvhA
	 Kf86t26f4EWdOjbMpmHErYExf6zXjeooBBCagTt2dF0DLcIuqa/V3q/Hv0aiUjxCOR
	 JzqS9fRy7EPFJF0NV695ZGNrLwB0qoCcKrOHGV1g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marcus Folkesson <marcus.folkesson@gmail.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 371/826] mfd: da9052-spi: Change read-mask to write-mask
Date: Tue,  3 Dec 2024 15:41:38 +0100
Message-ID: <20241203144758.236709305@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marcus Folkesson <marcus.folkesson@gmail.com>

[ Upstream commit 2e3378f6c79a1b3f7855ded1ef306ea4406352ed ]

Driver has mixed up the R/W bit.
The LSB bit is set on write rather than read.
Change it to avoid nasty things to happen.

Fixes: e9e9d3973594 ("mfd: da9052: Avoid setting read_flag_mask for da9052-i2c driver")
Signed-off-by: Marcus Folkesson <marcus.folkesson@gmail.com>
Link: https://lore.kernel.org/r/20240925-da9052-v2-1-f243e4505b07@gmail.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/da9052-spi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/da9052-spi.c b/drivers/mfd/da9052-spi.c
index be5f2b34e18ae..80fc5c0cac2fb 100644
--- a/drivers/mfd/da9052-spi.c
+++ b/drivers/mfd/da9052-spi.c
@@ -37,7 +37,7 @@ static int da9052_spi_probe(struct spi_device *spi)
 	spi_set_drvdata(spi, da9052);
 
 	config = da9052_regmap_config;
-	config.read_flag_mask = 1;
+	config.write_flag_mask = 1;
 	config.reg_bits = 7;
 	config.pad_bits = 1;
 	config.val_bits = 8;
-- 
2.43.0



