Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C88E2449B2A;
	Tue, 21 Jul 2026 17:46:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656016; cv=none; b=CBxun8WKNsKLE2Dt3f3q8wsaGLRyxA4oHesyI44+171JOoyXaNXz2ip7J3tKaomzPkfv+wYSFQoPFlhyidePP+URTxxwb5AtjLbYrJefRTGvXkpF4tudlBmH0xabAkpZZcny4BESSYa204wQHAEH/V2oSz//8M41ZCZ9JyNnvvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656016; c=relaxed/simple;
	bh=vt/ZPgY4lgLLSeazopxyKf3hJOzWaCeYSnhKY/2XMgU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tUEu/3lUjrLhRFei7418PsuzBGGx3/SF575Qjhv6aQc3wo3IlRDPAW2bcYMKPjibH4KQRVveFZk5TAHiAEUudNZbJHTgBwQghBvtkf0SaNsThgvr1CpSitb/AY2zRAD88sVeybCPxEc/STrait46tyiUH7ysNR6v4tFtb+nf1b8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BelMDoY4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BelMDoY4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AB881F000E9;
	Tue, 21 Jul 2026 17:46:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656014;
	bh=IqvAMHUYVzyfyKZq5R4uNqojVb2ouyJN2x6572LDJ2w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BelMDoY4eEcsG7mqkJTiZkCZHADRoyqGVTTHoZm2iczcZzE5QFsT+C6igKcobbr+j
	 PC+80jb3dWgb42Y221ghF1tZVLpFDnWbJ9Q+wHST97Z4tBGKQhRLWNSGjCeWD+PzN2
	 zZgDWQ10QrG3Zi+4o5Azg+yJrT4yYO+7fOgbr8ZY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Michael Walle <mwalle@kernel.org>,
	Pratyush Yadav <pratyush@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0226/1611] mtd: spi-nor: Drop duplicate Kconfig dependency
Date: Tue, 21 Jul 2026 17:05:42 +0200
Message-ID: <20260721152520.090442601@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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



