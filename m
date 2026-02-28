Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4516736C9D0
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:10:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302223; cv=none; b=SgjhVNmaGgCv146/O2QB12pP1IVpxBpuPbNaA6BqEjXVkHVvu6lNJ1NGI+SZ4vdl6kmFaR1c9wlvmPa39G/ESjveOvdYvQzcBURG4AaQWZtM4XI3o9Ev6wdY/AqAFesB7DbbMax13uTDPCxRHv91TGKgOli2pJCF/9yt2Z+Dp2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302223; c=relaxed/simple;
	bh=qGBQSABzXrlHIm6QVIbKjF7jFlK1dKbl85eswm3RJDU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lgR/TZYlyr3je1GWa9EMZ0KBnb/1FAj99ZHVAkR+ULYMHR8gn7GmJVvKOTscBo15LnFPtJRgDRFjFO5y5mx540U8ASYf7r/pxdThfBT1xHyNBiigbkuievTjZDGnkh/ZBz8S0qyRpFCmr/igb2pOseRLDOwEN5CDjly8Sot12h8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MxwCnjsS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MxwCnjsS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6EF9C116D0;
	Sat, 28 Feb 2026 18:10:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302223;
	bh=qGBQSABzXrlHIm6QVIbKjF7jFlK1dKbl85eswm3RJDU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MxwCnjsSsLv4RQwKWZaig141RHllf+Quc/LTSoLmajD5fgukKXc1gUG8QT9yXdPHJ
	 s38vPPRE6VEZstqzwwlTqRCmW3ZuyYN+FFd2geAs4wEtT18hRDVg2X/lB69k53p5E0
	 0ToomY6PhIkcS+4Krc5PTZhqioP2LHxJwBa8ZpZpfEY0r2HBihB/wO7h4TPJSQFdcu
	 emDWHkaBx6EIXtpPmeZpA+OZDwpM33my4RAb/kpc2e2DtWo01Osq+SaGE8UobDvFg1
	 4QMXVeePNViUCxCVCWaOyJFU9EnT9NM6WyveUH1+XezRQ3cwamNycM8O7bwnBq+weh
	 NNb4EOGk+U2VA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Matthew Schwartz <matthew.schwartz@linux.dev>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 231/283] mmc: rtsx_pci_sdmmc: increase power-on settling delay to 5ms
Date: Sat, 28 Feb 2026 13:06:13 -0500
Message-ID: <20260228180709.1583486-231-sashal@kernel.org>
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
index 195cd25c2e055..4931ee387f3cf 100644
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

