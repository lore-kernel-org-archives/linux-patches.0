Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213172;
	b=X1KYWrwLfbmgC8ZIZgdxsgv/1MdqkiglQehd2aacfR/eb1JMDHWhdQsmC+iRQWJcVJIW
	 ZDV+fibriJlzb7TuZ6adv5VVpnHLVvndqfFBKcRE+2J2WT8hKrbb+/o89MQn9dXhvk0bT
	 yzvz3GEfO/72Z1edi2I+KIv6BXQkRMKl+NEG9m7G6QJE6V002Wcgop8hwhEHkSEUyNZjG
	 jppJOJJcwdZfsobisF99VDg3URyer3ZU0P18V1rMbE6txpmgybtmTFW/i5W1MPUS5bG7j
	 6YnfbPvHhQAjWpCmq148S8rMYsmdiH4hMv9v+xGAXnZYy5iWX45MiXAn8IJBy1q31YA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213172;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pUZqNtixzDB1/m/sp7dJl9uaHRKNaY7f7yrpD7Uadfs=;
	b=YkBUYuSaW1P6JAK7cpBNb4RTT059WuWWsyD/bUeG+vdvyALe7PFJ7bJ9Y0gEULLFegH0
	 WP/3Wfi7h46+XWpBhz+bbkLmtByd8ZZGQFN2Jfj6zOdRGF4+G9YRArYexcflPf/nEY+Uj
	 I+yo6MRxiVQFe3FvPvr8g8z5kNI6//1ua+Dwy4aM8WT8njhpeWmfaYy1az7Se4k22weYN
	 RMkrcQiOzaeJsvUDCwiRilZC99jEWP9HXzHEtiUlyBHuMg3OAQ4rfyoG5qG1X/S6oy0Xs
	 n78mYSoUhph52oIeM3pfI+ujd57LJ9g5vBQL00kd73vBPTfBGYKwq2jXxSbnYu0+xAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mF2qWgRG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B7E0606A31C;
	Wed, 28 Oct 2026 18:46:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mF2qWgRG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C03D1F01825;
	Wed, 28 Oct 2026 18:46:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213172;
	bh=pUZqNtixzDB1/m/sp7dJl9uaHRKNaY7f7yrpD7Uadfs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mF2qWgRGq2BY2bSvzscQelBe79l4XmrPJ/c46UtqMjOI/9ir2HucZsCMi/5jKkGzg
	 0pW7c8oGfJH0EHxfBafqLKnmbpXOH0/w8SgbQVdzbd9L/E5ukUPaS0gHiYxcNtmUNp
	 LT+aaJLaPsyRtk4xQDkyFxWLnFJdxhsQp43h5QkU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0412/1887] iio: adc: aspeed: Simplify with dev_err_probe
Date: Wed, 28 Oct 2026 17:41:48 +0100
Message-ID: <20261028170508.611944595@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>

[ Upstream commit dcc3ac29f46fff6775c0a945afc68fd9dece6d34 ]

Use dev_err_probe() to make error code handling simpler and handle
deferred probe nicely (avoid spamming logs).

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Stable-dep-of: 95e4eb426b4b ("iio: adc: aspeed: propagate reset deassert errors")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/aspeed_adc.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/iio/adc/aspeed_adc.c b/drivers/iio/adc/aspeed_adc.c
index 998e8bcc06e1d..e6a9d8d77af53 100644
--- a/drivers/iio/adc/aspeed_adc.c
+++ b/drivers/iio/adc/aspeed_adc.c
@@ -549,11 +549,10 @@ static int aspeed_adc_probe(struct platform_device *pdev)
 		return PTR_ERR(data->clk_scaler);
 
 	data->rst = devm_reset_control_get_shared(&pdev->dev, NULL);
-	if (IS_ERR(data->rst)) {
-		dev_err(&pdev->dev,
-			"invalid or missing reset controller device tree entry");
-		return PTR_ERR(data->rst);
-	}
+	if (IS_ERR(data->rst))
+		return dev_err_probe(&pdev->dev, PTR_ERR(data->rst),
+				     "invalid or missing reset controller device tree entry");
+
 	reset_control_deassert(data->rst);
 
 	ret = devm_add_action_or_reset(data->dev, aspeed_adc_reset_assert,
-- 
2.53.0



