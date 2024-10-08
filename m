Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F03001C5793;
	Tue,  8 Oct 2024 13:16:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728393384; cv=none; b=kLpFmOO17911w21sLK+/qvIDW1BEXZV01k6LrvakHA2u28H0iRxzW64oC1ol3OaLxMDsjYFrMUb6LJ2c4qdKizOtU1q/WUKGCGm2A+ODnzzo1X0CDROpVu4gZxcgaCKQcQLuBzDgj7dl6MjSJmp2uvfzdu1QSry40nWnl47thlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728393384; c=relaxed/simple;
	bh=izMb9lzwB6H4R1iu1I4HIrOxPZRSgtOBrhQI7YG5nW8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GNjB3wLmM732vkk9IEyGxMBjuWPNw+3JnO1hG4MXD1Kw68MfpxBqozx5AnIqPWxJ7j5er5cK5rXBVEKol/P7kKse7TKmVtrKAIcr3i1I0xknEhj25qkYsXZ49EegItMXsBMbdbRVU1w9KPMAVInIMQ7bcaEBpbLts/LC1evKgg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BpZLnwJk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BpZLnwJk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 749E9C4CEC7;
	Tue,  8 Oct 2024 13:16:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728393383;
	bh=izMb9lzwB6H4R1iu1I4HIrOxPZRSgtOBrhQI7YG5nW8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BpZLnwJkTWrzNX8/rbbLPxhLlnigeoMVwfjvk7vNJqme/bc+mRShNDQPKvPH+jXbX
	 1VTvH4Ki8jyIBeya++x51zbRXmfuqJ4Vp6dYpLqnqoona3no27jveecOrDfDbbIVdo
	 Rqk0B77oaI5ZUxo/SNBuw6h34AvsMp9HCw1AfECw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Igor Pylypiv <ipylypiv@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 136/386] ata: sata_sil: Rename sil_blacklist to sil_quirks
Date: Tue,  8 Oct 2024 14:06:21 +0200
Message-ID: <20241008115634.786595393@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Damien Le Moal <dlemoal@kernel.org>

[ Upstream commit 93b0f9e11ce511353c65b7f924cf5f95bd9c3aba ]

Rename the array sil_blacklist to sil_quirks as this name is more
neutral and is also consistent with how this driver define quirks with
the SIL_QUIRK_XXX flags.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Niklas Cassel <cassel@kernel.org>
Reviewed-by: Igor Pylypiv <ipylypiv@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/sata_sil.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/ata/sata_sil.c b/drivers/ata/sata_sil.c
index cc77c02482843..df095659bae0f 100644
--- a/drivers/ata/sata_sil.c
+++ b/drivers/ata/sata_sil.c
@@ -128,7 +128,7 @@ static const struct pci_device_id sil_pci_tbl[] = {
 static const struct sil_drivelist {
 	const char *product;
 	unsigned int quirk;
-} sil_blacklist [] = {
+} sil_quirks[] = {
 	{ "ST320012AS",		SIL_QUIRK_MOD15WRITE },
 	{ "ST330013AS",		SIL_QUIRK_MOD15WRITE },
 	{ "ST340017AS",		SIL_QUIRK_MOD15WRITE },
@@ -600,8 +600,8 @@ static void sil_thaw(struct ata_port *ap)
  *	list, and apply the fixups to only the specific
  *	devices/hosts/firmwares that need it.
  *
- *	20040111 - Seagate drives affected by the Mod15Write bug are blacklisted
- *	The Maxtor quirk is in the blacklist, but I'm keeping the original
+ *	20040111 - Seagate drives affected by the Mod15Write bug are quirked
+ *	The Maxtor quirk is in sil_quirks, but I'm keeping the original
  *	pessimistic fix for the following reasons...
  *	- There seems to be less info on it, only one device gleaned off the
  *	Windows	driver, maybe only one is affected.  More info would be greatly
@@ -620,9 +620,9 @@ static void sil_dev_config(struct ata_device *dev)
 
 	ata_id_c_string(dev->id, model_num, ATA_ID_PROD, sizeof(model_num));
 
-	for (n = 0; sil_blacklist[n].product; n++)
-		if (!strcmp(sil_blacklist[n].product, model_num)) {
-			quirks = sil_blacklist[n].quirk;
+	for (n = 0; sil_quirks[n].product; n++)
+		if (!strcmp(sil_quirks[n].product, model_num)) {
+			quirks = sil_quirks[n].quirk;
 			break;
 		}
 
-- 
2.43.0



