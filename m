Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026816;
	b=M+eoLY90gHF5QsN9zNDLnhVQRcnUujUvlOZrrDco+YxtGqZgJhOBWJ401lniI4TgQZN6
	 kQFOnHQCQtCpEOtrRs8kXK6r0EI/Q0r47JI6cm93NFfHgfxHbTvowleTJvAOiqQA/ajjp
	 SHyae7pVadYcnKoEcyo3Wek9IDSw7lBQu/uFwYqUOgTqDHNsm/b0JPVcyuPx0Jz4Ye+gE
	 q81kzM68tQ9CWEx0mgZ1HuhRKtFX2vAGwxl8r0rhaJ5oRgvgpRdGGBoct46Iqtm18HNcH
	 nkIN5dHFbmBcGfdcYStX0KFLMYrTC5FcpewBAIHkHANL7kDlBkIOdL/6OSRXsT0dMUA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026816;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iHyOmFMm1JG+zDDR+GV+6Pr2IjyspvEl93VOACC0UF4=;
	b=erxnP6X3J730k11lyCFZakJAoNJ8kjs79ok8YTm8xS12Et0KnqILXautURHoEuYwxYTo
	 pJ4z5KBX5Xyi6RwHDOyjEn0rK+d+JtkJcrfgboe+m5BibVKi0rVQ9DhXUTVuvckha0srg
	 XjcK+AxgxLzI7kCocceMq9bAd/moKH1daQkPjf4KB5xYUKY1HyYCMMnh7M3m7R/8QQMGV
	 pMFFajYa+Y+5IM3h9VJZoEFt7aCB5yyz8ms/PY/uPhNWfpor+Lkn2M/JH7WXn188uihSQ
	 e1vRV62sd6eGWuFzHrrjqz1//0A31MMQLRzWoaV2bQzAgf2dtZemV3KcvsQiCi+WzaQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="UgI37/h+";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED121606A33F;
	Wed, 18 Nov 2026 18:33:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UgI37/h+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47D491F000C4;
	Wed, 18 Nov 2026 18:33:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026815;
	bh=iHyOmFMm1JG+zDDR+GV+6Pr2IjyspvEl93VOACC0UF4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UgI37/h+FXGzj1NiRSNSkPB7uOZaMsq/VRTiKgw9OV8xuHG41v5CxyUhiKzLg/FDq
	 VvvWu9h6MUdUtX5EU6Ugb8SZ4ADsgXWjcJmXieRQ3a8Fcva2VWUrNAxydadXgaPeVM
	 FXx2KZQoHYKy++xLmRslM9pNqo1/Nk5cZMwid6kM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	stable+noautosel@kernel.org
Subject: [PATCH 6.18 1570/2151] ata: libata-core: Quirk DELLBOSS VD max_sectors
Date: Wed, 18 Nov 2026 15:55:05 +0100
Message-ID: <20261118150219.077983613@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niklas Cassel <cassel@kernel.org>

[ Upstream commit 2e983271363108b3813b38754eb96d9b1cb252bb ]

Commit 9b8b84879d4a ("block: Increase BLK_DEF_MAX_SECTORS_CAP") increased
the default max_sectors_kb from 1280 KiB to 4096 KiB.

DELLBOSS VD with FW rev MV.R00-0 times out when sending I/Os of size
4096 KiB.

Enable ATA_QUIRK_MAX_SEC, with value 8191 (sectors) for this device,
since any I/O with more sectors than that lead to I/O timeouts.

With this, the DELLBOSS VD SATA controller is usable again.

Cc: stable+noautosel@kernel.org # depends on Move quirk flags to their own enum
Fixes: 9b8b84879d4a ("block: Increase BLK_DEF_MAX_SECTORS_CAP")
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Stable-dep-of: 4153718a215e ("ata: libata-core: Fix NO_FUA quirks shadowed by earlier quirk entries")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/libata-core.c | 11 +++++++++++
 include/linux/ata.h       |  1 +
 include/linux/libata.h    |  2 ++
 3 files changed, 14 insertions(+)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index cb74c6a5d9aa1..1034ba393456e 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -3203,6 +3203,10 @@ int ata_dev_configure(struct ata_device *dev)
 		dev->max_sectors = min_t(unsigned int, ATA_MAX_SECTORS_1024,
 					 dev->max_sectors);
 
