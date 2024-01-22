Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EE80129A63;
	Tue, 23 Jan 2024 00:12:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968739; cv=none; b=X6GGYRYPAKJGbxpjY9pW8Wn1CCxpbftxAnwBZH2X/WvB4Ck7pxa88fUqw+6TUxzhkf6DwEknQkomCHGk5WEykAVsyXDoBUF/bpzCpktEURBGmB2y3GUU3qG+pQOE0uMs71wV6CuofEubvFV/SjH1UF/sseDNpYMkBYpHWEoyeh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968739; c=relaxed/simple;
	bh=iMFLlhV2Cp5R4hiwxrQ+Q+n+anmXrK8+rDE9ECbtvD4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iTjUSitH9yFuurXsWRPSgVtv/pLg5k/qq2+pRi2va4HiKZyPa5GAwTBIrJbAQzKV3v8rGb1RNWvEjdfPlIhjEX1BCJWGfYX95psErelY8Gu6VL3NfgpdoE9aojk9kxyfOmeuzpXmNn2zVHP8SmmWyYEvGzqoO1PYF5l3V4nekiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0PNUXPfU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0PNUXPfU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44C56C43390;
	Tue, 23 Jan 2024 00:12:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705968739;
	bh=iMFLlhV2Cp5R4hiwxrQ+Q+n+anmXrK8+rDE9ECbtvD4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0PNUXPfU3xRN2OkiHXqiqCHdU6799ZVVmh2Gk31eC4attoO1TksXwSX+iyMOg+CfC
	 O3iV9GcSqNgLLNWAkoYtKjJZqLGkrojxyxlmjEvUeDsgIKIvoLp/9es7hvor21MLYp
	 l10KGE2ETd43MmJlYizcGXmEJvKBVE99ztv05JDU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 023/194] reset: hisilicon: hi6220: fix Wvoid-pointer-to-enum-cast warning
Date: Mon, 22 Jan 2024 15:55:53 -0800
Message-ID: <20240122235720.221468715@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235719.206965081@linuxfoundation.org>
References: <20240122235719.206965081@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 24e6d420b26b..84e761f454b6 100644
--- a/drivers/reset/hisilicon/hi6220_reset.c
+++ b/drivers/reset/hisilicon/hi6220_reset.c
@@ -104,7 +104,7 @@ static int hi6220_reset_probe(struct platform_device *pdev)
 	if (!data)
 		return -ENOMEM;
 
-	type = (enum hi6220_reset_ctrl_type)of_device_get_match_data(dev);
+	type = (uintptr_t)of_device_get_match_data(dev);
 
 	regmap = syscon_node_to_regmap(np);
 	if (IS_ERR(regmap)) {
-- 
2.43.0



