Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7398D351C2F;
	Wed, 20 May 2026 16:48:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295730; cv=none; b=ps/bO8CSKehtEGfaf4j7ZdxvS85Eg+RYvzz+ccHwuhIvYnRltEnt1tOnGC62dzxAoPp+QikXn2MKFONyNMFRuH8qrc89yboEPLsIWzoU4DQ2/Yz1PITO6r7zyR58v6DMUGFrd7bRIiK2WOGj7YORXcKq9WSFATf/wpoDr6DSd+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295730; c=relaxed/simple;
	bh=DhSoVA9VFaexd+xOLz3nO4zfhLvhlCOjT9Y0W6oeoRo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SsAYk7huqVdevdWOr6d93P4qff8QSOKWq9e7pb1XJ7qHQxB3Zp4XMn+C8fwppQU/GuQGdkfd6yoOiEvZIBh86/ZPQpAbE4A0I1dIhwhQuAsMSCkZxyfidDi8ZR0U/dPU/bB9jT54r7PAk65hpiouFgro6YK1c2lJ1Aw8xGIbYTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jzpvunmw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jzpvunmw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7EF31F000E9;
	Wed, 20 May 2026 16:48:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295729;
	bh=Po9KVEfb+d3rOk7SYr5zZpdSqmkzO0e9nXkRF5JctXY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jzpvunmwTPRDHfKQ2J+IhQGq7JmvW9INq3xOBAa4bUCg1hHb704pMZDQfQD7ZFo4K
	 91c5zhr2yh2PfBHq63VqDk65suPlT1fm9c8uYShowcZTMLG2oFrrm/OMRh2wxo6WCi
	 HDZ0v+7rNggGQbV6zN3IbNGeh4R0lr5Nn2maSdcI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	=?UTF-8?q?Barnab=C3=A1s=20Cz=C3=A9m=C3=A1n?= <barnabas.czeman@mainlining.org>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0531/1146] arm64: dts: qcom: msm8917-xiaomi-riva: Fix board-id for all bootloader
Date: Wed, 20 May 2026 18:13:01 +0200
Message-ID: <20260520162200.199023728@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Barnabás Czémán <barnabas.czeman@mainlining.org>

[ Upstream commit a49cd243503c528ea99e31a7853cf438ccc9032d ]

Redmi 5A comes with multiple bootloader versions where the expected
board-id is different.
Change the board-id to unified form what works on both bootloader
version.

Fixes: 26633b582056 ("arm64: dts: qcom: Add Xiaomi Redmi 5A")
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Barnabás Czémán <barnabas.czeman@mainlining.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260315-riva-common-v3-1-897f130786ed@mainlining.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/msm8917-xiaomi-riva.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/msm8917-xiaomi-riva.dts b/arch/arm64/boot/dts/qcom/msm8917-xiaomi-riva.dts
index 9db503e218886..1bfb16f90ddd5 100644
--- a/arch/arm64/boot/dts/qcom/msm8917-xiaomi-riva.dts
+++ b/arch/arm64/boot/dts/qcom/msm8917-xiaomi-riva.dts
@@ -18,7 +18,7 @@ / {
 	chassis-type = "handset";
 
 	qcom,msm-id = <QCOM_ID_MSM8917 0>;
-	qcom,board-id = <0x1000b 2>, <0x2000b 2>;
+	qcom,board-id = <0x1000b 1>, <0x1000b 2>;
 
 	pwm_backlight: backlight {
 		compatible = "pwm-backlight";
-- 
2.53.0



