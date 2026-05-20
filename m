Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E39AF41C2FC;
	Wed, 20 May 2026 18:38:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302334; cv=none; b=ec8AiafJV7hbxOxkddxr4vXpogoutO+P/KznYqk212OBUbQa3NP8n6yTUk4GIRKcCpZLW0p3T4l1/lOmtNfaALCcX8tbK29UF1mUPK0kkqNBqAbshD3KlNKrDYm5vw4tqZiH5w4H9oYCt+3NjcBvK/g0Q/Rr0d7KXA9xYBNTLAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302334; c=relaxed/simple;
	bh=l1ENN/0XhNYh7o79/4wDcZbRRVDaY91ZWEd3InGhj1k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nVcVwEFBX/Dzfq0J6BRafaHuXvkojI4975vBJzyE8T7KrW1MkdOnxfXdML2BXUpQQpBjk02k5/navGDKZ0IHYFTTxYZfaPciFMIj3OihqmPpqonqUU8Fb7JZ9m5HCGIIe+xdxrjXBII2NV6XwTWtY7LjMfPnT2WJ/yWnh7Kcnhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M2cbzOu0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M2cbzOu0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 262351F00893;
	Wed, 20 May 2026 18:38:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302332;
	bh=R7x7YD7GNMkhFzO9L2vaXQYbW/zdP/7ouuildr10O58=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M2cbzOu077ERobewN7K108rJOhDQUVJx8Obp5m90pYTQKAmXNGx4/byu+1QjoSBGp
	 9tCiy/+zpgWvZgUyYSqgAA5BaSlRpleW0lXUU2CH3D9CkIuH1Zm1dLIQyTGdw7SpHE
	 quUKlU4JDhwG7hfDXiU4zBpfrC97AkRhSHZDdkEE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marek.vasut+renesas@mailbox.org>,
	Tudor Ambarus <tudor.ambarus@linaro.org>,
	Takahiro Kuwano <Takahiro.Kuwano@infineon.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 228/508] mtd: spi-nor: sfdp: introduce smpt_map_id fixup hook
Date: Wed, 20 May 2026 18:20:51 +0200
Message-ID: <20260520162103.590105119@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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
index a68cf82498ed8..6c478331e494e 100644
--- a/drivers/mtd/spi-nor/core.h
+++ b/drivers/mtd/spi-nor/core.h
@@ -418,6 +418,8 @@ struct spi_nor_flash_parameter {
  * @post_bfpt: called after the BFPT table has been parsed
  * @smpt_read_dummy: called during SMPT table is being parsed. Used to fix the
  *                   number of dummy cycles in read register ops.
+ * @smpt_map_id: called after map ID in SMPT table has been determined for the
+ *               case the map ID is wrong and needs to be fixed.
  * @post_sfdp: called after SFDP has been parsed (is also called for SPI NORs
  *             that do not support RDSFDP). Typically used to tweak various
  *             parameters that could not be extracted by other means (i.e.
@@ -436,6 +438,7 @@ struct spi_nor_fixups {
 			 const struct sfdp_parameter_header *bfpt_header,
 			 const struct sfdp_bfpt *bfpt);
 	void (*smpt_read_dummy)(const struct spi_nor *nor, u8 *read_dummy);
+	void (*smpt_map_id)(const struct spi_nor *nor, u8 *map_id);
 	int (*post_sfdp)(struct spi_nor *nor);
 	int (*late_init)(struct spi_nor *nor);
 };
diff --git a/drivers/mtd/spi-nor/sfdp.c b/drivers/mtd/spi-nor/sfdp.c
index f1ec785628bfb..dcf88ad2a00b2 100644
--- a/drivers/mtd/spi-nor/sfdp.c
+++ b/drivers/mtd/spi-nor/sfdp.c
@@ -705,6 +705,16 @@ static u8 spi_nor_smpt_read_dummy(const struct spi_nor *nor, const u32 settings)
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
@@ -758,6 +768,8 @@ static const u32 *spi_nor_get_map_in_use(struct spi_nor *nor, const u32 *smpt,
 		map_id = map_id << 1 | !!(*buf & read_data_mask);
 	}
 
+	spi_nor_smpt_map_id_fixups(nor, &map_id);
+
 	/*
 	 * If command descriptors are provided, they always precede map
 	 * descriptors in the table. There is no need to start the iteration
-- 
2.53.0



