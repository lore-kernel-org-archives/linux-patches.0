Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 367083FC5D4;
	Wed, 20 May 2026 18:38:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302339; cv=none; b=U5UAJR60P9g0mJ4vnz87L4Fu5Wam42Mqf+L2Zgl2AunjpZXL0dnQ/Ptqc+p2LY/bMZCz6IjRNAFsSem5I9FBMqtczQlGjX/yVzVEW/+aH841aNLkhri0e5qRpGjLCLJhs2jzQ+sSkftoJsYYpNcLPP0+xex93taqjTOiymRUJrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302339; c=relaxed/simple;
	bh=uDc9AueAL4+plFpLKWO1EdDOX0YbV0L7DR1C8sQKQ5w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hx/GQfh1VP9ab0PwVKsJgEBmIzg9wOAYfbFeuoFIUvm83jLfHzFLqqoT3swquwEmPHuPha4zWBO17Ks+eps80x84LzdOTJj7Ht2QyOxh1LNQUS2uPeTKxgBtddZ6zH/VChnHOk1KEW9nC2+6gX18M+XOcFO5RT3xzXbQ4e+XJGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0wviswlJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0wviswlJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DA1F1F008A3;
	Wed, 20 May 2026 18:38:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302337;
	bh=2bTdPhUsmVAEbk3e40XlH5q5c2/1x0lcmT9KXw4XQ3k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0wviswlJ76YWMsEfPY1WXjGu2GgqXbvaxNOWCw/kOgvPvK/252O0aSg37daJWKybr
	 hjZouzzr3iLsVUreumTmJMvabdGjWe7l/xRd4SjLgWCmIR+djJMpgiYrISQsoq4gDd
	 kd0i2UYGRvtNVTIr4eHMuIrbwDQi4rK8N4F7VUVs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Gorski <jonas.gorski@gmail.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 229/508] mtd: spi-nor: update spi_nor_fixups::post_sfdp() documentation
Date: Wed, 20 May 2026 18:20:52 +0200
Message-ID: <20260520162103.612077078@linuxfoundation.org>
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
index 6c478331e494e..398383ba0d8d6 100644
--- a/drivers/mtd/spi-nor/core.h
+++ b/drivers/mtd/spi-nor/core.h
@@ -420,7 +420,7 @@ struct spi_nor_flash_parameter {
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



