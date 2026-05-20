Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B6573DC4DA;
	Wed, 20 May 2026 18:14:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300865; cv=none; b=mK7MPq4kmImPxMkq/t8W7g/dAGEClGuEbGXbBtZX1c8fG/XQh7cDeHJ9O/NW78Su3QE91ttSRiUv7NRCLGd8QJPjGu6OnNRaRZ5a7QtPEUDyvrq5+3KUrkO5OlgFqkT2XO3U5Tb3xBh2fdp6mHETW1cqDi1cpbeEwxGRIiyFma0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300865; c=relaxed/simple;
	bh=hbl/Y30VauLguiH7L/KozQ+sNeX4jpHH4rhJIRIZ/F4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=quiBxGzpfoCssOjQmPdItsJ1FqHuBRNcQovJYUghkbT2s1vmljbgIcFrxxE3JC4P3KICvMKQWhqLiVYIJu8vOeWRR/P5xMJuYAgF6n3N4btIdNysX+aryGTwX5q6kZ0hsbB+cAlnVBtXd77dMeJMMzKYsyh3hXCP9uov9NZr0Pc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XG/cn9ML; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XG/cn9ML"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 735071F000E9;
	Wed, 20 May 2026 18:14:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300864;
	bh=KYHg7kpezx+bs/dJL7sqiayYKEAzp6do0p7g0R6zTt8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XG/cn9MLvg3YQGPp5IcIAuBdgf5PZACVNWJpsMW2O93Rb6sa7BisQ2vcZakI6RdKW
	 Nl0uscxcYJQ5+qlh373tEbYxIho93ilEhc2k3t+RtI3bz7ckMUQYCGftAA569ThJ2R
	 pnWnxmuDyk/R7eMFjeQ2HQEbbl2TWCNHzsvbHO8g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marek.vasut+renesas@mailbox.org>,
	Tudor Ambarus <tudor.ambarus@linaro.org>,
	Takahiro Kuwano <Takahiro.Kuwano@infineon.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 336/666] mtd: spi-nor: sfdp: introduce smpt_map_id fixup hook
Date: Wed, 20 May 2026 18:19:07 +0200
Message-ID: <20260520162118.514478524@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takahiro Kuwano <Takahiro.Kuwano@infineon.com>

[ Upstream commit f74de390557bf2bcc5dca4a357b41c0701d3f76e ]

Certain chips have inconsistent Sector Map Parameter Table (SMPT) data,
which leads to the wrong map ID being identified, causing failures to
detect the correct sector map.

To fix this, introduce smpt_map_id() into the struct spi_nor_fixups.
This function will be called after the initial SMPT-based detection,
allowing chip-specific logic to correct the map ID.

Infineon S25FS512S needs this fixup as it has inconsistency between map
ID definition and configuration register value actually obtained.

Co-developed-by: Marek Vasut <marek.vasut+renesas@mailbox.org>
Signed-off-by: Marek Vasut <marek.vasut+renesas@mailbox.org>
Reviewed-by: Tudor Ambarus <tudor.ambarus@linaro.org>
Tested-by: Marek Vasut <marek.vasut+renesas@mailbox.org> # S25FS512S
Signed-off-by: Takahiro Kuwano <Takahiro.Kuwano@infineon.com>
Reviewed-by: Tudor Ambarus <tudor.ambarus@linaro.org>>
Signed-off-by: Pratyush Yadav <pratyush@kernel.org>
Stable-dep-of: 3620d67b4849 ("mtd: spi-nor: update spi_nor_fixups::post_sfdp() documentation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/spi-nor/core.h |  3 +++
 drivers/mtd/spi-nor/sfdp.c | 12 ++++++++++++
 2 files changed, 15 insertions(+)

diff --git a/drivers/mtd/spi-nor/core.h b/drivers/mtd/spi-nor/core.h
index 56718f954a859..3aeca2299ddb1 100644
--- a/drivers/mtd/spi-nor/core.h
+++ b/drivers/mtd/spi-nor/core.h
@@ -410,6 +410,8 @@ struct spi_nor_flash_parameter {
  * @post_bfpt: called after the BFPT table has been parsed
  * @smpt_read_dummy: called during SMPT table is being parsed. Used to fix the
  *                   number of dummy cycles in read register ops.
+ * @smpt_map_id: called after map ID in SMPT table has been determined for the
+ *               case the map ID is wrong and needs to be fixed.
  * @post_sfdp: called after SFDP has been parsed (is also called for SPI NORs
  *             that do not support RDSFDP). Typically used to tweak various
  *             parameters that could not be extracted by other means (i.e.
@@ -428,6 +430,7 @@ struct spi_nor_fixups {
 			 const struct sfdp_parameter_header *bfpt_header,
 			 const struct sfdp_bfpt *bfpt);
 	void (*smpt_read_dummy)(const struct spi_nor *nor, u8 *read_dummy);
+	void (*smpt_map_id)(const struct spi_nor *nor, u8 *map_id);
 	int (*post_sfdp)(struct spi_nor *nor);
 	int (*late_init)(struct spi_nor *nor);
 };
diff --git a/drivers/mtd/spi-nor/sfdp.c b/drivers/mtd/spi-nor/sfdp.c
index 86d869810d07a..20b791568d5f0 100644
--- a/drivers/mtd/spi-nor/sfdp.c
+++ b/drivers/mtd/spi-nor/sfdp.c
@@ -726,6 +726,16 @@ static u8 spi_nor_smpt_read_dummy(const struct spi_nor *nor, const u32 settings)
 	return read_dummy;
 }
 
+static void spi_nor_smpt_map_id_fixups(const struct spi_nor *nor, u8 *map_id)
+{
+	if (nor->manufacturer && nor->manufacturer->fixups &&
+	    nor->manufacturer->fixups->smpt_map_id)
+		nor->manufacturer->fixups->smpt_map_id(nor, map_id);
+
+	if (nor->info->fixups && nor->info->fixups->smpt_map_id)
+		nor->info->fixups->smpt_map_id(nor, map_id);
+}
+
 /**
  * spi_nor_get_map_in_use() - get the configuration map in use
  * @nor:	pointer to a 'struct spi_nor'
@@ -779,6 +789,8 @@ static const u32 *spi_nor_get_map_in_use(struct spi_nor *nor, const u32 *smpt,
 		map_id = map_id << 1 | !!(*buf & read_data_mask);
 	}
 
+	spi_nor_smpt_map_id_fixups(nor, &map_id);
+
 	/*
 	 * If command descriptors are provided, they always precede map
 	 * descriptors in the table. There is no need to start the iteration
-- 
2.53.0



