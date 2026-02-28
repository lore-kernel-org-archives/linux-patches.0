Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1869379EE2
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:04:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301897; cv=none; b=JLZagddJdNXeguaPZya+S/vFU24H5tJ4H5goMPPRXBAWjgFc5ZylamRb7kZa+baSgO62G/44S+n9dSRPeC62t4iZoF5+5NGN2kH7s+0/GefjmGb57MD5LHo+2sYXV0n2ABdMNAFzUYT+OuzjASo1GUhZPDnY6ckQsLjPny6vqZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301897; c=relaxed/simple;
	bh=xDoFfkezXp0xr/q6dD0gMIZB2GSrs5mvz9ej24iiAJs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XeXEP3EjnA/PkehvMlSf16TLdflziKOdPuFosq1VQuPoGzuN/A1XdIXe0T5TueY8b/Y66rb9r29kvZyiknE60pOg+jhU/6W6SxB5kNB+pFImiwmwdi/OmDfycGL077bDnJxOfO2I2TmqTSBDGIq4SfGJlSpeL8ujugEPCoAVXp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U4OYHpgO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U4OYHpgO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21952C19423;
	Sat, 28 Feb 2026 18:04:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301897;
	bh=xDoFfkezXp0xr/q6dD0gMIZB2GSrs5mvz9ej24iiAJs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U4OYHpgOaO68ssl+Cg/+oQU47rOz3ig1+ZrSg+XxjQzSveUNH/l8B9NGQlfd/UXtt
	 HQm6tHclQjkAKnINPsKT49bm7ua0xCwGxaRAG2Ao4L81SLSv/ow1/GDSOINKxbkmgd
	 aDwjmZhqbfjArsR2Dxio+/5YnZAKzRDl7hMwj6yvt4XfcKSLsoGKpqE550a5Xdp5iQ
	 ZsLnp+2UmoLNXjTU+ViooVp46n/AUvzVol+9to68CtjyIgSqul8zVfBlQmLxmgyTRk
	 E+//2+waDycm60B7c9RLn6kHOFbAMsXm2CV0X/yX4FMEvciLeZ8a8ucDM82x12KLy5
	 LBv/zErvOlaKQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Matthew Schwartz <matthew.schwartz@linux.dev>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 326/385] mmc: rtsx_pci_sdmmc: increase power-on settling delay to 5ms
Date: Sat, 28 Feb 2026 12:59:08 -0500
Message-ID: <20260228180011.1568201-326-sashal@kernel.org>
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
index 04aa47f1a24fb..f5bc757ddaa27 100644
--- a/drivers/mmc/host/rtsx_pci_sdmmc.c
+++ b/drivers/mmc/host/rtsx_pci_sdmmc.c
@@ -939,7 +939,7 @@ static int sd_power_on(struct realtek_pci_sdmmc *host, unsigned char power_mode)
 	if (err < 0)
 		return err;
 
-	mdelay(1);
+	mdelay(5);
 
 	err = rtsx_pci_write_register(pcr, CARD_OE, SD_OUTPUT_EN, SD_OUTPUT_EN);
 	if (err < 0)
-- 
2.51.0

