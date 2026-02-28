Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BCAE359A72
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:14:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302450; cv=none; b=K1o22ojJTn0P9TYBVyqNjg7ywCi6msacP/qLhA7k50A6ExQdiOr1euU+NSkqPnhpV2hiAJh67x+psSA/FNg2HDvyWk7RhZen39D8l7bFfyVOMSUem6+H2L03UGvLZJxA9uIKdlw57m8O4gW4UP6m4Ehy2SNfYUIMORffBqlkdW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302450; c=relaxed/simple;
	bh=OUH2LPSgOrGISwPiSo+DwkNnL0tpksJBbIwCwGl0dQc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tZ6vd6LtIv2YyIOJKLulkZUagSI7dCsKgRDyXefjFpWhlyL1x3U6pIFQVuvGjsMrmNhb1n2oPZjKoP8awE3YVcTuOHz/FnLSM3VfDPYSymsfqztrvju8rSS6YCdzwACGeSm+tke4M4DchXWkTV7kXEj/XWTcg3M56kk3xxSsEkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WzQwm/N2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WzQwm/N2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC70EC19423;
	Sat, 28 Feb 2026 18:14:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302450;
	bh=OUH2LPSgOrGISwPiSo+DwkNnL0tpksJBbIwCwGl0dQc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WzQwm/N2dQev0yVC92ZtkLtwmHdW4bQbyyVFnLzxrUrYuRnggil0wJlsIa0RdWVuc
	 eoDA1zLtLr0Q7je/cqlG1lZQBgiNnOKDH/yoaYo92OMfEV8cm6j6/Rchu/AbUiogOL
	 gz+Ik/YDbls7E5lNZxTsCnXixT0cgVQRcuUOCaP1Xjo9QZ9taceRf+X6yf3DY5oh/6
	 stlSz+QdveGKErIZOwW4rpjhjtoxA7TH4LZg6B8fagxUlYvLcB/3OFfq0XXUy6/4O9
	 VPqapoXBMqEvp5WwmKpxb+inTgLUhtwKwrN5RYRmHtx9A4Q5iEMha4s+R2SJMZu2yF
	 ornha5lr46KqQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Matthew Schwartz <matthew.schwartz@linux.dev>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 190/232] mmc: rtsx_pci_sdmmc: increase power-on settling delay to 5ms
Date: Sat, 28 Feb 2026 13:10:43 -0500
Message-ID: <20260228181127.1592657-190-sashal@kernel.org>
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

