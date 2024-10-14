Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A30E11AC8A2;
	Mon, 14 Oct 2024 15:26:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919571; cv=none; b=fgNa1HDzsCimdhULGmg8RtU/X+mobc9icT9Z57tDsXU0bejwHtjv5ZYMcqsIoZcrtmCrxx/mg0X5FwzT4t9oo5ktIQ8zBN3C1mY4BoeepBENt57nOYBExJJjQPl+kToKYwNmnaavlZX1G+3lIXe2u1pzN4bfjsdU9vpWLUem/ew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919571; c=relaxed/simple;
	bh=o/OTxOXiiwlq3JlOl5gtouOnbM8UhEYzSpnvlLnqpgU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zd0VtMaKMY5Fzt1wzRM1THfDKxAVdTSI9wdYId3s9qRfJS1llOOpvAGbRz71vwbgQhDfHap+lcYxqUpiSKGGWzQ8kz3xhj+THpp896ySeCke9uyn8ktwJkAvZHsK9ASy0G9pG1lYRC+HhZ8V/agIPRRwy/c2SR1bq6jlKNCgrbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zBrP97yD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zBrP97yD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12AA9C4CEC3;
	Mon, 14 Oct 2024 15:26:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919571;
	bh=o/OTxOXiiwlq3JlOl5gtouOnbM8UhEYzSpnvlLnqpgU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zBrP97yDvwt5aiAQm2BpxhlB7MMnUjpvDwg0Dsxz0iaMWFLFCBudKF5IiX7zqdwdx
	 aU45KajTMiEnSO27GqpraTI3Hfm1Qnj2QQQKWeSDHVIpFnksURxq7OylS646jITk0F
	 R/c+7AlGYb1K7sS6Gy30CS7CpYTYCmJtZCTKfh04=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Satya Priya Kakitapalli <quic_skakitap@quicinc.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 645/798] dt-bindings: clock: qcom: Add GPLL9 support on gcc-sc8180x
Date: Mon, 14 Oct 2024 16:19:59 +0200
Message-ID: <20241014141243.389792069@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Satya Priya Kakitapalli <quic_skakitap@quicinc.com>

[ Upstream commit 648b4bde0aca2980ebc0b90cdfbb80d222370c3d ]

Add the missing GPLL9 which is required for the gcc sdcc2 clock.

Fixes: 0fadcdfdcf57 ("dt-bindings: clock: Add SC8180x GCC binding")
Cc: stable@vger.kernel.org
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Satya Priya Kakitapalli <quic_skakitap@quicinc.com>
Link: https://lore.kernel.org/r/20240812-gcc-sc8180x-fixes-v2-2-8b3eaa5fb856@quicinc.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/dt-bindings/clock/qcom,gcc-sc8180x.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/dt-bindings/clock/qcom,gcc-sc8180x.h b/include/dt-bindings/clock/qcom,gcc-sc8180x.h
index 90c6e021a0356..2569f874fe13c 100644
--- a/include/dt-bindings/clock/qcom,gcc-sc8180x.h
+++ b/include/dt-bindings/clock/qcom,gcc-sc8180x.h
@@ -248,6 +248,7 @@
 #define GCC_USB3_SEC_CLKREF_CLK					238
 #define GCC_UFS_MEM_CLKREF_EN					239
 #define GCC_UFS_CARD_CLKREF_EN					240
+#define GPLL9							241
 
 #define GCC_EMAC_BCR						0
 #define GCC_GPU_BCR						1
-- 
2.43.0



