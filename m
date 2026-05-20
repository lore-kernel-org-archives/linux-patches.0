Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA9B13ED5C8;
	Wed, 20 May 2026 17:36:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298618; cv=none; b=AcHRVaYFxCMhgDjvesHbM4Fv/yZZ7r3XHPQPuMBlkBacmoep4P8N6CWpR/Y/EkSU+AGkfm7BhRLM6Zcdwi4llaHqD6hwrYpgsvUIqLbly0Z/9nyBvBsc7V6liTweupSKOJrjhXMlQAwIT5I4+ZR24O6hBLAiT4ajbVoVlcABoDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298618; c=relaxed/simple;
	bh=1jnKUWFbPjNrr9BGXsMkQMHOaYG2eNtNjenmz9tZGCY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OsiYtCyNHlDtgInQwJ/ZU/AdrSJYcFocrFyb/Et8mDEtb2p4L1m4Gm2pi1qP1I5u7Mq6XziMS1Gl48kYBGqsBYjQZGmgbD/IGN/qGyFXIdr5AwU5gvU3MdiAfJ0bK9ns+QF4XjwKjEvCtNS3UwV5NATUdm42CkUeGhKXJoZ8QHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WXnWZnGR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WXnWZnGR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67E2F1F00893;
	Wed, 20 May 2026 17:36:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298614;
	bh=HA3Zw8+x2lfSJkx7o4C19ufPrpfv+CQw4Xi6BL7aq7I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WXnWZnGRPwv9MEmrN4Ce3ULxWUhMTEkI7OScd1sQ/A6WCCCxSzkGkcAzj50NTHhg8
	 maNH+Jv4Of3WpUQ1hlVUoX2pIgioR/Edx4hbyhwBHQknEX6tFsW6V1PD7e0hKJluOq
	 c5VjuDgoRwMfhZ+IHBv2WTvuM6u3ZJA8X4bfDyTk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 477/957] mtd: spinand: winbond: Rename IO_MODE register macro
Date: Wed, 20 May 2026 18:16:00 +0200
Message-ID: <20260520162144.871458418@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miquel Raynal <miquel.raynal@bootlin.com>

[ Upstream commit 57e1015cc9a96372f330195abe32a904ec8d1eab ]

Suffix the macro name with *_REG to align with the rest of the driver.

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Stable-dep-of: 25a915fad503 ("mtd: spinand: winbond: Clarify when to enable the HS bit")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/spi/winbond.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mtd/nand/spi/winbond.c b/drivers/mtd/nand/spi/winbond.c
index b389c9ee58508..2361109101727 100644
--- a/drivers/mtd/nand/spi/winbond.c
+++ b/drivers/mtd/nand/spi/winbond.c
@@ -22,7 +22,7 @@
 #define W25N0XJW_SR4			0xD0
 #define W25N0XJW_SR4_HS			BIT(2)
 
-#define W35N01JW_VCR_IO_MODE			0x00
+#define W35N01JW_VCR_IO_MODE_REG	0x00
 #define W35N01JW_VCR_IO_MODE_SINGLE_SDR		0xFF
 #define W35N01JW_VCR_IO_MODE_OCTAL_SDR		0xDF
 #define W35N01JW_VCR_IO_MODE_OCTAL_DDR_DS	0xE7
@@ -368,7 +368,7 @@ static int w35n0xjw_vcr_cfg(struct spinand_device *spinand)
 	else
 		return -EINVAL;
 
-	ret = w35n0xjw_write_vcr(spinand, W35N01JW_VCR_IO_MODE, io_mode);
+	ret = w35n0xjw_write_vcr(spinand, W35N01JW_VCR_IO_MODE_REG, io_mode);
 	if (ret)
 		return ret;
 
-- 
2.53.0



