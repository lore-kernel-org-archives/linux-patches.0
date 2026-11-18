Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026813;
	b=IhMckXabJrSd5cWmFWPyHL8pHgWVY252uhbQucmrRZc2Omp+4lGG7loddKxpHOBbZiCN
	 dMng0SAQ/J/k1ys0M4lHy7SWdRhYf5ddawjlKm5bSvDYnoJ15skHgbKGW1sSJqmWMJi4m
	 5MDVnhGp431+gOLYrQ9npWqo9pXohGNGTLjD5+95BqLUIvOIo9RvpOhI43aqjQOnwR3JO
	 a8WWTb8eAknnsrzm3PCL7NCLFKMQfOpqyZ2yviG4i6KBHOGCQPpdWObKkd7W9t6Qw1aSo
	 hLEA/vmUV4JurrOVTG9QmvNLqroBO9dH3EO9KgdJ5DxWpL3ufex0pYTdc/UOT9mNrYw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026813;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=42H37l9r0YNiRNFFzNxlyOL+60S0d22tcZpTuaPBGrI=;
	b=IE01sJ7Selq5NZ9D0DeJ1PVWJCFV4TYfuq2NHJ2+qVahQc3wc2XonKMT9l0CxtOZSAtk
	 P4BAeceZdsRARmv8GBK/JZSFaoYFi3x6Cjzy27muQONG8ClgMbKAlI7k8wq68DsVg2qd+
	 ZVYI0uuSVZtQcO3JMgNtOrYsaT1zumAzsR6gN0+MMzzd+qNwziy2SmZ7Xg+C50PvkvZbi
	 NJ0/SNUf0USC8zvMfYYszmKbVmFWwrKvNjSDTOlXmEUqGaG1Ql55IDndCjagUiLGwy2bQ
	 Gc0wnQdHqzppqWmaH4+R3dONemcS/gdt1IWwiUCUrRJWaaHKvBMjPeqZDZ+br+tiubw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="e9U6A/yM";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5888F606A32F;
	Wed, 18 Nov 2026 18:33:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e9U6A/yM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60E1D1F000C4;
	Wed, 18 Nov 2026 18:33:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026812;
	bh=42H37l9r0YNiRNFFzNxlyOL+60S0d22tcZpTuaPBGrI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e9U6A/yMd6WnndnbEVD07u/mgLfgetNcwbbqmq9njvDKMkJ/aUeKdba8z2KtkSMwh
	 v9LCJITd/Mt5316TNDhfAHX+Z0YDjDZpSY0F19Eoj0sbSK6ELYHqNd7qHoQBKbJMSg
	 odziwvdeWWNAdaw7bL7HYOq78kZkGGG9JZPjdwGE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1569/2151] ata: libata: Move quirk flags to their own enum
Date: Wed, 18 Nov 2026 15:55:04 +0100
Message-ID: <20261118150219.038256410@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niklas Cassel <cassel@kernel.org>

[ Upstream commit a42b71d49945aac0b943987cbdec1d1c805caab3 ]

The anonymous enum in include/linux/libata.h that is used to store
various global constants can currently be backed by type int.
(It contains both negative and positive constants.)

__ATA_QUIRK_MAX is currently 31.
The quirk flags in the various global constants enum are defined as
"1U << quirk_flag_bit".

Thus if we simply add an additional quirk, the quirk flag will be 1 << 31,
which is a value that is too large to be represented by a signed int.
The various global constants enum will thus therefore be backed by type
long.

This will lead to error prints like e.g.:
ata_port_err(ap, "EH pending after %d tries, giving up\n",
	     ATA_EH_MAX_TRIES);

now failing to build, with build error:
error: format ‘%d’ expects argument of type ‘int’, but argument 4 has type ‘long int’ [-Werror=format=]

This is because all constants in the various global constants enum now
has to be printed as a long, as that is now the backing type of the enum.

Since the compiler will use the smallest possible backing type for an
enum, it is good practice to not mix unrelated things in a single enum.

Move the quirk flags to a separate enum, so that we don't need to change
the printf specifier for all other constants in the "various global
constants" enum when adding an additional quirk.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Stable-dep-of: 4153718a215e ("ata: libata-core: Fix NO_FUA quirks shadowed by earlier quirk entries")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/libata.h | 74 ++++++++++++++++++++++--------------------
 1 file changed, 38 insertions(+), 36 deletions(-)

