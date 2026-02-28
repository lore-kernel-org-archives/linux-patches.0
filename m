Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A6E5359A72
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:14:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302452; cv=none; b=JlAF9hZAjuoqJ5OD7iZvUb491UkrLoExqJOADYW07BrQSz6pRCOHXOlely4ZDJXFTOssZD6Sgqb/uxQueMEJLrq2eKThv3k6o+2VyR1sH6OhCvW6pwj+Nh8mQ8g+NwP2GonzjBI8RP6jTHEJ3K5Db+ERplNHa+7+BPtT4PDSKEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302452; c=relaxed/simple;
	bh=OfClsPc+6vglVTFABxcmg4jNSV3OX7xEiyNb4x7IrfI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gYSSUtH8Ku+Lycs+T1otyf++SpxCbVQLd/iFol5i64ycg6fdzjHvBSreFWVxzzKb4Q2zLh7rtFGjJOm09vEuvnIqOvLB0cWIO+wfdC3CEaG9/Xn6Ivimt1p+rmYVI/btJej3OWb261iXme6yvvrZhMkYwe326yZRTggNmX/cTDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lSIOmgk+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lSIOmgk+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56AE2C116D0;
	Sat, 28 Feb 2026 18:14:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302451;
	bh=OfClsPc+6vglVTFABxcmg4jNSV3OX7xEiyNb4x7IrfI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lSIOmgk+B7cr+pnpjF7oSUdV7c9c4/aHJ8A+jBebX1RxM3z7ZiDNYVExdR9W3Gnhm
	 hEvMnKe5Jwva6byzVQVxVtA/5yWRWkF8MUAadcYkHQFgSBw1tGqgwZcaCRrdyzAF86
	 RBbE3PScQgD7XFKFTC2Bxxjlk7voG7wPwuUecmqyfXrcnRFxQ1mbyDv6m8oVOL7L9q
	 tE8i7O6pZhaEaz/Q9oOMhPxwUGLEZZEAia4Qys9QTwbfsqvQ2oQxLp6JhZgiu2RRm7
	 UH5A8zXoHpgyd0TOIMUkYDR7tCtN9YCOT+iFTh1ew2UlapBQLrwloOa0AuWdyW3ZSd
	 RtpFm+Gh/n+fg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Matthew Schwartz <matthew.schwartz@linux.dev>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 192/232] Revert "mmc: rtsx_pci_sdmmc: increase power-on settling delay to 5ms"
Date: Sat, 28 Feb 2026 13:10:45 -0500
Message-ID: <20260228181127.1592657-192-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181127.1592657-1-sashal@kernel.org>
References: <20260228181127.1592657-1-sashal@kernel.org>
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
index 02da9016245bd..d063d50d69feb 100644
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

