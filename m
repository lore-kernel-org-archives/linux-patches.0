Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09052298CC4;
	Tue, 21 Jul 2026 22:05:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671505; cv=none; b=U/gKz30GM5dlsogz2kkwJWqmJ7AiCtc8E/r0IJvPa7xqoZ9RW9rjWWK1tjPeA17n2KOWXlPx1h/kUqW2BY2N1C9ZxdmpOWAz7WBegA+TBy7qtmxdOkQOV98zYLd2IH0OgjZxHYCT1GU0m/8TgrgT47l/81jn26PCfzmZhyZPdMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671505; c=relaxed/simple;
	bh=rHHmNqv52TYwJG1jRyS/xvQz6Yf8PIMn4KA18iVDTyM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HGRx7qFwOsSFbot6gbgh5f6+Nofa8o3ok7K0LtT4UIcQPXJF4M2RF1n5q5OdDOKJJgErhvcB2x6gCgEaZwHrpEKeza1I1j+NmdGJc3knYOSYMhUE1CxEVTNf9QyWq2sEM2hfDZuYRjZ3uYdUZjQ556YPc2B1LXVjIS7C6glWpLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZZ+ONPHR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZZ+ONPHR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FA821F000E9;
	Tue, 21 Jul 2026 22:05:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671503;
	bh=lMSCSj+3coY8Eq43uhhK2OW4GjxdaJQRJ4SlsOD+BYM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZZ+ONPHRQl1SNutorOZjmi0tPAQHEtcfTJLa4DToRAUJYp/PNeOl3eYemqamy0m77
	 0ZXzWldAQeg04NhaMCD7CKVXVeDYp2oFc4tooCd9wfIlltW8FmtC5/YaDPikph4jvk
	 QjxfPKMDtWvbty5xoxX56CxBrhJy8NT1H1Qo85J0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Michael Walle <mwalle@kernel.org>,
	Pratyush Yadav <pratyush@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 264/843] mtd: spi-nor: Drop duplicate Kconfig dependency
Date: Tue, 21 Jul 2026 17:18:19 +0200
Message-ID: <20260721152411.964793416@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miquel Raynal <miquel.raynal@bootlin.com>

[ Upstream commit a6470e2162e9c3779a4bd6ff3bed1b81d796e46e ]

I do not think the MTD dependency is needed twice. This is likely a
duplicate coming from a former rebase when the spi-nor core got cleaned
up a while ago. Remove the extra line.

Fixes: b35b9a10362d ("mtd: spi-nor: Move m25p80 code in spi-nor.c")
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Reviewed-by: Michael Walle <mwalle@kernel.org>
Signed-off-by: Pratyush Yadav <pratyush@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/spi-nor/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/mtd/spi-nor/Kconfig b/drivers/mtd/spi-nor/Kconfig
index 24cd25de2b8b71..fd05a24d64a96f 100644
--- a/drivers/mtd/spi-nor/Kconfig
+++ b/drivers/mtd/spi-nor/Kconfig
@@ -1,7 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0-only
 menuconfig MTD_SPI_NOR
 	tristate "SPI NOR device support"
-	depends on MTD
 	depends on MTD && SPI_MASTER
 	select SPI_MEM
 	help
-- 
2.53.0



