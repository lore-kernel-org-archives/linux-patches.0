Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D024F2FDC5E;
	Sat, 30 May 2026 17:28:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780162133; cv=none; b=Pak2FeXvY16JymDB+RAGG3GEoD+/6IK6add8JyzNrcsnRF2wYjEmOzbI6TKqg0C5P74eLp2rJQsau4ezTgLYBFc3gBQ7kyFmdsLP7FVd3AYD/gN7DO0+DKRqDg2XBA6Y3mUcdhQC8LmoS/eABVT4XEYekVwL9QWDLup1gxghQ1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780162133; c=relaxed/simple;
	bh=Rec9C2vGef9/qcQX70+Lztm5O9Bpku/grmt6wCPT4L8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MZxIKEOd4aWv1MBNBFJ2B5bvu1LBiiz6hp4XdbJfKdXamFdjtKVTna1SzxCvFX6GOtrt00gA7pYTKv3nbPSY8UwEuXrJSc357hiRe2H64C20w3XE/M7mTlm6j2V9eGuFKftZbHe4ZUIEb5oSD6Is0RUFQal9NrAkA+oNWbkadfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Nwdi+huX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nwdi+huX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D95E1F00893;
	Sat, 30 May 2026 17:28:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780162132;
	bh=hSWK3gw8uGJpZfEYmbPsz6s/7xZP1qCPhIpCuMkMZZk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Nwdi+huXA2Z4fhvcGFGgppucKGOYnUcCUvDppqb+YZ/m8YNz+D7d+OTIeR1xZmaor
	 uHe3s+PrLFFu1oFtB8242rmtgfxI7jR1mXfvT7forIa46bKWhY1rt3sxU0+G0aNy7H
	 I/z8htPLD4HUHZBcLOQoyBir9/VAFJNWAz2QuBHQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tudor Ambarus <tudor.ambarus@linaro.org>,
	Takahiro Kuwano <Takahiro.Kuwano@infineon.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 801/969] mtd: spi-nor: spansion: Enable JFFS2 write buffer for S25FS256T
Date: Sat, 30 May 2026 18:05:25 +0200
Message-ID: <20260530160322.747607546@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

From: Takahiro Kuwano <Takahiro.Kuwano@infineon.com>

[ Upstream commit a9180c298d3527f43563d02a62cb9e7e145642c6 ]

Infineon(Cypress) SEMPER NOR flash family has on-die ECC and its program
granularity is 16-byte ECC data unit size. JFFS2 supports write buffer
mode for ECC'd NOR flash. Provide a way to clear the MTD_BIT_WRITEABLE
flag in order to enable JFFS2 write buffer mode support. Drop the
comment as the same info is now specified in cypress_nor_ecc_init().

Fixes: 6afcc84080c4 ("mtd: spi-nor: spansion: Add support for Infineon S25FS256T")
Suggested-by: Tudor Ambarus <tudor.ambarus@linaro.org>
Signed-off-by: Takahiro Kuwano <Takahiro.Kuwano@infineon.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/641bfb26c6e059915ae920117b7ec278df1a6f0a.1680760742.git.Takahiro.Kuwano@infineon.com
Signed-off-by: Tudor Ambarus <tudor.ambarus@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/spi-nor/spansion.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/mtd/spi-nor/spansion.c b/drivers/mtd/spi-nor/spansion.c
index af97e3741f987..cd2d6a95d66e1 100644
--- a/drivers/mtd/spi-nor/spansion.c
+++ b/drivers/mtd/spi-nor/spansion.c
@@ -273,13 +273,7 @@ static int s25fs256t_post_sfdp_fixup(struct spi_nor *nor)
 
 static void s25fs256t_late_init(struct spi_nor *nor)
 {
-	/*
-	 * Programming is supported only in 16-byte ECC data unit granularity.
-	 * Byte-programming, bit-walking, or multiple program operations to the
-	 * same ECC data unit without an erase are not allowed. See chapter
-	 * 5.3.1 and 5.6 in the datasheet.
-	 */
-	nor->params->writesize = 16;
+	cypress_nor_ecc_init(nor);
 }
 
 static struct spi_nor_fixups s25fs256t_fixups = {
-- 
2.53.0



