Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E5942FB08C;
	Wed, 25 Feb 2026 06:58:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002690; cv=none; b=UHujWg/qt6df66hVgwROLBE830yc80u24q58UuTrdOr4h3eQpVFcSlzz6uCyqpupwciPKINUCRaw/liQWlYo3rVacuTNElSBml28iteioqoxPgf/Eqt4lKd5Ls1Q6bSHomOQEdk783tR0i9zXWoE4Inko5OOR4vTt6M/zoMZEFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002690; c=relaxed/simple;
	bh=xPVBD657GoiGw1Vndye4AGm+EHq+ckC7n7WhdWhhQ7w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PSvgtrLeaQaYl9BuNQKmUsOyuwrusCR3YfdBsXZZS3PZiDvkwN++vbxwJ9C3x3kUGc/jyTDDMLiwC2HTnJCDkQ/ec8QI/kl1qTU+cx+yHu2UEO+e9HJCUonW1rCp3kIa0fy3nlS0fmrsPDJkjVtMmgHnPHsGW/LovwU4FT9Qpas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ldwW57Vh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ldwW57Vh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48176C19425;
	Wed, 25 Feb 2026 06:58:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002690;
	bh=xPVBD657GoiGw1Vndye4AGm+EHq+ckC7n7WhdWhhQ7w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ldwW57VhOrI9ZZzWkmWZxdIBqm68bfCR75Um6iYfjRZnNf16GQYicwk/ZV+hDyIHy
	 /KgULQ8Ev0D3/7a4YOc8YvYGxAeR2tsdwzWLvlfRZ8L+avHrW4dWvRojzVkHo/12QL
	 HfhgqzSuLSf0i0biVo4ostxPWXuOy66a3hRi6m34=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Schwartz <matthew.schwartz@linux.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 466/641] mmc: rtsx_pci_sdmmc: increase power-on settling delay to 5ms
Date: Tue, 24 Feb 2026 17:23:12 -0800
Message-ID: <20260225012359.806168142@linuxfoundation.org>
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
index 4db3328f46dfb..b6cf1803c7d27 100644
--- a/drivers/mmc/host/rtsx_pci_sdmmc.c
+++ b/drivers/mmc/host/rtsx_pci_sdmmc.c
@@ -937,7 +937,7 @@ static int sd_power_on(struct realtek_pci_sdmmc *host, unsigned char power_mode)
 	if (err < 0)
 		return err;
 
-	mdelay(1);
+	mdelay(5);
 
 	err = rtsx_pci_write_register(pcr, CARD_OE, SD_OUTPUT_EN, SD_OUTPUT_EN);
 	if (err < 0)
-- 
2.51.0



