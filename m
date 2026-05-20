Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B7FE29D26E;
	Wed, 20 May 2026 17:32:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298332; cv=none; b=syASlkUdXk1AiTPRKTNIk6PDGkMp1Ch0iXG/B7EB2/+Np1EI23Uf/KbINxDfXZOLzC0KpAzQvsYJk9guLLM+ZU/g6rXnC0DYLpvUW0dEAtYbEttglGqNkq8oB9Jbzyt4rQ0t9UcjBnR+lgWfWVyWIoSDwXmjZMTwdFslzw8brIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298332; c=relaxed/simple;
	bh=5xrOiT6lHWB/qOmr12NtIfMGka2F14fA8haLCLLOwVA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xn5qcGVILunvIVSbmHgO25oOWdsbueGlBN4f5phC2gwld+Ys1n+npTZ1OtkEqv09vtj+IE/CHmUNZrQ4Uv3ll71CVeC0u7Hs+IYsWj1K+oVVH/bsTLPna/m+Dus13sKNrW7/osuBAbrm+1IFQ04l0e5FeHtMX7nlm+QWGUPrGPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wl0bbnqF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wl0bbnqF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9B6C1F000E9;
	Wed, 20 May 2026 17:32:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298331;
	bh=/v7IGro+IEegt6Kwx9NxCQ45gMigExFOgEv2CtWOEaE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wl0bbnqFzt++chO1PGjOghc1/2bfTEwVI/10cPCNQGH7U+Pj2Vgit0mGqjAa3h//O
	 y05yU+I6fl63n46BMYVQ0OnjxidYJKqgV10lr2gZ95ZzuPQFWGiPa7omQ1p5uQhw2y
	 CTU1nLTLKVrH8K+ppYISc/stqqYSSuw9XDIxFkIk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 370/957] arm64: dts: qcom: sm6125-ginkgo: Fix missing msm-id subtype
Date: Wed, 20 May 2026 18:14:13 +0200
Message-ID: <20260520162142.552907794@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>

[ Upstream commit 2c3b8260d1a0d9a388f2d30e3bbe50d93edfa2aa ]

qcom,msm-id property must consist of two numbers, where the second
number is the subtype, as reported by dtbs_check:

  sm6125-xiaomi-ginkgo.dtb: / (xiaomi,ginkgo): qcom,msm-id:0: [394] is too short

Xiaomi vendor DTS for Trinket IDP and QRD boards uses value of 0x10000,
so put it here as well.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20251229142806.241088-2-krzysztof.kozlowski@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Stable-dep-of: 535e5741bc9a ("arm64: dts: qcom: sm6125-xiaomi-ginkgo: Remove board-id")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm6125-xiaomi-ginkgo.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sm6125-xiaomi-ginkgo.dts b/arch/arm64/boot/dts/qcom/sm6125-xiaomi-ginkgo.dts
index 68a237215bd1f..6b68e391cf3ea 100644
--- a/arch/arm64/boot/dts/qcom/sm6125-xiaomi-ginkgo.dts
+++ b/arch/arm64/boot/dts/qcom/sm6125-xiaomi-ginkgo.dts
@@ -19,7 +19,7 @@ / {
 	chassis-type = "handset";
 
 	/* required for bootloader to select correct board */
-	qcom,msm-id = <QCOM_ID_SM6125>;
+	qcom,msm-id = <QCOM_ID_SM6125 0x10000>;
 	qcom,board-id = <22 0>;
 
 	chosen {
-- 
2.53.0



