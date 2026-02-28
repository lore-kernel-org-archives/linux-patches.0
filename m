Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3013235AC3F
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:19:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302757; cv=none; b=du1OVfl30BRESCtEq6ywVyDA77gNUVeOGj/1ANzdyjSMvHrzV4JOIC40rxx8ibxOL5V1dZ6Oh9f30XqHujdy5/gsGJY0JtuFboQyRUBcTM+Wa8y0FXwkTzYhVpJDEDLr5jcw2JwIfapTlO1zUOxru2emCqm1fFd2Rb7ZXCLLj+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302757; c=relaxed/simple;
	bh=NDkpNOtYNIxErHao3KNP4JcIV6Oy/AyJtoBsWnFHoKk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dcg69WXNFkOooq/hTNNP6QzHCdlkVaGyiKvWwa8akdds3Af1UNX8tMlVqL9G2iImoyPWFRqpj8mn4TsW1zQIcH/GfoUcrV9P5QQKVa97IHIEPy9u+mioWefoKIBM0BtYcRWQ04Dl0/fDkfU6gbznwWHJOx/GIiZqx4ISXlMvuXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y5Mp0JZ5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y5Mp0JZ5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67324C19424;
	Sat, 28 Feb 2026 18:19:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302756;
	bh=NDkpNOtYNIxErHao3KNP4JcIV6Oy/AyJtoBsWnFHoKk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y5Mp0JZ5ZubDCPhOgOmk5SJRFa2qlZ7I5PLLk0f4W/gijglXGfO9U7nTB+If3B4JX
	 c+QSSFT+F0lqdvH/2YuP3rGviW8WEwm5IfdjuQsT08vLaPOrsaaaCtPyVqJpPFpNbK
	 jeAI9hVibDWHk+41KavzHzqC+QzHCc4/TB3wpdPj338uBNFdEBczr3DjlbGE/H8LQm
	 kVDAIe4c4ODCMW8Jdp3W24htnXQpHxTYclEx9NoD1qK1LKGE2TiSmE6TbeDFgiQwSr
	 BF54KobTQLx3nlq8k4gJ0hOOk7STiLaTJc1jgX+7qPdTIs6LLU5eriDGPWhhtO9P7O
	 RQ2JQ3+otpS1g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Matthew Schwartz <matthew.schwartz@linux.dev>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 126/147] mmc: rtsx_pci_sdmmc: increase power-on settling delay to 5ms
Date: Sat, 28 Feb 2026 13:17:14 -0500
Message-ID: <20260228181736.1605592-126-sashal@kernel.org>
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
index f0e9a76679945..97f194afcc643 100644
--- a/drivers/mmc/host/rtsx_pci_sdmmc.c
+++ b/drivers/mmc/host/rtsx_pci_sdmmc.c
@@ -932,7 +932,7 @@ static int sd_power_on(struct realtek_pci_sdmmc *host, unsigned char power_mode)
 	if (err < 0)
 		return err;
 
-	mdelay(1);
+	mdelay(5);
 
 	err = rtsx_pci_write_register(pcr, CARD_OE, SD_OUTPUT_EN, SD_OUTPUT_EN);
 	if (err < 0)
-- 
2.51.0

