Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA7BA43CEE4;
	Tue, 21 Jul 2026 22:39:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673557; cv=none; b=gGBib3Lm7a6y+9q4sSaNToSTO7h9E6NWu0UUYW8fQHro9NroO+lHI8kdsyc5Np8YCE3ZW6rp8S64eAu9SJ7FogU9rYZmkf/HbTqT9TWeMxjkN7bjS7HzhaNRlP3mPQk+Nudx/rbxLkXUHiiznBjJv7MoRbdSYY2kfdxGFfnNQEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673557; c=relaxed/simple;
	bh=s07MqfgSRXtwrcXRr67/2nH1PvbkQmq3DQZK3Q68hJU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X2W0wFJVUNYa1HjGjB1Fz/EQOfwbKFX4rnRm+nfVA4OCGBhcSBWeNTToS8Bk4bJJU+b3QClwMJHb7x9lNAANHMcHIpvAD3OK7JcJ1ApkuhtThGf/OawskzARQcCYiACqG4tBrp0mCO8aL0K3LhGYnd41sGO9x8MmT9Sh82HQfPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xfhqlVbm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xfhqlVbm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B81F1F000E9;
	Tue, 21 Jul 2026 22:39:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673556;
	bh=Slv/3rMywYkZi20nJflggXGGeDWzZEqlhrOWy9CkEbA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xfhqlVbmdrG/dXLzLIsZY6oVNi48S4lQK2DN7/SN+r/Y+uKdx5uRqBqlAdjqS+rBM
	 dyyQvIs/iPnSeS0Oz5lgvcDMcNKHxiSqb8TVnezMQxBG/TrYOsnqZwaTUb8UCWO0K9
	 smbjNyNf09FnIIzlWf/WPHMfg9NFCUxYr22kdXws=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Michael Walle <mwalle@kernel.org>,
	Pratyush Yadav <pratyush@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 206/699] mtd: spi-nor: Drop duplicate Kconfig dependency
Date: Tue, 21 Jul 2026 17:19:25 +0200
Message-ID: <20260721152400.344289446@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index ffc4b380f2b16d..665ec75f81ed00 100644
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



