Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95D4C3D75C7;
	Wed, 20 May 2026 17:36:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298592; cv=none; b=t6p+TJqHQMxOIfGDsFIr5wnztqEpQBZiQ9KvuE7JKvHqgN40frAxJnh9Sko9Sy7JXogBjG3acMK97cwN0T9Q5YlagZJmvHolBFVRBiKtcttk/Ao8tiIYVFzhYC/6m6UGAcffTTaubzl541Mh0rTN/WuqbJenMqxxYHS88+kjqbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298592; c=relaxed/simple;
	bh=6DR5yD27V7q1GQdU20U74zf/tcQbaZ94X+gM3yIhK4g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FRGAPAILxsJbvrpZNjHko8Nmnp4gPI/E3ELkclPaAML/1Jp3dB+Yq0FmoqEdPFIoApLZKhftO4vjYkSHNsLHdpf/zi42oZa2Vj+002UWQm8E17NLjomKLPd0g0/Ti3dvta4tXrlTudgxwbd/ON6cAM7skl5EXK+BLETiSuAkQJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1kYngEZ8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1kYngEZ8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A66321F000E9;
	Wed, 20 May 2026 17:36:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298591;
	bh=Wb2h8iLfJ40gup5Mwns0wgu8M7HYB3aJTQMCqnhhDxk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1kYngEZ8P6BosCrg/zXP7v3RnFbtpJbuWaRZCcADnOcX4MjSt4gZPPvcmJiZz8fbI
	 xsmqzmix0kfBLZBdXK3z9mu0lYJqTg8NF7d6qg7uK9PXMF2HLPcxQZj2t7OnBDcr3z
	 xzTLmfGmVWrzuBkfRh3RPYLA04HdYZ5WgihkTLD8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Gorski <jonas.gorski@gmail.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 468/957] mtd: spi-nor: update spi_nor_fixups::post_sfdp() documentation
Date: Wed, 20 May 2026 18:15:51 +0200
Message-ID: <20260520162144.673989357@linuxfoundation.org>
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
index 16b382d4f04f2..e838c40a25897 100644
--- a/drivers/mtd/spi-nor/core.h
+++ b/drivers/mtd/spi-nor/core.h
@@ -413,7 +413,7 @@ struct spi_nor_flash_parameter {
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



