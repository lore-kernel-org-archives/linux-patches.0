Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6593746D561;
	Tue, 21 Jul 2026 15:47:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648851; cv=none; b=L6Bhgafngpa6BAI5VenK5mzDKouQCm+gq7x1MAaAjpVGh5ARs2BIej7nD+6P8vkRic3a1gLwKbP120X7xSOeG1TnUKx5cCAm/Hgpx+dOzdcoAm72ILxVEHulBNSkzKmy3mT1t5Unb0PrIaDn+GZaEr1zPLOxDqu0B9tEwbm5GdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648851; c=relaxed/simple;
	bh=roeqA1SKUU311xVx6tFDnUkcmKVn6TYc6F6TK2RMCKs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LNTbMhEhp9zoY/dxZFmBq1z4W9vPkLYIQjW4DNel1h24TPB3O1p9vukQEECXCz/DWbcskAh7fTjUF7pk1A3xD5Vp3x41L3NO0wHruY8nWjo6a0B1/60J5rF05GvlAI9Be8m4wPKBJ/7Kr6ynJc02S1XE6/TOJczE+PHiEuc18Jk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W31dw236; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W31dw236"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 816491F000E9;
	Tue, 21 Jul 2026 15:47:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648850;
	bh=0aYQDEiKP9psmWiTmP/VlyBRwBd3v6JaZ0/DG4D/x9I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W31dw236vpY54xm1f31lhW7ADvM8OrK7IiVS0iPp/XaX5WL4UmmIexs590spfXcK5
	 F6CdnCwatP5CTAxqU0RpQZglz0zfDugLSOHuZFbrgzJrY7pwX2Nb5Sr260+TGbGwj1
	 r6dvrITjtr0zQ6N3k51pHj3kw1w43oXPmI5dTC68=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Michael Walle <mwalle@kernel.org>,
	Pratyush Yadav <pratyush@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0318/2077] mtd: spi-nor: Drop duplicate Kconfig dependency
Date: Tue, 21 Jul 2026 16:59:51 +0200
Message-ID: <20260721152600.176181105@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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



