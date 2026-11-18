Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035768;
	b=wTxH/m30VlRUHzwdpiJpPMFuwbmbKQfQOhFrQgbQz+TvUw/P38UamaXEblPQVxobUmec
	 oYJIZs5jwzZd6lsHsSORDk4pTcm+9uY+g1SdeEi1/ZUEcTNC5+4je9TImp3He6p73P0qO
	 1i3fXxhL7UBgD0fzVdov+D+jSQ8woYAibkImJglFSG3EmYrvYudvh/3DkhIqRVI7EU/iP
	 eM70z7NoBb94V86yQIOJ2ZCG7K/uNKwF3+C05ypMM+HOZcsQY0RXVA93upW9K+2EhxkKK
	 zwP2wP3xOMXsi72/jT9oKhcKdkxS379c8g4p1B4MrGtcF7FGKyUkzR+E+HeD470NDsA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035768;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Gc+bW2LtWp6FdfvXfikm8b/s8ZEMp7ump8NLWMvdXco=;
	b=YRvjzcBbqZLQnsmIR4CWJGD3q2NcpiiHs1M9KyAy8k5C+OX6ACWWENTjfUGpcCvbtIlR
	 QskTWfQJE/p2V1nmmmI9TAQXENnfgyL0PNF72mJQdyU5hhxuRVGHCORr3RtLBRfp9WIyw
	 zxBbRc/1jdGZiWWBkleMv5q84bFf0RkPUKCymmRMEb/dOZYLMggzDHuJMVf36BoyAquvd
	 qmTxoAki1Xqmr7wSs2ToJxCLggByVtTyt7Ijpl0VWGQHovCaGfFMTSmCR+Bm1OmEjgM2c
	 oOnM9K6XdoF5TaQgV6K/3n8FecwC0N62TDMxJY59gDQCS0Ti5knZthzSDRK2kRXRSRQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=es5+JtqW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A82C7606A31C;
	Wed, 18 Nov 2026 21:02:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=es5+JtqW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BAAD1F000C4;
	Wed, 18 Nov 2026 21:02:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035768;
	bh=Gc+bW2LtWp6FdfvXfikm8b/s8ZEMp7ump8NLWMvdXco=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=es5+JtqWwHlCxQ7MJwJWtzJ7v6VAchurlaGefz8/fBKAY2Q4BdO7mS9w3ktAtmfxS
	 qFulix4G4Hw2p+1LEUAG/vluZp763zv8GTLm3m9tQQSsVW+re/5KtvvNYypGaWtPJn
	 M21Cg+Qxk9Hxa5JskyYSN8u8AqgGYHh07umJSq0c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Dipen Patel <dipenp@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0819/3318] hte: tegra194: Initialize slice locks before registering chip
Date: Wed, 18 Nov 2026 15:24:01 +0100
Message-ID: <20261118150343.614134910@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Runyu Xiao <runyu.xiao@seu.edu.cn>

[ Upstream commit 1329abe1bae416ab2cff89c3312d33f745d341c7 ]

Registering the HTE chip publishes its request callbacks to consumers.
Initialize every slice lock before registration so a concurrent HTE
request cannot use an uninitialized lock.

Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
Fixes: 09574cca6ad6 ("hte: Add Tegra194 HTE kernel provider")
Cc: stable@vger.kernel.org
Acked-by: Dipen Patel <dipenp@nvidia.com>
Signed-off-by: Dipen Patel <dipenp@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hte/hte-tegra194.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/hte/hte-tegra194.c b/drivers/hte/hte-tegra194.c
index 6fe6897047aca..5fe7f0b7a22fe 100644
--- a/drivers/hte/hte-tegra194.c
+++ b/drivers/hte/hte-tegra194.c
@@ -784,17 +784,17 @@ static int tegra_hte_probe(struct platform_device *pdev)
 
 	hte_dev->chip = gc;
 
+	for (i = 0; i < slices; i++) {
+		hte_dev->sl[i].flags = 0;
+		spin_lock_init(&hte_dev->sl[i].s_lock);
+	}
+
 	ret = devm_hte_register_chip(hte_dev->chip);
 	if (ret) {
 		dev_err(gc->dev, "hte chip register failed");
 		return ret;
 	}
 
-	for (i = 0; i < slices; i++) {
-		hte_dev->sl[i].flags = 0;
-		spin_lock_init(&hte_dev->sl[i].s_lock);
-	}
-
 	val = HTE_TECTRL_ENABLE_ENABLE |
 	      (HTE_TECTRL_INTR_ENABLE << HTE_TECTRL_INTR_SHIFT) |
 	      (hte_dev->itr_thrshld << HTE_TECTRL_OCCU_SHIFT);
-- 
2.53.0



