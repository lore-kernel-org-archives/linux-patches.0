Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3DAB3783D4;
	Tue, 21 Jul 2026 20:29:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665794; cv=none; b=YW80uLO7tT2KQcJKC6ZIQmN/RZ/gl5ZWEmjPsyxVDWgnYNec9UJd7/Nqh+L7vfGzu69/f36X801jZHRUvtowkfA5juHiz2dpfyTudfzUmzOZOiSSmetdA0jB/GODjXgfMJiZ0rUYKSVh8qzqEb8Qj406KC2rgsQ1n+STwSyyoOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665794; c=relaxed/simple;
	bh=dM7NZE3oTffIvWilZ7bu0o2P74X0XPm3vmht70wnels=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CYIu58I/TYvSZhfOquStxXvN4OXZX4z0fDUYhqVNh2Gt/MD8SuJhYPOV8QwoUmiM05p/JSQgb3me8vjxXqDIQsUDuUNoo0j5MMoEiKfh+9KUIwNLDmhQvHmgaPZSrD/QbpcFclbdAacJKmbDGJeavyIGDilopneE26RClV9vKno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CCyc/NRC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CCyc/NRC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 640A31F000E9;
	Tue, 21 Jul 2026 20:29:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665792;
	bh=V/ZyWjYeuznv/Mrmeg6fGm17GEu4fJJ5N2RrXbwQRfk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CCyc/NRCOvAObcrItG3zgmb31QufVFnBLmdC2NePegJ4Mayy5il8qo9UzvMBraX21
	 IuCw0mzdxKIqSspe3ItJlHoiaG8ADjkUFSGKuN6FbaPKFls7xTDZPwTOD5L8L+AHKj
	 hNQsJ392n9Fl5K9jB8mfQ/v1qJGNnGh0VqMzvju4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Michael Walle <mwalle@kernel.org>,
	Pratyush Yadav <pratyush@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0438/1266] mtd: spi-nor: Drop duplicate Kconfig dependency
Date: Tue, 21 Jul 2026 17:14:35 +0200
Message-ID: <20260721152451.640416027@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



