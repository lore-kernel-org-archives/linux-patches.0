Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E769B46D561;
	Tue, 21 Jul 2026 15:47:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648822; cv=none; b=KNJ22B3wjSPImb+MW6hybBIPIEAhebJ6QXQghZT53F1JCkpgAMCcJyBeDYXGr2m1CX636uWMU/t4nvdcgCIbTukjWpHvElbXTcnJ+XaUWSCuT80pHuC599NhTvJkIUnCV466fo1/MyMR7qagJwFtEI2ceYbciIqdGoLMK0fJBsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648822; c=relaxed/simple;
	bh=fW51LLjT1nU654bFSweUwKtu4ymEBDiz5GP0aajrcPM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=us4XpkTwzt3uH4iIeUzt9wHyuEVbdP6Q+VaeklesUDAqmNuhRnkIgcEIgZ3+/ZCHDdSUtS0ymdMyuyrgO7LxBtKdEFExOIB5PxVJXyZzi9fe0TwKZRlArm9YaG279D3EFL8gBE5yLJKI61Gs+7untbrssXrRQ+rM+KppUnD1sqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D6+faDY6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D6+faDY6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32DF71F000E9;
	Tue, 21 Jul 2026 15:47:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648820;
	bh=zSmN2XttEbu+13FXH41NXaXAPJayB54kAnsdknGzqEg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D6+faDY661RSnrksKQmvdb1HoKzaZHwBexUpY8Cw6zST5mhpyybd6EvGGIMu0aeih
	 vGpMAJ3UH+lN9hWhX2pVj0C8Xkwy2NLTss7MY0Chf/RwzBs3s8JxHYA/aKG8bCWCaV
	 P8rJ8NTpfeanvBpY4BImz4x9uZP7elSYeQvGdQfg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Walle <mwalle@kernel.org>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0317/2077] mtd: spi-nor: debugfs: Fix the flags list
Date: Tue, 21 Jul 2026 16:59:50 +0200
Message-ID: <20260721152600.153474136@linuxfoundation.org>
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

[ Upstream commit 829dff83597615208aedf0f5abb3878b47f2314d ]

As mentioned above the spi_nor_option_flags enumeration in core.h, this
list should be kept in sync with the one in the core.

Add the missing flag.

Fixes: 6a42bc97ccda ("mtd: spi-nor: core: Allow specifying the byte order in Octal DTR mode")
Reviewed-by: Michael Walle <mwalle@kernel.org>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Pratyush Yadav <pratyush@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/spi-nor/debugfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mtd/spi-nor/debugfs.c b/drivers/mtd/spi-nor/debugfs.c
index 14ba1680c31547..c0bd8f1149a51d 100644
--- a/drivers/mtd/spi-nor/debugfs.c
+++ b/drivers/mtd/spi-nor/debugfs.c
@@ -29,6 +29,7 @@ static const char *const snor_f_names[] = {
 	SNOR_F_NAME(RWW),
 	SNOR_F_NAME(ECC),
 	SNOR_F_NAME(NO_WP),
+	SNOR_F_NAME(SWAP16),
 };
 #undef SNOR_F_NAME
 
-- 
2.53.0



