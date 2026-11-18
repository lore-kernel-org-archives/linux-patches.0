Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034694;
	b=hR/Go5j4lsz8QtxxozjgL2zb75k/8jea1m16DN9aSk9xjooSfxsWhhXrck9K/oOTR3VC
	 AeSQCa3WpAKMkx8TgIZ/8/cdKbKkZeQrTS7FGeDjYFJf4yYBzJyx2fJSi5AV0sZY1yICW
	 sfU7PBiPqD5x3N01k7ENpgr6IZQaS1oh4IdJJce/yBbKYumQRG8Vh+pQe28NiAF7nREsu
	 KWetYmT38Jv4g12xdDRYz+jvZbkNf1Rqr7HwkzIG9Geki4iRsdEbMTBDvnyPD6DN06c1D
	 Q3FW6S1ZT/gSsLJyMiI6jMkKO1C8YmHmy+BSrI7QDdTjS3pcecQiTQOPFl0RaGBIFmw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034694;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eGwUCnUowF9sDi4zLyg3/MLLRK31AP9+uUKqWG1rWLo=;
	b=si0zyDTQ5z0QcU2Lt3nxmQA4RYklPoRBjWbDFmdWxnyvVOxZJyEGc0rlrBEgX/TLygJb
	 jmkqi4aZVM6nSmIMP0edXq5ddTLQ0hsnFW35FINL1GtXrHZbcu7bwVCIyBq7TYRbqXnRa
	 PZNKjBt4oZ+1GuKiYu8xE223vUm3hEv3S12tS1+j5Q8kMDN7Vv1LD65Vst7mGXZbGdJpA
	 Xn8gEg2+hO6vuxll/4/JHSn3arRIHnedl/nyxVBoOcKoeFdUdl6uOq3fVyb7kvYh4wCtk
	 2rr75HfxL5jq89L4FApEd8FSE8dBKh2jZmbV53NDl215V45TEBs61BGtXqSuLzd+wGQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0XHqf5Cm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25CE6606A31C;
	Wed, 18 Nov 2026 20:44:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0XHqf5Cm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7670A1F000C4;
	Wed, 18 Nov 2026 20:44:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034694;
	bh=eGwUCnUowF9sDi4zLyg3/MLLRK31AP9+uUKqWG1rWLo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0XHqf5CmFraCgtHA4xPYfFIHLpzxEAdvwa0R7ipyqzsaSsqXyZiL/zyw8ycsFCxRu
	 vLB+m6GW9HikVzRoUXAce38g6InDaHoe7fU0FV0J12h4ZL5W6KzaM+O+t+VDkTrrC9
	 v0FCNPxEVyNXXSktfwSkgY039zxxZUJul35xSyGE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>,
	Loic Poulain <loic.poulain@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0433/3318] i2c: qcom-cci: Do not check return value of cci_init()
Date: Wed, 18 Nov 2026 15:17:35 +0100
Message-ID: <20261118150329.638259269@linuxfoundation.org>
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
index 7050b01f32287..e5dacc6677b01 100644
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
@@ -634,9 +632,7 @@ static int cci_probe(struct platform_device *pdev)
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



