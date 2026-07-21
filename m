Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AE2D29CE9;
	Tue, 21 Jul 2026 21:22:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668975; cv=none; b=XKfyktfp0yEdJkllYHX77IPT/s1ofPMhB6VIllpp/LeF1WTOF5118+7rdUe9h9ZMpcwsSWrUQFN4opfm9gVDI4ouX6Y3GDrfq19a3vQ2dd+/yUvlxX5Ew6gzNdx7STFi5laZ+34zzTHt3LSHUS6efdWV1hlXCrwAinzOq+B5yhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668975; c=relaxed/simple;
	bh=cz8b8qv4AmIvBjrgv9eiJKLtrM9hIggevvj8aXryYfs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tGB6ZXLeQNtCPEDCKV5kEOwHToCkINaLtax+9pwJR4i3AFKK3PZfIbO9lLHWU7cIzyeiIcr/KNHaS3xcBXRXLbK1vCu4Wgm7NpiY9H+RHyR1efFTfakWqnOdvubmTOsWGwHUuzaYXlNqMkB3cBECsHs0I2CbFPz2a1sZiYsoc28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lGxN27/W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lGxN27/W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 830D51F000E9;
	Tue, 21 Jul 2026 21:22:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668974;
	bh=tIitX/+NiC2fWbItBAVn9X/2zRfGVfr7dVvuuU8ioM0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lGxN27/WGzzfhw86Tk0z3QS7sCt4Bi4VZcpnrPP6gr11uGNbJQe3zMUo2QoC5cKyD
	 SeMAuWTaCUvTu27Wdmo8hYYYwBEUQ/4L5/ObyQOCCs4tspYrI1RubAyUQeukP9oQrU
	 ql5TB12jpO7dWdENb4AOHrGwbn3mK3FSawO3Az/M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Michael Walle <mwalle@kernel.org>,
	Pratyush Yadav <pratyush@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0336/1067] mtd: spi-nor: Drop duplicate Kconfig dependency
Date: Tue, 21 Jul 2026 17:15:37 +0200
Message-ID: <20260721152432.113819020@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



