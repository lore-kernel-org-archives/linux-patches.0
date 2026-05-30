Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 847CB3546F6;
	Sat, 30 May 2026 17:16:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780161396; cv=none; b=dEH6rpJMTQ+M5Z6hfEqprJ8HutzdukCGZbXJetBsR5DHbgepp+5sI600CDjDuRVgJ1IXvC8pf9zL38D2vbKV02nuZy1qGZgPU1mc1GytW8YaGat0+5mLJikrOLSHVFLiIvU4j4k9OsBJcX7uamx12W0a9gNwY2269Mq+kOVdS3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780161396; c=relaxed/simple;
	bh=sSffx3UkrBPIOHiIAJLa1ijj3FB8QlvUCQFx9eIfVnM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jF0HIFosJrmNofnn9wCSiUbIqCUmQ4RCj890oxEFSoUBbuERynEkT0TDtUofFQT+to19wy1RiDz7L0XhrBCcHHIcfqRx+aV5D2/N2DVyn5uMSNCa6A2C7pxNm7JhLJYNfPdcTJx0zVuXptX7THjnqg3rx+hbqBe+VOpW2EjJoDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dbay6evG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dbay6evG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C90131F00893;
	Sat, 30 May 2026 17:16:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780161395;
	bh=wDJ+djticFuMnP+WdYMgBNGbyOymuy0HsDsrktx2Bbk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dbay6evGfGl6wtkiqLw2Sx1ovhZKyqsI+2fxI8lC77TBKMscpI8R6dc5ljU9qeH0g
	 HuPfzm0qZCoJtYx2vf+PAoYVjkfjRKT99gCq7//Zuf5mxbQnEp7nV/dxEApEQIcuzF
	 5mNWl+qyGtlO6u9Tp23wmPNPhyxntAVhYAtGIGuc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Gorski <jonas.gorski@gmail.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 612/969] mtd: spi-nor: update spi_nor_fixups::post_sfdp() documentation
Date: Sat, 30 May 2026 18:02:16 +0200
Message-ID: <20260530160317.332514933@linuxfoundation.org>
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

From: Jonas Gorski <jonas.gorski@gmail.com>

[ Upstream commit 3620d67b48493c6252bbc873dc88dde81641d56b ]

After commit 5273cc6df984 ("mtd: spi-nor: core: Call
spi_nor_post_sfdp_fixups() only when SFDP is defined")
spi_nor_post_sfdp_fixups() isn't called anymore if no SFDP is detected.

Update the documentation accordingly.

Fixes: 5273cc6df984 ("mtd: spi-nor: core: Call spi_nor_post_sfdp_fixups() only when SFDP is defined")
Signed-off-by: Jonas Gorski <jonas.gorski@gmail.com>
Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/spi-nor/core.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/spi-nor/core.h b/drivers/mtd/spi-nor/core.h
index 1bf6bad5942d6..da451859c3910 100644
--- a/drivers/mtd/spi-nor/core.h
+++ b/drivers/mtd/spi-nor/core.h
@@ -411,7 +411,7 @@ struct spi_nor_flash_parameter {
  *                   number of dummy cycles in read register ops.
  * @smpt_map_id: called after map ID in SMPT table has been determined for the
  *               case the map ID is wrong and needs to be fixed.
- * @post_sfdp: called after SFDP has been parsed (is also called for SPI NORs
+ * @post_sfdp: called after SFDP has been parsed (is not called for SPI NORs
  *             that do not support RDSFDP). Typically used to tweak various
  *             parameters that could not be extracted by other means (i.e.
  *             when information provided by the SFDP/flash_info tables are
-- 
2.53.0



