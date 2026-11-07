Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062750;
	b=RJcXD2R+Cie24l8xRksCj+Ad+QBhLG3tlVQLP0ekksALTlMh885UYDWhwwYUZBPwnQAR
	 HI5KEHC0mFaWUmD7nSjlXZiZ7RpTbzQ2fDZ3xW2Kka/yde2sqFD+a2fQv7NamjIg5UCj2
	 m5GPU+hBW9Gutp/a50nWX0lPvwyPGl5q6hg5RBWK89AdtTmkslycirAT0sLJtpNgIrB0W
	 VDimY/nsN4Wg2QrZRCR5hG9WrYYPJCzh3xt/OJLFcOm8wZfEEZTiP4rz8pp75b5z12yv6
	 ZQ25nM8cRgMnvQfpb0gqmmYyNDBBOWRJBaTXbpioSK/lTwjeRYwE/x3UNosl0Otj2qw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062750;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+UUxmzkzSqkdtqb3nda5TyBfVVqiXxN0LZV9sh1XR+U=;
	b=0wcsMh/7HRPvIIhTR6AM2sJHJvCUaO9vrujRfze+iWniU/o1KOByDw0iBIHnPRR/Zf43
	 MJ6GKSfOMedEHGMfTe4dHZKoKUIRsqk8XOvvkdAmRe5947Xh6yBSBHR0z9+y86cSEPFP+
	 3Tsjy3L+LEz8RwiydIRQnaWcLZnEkGLkQDueUiFmo+/37G1Iw7EuZRLoDh5NRR59bTSej
	 Kgw7lxW8xRrSQk7z0V9AviSq5mZ7jPMN7wmA6xiWy2yQO2iRtnTMhCkaPy6O2CFnq2AQE
	 MKfT2Yfq64QNirfJft3p1kz5RzJYlseA5BxMM1B+jWiU7IOCfScUvy+i5qqPEr2DVkg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=COpjDJ7r;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEC22606A32E;
	Sat,  7 Nov 2026 14:45:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=COpjDJ7r
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CD011F0089F;
	Sat,  7 Nov 2026 14:45:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062749;
	bh=+UUxmzkzSqkdtqb3nda5TyBfVVqiXxN0LZV9sh1XR+U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=COpjDJ7rg3WEgR2jMkH4Ndas2WLedYz2NldXzPDa/4B5Bqmr80PlfNijnmxjgaXYE
	 Rm35xw7aWaxGZ7Iuq6ON/k12JbBpr4MqrO82Uqxr+XGiaoQSI2vK12+wEHcYn3bKxs
	 nfPMNAbXsIbiovnC7iGnM/0w/HDaY+p1ALu2yFmI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Dipen Patel <dipenp@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 063/869] hte: tegra194: Initialize slice locks before registering chip
Date: Sat,  7 Nov 2026 08:45:45 -0500
Message-ID: <20261107134854.447704478@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 690eb9be30fb8..4644677370022 100644
--- a/drivers/hte/hte-tegra194.c
+++ b/drivers/hte/hte-tegra194.c
@@ -787,17 +787,17 @@ static int tegra_hte_probe(struct platform_device *pdev)
 
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



