Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 826BA346FA0
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:10:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302226; cv=none; b=t+Sj89V+oFXR3rMHrr8K91ak4wjdYHUyrnbOI3/aGFU3g/66MnWoF3zqP+QE3XxzImaTYH7m8qRgKaaHQ9Ci6NtE23TycN/94osb5M5HdY+ldPhYv+xQaJzJcsEXOvOlx2v30oDtrWyeR642jT9dZJgwbfAOO+ewOtjXaTNX+gM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302226; c=relaxed/simple;
	bh=4n8ZkTkKsJFjMVrb1ySlwpYbxD4b4D9iY76TyUOMUNM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iXaZtNkYmwgEFU8fBx3zlDdW38XIhoY+LiScqK3qzTP1CDO7RP0DfP7ErV6nBM9X9I4DUeNdbEwCvdJht3zFtCGUXa1BNkAjC6FnREhdlAEy3Q9DVuAd6gehFj7ZZB8lvEA8GFxTIPCzmkagcf77WnIQa3Vp5SVRmxYM0XMZDS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oPuJu5Fp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oPuJu5Fp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D255EC19423;
	Sat, 28 Feb 2026 18:10:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302226;
	bh=4n8ZkTkKsJFjMVrb1ySlwpYbxD4b4D9iY76TyUOMUNM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oPuJu5FpyZdasVXza310gO4ZWdbme7MW5M/xZ+9aK/1suQ3pUgMD2melvYfNn/tbV
	 csUAxhg8zqCFdC3ZEZS7P7n0xSGUR5BPSKARO0Mky0WlDO7QvXyFL+XRdLeI5ZeY/5
	 OyJBvIG0mHxuJbxfJV5LdlL4Z2yRl3I1mFK1PqQCjOilsAJO2B5DF7YRp3PERswsVm
	 eWsMeGATYq7kwAmsvJQFVB68VIhLO5o1p3tajXxg3bPKj9YnutO9OBqAmTD1xr8NC5
	 Rako1/eg7tSrP3xYrisP1bolcbKcO3X37VYlgVcqOTgY/LGgzapVkFbyPXP2jR7t2X
	 qdjFxUut/jVNA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Matthew Schwartz <matthew.schwartz@linux.dev>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 235/283] Revert "mmc: rtsx_pci_sdmmc: increase power-on settling delay to 5ms"
Date: Sat, 28 Feb 2026 13:06:17 -0500
Message-ID: <20260228180709.1583486-235-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
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
index 4931ee387f3cf..195cd25c2e055 100644
--- a/drivers/mmc/host/rtsx_pci_sdmmc.c
+++ b/drivers/mmc/host/rtsx_pci_sdmmc.c
@@ -938,7 +938,7 @@ static int sd_power_on(struct realtek_pci_sdmmc *host, unsigned char power_mode)
 	if (err < 0)
 		return err;
 
-	mdelay(5);
+	mdelay(1);
 
 	err = rtsx_pci_write_register(pcr, CARD_OE, SD_OUTPUT_EN, SD_OUTPUT_EN);
 	if (err < 0)
-- 
2.51.0

