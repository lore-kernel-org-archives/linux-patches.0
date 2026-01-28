Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D7E22D0C99;
	Wed, 28 Jan 2026 15:34:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769614496; cv=none; b=DuPNRPFOwt0sweZyjny9bd1JJ+sSn/+NNj2E0y7GVCEW6y8pT2GqcNQhOu3cuyRdhfWDRID0bAu4OEGiJVh73bHXBtG9YwXaysq1M+mk1F3bLeS/ZjLIficLUuBYsp5tGfNZ0Sf/OJZW3A0wiIz3PVBGQMjDlEbDNF8ipahI0CY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769614496; c=relaxed/simple;
	bh=YjwjOiqyiSu8XbLdAmnfBai8l+7AOZPZcPgLX69Bbt8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KNoTSsAEufeEI7DZy+UFy4mEoqf4vDc1xB0JAw9IYBJZapxHBd7y+D1pEsL1BnS9Aq/U7Zc8Cm0U9Iq6IK+7YRi/Npuy16gCh39MKv4P6RXyeSY99cQ5V1I123owQi2FM65LPpUesQ1haG0ZZx8mFMLn5NSrTyrDJUFIER5WPWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BlYcjlEP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BlYcjlEP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D43DC4CEF1;
	Wed, 28 Jan 2026 15:34:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769614495;
	bh=YjwjOiqyiSu8XbLdAmnfBai8l+7AOZPZcPgLX69Bbt8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BlYcjlEPGBlMByWSLiQR9YrudtvIV3a8t3u+l+pdWI+8Im0kAR28FrEqNorBZPw1J
	 oyVOSoRLxf2aZD6bGKKjJbW+VuMqKiSiDC+uwuNP/2U4dpnRVV46Pt4k/Ur0dENx1S
	 jvmPwyvDOGnIUc4XW3UfWTKTmVHzsGQByHNn8g/k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 155/254] spi: sprd-adi: switch to use spi_alloc_host()
Date: Wed, 28 Jan 2026 16:22:11 +0100
Message-ID: <20260128145350.389382141@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.698118637@linuxfoundation.org>
References: <20260128145344.698118637@linuxfoundation.org>
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

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 0a3d087d09a8f52c02d0014bad63be99c53c4812 ]

Switch to use modern name function spi_alloc_host().

No functional changed.

Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://msgid.link/r/20231128093031.3707034-2-yangyingliang@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 383d4f5cffcc ("spi: spi-sprd-adi: Fix double free in probe error path")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-sprd-adi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi-sprd-adi.c b/drivers/spi/spi-sprd-adi.c
index 58c3badd9c79a..262c11d977ea3 100644
--- a/drivers/spi/spi-sprd-adi.c
+++ b/drivers/spi/spi-sprd-adi.c
@@ -528,7 +528,7 @@ static int sprd_adi_probe(struct platform_device *pdev)
 	pdev->id = of_alias_get_id(np, "spi");
 	num_chipselect = of_get_child_count(np);
 
-	ctlr = spi_alloc_master(&pdev->dev, sizeof(struct sprd_adi));
+	ctlr = spi_alloc_host(&pdev->dev, sizeof(struct sprd_adi));
 	if (!ctlr)
 		return -ENOMEM;
 
-- 
2.51.0



