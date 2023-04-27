Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CFEEC2CB
	for <patches@lists.linux.dev>; Thu, 27 Apr 2023 20:21:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 071D2C4339C
	for <patches@lists.linux.dev>; Thu, 27 Apr 2023 20:21:40 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (2048-bit key) header.d=idesmi.eu header.i=@idesmi.eu header.b="TRkpemao"
Resent-From: Mark Brown <broonie@kernel.org>
Resent-Date: Thu, 27 Apr 2023 21:21:37 +0100
Resent-Message-ID: <ZErZUfVxNWsjLYhN@sirena.org.uk>
Resent-To: patches@lists.linux.dev
Envelope-to: broonie@sirena.co.uk
Delivery-date: Thu, 27 Apr 2023 20:17:09 +0100
Received: from dfw.source.kernel.org ([139.178.84.217])
	by cassiel.sirena.org.uk with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <SRS0=AdWU=AS=idesmi.eu=kilgore.trout@kernel.org>)
	id 1ps774-00DnFZ-HX
	for broonie@sirena.co.uk; Thu, 27 Apr 2023 20:17:09 +0100
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.source.kernel.org (Postfix) with ESMTPS id B110163CF2
	for <broonie@sirena.co.uk>; Thu, 27 Apr 2023 19:17:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix)
	id 3A2B2C433D2; Thu, 27 Apr 2023 19:17:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 37B13C4339B
	for <broonie@kernel.org>; Thu, 27 Apr 2023 19:17:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.kernel.org 37B13C4339B
Authentication-Results: smtp.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=idesmi.eu
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=idesmi.eu
Received: from smtp1.mailbox.org (smtp1.mailbox.org [IPv6:2001:67c:2050:b231:465::1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-101.mailbox.org (Postfix) with ESMTPS id 4Q6lpx61z1z9t8X;
	Thu, 27 Apr 2023 21:16:57 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=idesmi.eu; s=MBO0001;
	t=1682623017;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=he1u3nZUz/38H7+Zs5xdfVAxl5D2IfPMYSGZPsYah+g=;
	b=TRkpemaogGr/MKQbJaigodKG1h6Po1jWz+MUt29Zy8EvPm6sWj5fgTAleKcaYTuP6KbjiH
	d4Bj1NhZ3bcjqAV6fh/8w2A050XwR/J99dBQUWm/p6Y8QPYYuhJ0opeuyahMtXkCVenVyS
	CuEmKjghJMjMC3C/KUUbeWRHLe18d48x7aCd4Q+ojJ1AMar6HP55+KkxaJehMQs8FYvHol
	718J5qUC/wIgI/9sC2d0aNvqz0EPp5atTn+IHY5+JOEA++kNb5xLsqWn8XEDGZ0p0By9Tr
	ILHKANqA/d3yMOgLBZOkjMQNdPxklDMLQt9qIl2N4LjDvJDOrT2uYDup9FL3mA==
From: Enrico Belleri <kilgore.trout@idesmi.eu>
To: broonie@kernel.org
Cc: alsa-devel@alsa-project.org,
	Enrico Belleri <kilgore.trout@idesmi.eu>
Date: Thu, 27 Apr 2023 21:16:45 +0200
Message-Id: <20230427191645.24519-1-kilgore.trout@idesmi.eu>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4Q6lpx61z1z9t8X
X-SA-Exim-Connect-IP: 139.178.84.217
X-SA-Exim-Mail-From: SRS0=AdWU=AS=idesmi.eu=kilgore.trout@kernel.org
Subject: [PATCH] ASoC: amd: yc: Add ASUS M3402RA into DMI table
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); Unknown failure
X-TUID: fJVAg+H1ho+R

Fix builtin microphone on ASUS Vivobook S 14 OLED 2022 (M3402RA)

Same issue with this model as apparently with other Rembrandt laptops: https://bugzilla.kernel.org/show_bug.cgi?id=216270

Signed-off-by: Enrico Belleri <kilgore.trout@idesmi.eu>
---
 sound/soc/amd/yc/acp6x-mach.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/amd/yc/acp6x-mach.c b/sound/soc/amd/yc/acp6x-mach.c
index 4a69ce702360..80dfb6036859 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -213,6 +213,13 @@ static const struct dmi_system_id yc_acp_quirk_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "M5402RA"),
 		}
 	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "ASUSTeK COMPUTER INC."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "M3402RA"),
+		}
+	},
 	{
 		.driver_data = &acp6x_card,
 		.matches = {
-- 
2.40.0

