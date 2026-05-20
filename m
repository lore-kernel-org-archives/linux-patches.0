Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6594528DC4;
	Wed, 20 May 2026 17:33:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298440; cv=none; b=eFWDdWY98hS1urucUGT5RCt3jIqgYd5n+J4L77Pjd6YmCDsnneXFQiyN+uVEu3NDvaTyBqK/w67Uww/bKfn10nHRiwMuTi3DvPcl5zXxvOQElCSJTyFmp6zO7NBvcmw+EGxjdSnpKhTA6UL4N5IylJArButBdbZEQ/KkmErBBOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298440; c=relaxed/simple;
	bh=2QGj792C7JUca4IvCNyhetC72CdpQysw2qCwra6Nl4s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=K22b6XzXyDuAHeKFEPLTvByCV5SwuEX/It65PhiXDy9WEkMLbTjDZLnqv2NdbvrGIHcvYuzt628Ngo4d6d+Hn2LVtaZ8n9DceC6sp7XYqVkPVr1MGNpT+toV41mxFi2IIwqijPD8D9d4mJA1DTT/bV3wtTdTYAOzTHz27eMshfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Al300R/C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Al300R/C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C42341F000E9;
	Wed, 20 May 2026 17:33:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298439;
	bh=5VnF2b7/1OljUYfuB5RYr/Jrs7SnQze8N+L21wG3NPA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Al300R/Cl1kc1eZzvO1P9oBLCyIY4dIPdGpxc3OoTvAgQptEfvA2+455WwS1sZuQw
	 ez7XyBKWPVQCZOFblkfbT0EI9JWZxqujlMsj0uMBTUymd+eGU7K9gx7gfGBC7/l6ET
	 rWlbuKUE7Np4cA/cs//MKUC/aHf8KvOnEVJ5Cjlw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	=?UTF-8?q?Barnab=C3=A1s=20Cz=C3=A9m=C3=A1n?= <barnabas.czeman@mainlining.org>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 412/957] arm64: dts: qcom: msm8917-xiaomi-riva: Fix board-id for all bootloader
Date: Wed, 20 May 2026 18:14:55 +0200
Message-ID: <20260520162143.458741888@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