+	if (dev->quirks & ATA_QUIRK_MAX_SEC_8191)
+		dev->max_sectors = min_t(unsigned int, ATA_MAX_SECTORS_8191,
+					 dev->max_sectors);
+
 	if (dev->quirks & ATA_QUIRK_MAX_SEC_LBA48)
 		dev->max_sectors = ATA_MAX_SECTORS_LBA48;
 
@@ -4055,6 +4059,7 @@ static const char * const ata_quirk_names[] = {
 	[__ATA_QUIRK_NO_DMA_LOG]	= "nodmalog",
 	[__ATA_QUIRK_NOTRIM]		= "notrim",
 	[__ATA_QUIRK_MAX_SEC_1024]	= "maxsec1024",
+	[__ATA_QUIRK_MAX_SEC_8191]	= "maxsec8191",
 	[__ATA_QUIRK_MAX_TRIM_128M]	= "maxtrim128m",
 	[__ATA_QUIRK_NO_NCQ_ON_ATI]	= "noncqonati",
 	[__ATA_QUIRK_NO_LPM_ON_ATI]	= "nolpmonati",
@@ -4161,6 +4166,12 @@ static const struct ata_dev_quirks_entry __ata_dev_quirks[] = {
 	{ "LITEON CX1-JB*-HP",	NULL,		ATA_QUIRK_MAX_SEC_1024 },
 	{ "LITEON EP1-*",	NULL,		ATA_QUIRK_MAX_SEC_1024 },
 
+	/*
+	 * These devices time out with higher max sects.
+	 * https://bugzilla.kernel.org/show_bug.cgi?id=220693
+	 */
+	{ "DELLBOSS VD",	"MV.R00-0",	ATA_QUIRK_MAX_SEC_8191 },
+
 	/* Devices we expect to fail diagnostics */
 
 	/* Devices where NCQ should be avoided */
diff --git a/include/linux/ata.h b/include/linux/ata.h
index c9013e472aa3d..54b416e269959 100644
--- a/include/linux/ata.h
+++ b/include/linux/ata.h
@@ -29,6 +29,7 @@ enum {
 	ATA_MAX_SECTORS_128	= 128,
 	ATA_MAX_SECTORS		= 256,
 	ATA_MAX_SECTORS_1024    = 1024,
+	ATA_MAX_SECTORS_8191    = 8191,
 	ATA_MAX_SECTORS_LBA48	= 65535,/* avoid count to be 0000h */
 	ATA_MAX_SECTORS_TAPE	= 65535,
 	ATA_MAX_TRIM_RNUM	= 64,	/* 512-byte payload / (6-byte LBA + 2-byte range per entry) */
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 9e7be3591b048..3a50f96d38403 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -75,6 +75,7 @@ enum ata_quirks {
 	__ATA_QUIRK_NO_DMA_LOG,		/* Do not use DMA for log read */
 	__ATA_QUIRK_NOTRIM,		/* Do not use TRIM */
 	__ATA_QUIRK_MAX_SEC_1024,	/* Limit max sects to 1024 */
+	__ATA_QUIRK_MAX_SEC_8191,	/* Limit max sects to 8191 */
 	__ATA_QUIRK_MAX_TRIM_128M,	/* Limit max trim size to 128M */
 	__ATA_QUIRK_NO_NCQ_ON_ATI,	/* Disable NCQ on ATI chipset */
 	__ATA_QUIRK_NO_LPM_ON_ATI,	/* Disable LPM on ATI chipset */
@@ -115,6 +116,7 @@ enum {
 	ATA_QUIRK_NO_DMA_LOG		= (1U << __ATA_QUIRK_NO_DMA_LOG),
 	ATA_QUIRK_NOTRIM		= (1U << __ATA_QUIRK_NOTRIM),
 	ATA_QUIRK_MAX_SEC_1024		= (1U << __ATA_QUIRK_MAX_SEC_1024),
+	ATA_QUIRK_MAX_SEC_8191		= (1U << __ATA_QUIRK_MAX_SEC_8191),
 	ATA_QUIRK_MAX_TRIM_128M		= (1U << __ATA_QUIRK_MAX_TRIM_128M),
 	ATA_QUIRK_NO_NCQ_ON_ATI		= (1U << __ATA_QUIRK_NO_NCQ_ON_ATI),
 	ATA_QUIRK_NO_LPM_ON_ATI		= (1U << __ATA_QUIRK_NO_LPM_ON_ATI),
-- 
2.53.0



