Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5CD01684BE;
	Wed, 20 May 2026 17:32:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298342; cv=none; b=e9VB2i8Sif2aiAYlVKZjQJW0i8PCSNH3msGLq3ig7LnB3Fn3tL53CJzB0wenVGir1ljIy+qndMvoEhSn9Bz+2Z/O9WgzLppDsJhfSYiRvrNP6424LivwSGtTj+vfL3IDfbCUL/+8hW21pqp9S+EpWGn8SbtK+HTqVeyf/5cj2E4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298342; c=relaxed/simple;
	bh=ORcMg6/k4ASIvBSKxQRxv6fPdryrzUGJZcgt2QduwlY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TJWObFoOOsXp1rQQrD88SfbpdGdTrimy1lZfrZm4k+oEY4VAuxa/5CNmlMg1/KcHlaFZUSnjqymKE+vohm+1UAtq2IT3joTSH0c62+4ugPwDQd8PfanEf3kwPWm75gUWKUUuNZjMT5exuYrjaHiST8LC0yVLVboYvIKA4fFnLUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x2mmSfrL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x2mmSfrL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 387E51F000E9;
	Wed, 20 May 2026 17:32:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298341;
	bh=tcjC6ul946kat5OlEyhYHT899gWaQdabRZ0vNRLyPlM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x2mmSfrLWObMgP9LxleIezy6EjaIN7yh5UzdKc8/A+w+j+W37B/zj+RFrCSvbBJ6M
	 lVEHPhzZ8HhzaTL7OUAee2h+5lrpZ+l+P86BOcHFeCRtkUQpOZwcaa/hiGjI3Kx0L9
	 8kTwNePx68wM2AXTayYbGatmO7Yo7GWbX0SgdzXM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Biswapriyo Nath <nathbappai@gmail.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	=?UTF-8?q?Barnab=C3=A1s=20Cz=C3=A9m=C3=A1n?= <barnabas.czeman@mainlining.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 374/957] arm64: dts: qcom: sm6125-xiaomi-ginkgo: Fix reserved gpio ranges
Date: Wed, 20 May 2026 18:14:17 +0200
Message-ID: <20260520162142.639216197@linuxfoundation.org>
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

[ Upstream commit e8669e010991154bedadd1cd67700544e0362e99 ]

The device was crashing on boot because the reserved gpio ranges
was wrongly defined. Correct the ranges for avoid pinctrl crashing.

Fixes: 9b1a6c925c88 ("arm64: dts: qcom: sm6125: Initial support for xiaomi-ginkgo")
Tested-by: Biswapriyo Nath <nathbappai@gmail.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Barnabás Czémán <barnabas.czeman@mainlining.org>
Link: https://lore.kernel.org/r/20260126-xiaomi-willow-v3-5-aad7b106c311@mainlining.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm6125-xiaomi-ginkgo.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sm6125-xiaomi-ginkgo.dts b/arch/arm64/boot/dts/qcom/sm6125-xiaomi-ginkgo.dts
index 418cfe67a2da8..c3edeee3af3ef 100644
--- a/arch/arm64/boot/dts/qcom/sm6125-xiaomi-ginkgo.dts
+++ b/arch/arm64/boot/dts/qcom/sm6125-xiaomi-ginkgo.dts
@@ -293,7 +293,7 @@ &sdhc_2 {
 };
 
 &tlmm {
-	gpio-reserved-ranges = <22 2>, <28 6>;
+	gpio-reserved-ranges = <0 4>, <30 4>;
 };
 
 &usb3 {
-- 
2.53.0



