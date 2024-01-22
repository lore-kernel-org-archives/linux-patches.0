Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0D5814A081;
	Tue, 23 Jan 2024 01:08:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705972099; cv=none; b=U3fJIF6WO98IT6fJXJ65ynwn4HOOMypYf/eE3nPB0ih2WdR7MsJxembBptRsqRCN+lAF/xAepTUVplpA1WgIzHcNHpeCzkYz5Z1NnKiqIaFOx49zGemZ6JcNZQpfI++qvhokGBa3ahhBfMJIX8HW0BPYTeIuGJj+8mRTLF1oI6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705972099; c=relaxed/simple;
	bh=nTgtlw44IMrSKzAVmhmXtAl3s5wv3+J7sWL9OEvMCZk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lBmkb30oNxA/Z0AEBkLVyRUNNFmyhvcahf9s46gtmcQxiRolsS2J2D3WH/43lEluqqoPtS7up/IzlKBc5+e+P0yv8mpHsLL3/uOjfLEcTzM2G+q7b6LsG9sV+wiGd9P4dzuB1JyqzF8dD5YXMRzEO6YbMxe/KWy/7qznzjRcsb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oAVe4xA3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oAVe4xA3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94D64C43390;
	Tue, 23 Jan 2024 01:08:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705972098;
	bh=nTgtlw44IMrSKzAVmhmXtAl3s5wv3+J7sWL9OEvMCZk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oAVe4xA3V+reeimAegAg3KMpRCA3OsZle/+xL7aiaOIHCndvdbwDvsyxmlOFqYQuV
	 P1EiVG9fAycx0nbT38HMckhsDl4JJ9uBPS/IBZOyjr8nLoHukmh7uwkX+pKK3aU42F
	 76i7vTlfiYLDfyXqj0wOeMxTVRsbgIvQKO+FY0CI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 037/374] reset: hisilicon: hi6220: fix Wvoid-pointer-to-enum-cast warning
Date: Mon, 22 Jan 2024 15:54:53 -0800
Message-ID: <20240122235745.926590176@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit b5ec294472794ed9ecba0cb4b8208372842e7e0d ]

'type' is an enum, thus cast of pointer on 64-bit compile test with W=1
causes:

  hi6220_reset.c:166:9: error: cast to smaller integer type 'enum hi6220_reset_ctrl_type' from 'const void *' [-Werror,-Wvoid-pointer-to-enum-cast]

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20230810091300.70197-1-krzysztof.kozlowski@linaro.org
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/reset/hisilicon/hi6220_reset.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/reset/hisilicon/hi6220_reset.c b/drivers/reset/hisilicon/hi6220_reset.c
index 5ca145b64e63..30951914afac 100644
--- a/drivers/reset/hisilicon/hi6220_reset.c
+++ b/drivers/reset/hisilicon/hi6220_reset.c
@@ -164,7 +164,7 @@ static int hi6220_reset_probe(struct platform_device *pdev)
 	if (!data)
 		return -ENOMEM;
 
-	type = (enum hi6220_reset_ctrl_type)of_device_get_match_data(dev);
+	type = (uintptr_t)of_device_get_match_data(dev);
 
 	regmap = syscon_node_to_regmap(np);
 	if (IS_ERR(regmap)) {
-- 
2.43.0



