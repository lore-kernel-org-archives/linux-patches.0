Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7741C301EEB;
	Sat, 28 Feb 2026 17:56:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301404; cv=none; b=rBBwh71gfCIdBLh+FjVookS41vZhRD4oQjZligoVbnWvSLj0XGDKz13eWlrWGaR/z1owU1x4Jbcatp5qCnuJrlPYND432pBIUeVtucUNwNP3BokzwXlft0jOPXO1ygPm1jSih9Vu/JaHbehtg9bzMvxwYdmIPpBCXPp54fX2bbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301404; c=relaxed/simple;
	bh=uxO4sj5MCXLDVJhQZ76jD4v7S/r42pofPA44kewwmDY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p7kJdDD/Hk6spcuPA8bpNxBBXNb+6+K9CBBMBOOzN1wTJQTcdRITdmlz0Qf1QOPq8bLBfGcBOpyHBnJ0z3/9Jn1Ucr3cTx10OesaQeeEj65yO3De2ef3rj3GxM+2dmoB/ZdO7w2bxz8lfzKp1EM59J55miorwJSIVKQHo1lgNpM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qokweMLy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qokweMLy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 983DDC19425;
	Sat, 28 Feb 2026 17:56:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301404;
	bh=uxO4sj5MCXLDVJhQZ76jD4v7S/r42pofPA44kewwmDY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qokweMLyRSAywQ4pDfibdl4YtD/YrQ6n4KtGk9qgYKw2rqz5hofNgFmc5JWE1FVlV
	 5AyD4xbqMWyOdbMQ8WOCGdfV/ejswi5CWAug/Z3zCnYKPjZQLdUkvJyhXj1FErSMtN
	 CvU9AduD+zAKBM+WS/RUz/A0t1XXaBJSLD1tgzo+7Jqqw307OrABmr6Epg+gIhn/um
	 FZ4fHVJepTm8q/o2S/Z095jiUbX3eo5idsLhgyIVjWYFSMkQTMGyTni2jY09y2EEYX
	 MmzqagC1aC8CI77A4/UQz0uIWx7uUmNtd89pIFbxePcJALmc0QLLfKArI8EGuZTuIu
	 GjodSDihp8D/A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Janne Grunau <j@jannau.net>,
	stable@vger.kernel.org,
	Sven Peter <sven@kernel.org>,
	Neal Gompa <neal@gompa.dev>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 593/752] mfd: macsmc: Initialize mutex
Date: Sat, 28 Feb 2026 12:45:04 -0500
Message-ID: <20260228174750.1542406-593-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Janne Grunau <j@jannau.net>

[ Upstream commit 414f65d6736342c77d4ec5e7373039f4a09250dd ]

Initialize struct apple_smc's mutex in apple_smc_probe(). Using the
mutex uninitialized surprisingly resulted only in occasional NULL
pointer dereferences in apple_smc_read() calls from the probe()
functions of sub devices.

Cc: stable@vger.kernel.org
Fixes: e038d985c9823 ("mfd: Add Apple Silicon System Management Controller")
Signed-off-by: Janne Grunau <j@jannau.net>
Reviewed-by: Sven Peter <sven@kernel.org>
Reviewed-by: Neal Gompa <neal@gompa.dev>
Link: https://patch.msgid.link/20251231-macsmc-mutex_init-v2-1-5818c9dc9b29@jannau.net
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/macsmc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mfd/macsmc.c b/drivers/mfd/macsmc.c
index e6cdae221f1d4..3228e79c86eb5 100644
--- a/drivers/mfd/macsmc.c
+++ b/drivers/mfd/macsmc.c
@@ -413,6 +413,7 @@ static int apple_smc_probe(struct platform_device *pdev)
 	if (!smc)
 		return -ENOMEM;
 
+	mutex_init(&smc->mutex);
 	smc->dev = &pdev->dev;
 	smc->sram_base = devm_platform_get_and_ioremap_resource(pdev, 1, &smc->sram);
 	if (IS_ERR(smc->sram_base))
-- 
2.51.0