diff --git a/include/linux/libata.h b/include/linux/libata.h
index a92908f07e220..9e7be3591b048 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -85,6 +85,44 @@ enum ata_quirks {
 	__ATA_QUIRK_MAX,
 };
 
+/*
+ * Quirk flags: may be set by libata or controller drivers on drives.
+ * Some quirks may be drive/controller pair dependent.
+ */
+enum {
+	ATA_QUIRK_DIAGNOSTIC		= (1U << __ATA_QUIRK_DIAGNOSTIC),
+	ATA_QUIRK_NODMA			= (1U << __ATA_QUIRK_NODMA),
+	ATA_QUIRK_NONCQ			= (1U << __ATA_QUIRK_NONCQ),
+	ATA_QUIRK_MAX_SEC_128		= (1U << __ATA_QUIRK_MAX_SEC_128),
+	ATA_QUIRK_BROKEN_HPA		= (1U << __ATA_QUIRK_BROKEN_HPA),
+	ATA_QUIRK_DISABLE		= (1U << __ATA_QUIRK_DISABLE),
+	ATA_QUIRK_HPA_SIZE		= (1U << __ATA_QUIRK_HPA_SIZE),
+	ATA_QUIRK_IVB			= (1U << __ATA_QUIRK_IVB),
+	ATA_QUIRK_STUCK_ERR		= (1U << __ATA_QUIRK_STUCK_ERR),
+	ATA_QUIRK_BRIDGE_OK		= (1U << __ATA_QUIRK_BRIDGE_OK),
+	ATA_QUIRK_ATAPI_MOD16_DMA	= (1U << __ATA_QUIRK_ATAPI_MOD16_DMA),
+	ATA_QUIRK_FIRMWARE_WARN		= (1U << __ATA_QUIRK_FIRMWARE_WARN),
+	ATA_QUIRK_1_5_GBPS		= (1U << __ATA_QUIRK_1_5_GBPS),
+	ATA_QUIRK_NOSETXFER		= (1U << __ATA_QUIRK_NOSETXFER),
+	ATA_QUIRK_BROKEN_FPDMA_AA	= (1U << __ATA_QUIRK_BROKEN_FPDMA_AA),
+	ATA_QUIRK_DUMP_ID		= (1U << __ATA_QUIRK_DUMP_ID),
+	ATA_QUIRK_MAX_SEC_LBA48		= (1U << __ATA_QUIRK_MAX_SEC_LBA48),
+	ATA_QUIRK_ATAPI_DMADIR		= (1U << __ATA_QUIRK_ATAPI_DMADIR),
+	ATA_QUIRK_NO_NCQ_TRIM		= (1U << __ATA_QUIRK_NO_NCQ_TRIM),
+	ATA_QUIRK_NOLPM			= (1U << __ATA_QUIRK_NOLPM),
+	ATA_QUIRK_WD_BROKEN_LPM		= (1U << __ATA_QUIRK_WD_BROKEN_LPM),
+	ATA_QUIRK_ZERO_AFTER_TRIM	= (1U << __ATA_QUIRK_ZERO_AFTER_TRIM),
+	ATA_QUIRK_NO_DMA_LOG		= (1U << __ATA_QUIRK_NO_DMA_LOG),
+	ATA_QUIRK_NOTRIM		= (1U << __ATA_QUIRK_NOTRIM),
+	ATA_QUIRK_MAX_SEC_1024		= (1U << __ATA_QUIRK_MAX_SEC_1024),
+	ATA_QUIRK_MAX_TRIM_128M		= (1U << __ATA_QUIRK_MAX_TRIM_128M),
+	ATA_QUIRK_NO_NCQ_ON_ATI		= (1U << __ATA_QUIRK_NO_NCQ_ON_ATI),
+	ATA_QUIRK_NO_LPM_ON_ATI		= (1U << __ATA_QUIRK_NO_LPM_ON_ATI),
+	ATA_QUIRK_NO_ID_DEV_LOG		= (1U << __ATA_QUIRK_NO_ID_DEV_LOG),
+	ATA_QUIRK_NO_LOG_DIR		= (1U << __ATA_QUIRK_NO_LOG_DIR),
+	ATA_QUIRK_NO_FUA		= (1U << __ATA_QUIRK_NO_FUA),
+};
+
 enum {
 	/* various global constants */
 	LIBATA_MAX_PRD		= ATA_MAX_PRD / 2,
@@ -391,42 +429,6 @@ enum {
 	 */
 	ATA_EH_CMD_TIMEOUT_TABLE_SIZE = 9,
 
-	/*
-	 * Quirk flags: may be set by libata or controller drivers on drives.
-	 * Some quirks may be drive/controller pair dependent.
-	 */
-	ATA_QUIRK_DIAGNOSTIC		= (1U << __ATA_QUIRK_DIAGNOSTIC),
-	ATA_QUIRK_NODMA			= (1U << __ATA_QUIRK_NODMA),
-	ATA_QUIRK_NONCQ			= (1U << __ATA_QUIRK_NONCQ),
-	ATA_QUIRK_MAX_SEC_128		= (1U << __ATA_QUIRK_MAX_SEC_128),
-	ATA_QUIRK_BROKEN_HPA		= (1U << __ATA_QUIRK_BROKEN_HPA),
-	ATA_QUIRK_DISABLE		= (1U << __ATA_QUIRK_DISABLE),
-	ATA_QUIRK_HPA_SIZE		= (1U << __ATA_QUIRK_HPA_SIZE),
-	ATA_QUIRK_IVB			= (1U << __ATA_QUIRK_IVB),
-	ATA_QUIRK_STUCK_ERR		= (1U << __ATA_QUIRK_STUCK_ERR),
-	ATA_QUIRK_BRIDGE_OK		= (1U << __ATA_QUIRK_BRIDGE_OK),
-	ATA_QUIRK_ATAPI_MOD16_DMA	= (1U << __ATA_QUIRK_ATAPI_MOD16_DMA),
-	ATA_QUIRK_FIRMWARE_WARN		= (1U << __ATA_QUIRK_FIRMWARE_WARN),
-	ATA_QUIRK_1_5_GBPS		= (1U << __ATA_QUIRK_1_5_GBPS),
-	ATA_QUIRK_NOSETXFER		= (1U << __ATA_QUIRK_NOSETXFER),
-	ATA_QUIRK_BROKEN_FPDMA_AA	= (1U << __ATA_QUIRK_BROKEN_FPDMA_AA),
-	ATA_QUIRK_DUMP_ID		= (1U << __ATA_QUIRK_DUMP_ID),
-	ATA_QUIRK_MAX_SEC_LBA48		= (1U << __ATA_QUIRK_MAX_SEC_LBA48),
-	ATA_QUIRK_ATAPI_DMADIR		= (1U << __ATA_QUIRK_ATAPI_DMADIR),
-	ATA_QUIRK_NO_NCQ_TRIM		= (1U << __ATA_QUIRK_NO_NCQ_TRIM),
-	ATA_QUIRK_NOLPM			= (1U << __ATA_QUIRK_NOLPM),
-	ATA_QUIRK_WD_BROKEN_LPM		= (1U << __ATA_QUIRK_WD_BROKEN_LPM),
-	ATA_QUIRK_ZERO_AFTER_TRIM	= (1U << __ATA_QUIRK_ZERO_AFTER_TRIM),
-	ATA_QUIRK_NO_DMA_LOG		= (1U << __ATA_QUIRK_NO_DMA_LOG),
-	ATA_QUIRK_NOTRIM		= (1U << __ATA_QUIRK_NOTRIM),
-	ATA_QUIRK_MAX_SEC_1024		= (1U << __ATA_QUIRK_MAX_SEC_1024),
-	ATA_QUIRK_MAX_TRIM_128M		= (1U << __ATA_QUIRK_MAX_TRIM_128M),
-	ATA_QUIRK_NO_NCQ_ON_ATI		= (1U << __ATA_QUIRK_NO_NCQ_ON_ATI),
-	ATA_QUIRK_NO_LPM_ON_ATI		= (1U << __ATA_QUIRK_NO_LPM_ON_ATI),
-	ATA_QUIRK_NO_ID_DEV_LOG		= (1U << __ATA_QUIRK_NO_ID_DEV_LOG),
-	ATA_QUIRK_NO_LOG_DIR		= (1U << __ATA_QUIRK_NO_LOG_DIR),
-	ATA_QUIRK_NO_FUA		= (1U << __ATA_QUIRK_NO_FUA),
-
 	/* User visible DMA mask for DMA control. DO NOT renumber. */
 	ATA_DMA_MASK_ATA	= (1 << 0),	/* DMA on ATA Disk */
 	ATA_DMA_MASK_ATAPI	= (1 << 1),	/* DMA on ATAPI */
-- 
2.53.0



