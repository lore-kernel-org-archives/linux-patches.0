Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81CD63603EC
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:19:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302758; cv=none; b=EuSqy6Eqecf6NLXUpPr7WK9Vu4INPFXtnf7XMezBULfQsm5gTIVJUZyq/L3LwGPaBmmJffuEHpUhadXWnR0W5XyKItOsNrX9Hbdv/4zy2Xo+GWTFhxrsn9sMOV1yGma8h2Ty3Pw6V/1ycavUWSQLPXFrk1DxxHJkoPwvfSSKPNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302758; c=relaxed/simple;
	bh=DCLWrHXmfrl4UH2oqL/6FxfhMEE+8QaVE9k1b//NkzY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tOn0DcSlaaK8vCftJw5Ie8r6ysoQNKRSun+NZHSyPN1JPGt7X/LPNJiph3O9WmMiTueGAOZXC1yJhWyyfOuQwXTdUUWN/O8xNiTf6aFHcgd5s4Udxlc8Y0x3fNy+CetHEC5uTOgPyR34wsHo1glbRIz4jOkipju+KgD0J88N3ig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rJqLhU4F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rJqLhU4F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3228C116D0;
	Sat, 28 Feb 2026 18:19:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302758;
	bh=DCLWrHXmfrl4UH2oqL/6FxfhMEE+8QaVE9k1b//NkzY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rJqLhU4FEet1Ql689c30a/uP0rPbIPlAMIig8NIr0ytC/GuK2vFZ+rh0bH9JaJjpS
	 tPd9EGj1r4w3diDYjcyHJ/fTwx4JEhNnZzypz7QIlLHeoc1Zra2tYYpTFv+UjDDdda
	 aJKOYA+jyVAplmYuag+HiKZH61aeBiwQkrG99vggIsdOXd1xL45CEc83qPTp1DrHXh
	 pSU0pxZAcgh1wvAQcPEuLK0xXIK9aj7IMjrJtdkFq8XVfmX2yY31qQsyn75j8zGFcR
	 eN8sUu+FCcuxtvsq+o3xNlZhuDURweVvoO/sTbRu3dE5PJnu2xhWTt7CQ7yC+ls4HO
	 ncA5C9Xidf6uw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Matthew Schwartz <matthew.schwartz@linux.dev>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 128/147] Revert "mmc: rtsx_pci_sdmmc: increase power-on settling delay to 5ms"
Date: Sat, 28 Feb 2026 13:17:16 -0500
Message-ID: <20260228181736.1605592-128-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181736.1605592-1-sashal@kernel.org>
References: <20260228181736.1605592-1-sashal@kernel.org>
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
index 97f194afcc643..f0e9a76679945 100644
--- a/drivers/mmc/host/rtsx_pci_sdmmc.c
+++ b/drivers/mmc/host/rtsx_pci_sdmmc.c
@@ -932,7 +932,7 @@ static int sd_power_on(struct realtek_pci_sdmmc *host, unsigned char power_mode)
 	if (err < 0)
 		return err;
 
-	mdelay(5);
+	mdelay(1);
 
 	err = rtsx_pci_write_register(pcr, CARD_OE, SD_OUTPUT_EN, SD_OUTPUT_EN);
 	if (err < 0)
-- 
2.51.0

