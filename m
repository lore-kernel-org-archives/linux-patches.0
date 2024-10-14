Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AC761AD3E1;
	Mon, 14 Oct 2024 14:50:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917443; cv=none; b=VpANiPnAM7rRAMEtMJbD8MAYgc2NZmLiRVR+OuEQ5GxM1y6MUScnu9WXvE5BvBe+S9Xh5HoI1zFe4YroB2elOalfPmXBzTBBguKqcBlQDvnjNOaDHGcvufuPNB1rCGzVDXr7D7lXuG699TWkfmwAbj9N3nF5YCu0G71AeMDrcLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917443; c=relaxed/simple;
	bh=s+Q9ae2CKP13EopAvWmLG+7j2KYCesuYVuYy4wyM4ys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WpINSN3/4bdQnVOzgs9EGmBc8ZaC6L7OaMr7LfDGsE3ihaBwUgSS7fnK/kyfz+lAQbwQWFz8vdiDKpdkJOOGsmW6KD8xAvs/amNPXMTYvK+EbToOIwWevGBcaoHUTHWMO3SnYIRiH7jX+ZIufo3ACLzzuplL6JKqsEWMxg0V/h4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YynYtv0s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YynYtv0s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71351C4CEC3;
	Mon, 14 Oct 2024 14:50:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917442;
	bh=s+Q9ae2CKP13EopAvWmLG+7j2KYCesuYVuYy4wyM4ys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YynYtv0s6GUnDn9kdfrQBbIocsI69M9WiFuguhbNTsxJoffOY74mabXRhg9fSp+QB
	 6UqHDdCryVFnd+ShTL8G7K5uvsawFUGv5m1qHzBD/Yr6He65jZoDbSbfSpEgeV/uqk
	 KbckwKyhO1xsJl1hO5hBXmMm4jsV61GBQ3OJXWbk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weili Qian <qianweili@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 037/798] crypto: hisilicon/hpre - enable sva error interrupt event
Date: Mon, 14 Oct 2024 16:09:51 +0200
Message-ID: <20241014141219.401220431@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Weili Qian <qianweili@huawei.com>

[ Upstream commit 391dde6e48ff84687395a0a4e84f7e1540301e4e ]

Enable sva error interrupt event. When an error occurs on
the sva module, the device reports an abnormal interrupt to
the driver.

Signed-off-by: Weili Qian <qianweili@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Stable-dep-of: 145013f72394 ("crypto: hisilicon/hpre - mask cluster timeout error")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/hisilicon/hpre/hpre_main.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/hisilicon/hpre/hpre_main.c b/drivers/crypto/hisilicon/hpre/hpre_main.c
index 269df4ec148ba..19a36facabcc4 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_main.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_main.c
@@ -203,7 +203,7 @@ static const struct hisi_qm_cap_info hpre_basic_info[] = {
 	{HPRE_QM_RESET_MASK_CAP, 0x3128, 0, GENMASK(31, 0), 0x0, 0xC37, 0x6C37},
 	{HPRE_QM_OOO_SHUTDOWN_MASK_CAP, 0x3128, 0, GENMASK(31, 0), 0x0, 0x4, 0x6C37},
 	{HPRE_QM_CE_MASK_CAP, 0x312C, 0, GENMASK(31, 0), 0x0, 0x8, 0x8},
-	{HPRE_NFE_MASK_CAP, 0x3130, 0, GENMASK(31, 0), 0x0, 0x3FFFFE, 0xFFFFFE},
+	{HPRE_NFE_MASK_CAP, 0x3130, 0, GENMASK(31, 0), 0x0, 0x3FFFFE, 0x1FFFFFE},
 	{HPRE_RESET_MASK_CAP, 0x3134, 0, GENMASK(31, 0), 0x0, 0x3FFFFE, 0xBFFFFE},
 	{HPRE_OOO_SHUTDOWN_MASK_CAP, 0x3134, 0, GENMASK(31, 0), 0x0, 0x22, 0xBFFFFE},
 	{HPRE_CE_MASK_CAP, 0x3138, 0, GENMASK(31, 0), 0x0, 0x1, 0x1},
@@ -283,6 +283,9 @@ static const struct hpre_hw_error hpre_hw_errors[] = {
 	}, {
 		.int_msk = BIT(23),
 		.msg = "sva_fsm_timeout_int_set"
+	}, {
+		.int_msk = BIT(24),
+		.msg = "sva_int_set"
 	}, {
 		/* sentinel */
 	}
-- 
2.43.0



