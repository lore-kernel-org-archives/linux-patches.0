Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 043921E3DF9;
	Tue,  3 Dec 2024 15:12:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238754; cv=none; b=bLwyYsJuRnJ90kiHHll4hO/9U9xQOrMlJltGd27zPrwRzhrFmAZcehVScstsq9VSSQlXFAprAaEIpBQJME2FWKyjpddQI294QfrJmt1n8bM3qPEQalNK6mFugZlQ8tGWrh0zDhhAddFj9Cvjnm02aIK2K/orfasNCMyWqaPGmjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238754; c=relaxed/simple;
	bh=wRG26OxrXHMt4k4DJ0auu5dpn4lmQaprRpkkc0SxVb4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uRM6we+MfKJLUGaXAXSkLy2HOxGQ5WGhEfmiOztiI2oKh74cB09QG8K7MTSIqQQpiK8+AwWCgDP5vQFTOYkPzUI6CO5UsXl2+W2lXK6B8jpTDx34Ms54/eOOC0UCvZ342m9CWheA+VyuZVEqNuEjHvWHWyQ1KDGCZekdfsdLrsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MWccPuyJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MWccPuyJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 811F9C4CECF;
	Tue,  3 Dec 2024 15:12:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238753;
	bh=wRG26OxrXHMt4k4DJ0auu5dpn4lmQaprRpkkc0SxVb4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MWccPuyJJI01memIQZTgyIsmzyB4EwFh7d/Rowlf0f5o89robAA3jF6iERx/rnReW
	 uVtsZiTO5+Y3p7vPv4WVWxtvv6PpPMxsH+LryO7iW0ZnrAlU4gwxzqCbzgpOG9A6Qs
	 wVmo9rIjvgnJW/QzBDtXRx93XIjThgjGNdRW2zho=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marcus Folkesson <marcus.folkesson@gmail.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 387/817] mfd: da9052-spi: Change read-mask to write-mask
Date: Tue,  3 Dec 2024 15:39:19 +0100
Message-ID: <20241203144010.977648238@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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



