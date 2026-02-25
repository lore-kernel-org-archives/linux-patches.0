Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 340C52D7393;
	Wed, 25 Feb 2026 06:58:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002685; cv=none; b=n07hwXrqg4vbe7QbqZw9/7JKvF+ydtGNhu0E11a2/HLfo3b153xnUgHmuD78CufUCHOSVdBgFFV2ND3d5wpgl3UYYCE8AUHG2v6WyaFKo73+AevYTVpTo06lt0y6RtQp71U225K3BuJBt33loRAkUebXI97O+7ylzZn43CRFqC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002685; c=relaxed/simple;
	bh=D7Ajchl2pWFzmpbhvwA+qjR0szPqfqo6LntQwvpQBAo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YlyNcdkAGAf2pUH4KmNCDL7mGoIJ4wL/MVb0jAWYsKVqn0oEt67O8uYeaAfTMgxuA/ZHDgVQeREFkIgtMcQ20qjN88nWQXRnJDH73IIA4aka+0nKY2Q6ue+mm5YmoW+8OP+m1ZEW/XJMJxTZnJiovheGic8s1n1NdmFgkIgxg0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jy7iTgVk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jy7iTgVk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EE65C116D0;
	Wed, 25 Feb 2026 06:58:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002685;
	bh=D7Ajchl2pWFzmpbhvwA+qjR0szPqfqo6LntQwvpQBAo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jy7iTgVks7KMs2sOp09uL362gypVQBD9Bzx3gV72kVq0dsHc2JmC8cvM4W8gRXJXO
	 WF/+7l3kv4wHMTZgzSBjjoWSiWVJxPrBYulfS0Qq3XpVwLIm44sYvZPaIkmB3T1X/0
	 bjCGxeDFMZFsl4Ck1m8Qh27HbEKNKsS4uZ9TpwlE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Schwartz <matthew.schwartz@linux.dev>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 476/641] Revert "mmc: rtsx_pci_sdmmc: increase power-on settling delay to 5ms"
Date: Tue, 24 Feb 2026 17:23:22 -0800
Message-ID: <20260225012400.051847175@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

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
index b6cf1803c7d27..4db3328f46dfb 100644
--- a/drivers/mmc/host/rtsx_pci_sdmmc.c
+++ b/drivers/mmc/host/rtsx_pci_sdmmc.c
@@ -937,7 +937,7 @@ static int sd_power_on(struct realtek_pci_sdmmc *host, unsigned char power_mode)
 	if (err < 0)
 		return err;
 
-	mdelay(5);
+	mdelay(1);
 
 	err = rtsx_pci_write_register(pcr, CARD_OE, SD_OUTPUT_EN, SD_OUTPUT_EN);
 	if (err < 0)
-- 
2.51.0



