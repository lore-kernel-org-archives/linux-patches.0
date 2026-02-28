Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25533379EEC
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:05:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301905; cv=none; b=hmMdX5npmfC2+ZS6rE8y9GT8VO40jdiDlKbUtn3/3kBxVgvGHI0R0AMIi5pbbTaNsrPrmYDPWNlhScGCQbLcGn9LYqbw4gZxCdYAKBk+yQWIWohoIUc+tFznFQdmoJNqy1fivUgXNkp/51/H87m7UbqQ4L57PsNF1sEd5TcVycw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301905; c=relaxed/simple;
	bh=8Y006eOZ2jWLMdM+TYM+PyMhrjDT5ouh9nm3g16If94=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VYaKCVFbB/DoUGtzKyx2SQoDBXGCHVKyFthnIjLHnuupWwiY84wLF3djk8ri84aLerrcFWb6MKNTs8ofivCAYtw6nciOZ6ER+xXyABTuKcAsgBr3VQgGCw6Tf+WgoC5+tuZtWlDYZvTlLtMQXZmeFWXiHPWcrJ6Hb/TiePvqqm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aNUJPUg5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aNUJPUg5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 715B7C116D0;
	Sat, 28 Feb 2026 18:05:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301905;
	bh=8Y006eOZ2jWLMdM+TYM+PyMhrjDT5ouh9nm3g16If94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aNUJPUg5GazW4tS5pRLR34ueF0zWTF4A4IY61/zs4RNFBwqeB4ssNqLn8DK/dwCik
	 mw0FmZ7J/CgBa65bx1kmcNnJ4d5amyFxUJhctl+969OvEZhaoCaClv6SmIpQIFfIDo
	 DV/Jjd1HeexTvSRc9jIQXoodrpUCJyG7C8ayKMBhD6RA+39YIqSiO4qot5jIqd7O8l
	 w8A7JBIemWgSu+4USjxNEJgxEuWYMjTLUkZ7rTO1nQ7BKtMLEpsMHwhbaBKLJoqnEH
	 tc2krhejL9ZTLNNT1b/eXikSwQIhF5S9vfADYk0UsGYvSsllHKGnPMGn1CmaLTH6Z0
	 TwB5Rvy2DLbLA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Matthew Schwartz <matthew.schwartz@linux.dev>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 335/385] Revert "mmc: rtsx_pci_sdmmc: increase power-on settling delay to 5ms"
Date: Sat, 28 Feb 2026 12:59:17 -0500
Message-ID: <20260228180011.1568201-335-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

[ Upstream commit ff112f1ecd10b72004eac05bae395e1c65f0c63c ]

This reverts commit aced969e9bf3701dc75cfca57c78c031b7875b9d.

It was determined that this was not the correct "fix", so should be
reverted.

Fixes: aced969e9bf3 ("mmc: rtsx_pci_sdmmc: increase power-on settling delay to 5ms")
Cc: Matthew Schwartz <matthew.schwartz@linux.dev>
Cc: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/rtsx_pci_sdmmc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mmc/host/rtsx_pci_sdmmc.c b/drivers/mmc/host/rtsx_pci_sdmmc.c
index f5bc757ddaa27..04aa47f1a24fb 100644
--- a/drivers/mmc/host/rtsx_pci_sdmmc.c
+++ b/drivers/mmc/host/rtsx_pci_sdmmc.c
@@ -939,7 +939,7 @@ static int sd_power_on(struct realtek_pci_sdmmc *host, unsigned char power_mode)
 	if (err < 0)
 		return err;
 
-	mdelay(5);
+	mdelay(1);
 
 	err = rtsx_pci_write_register(pcr, CARD_OE, SD_OUTPUT_EN, SD_OUTPUT_EN);
 	if (err < 0)
-- 
2.51.0

