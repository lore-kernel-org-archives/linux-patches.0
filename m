Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D7E939B970
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:16:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302619; cv=none; b=g7wkD/HaNjXqjkOM9AHMrypPO0UEJG/4oX9aWIOXzUYNNeRB1VLfQQhMNihzg/Elo+4CMOLb1FQQNK/dg8JezBTAYbHMbL8MFo3cOgRjsS6dJa6ab/ExcY3L9mePNSGo1OdzvZX77RHnrI6FaqXxlE9CVlCpeRPny7rtbZdc6Sw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302619; c=relaxed/simple;
	bh=OUH2LPSgOrGISwPiSo+DwkNnL0tpksJBbIwCwGl0dQc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q00lk7PwGVsokiA+2WJipbHDOCBCobCFlKnIC2Qqu4vYvkXSvHCutrwxRDTuFLl8zW18HFLjg/QUt1WjsaRdPlt5dOuQY+McbFPrQ9D8XnkDuG7bN/kS3d+jMpBi654nkfkX4mPdz17pHI46CLdFfQztDeXAliHmn+QUyknCasI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QWTXaUt2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QWTXaUt2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2567C19423;
	Sat, 28 Feb 2026 18:16:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302619;
	bh=OUH2LPSgOrGISwPiSo+DwkNnL0tpksJBbIwCwGl0dQc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QWTXaUt2IlDB9+VkK/7aMmjE4bDENxmhNIHExbDnWH/vlFqKqx+V7FiaCOY8732L9
	 QrasXIOEGw//vdidsdJ/phIWr1vkdOli1Cr8YvSWMqdpPXwKhfiSGgC4exhoPahlxB
	 bXd9b39Hg5Ij1qylH0zdSqKmdkV6ZGa0WmY2czaj7NKO7jZVD6FgHhJzsgrADIJC2y
	 JRQGyt0DiPWM9DfjJWzWfFC4a+rB6V85+cyc20K4pT+cEx6hXEqcNzPsSUf2nn9T8V
	 YAtzjHeKqq8nO5uRnMH3AnPaGOw08dbJe79qBlqisjyo10egXJ8ttH2U+v5Rh82p/b
	 KB75p2SRXh+Fw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Matthew Schwartz <matthew.schwartz@linux.dev>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 137/164] mmc: rtsx_pci_sdmmc: increase power-on settling delay to 5ms
Date: Sat, 28 Feb 2026 13:14:36 -0500
Message-ID: <20260228181505.1600663-137-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181505.1600663-1-sashal@kernel.org>
References: <20260228181505.1600663-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Matthew Schwartz <matthew.schwartz@linux.dev>

[ Upstream commit aced969e9bf3701dc75cfca57c78c031b7875b9d ]

The existing 1ms delay in sd_power_on is insufficient and causes resume
errors around 4% of the time.

Increasing the delay to 5ms resolves this issue after testing 300
s2idle cycles.

Fixes: 1f311c94aabd ("mmc: rtsx: add 74 Clocks in power on flow")
Signed-off-by: Matthew Schwartz <matthew.schwartz@linux.dev>
Link: https://patch.msgid.link/20260105060236.400366-3-matthew.schwartz@linux.dev
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/rtsx_pci_sdmmc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mmc/host/rtsx_pci_sdmmc.c b/drivers/mmc/host/rtsx_pci_sdmmc.c
index d063d50d69feb..02da9016245bd 100644
--- a/drivers/mmc/host/rtsx_pci_sdmmc.c
+++ b/drivers/mmc/host/rtsx_pci_sdmmc.c
@@ -938,7 +938,7 @@ static int sd_power_on(struct realtek_pci_sdmmc *host, unsigned char power_mode)
 	if (err < 0)
 		return err;
 
-	mdelay(1);
+	mdelay(5);
 
 	err = rtsx_pci_write_register(pcr, CARD_OE, SD_OUTPUT_EN, SD_OUTPUT_EN);
 	if (err < 0)
-- 
2.51.0

