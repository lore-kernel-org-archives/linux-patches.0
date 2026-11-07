Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061394;
	b=1o9ETrWMMQqXOeX55BEOLFpRNAT7GV1bJhADVZ9izIXjnQAB/Y/rR6WK7Bs82SKMBsrX
	 PO7f0phXlhFpJif+t9+RMc6VGQYLXmsmr6j360s0CU9MKDgBj20khK2ZB/mkU0C9WcvFS
	 XU+o/m7u99OTRclYfF3rVVGtLg6GcKMzn1qqDvZO4Nifkwyul4PT1amONRxse/eFhWwRw
	 vWueL12iUNv/7yNoMo/tj6K6wtuOwiJMT9K4b1mgGD9Fxx1oaUhtPQJkntiS383vG/M5V
	 3C3FzirDhaOJCLEqqjcj3AjP7eloMkXFpoz0DikHr0l5fbWXp1zzmfU/5iqksy1i3NQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061394;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pPqo2are8xUVDbfb3qdB1NRHRgfx6ccenWkocDqyFLs=;
	b=CiNLV5PawrtVZ0vGdmBMiHlHChMX2qFbuVZenGHvwwmCUOlLnQVTjRv/SkoC7w80lE0F
	 sYoeU1/QVDeiknXnk/ZtAyt8ZBrK3XXP9mzrnpnnYysAE9PMKJQMSgQZgtZ5En3nG403A
	 Hvgc0Bf6wPmmrfOOKH34yWuTeNK2bwFgIi1Hk5Qarmpcp71mw4ud64ne+J39kdKBg1HGO
	 xTAam1V4JOdvLSJ0MlARbXvHAYbmT/h3hghocst8C0oBQMDMXLzpjfP8a9Zh6iNym/jdo
	 yj90Gg5l6TnJuLY0rlgvpOlVjZnOBvVQgjE98xHLREkpn6g1MLWEreEOO5aS3cVW6Og==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hrmh02lZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7158606A333;
	Sat,  7 Nov 2026 14:23:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hrmh02lZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70BDE1F0089F;
	Sat,  7 Nov 2026 14:23:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061393;
	bh=pPqo2are8xUVDbfb3qdB1NRHRgfx6ccenWkocDqyFLs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hrmh02lZqlKhXqBUNJQ5dWO1hu79qbu/vNgvuvg7H3gyUmvs8/DUHtwPEWqr87ImI
	 AhJy6ECCiNwgwGnbHD+VG/xi+tjpODQO/hTuEfbY1WK2bCTj0RMTmDgBG8SWewXyMz
	 sTgEpH8ZD3vsSVtFdYBPZwCaWByznfjNgzpsUxTo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>,
	Loic Poulain <loic.poulain@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0496/1536] i2c: qcom-cci: Do not check return value of cci_init()
Date: Sat,  7 Nov 2026 08:41:52 -0500
Message-ID: <20261107135011.392852101@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>

[ Upstream commit 17c5d247e3e4708cac05ff087c8013c0dda383a2 ]

The cci_init() function is not supposed to fail, and it never returns
a non-zero, so it'd make sense to convert its signature to void.

Signed-off-by: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
Reviewed-by: Loic Poulain <loic.poulain@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://lore.kernel.org/r/20260515234121.1607425-3-vladimir.zapolskiy@linaro.org
Stable-dep-of: f98d49864821 ("i2c: qcom-cci: fix autosuspend cleanup")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-qcom-cci.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/i2c/busses/i2c-qcom-cci.c b/drivers/i2c/busses/i2c-qcom-cci.c
index 86d45f0752344..5215a003869df 100644
--- a/drivers/i2c/busses/i2c-qcom-cci.c
+++ b/drivers/i2c/busses/i2c-qcom-cci.c
@@ -247,7 +247,7 @@ static int cci_reset(struct cci *cci)
 	return 0;
 }
 
-static int cci_init(struct cci *cci)
+static void cci_init(struct cci *cci)
 {
 	u32 val = CCI_IRQ_MASK_0_I2C_M0_RD_DONE |
 			CCI_IRQ_MASK_0_I2C_M0_Q0_REPORT |
@@ -288,8 +288,6 @@ static int cci_init(struct cci *cci)
 		val = hw->scl_stretch_en << 8 | hw->trdhld << 4 | hw->tsp;
 		writel(val, cci->base + CCI_I2C_Mm_MISC_CTL(i));
 	}
-
-	return 0;
 }
 
 static int cci_run_queue(struct cci *cci, u8 master, u8 queue)
@@ -624,9 +622,7 @@ static int cci_probe(struct platform_device *pdev)
 	if (ret < 0)
 		goto error;
 
-	ret = cci_init(cci);
-	if (ret < 0)
-		goto error;
+	cci_init(cci);
 
 	pm_runtime_set_autosuspend_delay(dev, MSEC_PER_SEC);
 	pm_runtime_use_autosuspend(dev);
-- 
2.53.0



